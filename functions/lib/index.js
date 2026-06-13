"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.milestoneNotification = exports.weeklyChallenge = exports.dailyStreakReminder = void 0;
const admin = require("firebase-admin");
const scheduler_1 = require("firebase-functions/v2/scheduler");
const firestore_1 = require("firebase-functions/v2/firestore");
admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();
// ─── Helpers ────────────────────────────────────────────────────────────────
function todayKey() {
    const now = new Date();
    const y = now.getUTCFullYear();
    const m = String(now.getUTCMonth() + 1).padStart(2, "0");
    const d = String(now.getUTCDate()).padStart(2, "0");
    return `${y}-${m}-${d}`;
}
async function sendToToken(token, title, body, data = {}) {
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
    }
    catch (err) {
        const code = err.code;
        // Token is invalid/unregistered — remove it from Firestore
        if (code === "messaging/registration-token-not-registered" ||
            code === "messaging/invalid-registration-token") {
            await db.collection("users").doc(token).delete();
            console.log(`Removed stale token: ${token.slice(0, 20)}...`);
        }
        else {
            console.error(`Send failed for token ${token.slice(0, 20)}:`, code);
        }
    }
}
// ─── 1. Daily Streak Reminder ────────────────────────────────────────────────
// Runs every day at 3 PM UTC (6 PM Gulf / Pakistan time).
// Sends to users who have NOT opened the app today — don't bother active users.
exports.dailyStreakReminder = (0, scheduler_1.onSchedule)({ schedule: "0 15 * * *", timeZone: "UTC" }, async () => {
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
    const messages = {
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
        var _a, _b;
        const data = doc.data();
        const token = data.fcmToken;
        const streak = (_a = data.streak) !== null && _a !== void 0 ? _a : 0;
        const name = (_b = data.name) !== null && _b !== void 0 ? _b : "Champ";
        if (!token)
            return;
        let msg = messages.default;
        if (streak >= 7)
            msg = messages.streak_7;
        else if (streak >= 3)
            msg = messages.streak_3;
        else if (streak >= 1)
            msg = messages.streak_1;
        // Personalise the body with the child's name
        const body = msg.body.replace("Ahmad", name);
        await sendToToken(token, msg.title, body, {
            type: "streak_reminder",
            screen: "progress",
        });
    });
    await Promise.allSettled(sends);
    console.log(`[dailyStreakReminder] Sent to ${snapshot.size} users.`);
});
// ─── 2. Weekly Challenge ─────────────────────────────────────────────────────
// Every Monday at 8 AM UTC (11 AM Gulf time) — fresh week, fresh challenge.
exports.weeklyChallenge = (0, scheduler_1.onSchedule)({ schedule: "0 8 * * 1", timeZone: "UTC" }, async () => {
    console.log("[weeklyChallenge] Sending weekly challenge notifications");
    const snapshot = await db.collection("users").get();
    if (snapshot.empty)
        return;
    const challenges = [
        "🎯 This week: Score 50+ in the Quiz Game!",
        "🐸 This week: Complete 3 Frog Jump games!",
        "⭐ This week: Earn 10 new stars!",
        "📚 This week: Read 2 stories!",
        "🏃 This week: Play Math Runner 3 times!",
    ];
    const challenge = challenges[new Date().getUTCDate() % challenges.length];
    const sends = snapshot.docs.map(async (doc) => {
        const token = doc.data().fcmToken;
        if (!token)
            return;
        await sendToToken(token, "🏆 New Weekly Challenge!", challenge, { type: "weekly_challenge", screen: "games" });
    });
    await Promise.allSettled(sends);
    console.log(`[weeklyChallenge] Sent to ${snapshot.size} users.`);
});
// ─── 3. Milestone Notification ───────────────────────────────────────────────
// Fires automatically when a user's totalStars crosses 10, 25, 50, 100.
// Triggered by Firestore writes — no cron needed.
exports.milestoneNotification = (0, firestore_1.onDocumentWritten)("users/{userId}", async (event) => {
    var _a, _b, _c, _d, _e, _f, _g;
    const after = (_b = (_a = event.data) === null || _a === void 0 ? void 0 : _a.after) === null || _b === void 0 ? void 0 : _b.data();
    const before = (_d = (_c = event.data) === null || _c === void 0 ? void 0 : _c.before) === null || _d === void 0 ? void 0 : _d.data();
    if (!after)
        return;
    const stars = (_e = after.totalStars) !== null && _e !== void 0 ? _e : 0;
    const prevStars = (_f = before === null || before === void 0 ? void 0 : before.totalStars) !== null && _f !== void 0 ? _f : 0;
    const token = after.fcmToken;
    const name = (_g = after.name) !== null && _g !== void 0 ? _g : "Champ";
    if (!token || stars <= prevStars)
        return;
    const milestones = {
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
});
//# sourceMappingURL=index.js.map