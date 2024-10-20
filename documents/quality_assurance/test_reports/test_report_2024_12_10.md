# **Test Session Report**

## **Testing Session Information**

| Date               | Time         | OS Used                      | Tester Name     | Version Used                                                  |
| ------------------ | ------------ | ---------------------------- | --------------- | ------------------------------------------------------------- |
| October 12th, 2024 | 7:40 PM CEST | macOS Sequoia (Build 15.0.1) | Antoine Prevost | Pre-release (commit e548b9a5afc3b4108455df7b9d4d3a23879610e5) |

---

| Number of Tests Executed | Number of Tests Passed | Success Percentage |
| ------------------------ | ---------------------- | ------------------ |
| 55                       | 10                     | 18.18%             |

---

## **Objectives**

- Verify the implementation of the main features.
- Identify features needing immediate attention for future updates.
- Confirm the integrity of existing features and verify the correctness of the test environment.

---

## **Test Results**

The detailed test results are available in this [spreadsheet document](https://docs.google.com/spreadsheets/d/13jn9MZXwvPJthTED8lPlTzNpH2iK69MnvhQDEM3IoZw/edit?usp=sharing).

Each sheet at the bottom covers individual test cases. You can find an overview of the test runs on the first page of the document.

---

## **Issues Identified**

### 1. **Missing Core Features**
  Although some core features are implemented, the absence of logs, bonuses, and overall gameplay variety makes the game less engaging. The development team should prioritize implementing features that introduce more varied gameplay.

### 2. **Win/Lose Conditions**
  There is no life system currently in place. Although collisions are implemented, win and lose conditions are missing, making the game lack a clear objective.

### 3. **Texturing**
  All game objects are currently represented as simple squares with basic colors. To enhance the game's appeal, character sprites should be implemented as soon as possible, as they are crucial to the game's attractiveness.

---

## **Conclusion**

The game's development is progressing well, but it still lacks key features necessary for making it more engaging and adhering closely to the requirements and specifications.

---

## **Next Steps**

1. Refine existing features to resolve discrepancies and align with the specifications (e.g., speed adjustments).
2. Implement sprite displays for game characters.
3. Add bonuses and introduce more dynamic game behaviors to enrich gameplay.
