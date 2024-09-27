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
      - [Game Levels (1-4):](#game-levels-1-4)
    - [2.5 Scoring System](#25-scoring-system)
    - [2.6 End of Game](#26-end-of-game)

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

"Frogger FPGA" is a project aimed at creating a fun and interactive Frogger game using FPGA technology and Verilog programming. In this classic arcade-style game, players guide a frog across a busy road filled with moving cars and navigate a river with logs and other obstacles. The goal is to safely reach the other side while avoiding hazards. This project prioritizes an engaging gaming experience while also showcasing the power of FPGA for real-time applications.

_A logo of the game is shown below:_

<div align="center">

//placeholder image

</div>

### 1.2 Purpose

This project is an opportunity for us to dive deeper into Verilog programming and FPGA technology. Our main goal is to create a fun and exciting Frogger game that can be displayed on a 640x480 VGA monitor. The game will involve a frog crossing a road filled with obstacles, focusing on delivering a smooth, engaging experience for users.

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

In the FPGA Frogger game, the player’s goal is to guide a frog from the bottom of the screen to one of the safe home bays at the top. The player must help the frog cross a busy highway filled with fast-moving vehicles, and then navigate a river by jumping on logs, turtles, and other floating objects. The challenge lies in avoiding obstacles such as cars, diving turtles, and alligator jaws. Successfully reaching a home bay earns points, and additional bonuses can be collected along the way.

To complete a level, the player must guide five frogs safely into the home bays. Each frog represents a life, and the player starts with four lives. The game ends when all frogs are lost or when the player completes all the levels. Additionally, Frogger has a time limit of 30 seconds (or 60 ticks) per frog, shown by a time band at the bottom of the screen. The remaining time also contributes to the player’s score if the frog reaches a home bay on time.

_Frogger game:_

<div align="center">

//placeholder image

</div>

### 2.2 Gameplay Mechanics

#### 2.2.1 Gameplay movement

The frog advances one space per button press. When the frog reaches the top row of the screen and completes the level, the frog is automatically repositioned at the bottom to begin the next level.

_Frog:_

<div align="center">

//placeholder image

</div>

#### 2.2.2 Gameplay controls

The player controls Frogger using the four buttons on the FPGA system. These buttons allow movement in four directions: up, down, left, and right.

_FPGA BUTTONS:_

<div align="center">

//placeholder image

</div>

#### 2.2.3 Highway Crossing

The player begins each round by moving the frog through a four-lane highway. Cars and trucks move horizontally across the screen in both directions at varying speeds. Traffic patterns vary in speed and direction, presenting a continuous challenge for the player to navigate without getting squashed. If the frog touches any vehicle, the player loses a life.

Each forward jump earns the player 10 points. Completing this section will lead the players to the next section.

_Highway:_

<div align="center">

//placeholder image

</div>

#### 2.2.4 River Crossing

After the highway, Frogger reaches the riverbank. To get to the home bays, the player must jump across floating logs, turtles, and other moving objects. The logs move at different speeds and in different directions. Turtles periodically dive underwater, forcing the player to hop off before they disappear.

Additional river hazards include snapping alligator jaws, which can appear while Frogger is on logs. As the game progresses, new threats like fast-moving otters that can pull the frog into the water emerge, adding difficulty.

The river is divided into 6 rows:

- The first row contains set of three turtles;
- The second row contains either short logs or long logs;
- The third row contains long logs only;
- The fourth row contains sets of two turtles;  
- The fifth row contains random logs from short, medium or long ones; 
- The sixth and last row is the goal, containing five safe spot, that the user must fill. And other from that, the grass is unsafe for the user.

Note: From the first to the fifth row, objects are spawned randomly, we will dive into it later.

_River Bank:_

<div align="center">

![river](./images/river.png)

</div>

**Logs**:

They come in three different sizes and shapes, a short one, a medium one and a long one. Which the frog can rely on, without falling in the water.
The logs float from left to right.

Frogger can jump from side to side of the log, but beware not to fall into the water.
Moreover, you can jump from a log to another floating object forward or backward.


_Logs_:

<div align="center">

![log1](./images/log1.png) <br>
![log2](./images/log2.png) <br>
![log3](./images/log3.png)

</div>

**Key hazards**:

- **Diving Turtles**: They come in set of three or in set of two turtles. However,avoid jumping on turtles that are diving underwater, as Frogger will fall and lose a life. When they are overwater, they act as a log, meaning you can jump on the turtles' back. After a second, the state of the turtle changes to underwater. The frog cannot stay above them and if the player is still on the frog when they dive, the frog will fall into the water. The players must be on another floating object before the dive of the turtle to save himself. The frog will fall in the water if the user jumps to the left or the right off either of the end turtles.

_Diving Turtles:_

<div align="center">

![turtles](./images/turtle.png)

</div>

- **Alligator Jaws**: Beware of logs with hidden alligator jaws. They are alligator disguised as a log. The thing that deferentiate them fron the logs are their jaws. You can jump on the alligator's back safely, but if frogger jumps into the alligator's jaw. The user loses a life. Every second, the alligator clacks his jaw, emphasizing the dangerous character he is.

_Alligator:_

<div align="center">

![alligator](./images/alligator.png)

</div>

- **Otters**: These creatures swim rapidly and can grab Frogger off floating objects, forcing the player to navigate carefully. They spawn only after the level 3. Every second, they have a little swimming animation that occurs.


_Otters:_

<div align="center">

![otter](./images/otter.png)

</div>

If Frogger falls into the river, the player loses a life, as the frog cannot swim.

#### 2.2.5 River Banks

There are five home bays at the top of the screen. To complete a level, Frogger must safely reach one of these bays. However, the bays may be blocked by hazards like alligator heads or occupied by another frog. If this occurs, the player must wait or choose a different bay.

Reaching a home bay grants **50 points**, and players can earn bonus points if a fly or pink frog appears, as explained in the next section. The player must navigate all five frogs to the home bays to complete a level.

_River banks:_

<div align="center">

![goal](./images/goal.png)

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

#### Game Levels (1-4):

- **Level 1 & 2**:

  - At the start, Frogger can float off-screen safely, allowing for a moderate introduction to the gameplay.
  - Traffic patterns are manageable, with vehicles moving at a moderate speed. Players will have time to learn the timing of their movements without the pressure of fast-moving obstacles.
  - River obstacles, such as logs and turtles, are plentiful, the players will have ample opportunities to practice hopping safely across the water.
  - As players progress through these levels, the speed of traffic and river objects gradually increases.

- **Level 3 & 4**:
  - In these advanced levels, Frogger can no longer float off-screen.
  - The game starts at a higher difficulty, with traffic moving significantly faster.
  - New hazards are introduced, such as **otter attacks** appearing off logs or turtles, which players must avoid to prevent losing lives.
  - With fewer floating objects in the river, players must navigate a more treacherous environment.

To proceed to the next level, the player must safely guide five frogs into the home bays. After completing all levels, the difficulty ramps up again.

<!-- Uncertain if we make it infinite or if we do 8 levels as stated before. -->

### 2.5 Scoring System

Points are awarded for various actions within the game:

- **Jumping Frogger forward**: 10 points per forward jump.
- **Reaching a home bay**: 50 points.
- **Guiding all five frogs home**: 1,000 points.
- **Rescuing the pink frog**: 200 points.
- **Eating a fly**: 200 points.
- **Bonus points for remaining time**: 10 points per remaining tick.

If the player reaches a high score of 20,000 points and fewer than four frogs remain, an extra frog (life) is awarded.

### 2.6 End of Game

The game ends when all frogs (lives) are lost. The player can restart the game or reset it via the FPGA system to begin a new round.
