# Functional Specifications

## Table of Contents

<details>
<summary>Click to expand</summary>

- [Functional Specifications](#functional-specifications)
  - [Table of Contents](#table-of-contents)
  - [1. Introduction](#1-introduction)
    - [1.1 Overview](#11-overview)
    - [1.2 Purpose](#12-purpose)
    - [1.3 Personas](#13-personas)
    - [1.4 Use cases](#14-use-cases)
  - [2. Frogger game](#2-frogger-game)
    - [2.1 Game Objective](#21-game-objective)
    - [2.2 Gameplay Mechanics](#22-gameplay-mechanics)
      - [2.2.1 Gameplay movement](#221-gameplay-movement)
      - [2.2.2 Gameplay controls](#222-gameplay-controls)
      - [2.2.3 Highway Crossing](#223-highway-crossing)
      - [2.2.4 River Crossing](#224-river-crossing)
      - [2.2.5 River Banks](#225-river-banks)
    - [2.3 Bonuses](#23-bonuses)
      - [2.3.1 Pink Frog](#231-pink-frog)
      - [2.3.2 Fly Bonus](#232-fly-bonus)
    - [2.4 Game Difficulty](#24-game-difficulty)
      - [Game Levels (1-8)](#game-levels-1-8)
    - [2.5 Time Band](#25-time-band)
    - [2.6 Scoring System](#26-scoring-system)
    - [2.7 End of Game](#27-end-of-game)
  - [3. Non-Functional Requirements](#3-non-functional-requirements)
    - [3.1 Costs](#31-costs)
        - [Capital Expenditures](#capital-expenditures)
        - [Time Invested](#time-invested)
        - [Operational Expenditures](#operational-expenditures)
        - [Project Scope](#project-scope)
    - [3.2 Response/Performance \& Reliability](#32-responseperformance--reliability)
        - [Performance Metrics](#performance-metrics)
        - [Reliability Considerations](#reliability-considerations)
    - [3.3 Testability](#33-testability)
    - [3.4 Documentation](#34-documentation)
    - [3.5 Flexibility](#35-flexibility)
  - [4. Risks and Assumptions](#4-risks-and-assumptions)
    - [4.1 Risks](#41-risks)
    - [4.2 Budget considerations](#42-budget-considerations)
    - [4.3 Out of Scope](#43-out-of-scope)
    - [4.4 External resources](#44-external-resources)

</details>

## 1. Introduction

This is the official document containing the functional specifications of the FPGA Frogger project. Our team is composed of:

| Name               | Role              | Description                                                                               |
| ------------------ | ----------------- | ----------------------------------------------------------------------------------------- |
| Max BERNARD        | Project Manager   | Responsible for project management, including timelines, planning and team coordination.  |
| David CUAHONTE     | Program Manager   | Manages functional specification development and client communication for the project.    |
| Aurélien FERNANDEZ | Technical Lead    | Guides technical decisions and translates requirements into scalable technical solutions. |
| Quentin CLEMENT    | Software Engineer | Develops and implements codebase, ensures code quality and collaboration within the team. |
| Mathis KAKAL       | Software Engineer | Develops and implements codebase, ensures code quality and collaboration within the team. |
| Antoine PREVOST    | Quality Assurance | Creates tests to validate the quality of the solution and to ensure compliance.           |
| Thibaud MARLIER    | Technical Writer  | Creates comprehensive end-user documentation to facilitate the usage of the application.  |

### 1.1 Overview

"Frogger FPGA" is a project aimed at creating a fun and interactive Frogger game using FPGA technology and Verilog programming. In this classic arcade-style game, a player guides a frog across a busy road filled with moving cars and navigate a river with logs and other obstacles. The goal is to safely reach the other side while avoiding hazards. This project prioritizes an engaging gaming experience while also showcasing the power of FPGA for real-time applications.

_A logo of the game is shown below:_

<div align="center">

![logo](./images/logo.jpeg)

</div>

### 1.2 Purpose

This project is an opportunity for us to dive deeper into Verilog programming and FPGA technology. Our main goal is to create a fun and exciting Frogger game that can be displayed on a 640x480 VGA monitor. The game involves a frog crossing a road filled with obstacles, focusing on delivering a smooth, engaging experience for users.

While the primary objective is to get the core gameplay functioning, we’re also considering adding more detailed graphics and possibly arcade features in the future. However, features like sound fall outside the scope of this project.

### 1.3 Personas

The primary users of the FPGA Frogger game include:

- **Modern Gamer**: This individual enjoys fast-paced and exciting games but also appreciates the retro charm of classic arcade games. They are looking for a simple yet challenging experience and are interested in exploring games that go beyond typical software, like one built on FPGA hardware. They value innovation in how games are made and enjoy testing out unique gaming platforms.

- **Old-school Gamer**: Someone who grew up playing arcade games like Frogger. They seek nostalgia and appreciate the authenticity of recreating the original experience. This person is likely to appreciate the familiar gameplay mechanics while being intrigued by the idea of playing Frogger on new technology like an FPGA.

### 1.4 Use cases

**Modern Gamer Explores FPGA Frogger**:

1. A modern gamer, curious about FPGA technology, connects the system to their VGA monitor and powers it on.
2. The gamer starts playing, moving the frog across the screen, and testing the game’s responsiveness with the FPGA hardware.
3. The gamer enjoys the retro-style gameplay while appreciating the modern tech behind it, and continues playing to see how far they can progress.

**Old-school Gamer Revisits a Classic Arcade Experience**:

1. An old-school gamer, familiar with the original Frogger, starts the FPGA version to see how it compares.
2. The gamer recognizes the gameplay mechanics and immediately feels nostalgic, guiding the frog across the screen while avoiding obstacles.
3. As the levels get harder, the gamer feels challenged by the faster obstacles but enjoys the faithful recreation of the original game on FPGA.

**Modern and Old-school Gamers Compete for High Scores**:

1. Both a modern and an old-school gamer set up the FPGA system for a friendly competition.
2. They take turns playing, each trying to complete as many levels as possible without losing all their lives.
3. The gamers compare scores after each round, enjoying the blend of retro gameplay and the technical challenge presented by the FPGA platform.

## 2. Frogger game

### 2.1 Game Objective

To complete a level, the player must guide five frogs safely into the home bays. Each frog represents a life, and the player starts with four lives. The game ends when all frogs are lost or when the player completes all the levels. Additionally, Frogger has a time limit of 30 seconds (or 60 ticks) per frog, shown by a time band at the bottom of the screen. The remaining time also contributes to the player’s score if the frog reaches a home bay on time.

_Frogger game:_

<div align="center">

![game](./images/frogger_game.png)


</div>

### 2.2 Gameplay Mechanics

#### 2.2.1 Gameplay movement

The frog advances one tile per button press. When the frog reaches the top row of the screen and completes the level, the frog is automatically repositioned at the bottom to begin the next level.

_Frog:_

<div align="center">

![frog](./images/frog.png)

</div>

#### 2.2.2 Gameplay controls

The player controls Frogger using the four buttons on the FPGA system. These buttons allow movement in four directions: up, down, left, and right.

_FPGA BUTTONS:_

<div align="center">

![FPGA](./images/fpga.jpg)

</div>

#### 2.2.3 Highway Crossing

The player begins each round by moving the frog through a four-lane highway. Cars and trucks move horizontally across the screen in both directions at varying speeds. Traffic patterns vary in speed and direction, presenting a continuous challenge for the player to navigate without getting squashed. If the frog touches any vehicle, the player loses a life.

Each forward jump earns the player 10 points. Completing this section will lead the players to the next section.

_Highway:_

<div align="center">

![road](./images/road.png)

</div>

#### 2.2.4 River Crossing

After the highway, Frogger reaches the riverbank. To get to the home bays, the player must jump across floating logs, turtles, and other moving objects. The logs move at different speeds and in different directions. Turtles periodically dive underwater, forcing the player to hop off before they disappear.

Additional river hazards include snapping alligator jaws, which can appear while Frogger is on logs. As the game progresses, new threats like fast-moving otters that can pull the frog into the water emerge, adding difficulty.

The river is divided into 7 rows:

- The first row is the river bank, a rather safe place, where the snake spawns after level 3;
- The second row contains set of three turtles;
- The third row contains either short logs or long logs;
- The fourth row contains long logs only;
- The fifth row contains sets of two turtles;
- The sixth row contains random logs from short, medium or long ones;
- The seventh and last row is the goal, containing five safe spot, that the user must fill. And other from that, the grass is unsafe for the user. Moreover, some enemies and bonuses can be here.

Note: From the second to the seventh row, objects are spawned randomly, we will dive into it later.

_River Bank:_

<div align="center">

![river](./images/river.png)

</div>

**Logs**:

Logs come in three different sizes and shapes: short, medium, and long. Frogger can safely land on these logs without falling into the water, as they float from left to right across the screen.

Frogger is able to jump side to side while on a log, but be careful not to fall into the water. Additionally, Frogger can leap from one log to another floating object, moving forward or backward.

_Logs_:

<div align="center">

![log1](./images/log1.png) <br>
![log2](./images/log2.png) <br>
![log3](./images/log3.png)

</div>

**Small logs:**

![log1](./images/log1.png)

A small log spans the equivalent of 2 tiles.
Thus 64x32 pixels.

**Medium logs:**

![log2](./images/log2.png)

A medium log spans the equivalent of 3 tiles.
Thus 96x32 pixels.

**Long Logs:**

![log3](./images/log3.png)

A long log spans the equivalent of 5 tiles.
Thus 160x32 pixels.

**Key hazards**:

- **Diving Turtles**: Turtles in the game appear in sets of two or three. You can jump on them when they are above the water, where they function like logs, supporting the frog. However, be cautious of turtles that dive underwater. If Frogger is still on a turtle when it dives, he will fall into the water and lose a life. To avoid this, players must leap to another floating object before the turtles submerge. Additionally, if you jump to the left or right off the edge of a turtle group, Frogger will also fall into the water, leading to the loss of a life.

_Diving Turtles:_

<div align="center">

![turtles](./images/turtle.png)

</div>

- **Alligator Jaws**: Beware of logs with hidden alligator jaws. These are actually alligators disguised as logs. The key difference between them and regular logs is their visible jaws. You can safely jump on the alligator's back, but if Frogger lands on its open jaw, you'll lose a life. Every second, the alligator snaps its jaws, emphasizing the danger it poses.

_Alligator:_

<div align="center">

![alligator](./images/alligator.png)

</div>

- **Otters**: These creatures swim rapidly and can snatch Frogger off floating objects, adding an extra layer of challenge for the player. They only start appearing after level 3. Every second, they perform a brief swimming animation, signaling their presence and keeping players on their toes.

_Otters:_

<div align="center">

![otter](./images/otter.png)

</div>

If Frogger falls into the river, the player loses a life, as the frog cannot swim.

#### 2.2.5 River Banks

At the top of the screen, there are five home bays that Frogger must safely reach to complete a level. However, some bays may occasionally be blocked by hazards, such as alligator heads. If a bay is blocked, the player must wait or aim for a different one. Once Frogger successfully reaches a home bay, that bay becomes unavailable for the rest of the level, and the player must fill the remaining bays to advance.

Reaching a home bay grants **50 points**, and players can earn bonus points if a fly or pink frog appears, as explained in the next section. The player must navigate all five frogs to the home bays to complete a level.

_River banks:_

<div align="center">

![goal](./images/goal.png)

</div>

On the upper river bank, one enemy can spawn:

- **Alligator's head**: If an alligator's head is showing in a home bay, it is not safe to enter it. Jumping into it will result into the death of a frog. However, if the alligator just appeared, there's a 2 second safe period before being deadly.

_Alligator's head:_

<div align="center">

![goal with enemies](./images/goal_enemies.png)

</div>

On the lower river bank and on the logs, one more enemy can spawn after the level 3:

- **Snakes**: They are deadly enemies spawning randomly on the logs and the lower river bank. It goes from left to right. If a snake touches the frog, it will lead to the death of the frog. The snake has a moving animation, as shown below, that changes every clock cycle.

_Snake:_

<div align="center">

![snake](./images/snake.png)

</div>

### 2.3 Bonuses

In "Frogger," players can increase their score through special bonuses scattered throughout the game. The key bonuses are as follows:

#### 2.3.1 Pink Frog

- Occasionally, a pink "lady" frog appears on a log within the river.
- Lady moves from left to right on the log she's on.
- To earn bonus points, players must jump onto the log with the pink frog and safely guide her to a home bay.
- Successfully bringing the pink frog home grants the player **200 bonus points**.

_Pink frog:_

<div align="center">

![pink frog](./images/pink_frog.png)

</div>

#### 2.3.2 Fly Bonus

- A fly may appear in one of the home bays at random intervals.
- Players can earn additional points by hopping Frogger into the home bay with the fly.
- Collecting the fly rewards the player with **200 bonus points**.

_Flies:_

<div align="center">

![fly](./images/fly.png) <br>
![fly home](./images/fly_home.png)

</div>

### 2.4 Game Difficulty

The difficulty in "Frogger" escalates across four distinct levels. Here’s a breakdown of what to expect at each level:

<!-- The original frogger has 4 levels, the requirements says 8 uncertain for now. -->

#### Game Levels (1-8)

- **Level 1**:

  - At the start, Frogger can float off-screen for a frame, allowing for a moderate introduction to the gameplay.
  - Traffic patterns are manageable, with vehicles moving at across the screen with periodically larger gaps. Players will have time to learn the timing of their movements without the pressure of fast-moving obstacles.
  - River obstacles, such as logs and turtles, are plentiful, the players will have ample opportunities to practice hopping safely across the water.
  - As players progress through these levels, the speed of traffic and river objects gradually increases.

- **Level 2**:

  - Alligators start to appear in the river alongside the logs.
  - The frog can walk on the alligators' back but the Frogger die when it walk on the Alligators head.

- **Level 3 & 4**:
  - In these advanced levels, Frogger can no longer float off-screen.
  - The game starts at a higher difficulty, with traffic being denser and log more sparse.
  - New hazards are introduced, such as **otter attacks** that can push frogger in the water.
  - With fewer floating objects in the river, players must navigate a more treacherous environment.
- **Level 5 to 8**
  - After these level the speed increase sharply.
  - The density of traffic is lower but will increase again.

To proceed to the next level, the player must safely guide five frogs into the home bays. After completing all levels, the difficulty ramps up again.

<!-- reference video https://www.youtube.com/watch?v=k3nKtOh41fE -->

- **Speed of objects in second to cross the screen**:

| Level | Lane1 | Lane2 | Lane3 | Lane4 | Lane5 | Turtle1 | Log1 | Log2 | Turtle2 | Log3 | Snakes |
| ----- | ----- | ----- | ----- | ----- | ----- | ------- | ---- | ---- | ------- | ---- | ------ |
| 1     | 22    | 18    | 15    | 10    | 8     | 8       | 22   | 4    | 8       | 11   | /      |
| 2     | 22    | 18    | 15    | 10    | 8     | 8       | 22   | 4    | 8       | 11   | /      |
| 3     | 22    | 18    | 15    | 10    | 8     | 8       | 22   | 4    | 8       | 11   | 8      |
| 4     | 20    | 18    | 15    | 10    | 8     | 8       | 20   | 4    | 8       | 10   | 8      |
| 5+    | 8     | 12    | 8     | 2     | 10    | 4       | 20   | 8    | 12      | 8    | 8      |

Alligators have the same speed as the logs in the lane they are in.
Otters are 10% faster then the logs or turtles in the lane.

- **Density of cars and logs:**

| Level   | Lane 1                                                                            | Lane 2                                                                                                                 | Lane 3                                                                            | Lane 4                               | Lane 5                               | Banking     | Water 1                                                                                                             | Water 2                                                                                     | Water 3                                   | Water 4                                                                                | Water 5                                                                      | Home |
| ------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------ | ------------------------------------ | ----------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ----------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ---- |
| Level 1 | **3 cars**, spaced by **4 tiles**                                                 | **3 cars**, spaced by **3 tiles**                                                                                      | **3 cars**, spaced by **3 tiles**                                                 | **1 car**                            | **2 cars**, spaced by **4 tiles**    | X           | **4 sets** of **3 turtles**, **1 tile apart**, first set is **diving turtles**                                      | **3 small logs**, **2 tiles apart**                                                         | **3 long logs**, **2 tiles apart**        | **4 sets** of **2 turtles**, **2 tiles apart**, first set is **diving turtles**        | **3 medium logs**, **2 tiles apart**                                         | X    |
| Level 2 | **4 cars**, first **3** separated by **4 tiles**, fourth separated by **2 tiles** | **4 cars**, separated by **4 tiles**                                                                                   | **4 cars**, first **3** separated by **4 tiles**, fourth separated by **2 tiles** | **2 cars**, separated by **2 tiles** | **3 cars**, separated by **4 tiles** | X           | **3 sets** of **3 turtles**, first set separated by **3 tiles**, second and third by **1 tile**                     | **3 small logs**, **2 tiles apart**                                                         | **1 long log**                            | **5 sets** of **2 turtles**, **1 tile apart**, first set is **diving turtles**         | **3 logs**, **2 tiles apart**, **1 crocodile** replaces a log every interval | X    |
| Level 3 | **4 cars**, separated by **3 tiles**                                              | **4 cars**, first **3** separated by **4 tiles**, last separated by **2 tiles**                                        | **5 cars**, first **4** separated by **3 tiles**, last separated by **1 tile**    | **2 cars**, separated by **3 tiles** | **3 cars**, separated by **2 tiles** | **1 snake** | **3 sets** of **3 turtles**, **2 tiles apart**, **1/3** are **diving turtles**                                      | **3 small logs**, first separated by **3 tiles**, last two by **1 tile**                    | **1 long log**                            | **4 sets** of **2 turtles**, **2 tiles apart**, **1/4** are **diving turtles**         | **2 medium logs**, **2 tiles apart**                                         | X    |
| Level 4 | **4 cars**, first **3** separated by **3 tiles**, last separated by **1 tile**    | **4 cars**, separated by **3 tiles**                                                                                   | **4 cars**, first **3** separated by **3 tiles**, last separated by **1 tile**    | **3 cars**, separated by **3 tiles** | **4 cars**, separated by **2 tiles** | **1 snake** | **3 sets** of **3 turtles**, separated by **3 tiles**, **1/3** are **diving turtles**                               | **2 small logs**, separated by **4 tiles**                                                  | **1 long log**                            | **3 sets** of **2 turtles**, separated by **2 tiles**, **1/3** are **diving turtles**  | **2 medium logs**, separated by **2 tiles**                                  | X    |
| Level 5 | **5 cars**, first **4** separated by **2 tiles**, fifth separated by **1 tile**   | **4 cars**, separated by **3 tiles**                                                                                   | **5 cars**, separated by **2 tiles**                                              | **4 cars**, separated by **2 tiles** | **3 cars**, separated by **2 tiles** | **1 snake** | **2 sets** of **3 turtles**, separated by **3 tiles**, **1/2** are **diving turtles**                               | **2 small logs**, separated by **3 tiles**                                                  | **1 long log**                            | **3 sets** of **2 turtles**, separated by **3 tiles**                                  | **1 crocodile**                                                              | X    |
| Level 6 | **3 cars**, separated by **3 tiles**                                              | **3 cars**, separated by **3 tiles**                                                                                   | **3 cars**, separated by **3 tiles**                                              | **1 car**                            | **2 cars**, separated by **3 tiles** | **1 snake** | **4 sets** of **3 turtles**, separated by **2 tiles**, **1/4** are **diving turtles**                               | **3 small logs**, separated by **2 tiles**                                                  | **2 long logs**, separated by **2 tiles** | **4 sets** of **2 turtles**, separated by **2 tiles**, **1/4** are **diving turtles**  | **2 medium logs**, **1 crocodile**, separated by **2 tiles**                 | X    |
| Level 7 | **4 cars**, first **3** separated by **3 tiles**, last separated by **1 tile**    | **4 cars**, separated by **3 tiles**                                                                                   | **4 cars**, first **3** separated by **3 tiles**, last separated by **1 tile**    | **2 cars**, separated by **1 tile**  | **3 cars**, separated by **3 tiles** | **1 snake** | **3 sets** of **3 turtles**, first separated by **3 tiles**, last two by **1 tile**, last set is **diving turtles** | **3 small logs**, separated by **3 tiles**                                                  | **1 long log**                            | **5 sets** of **2 turtles**, separated by **1 tile**, **1/5** are **diving turtles**   | **1 crocodile**, **2 medium logs**, separated by **2 tiles**                 | X    |
| Level 8 | **4 cars**, separated by **3 tiles**                                              | **4 cars**, first and second separated by **3 tiles**, second and third by **1 tile**, third and fourth by **3 tiles** | **5 cars**, first and second separated by **1 tile**, others by **2 tiles**       | **2 cars**, separated by **3 tiles** | **3 cars**, separated by **2 tiles** | **1 snake** | **3 sets** of **3 turtles**, separated by **2 tiles**, first set is **diving turtles**                              | **3 small logs**, first and second separated by **1 tile**, second and third by **3 tiles** | **1 long log**                            | **4 sets** of **2 turtles**, separated by **2 tiles**, first set is **diving turtles** | **1 medium log**, **1 crocodile**, separated by **2 tiles**                  | X    |

### 2.5 Time Band

Frogger has a time limit of 30 seconds (or 60 ticks) to reach the home bay.
If the player fails to bring the frog to the home bay within this time, they will lose a life.
The remaining time is displayed as a time band at the bottom right of the screen.

_time band_:

![time band](./images/timeband.png)

The time band gradually shrinks as time passes. When only 10 seconds (or 20 ticks) remain, the time band turns red to signal that time is running out, as shown below:

_time running out_:

![red time band](./images/redtimeband.png)

### 2.6 Scoring System

Points are awarded for various actions within the game:

- **Jumping Frogger forward**: 10 points per forward jump.
- **Reaching a home bay**: 50 points.
- **Guiding all five frogs home**: 1,000 points.
- **Rescuing the pink frog**: 200 points.
- **Eating a fly**: 200 points.
- **Bonus points for remaining time**: 10 points per remaining tick.

If the player reaches a high score of 20,000 points and fewer than four frogs remain, an extra frog (life) is awarded.

|Action| Points Earned|
|------|--------------|
|Jump Forward| +10 points|
|Reaching Home Bay| +50 points|
|Beating A Level| +1,000 points|
|Escorting Pink Lady | +200 points|
|Eating A Fly| +200 points|
|Bonus Time| +10 points * ticks remaining|
|Score = 20,000| 1 UP|

### 2.7 End of Game

The game ends when all of Frogger's lives are lost. At this point, the player can either restart the game or reset it using the FPGA system to begin a new round. Additionally, if the player successfully reaches the end of the 8th level, they will have beaten the game. They are redirected to the main menu.

## 3. Non-Functional Requirements

This section outlines the non-functional requirements for the FPGA Frogger game project, focusing on costs, performance, reliability, and testability.

### 3.1 Costs

##### Capital Expenditures

- **Board**: NandLand Go-Board, priced at €70.
- **Monitor**: Acer EK251Q EBI, priced at €109.99.

The capital expenditures, including the board and monitor, are furnished by the school. There are no relevant development environment costs, as the project uses freely available software.

##### Time Invested

Since this is an educational project, significant time will be invested in learning Verilog and FPGA design. The goal is to both create a functional product and gain knowledge over the tools and hardware.

##### Operational Expenditures

As the project is entirely self-contained, running on the FPGA hardware, there are no cloud services, server usage, or ongoing maintenance costs. Operational expenditures are expected to be at a minimum after development.

##### Project Scope

The scope of this project is focused on learning FPGA and Verilog programming while building a fun, playable Frogger game. The cost needs to stay low as the primary objective is education.

### 3.2 Response/Performance & Reliability

This section defines how quickly and reliably the system responds to user inputs and renders changes on the screen.

##### Performance Metrics

- **VGA Display**: The game runs at a 640x480 resolution, there will be smooth transitions between game objects while adhering to VGA timing constraints. Clear visuals and consistent refresh rate are expected.
- **Target FPS**: The game aims for a frame rate of 30 FPS without screen tearing.
- **Input Latency**: The frog’s movement should occur within 10 to 30 milliseconds of pressing a button.
- **Object Movement**: Vehicles and obstacles must move fluidly across the screen without jittering. Object speeds will vary by difficulty, but all movements should be smooth and reliable.

##### Reliability Considerations

- **Error Handling**: The system needs to handle unexpected conditions, such as edge cases like simultaneous button presses. The game will reset or retry if these occur.
- **Stability**: The game should not crash or freeze during normal gameplay, the players need to be able to complete the game without technical issues.

### 3.3 Testability

Testability refers to how easily the system's functionality can be verified. A comprehensive test plan is being developed by a team member. The testing process will cover both simulation and in-hardware testing, with manual gameplay serving as the primary method due to the project's hardware setup.

### 3.4 Documentation

- **Definition:** The quality and comprehensiveness of documentation provided to aid in learning, future reference, and ensuring that the project’s goals, scope, and ambitions are clearly communicated. The documentation must align with our vision for the software.

- **Considerations:**

  - **Comprehensive Documentation:** Our team will ensure that all of the documentation of the project is comprehensive for everyone by having clear english.
  - **Code Documentation:** Code should be easily-readable, and commented with purpose. Ensuring comprehensiveness and clarity in the software. As Verilog is a low level language , clarity will be necessary.

### 3.5 Flexibility

- **Definition:** Flexibility refers to the system's ability to accommodate future enhancements, evolving user needs, and minor adjustments without requiring major rework.

  In this project, flexibility ensures that the game remains reprogrammable over time, allowing for potential feature additions such as new levels, difficulty settings, or user-requested improvements.

- **Considerations:**
  - **Feature Extensions:** Although our team won't provide post-project support, the game’s design must allow future developers to easily modify and extend its functionalities.
  - **Bug Fixes:** A flexible system also simplifies the process of addressing bugs, enabling developers to efficiently implement fixes without needing to overhaul the software structure.

## 4. Risks and Assumptions

### 4.1 Risks

| **Risk**                 | **Impact** | **Mitigation**                                                                                                                                                     |
| ------------------------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Hardware Failure**     | High       | Regular testing of hardware components and keeping backup components available to minimize downtime.                                                               |
| **Software Development** | Medium     | As Verilog is not designed for game development, thorough planning and incremental testing will help manage issues, along with continued learning of the language. |

### 4.2 Budget considerations

As the game is being created from scratch, there should not be any expenses related to the software creation. However, there may be a need to spend some money for unforeseen components or enhancements. It’s important to note that while the FPGA board and VGA monitor were provided by the school, future users of the project will need to obtain these components themselves. We reserve the right to recommend specific functionalities if deemed necessary.

### 4.3 Out of Scope

- The inclusion of an arcade cabinet design is considered out of scope.
- Detailed shapes and graphics are deemed out of scope.
- Sound effects and music are out of scope.
- Integration of leaderboards is out of scope.
- Multi-language support for the game is out of scope.

### 4.4 External resources

To enhance our understanding of the game mechanics, we referred to the official Frogger manual. [Link](https://annarchive.com/files2/Frogger%20%28U%29.pdf)
