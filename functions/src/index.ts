import * as admin from "firebase-admin";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ─── Helpers ────────────────────────────────────────────────────────────────

function todayKey(): string {
  const now = new Date();
  const y = now.getUTCFullYear();
  const m = String(now.getUTCMonth() + 1).padStart(2, "0");
  const d = String(now.getUTCDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

async function sendToToken(
  token: string,
  title: string,
  body: string,
  data: Record<string, string> = {}
): Promise<void> {
  try {
    await messaging.send({
      token,
      notification: { title, body },
      data,
      android: {
        notification: {
          channelId: "math_stars_channel",
          priority: "high",
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: { sound: "default", badge: 1 },
        },
      },
    });
  } catch (err: unknown) {
    const code = (err as { code?: string }).code;
    // Token is invalid/unregistered — remove it from Firestore
    if (
      code === "messaging/registration-token-not-registered" ||
      code === "messaging/invalid-registration-token"
    ) {
      await db.collection("users").doc(token).delete();
      console.log(`Removed stale token: ${token.slice(0, 20)}...`);
    } else {
      console.error(`Send failed for token ${token.slice(0, 20)}:`, code);
    }
  }
}

// ─── 1. Daily Streak Reminder ────────────────────────────────────────────────
// Runs every day at 3 PM UTC (6 PM Gulf / Pakistan time).
// Sends to users who have NOT opened the app today — don't bother active users.

export const dailyStreakReminder = onSchedule(
  { schedule: "0 15 * * *", timeZone: "UTC" },
  async () => {
    const today = todayKey();
    console.log(`[dailyStreakReminder] Running for date: ${today}`);

    const snapshot = await db
      .collection("users")
      .where("lastActiveDate", "!=", today)
      .get();

    if (snapshot.empty) {
      console.log("No inactive users today.");
      return;
    }

    const messages: Record<string, { title: string; body: string }> = {
      streak_1: {
        title: "🔥 Keep your streak alive!",
        body: "You're on a roll! Come practice math today and keep your streak going.",
      },
      streak_3: {
        title: "🔥 3-Day Streak — don't lose it!",
        body: "You've been amazing! One quick math session keeps your streak alive.",
      },
      streak_7: {
        title: "🏆 7-Day Streak at risk!",
        body: "Wow, a whole week! Don't let it end now — just 5 minutes of math!",
      },
      default: {
        title: "⭐ Time for Math Stars!",
        body: "Ahmad is waiting for you! Come earn some stars today.",
      },
    };

    const sends = snapshot.docs.map(async (doc) => {
      const data = doc.data();
      const token: string = data.fcmToken;
      const streak: number = data.streak ?? 0;
      const name: string = data.name ?? "Champ";

      if (!token) return;

      let msg = messages.default;
      if (streak >= 7) msg = messages.streak_7;
      else if (streak >= 3) msg = messages.streak_3;
      else if (streak >= 1) msg = messages.streak_1;

      // Personalise the body with the child's name
      const body = msg.body.replace("Ahmad", name);

      await sendToToken(token, msg.title, body, {
        type: "streak_reminder",
        screen: "progress",
      });
    });

    await Promise.allSettled(sends);
    console.log(`[dailyStreakReminder] Sent to ${snapshot.size} users.`);
  }
);

// ─── 2. Weekly Challenge ─────────────────────────────────────────────────────
// Every Monday at 8 AM UTC (11 AM Gulf time) — fresh week, fresh challenge.

export const weeklyChallenge = onSchedule(
  { schedule: "0 8 * * 1", timeZone: "UTC" },
  async () => {
    console.log("[weeklyChallenge] Sending weekly challenge notifications");

    const snapshot = await db.collection("users").get();
    if (snapshot.empty) return;

    const challenges = [
      "🎯 This week: Score 50+ in the Quiz Game!",
      "🐸 This week: Complete 3 Frog Jump games!",
      "⭐ This week: Earn 10 new stars!",
      "📚 This week: Read 2 stories!",
      "🏃 This week: Play Math Runner 3 times!",
    ];
    const challenge = challenges[new Date().getUTCDate() % challenges.length];

    const sends = snapshot.docs.map(async (doc) => {
      const token: string = doc.data().fcmToken;
      if (!token) return;
      await sendToToken(
        token,
        "🏆 New Weekly Challenge!",
        challenge,
        { type: "weekly_challenge", screen: "games" }
      );
    });

    await Promise.allSettled(sends);
    console.log(`[weeklyChallenge] Sent to ${snapshot.size} users.`);
  }
);

// ─── 3. Milestone Notification ───────────────────────────────────────────────
// Fires automatically when a user's totalStars crosses 10, 25, 50, 100.
// Triggered by Firestore writes — no cron needed.

export const milestoneNotification = onDocumentWritten(
  "users/{userId}",
  async (event) => {
    const after = event.data?.after?.data();
    const before = event.data?.before?.data();
    if (!after) return;

    const stars: number = after.totalStars ?? 0;
    const prevStars: number = before?.totalStars ?? 0;
    const token: string = after.fcmToken;
    const name: string = after.name ?? "Champ";

    if (!token || stars <= prevStars) return;

    const milestones: Record<number, { title: string; body: string }> = {
      10: {
        title: "⭐ 10 Stars Earned!",
        body: `Amazing ${name}! You've earned 10 stars. New games are unlocking!`,
      },
      25: {
        title: "🌟 25 Stars — Superstar!",
        body: `Incredible ${name}! 25 stars collected. You're a math superstar!`,
      },
      50: {
        title: "🏆 50 Stars — Math Champion!",
        body: `${name} you're a Math Champion! 50 stars and counting. Keep shining!`,
      },
      100: {
        title: "👑 100 Stars — Math Master!",
        body: `${name} has unlocked MASTER status! Premium stories are now unlocked!`,
      },
    };

    for (const [milestone, msg] of Object.entries(milestones)) {
      const m = Number(milestone);
      if (prevStars < m && stars >= m) {
        await sendToToken(token, msg.title, msg.body, {
          type: "milestone",
          screen: "progress",
        });
        break; // only one milestone notification at a time
      }
    }
  }
);
