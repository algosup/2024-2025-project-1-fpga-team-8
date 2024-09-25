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
| Antoine PREVOST    | QA                | Creates tests to validate the quality of the solution and to ensure compliance.           |
| Thibaud MARLIER    | Technical Writer  | Creates comprehensive end-user documentation to facilitate the usage of the application . |

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

