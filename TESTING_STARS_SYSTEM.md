## Stars System - Testing Checklist

### Prerequisites
- App is built and running
- Check the home screen initially shows "⭐ 0 Stars" or current saved stars
- Note current star count

### Test 1: Story Completion
**Steps:**
1. Navigate to "📚 Subjects" → "Story Mode"
2. Select any story (e.g., "The Mango Orchard Adventure")
3. Read through all scenes and answer questions correctly
4. Reach the end of the story → Celebration screen appears
5. Note the stars earned display
6. Click "← Back to Stories"
7. Navigate back to Home Screen

**Expected Results:**
- ✓ Celebration screen shows correct number of stars earned
- ✓ Star count on home screen increased by the story's stars (3 for math, 2 for reading)
- ✓ Header shows updated "⭐ [new total] Stars"
- ✓ Stars strip shows updated "⭐ [new total] / 40 Stars"
- ✓ Progress bar reflects the new percentage

---

### Test 2: Quiz Game Completion
**Steps:**
1. Navigate to "📚 Subjects" → "Math"
2. Select "Quiz Game"
3. Complete all 10 questions with as many correct answers as possible
4. Quiz completion screen appears
5. Navigate back to Home Screen

**Expected Results:**
- ✓ Stars earned = score from quiz (e.g., 8/10 = 8 stars)
- ✓ Home screen star count increased
- ✓ Progress bar updated

---

### Test 3: Mini Game Completion
**Steps:**
1. Navigate to "Games" section
2. Select a mini game (e.g., Subtraction, Counting, etc.)
3. Complete the game with passing score
4. Result dialog appears showing score and stars
5. Return to home screen

**Expected Results:**
- ✓ Stars based on performance (1-3 stars)
- ✓ Home screen total updated
- ✓ Stars persist after closing dialog

---

### Test 4: Data Persistence
**Steps:**
1. Note current star count on home screen
2. Close the app completely (not just backgrounding)
3. Reopen the app
4. Navigate to home screen

**Expected Results:**
- ✓ Star count remains the same
- ✓ No data loss

---

### Test 5: Multiple Completions
**Steps:**
1. Complete 2-3 games/stories in sequence
2. Return to home screen between each one
3. Monitor total star accumulation

**Expected Results:**
- ✓ Stars accumulate correctly
- ✓ Total reflects all earned stars
- ✓ Progress bar updates smoothly

---

### Test 6: Cross-Game Completion
**Steps:**
1. Complete one story (earn 2-3 stars)
2. Complete one quiz (earn 7-10 stars based on score)
3. Complete one mini game (earn 1-3 stars)

**Expected Results:**
- ✓ Total is sum of all earned stars
- ✓ Progress bar reflects overall progress toward 40 stars

---

### Test 7: Edge Cases

#### Multiple Story Completions
1. Complete the same story multiple times
2. Verify stars are added each time (not just once)

#### All Stories Completed
1. Complete enough games/stories to reach 40+ stars
2. Verify progress bar maxes out at 100%
3. Verify star count shows correct total (can exceed 40)

#### App Backgrounding
1. Complete a game
2. See stars updated
3. Minimize app (background)
4. Reopen app
5. Verify stars are still there

---

### Debug Info

If stars are not updating:

1. **Check Storage:**
   - Look for GetStorage files in app documents
   - Look for SharedPreferences files

2. **Check Console Logs:**
   - Search for "StarsService" to verify service is initialized
   - Check for any errors in the observer stream

3. **Manual Reset (if needed):**
   - The StarsService can be extended to include a resetStars() method for testing

4. **Verify Service Registration:**
   - Make sure `Get.put(StarsService())` is called in main.dart
   - Verify `Get.isRegistered<StarsService>()` returns true in controllers

---

### Current Star Thresholds

**Max Possible Stars:** 40 (recommended cap on home screen)
- 12 Stories × 2-3 stars = 24-36 stars
- Quiz Games = 0-10 stars per game
- Mini Games = 1-3 stars per game

Users can exceed 40 stars, but progress bar shows 100% at 40.

---

### Notes
- All changes are backward compatible with existing data
- Different storage systems (GetStorage & SharedPreferences) are synced
- No migration needed for existing users


