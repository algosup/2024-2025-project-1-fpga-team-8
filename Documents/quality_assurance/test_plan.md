# Test plan

<details>
<summary>Table of contents</summary>

- [Test plan](#test-plan)
  - [1. Introduction](#1-introduction)
  - [2. Test Environment](#2-test-environment)
    - [2.1. Hardware Platform](#21-hardware-platform)
      - [2.1.1. FPGA Board](#211-fpga-board)
      - [2.1.2. Interfaces](#212-interfaces)
    - [2.2. Software Tools](#22-software-tools)
    - [2.3. Test Equipment](#23-test-equipment)
  - [3. Scope of Testing](#3-scope-of-testing)
    - [3.1. In Scope](#31-in-scope)
    - [3.2. Out of Scope](#32-out-of-scope)
  - [4. Test Objectives](#4-test-objectives)
  - [5. Testing Strategy](#5-testing-strategy)
    - [5.1. Test Methodology](#51-test-methodology)
      - [5.1.1. BlackBox Testing](#511-blackbox-testing)
      - [5.1.2. Simulation Testing](#512-simulation-testing)
      - [5.1.3. Hardware Testing](#513-hardware-testing)
      - [5.1.4. Regression Testing](#514-regression-testing)
    - [5.2. Test Cases](#52-test-cases)
    - [5.3. Test Reports](#53-test-reports)
    - [5.4. Bug Lifecycle](#54-bug-lifecycle)

</details>

## 1. Introduction

This document outlines the test plan for verifying and validating the Frogger game developed in Verilog for execution on the Go Board FPGA platform. The objective is to ensure that the game functions correctly, both in terms of gameplay logic and interaction with the hardware peripherals (7-segment displays, switches, LEDs).

## 2. Test Environment

The test environement includes the hardware, the software and the development tools necessary for testing the Frogger game that will be uploaded on the FPGA.

### 2.1. Hardware Platform

#### 2.1.1. FPGA Board

- Go Board FPGA Platform
  - Lattice ICE40 HX1K FPGA
  - Mini USB
  - Four Settable LEDs
  - Four Push-Buttons
  - A Dual 7-Segment LED Display
  - VGA Connector
  - External Connector (PMOD)
  - 25 MHz on-board clock
  - 1Mb Flash for booting up the FPGA

The defaut settings of the hardware won't be changed to ensure compatiility of our program among all Go Boards. Here is the list of the default voltages and parameters of our board:

<!-- Add the list of default parameters (CF: https://nandland.com/wp-content/uploads/2022/06/Go_Board_V1.pdf) -->

#### 2.1.2. Interfaces

**Input:**

- Push-Buttons for Frogger control

**Output:** 

- VGA Display for rendering game visuals
- Settable LEDs to display the remaining lives and status of the game
- Dual 7-Segment LED Display to indicate the score of the user

### 2.2. Software Tools

**Language:**

- Verilog HDL (Hardware Description Language): This language will be used to design and verify the electronic systems of our game. It is the support of the game mechanics and the display management.

**Simulation Tool:** 

- [EDAPlayGround](edaplayground.com) - This website will be used to test throughly the code before being synthesized and deployed to hardware.
  - **Simulator Used:** Icarus Verilog 12.0
  - **Compile Options:** `-Wall -g2012`
  - **Additional Tools:** Usage of EPWave to verify the state of every variable.

**Synthesis Tool:**

- [Apio](https://apiodoc.readthedocs.io/en/stable/index.html) will be used for synthesizing the Verilog code and to create the bitstream for the FPGA.

<!-- Potentially missing STA Tools, further investigations on this subject will be done -->

### 2.3. Test Equipment

- **Monitor:** <!-- Check the complete specifications  -->
- **Input Device:** The only inputs will be the Physical buttons located on the Go Board FPGA
- **Non-Graphical Outputs:** 4 Settable LEDs and Dual 7-Segment LED Display wired on the Go Board

## 3. Scope of Testing

The scope of testing of Frogger's clone encompasses all key requirements pointed out by the client and mentionned in the specifications. It will ensure the correctness of the exectued actions, the execution of a smooth gameplay and correct system performance on the Go Board.

### 3.1. In Scope

- **Game Logic & Behaviour:**
  - Frog movements based on user input in the following directions: Up, Down, Left, Right.
  - Collision detection with ennemies (cars)
  - Scoring system when reaching the top of a level
  - Game states management to handle game overs and level completions

- **Hardware interfaces:**
  - Buttons to control Frogger's movement.
  - VGA output for visualizing the game elements.
  - LED indicators to indicate remaining lives.

- **Performance:**
  - Verify response time between inputs and display.
  - Ensure the game runs smoothly at a constant framerate.
  - Acknowledge the program's logic and timings.

### 3.2. Out of Scope

The following elements will nor be covered in the test plan, nor in the test cases:

- **Advanced Audio & Sound Effects**
  - Audio functionality (if any) has no output interface on the Go-Board, and consequently, won't be part of the testing scope.
- **New Hardware Implmentations:**
  - To ensure our Frogger clone can be executed on any Go Board, new hardware implementation is not planned and won't be reviewed.
- **Addition of a game menu:**
  - The addition of a screen like this one could be a great implementation, however, it is not part of the game mechanics, and consequently, won't be reviewed.

## 4. Test Objectives

The objective of the testing phase of Frogger is to rigorously evaluate that our clone meets the requirements and objectives mentionned in the document given by the client, but also in the specifications. Consequently, the testing phase will focus on verifying the following points:

1. Validate Requirements - Core gameplay features

    Those requirements represent the MVP expected by the end of the project. Referring to the client's expectations, we should, at least, validate the following points:

    - Having a 32-pixel wide white square representing the frog. This square can be moved with the Switch buttons.
    - There must be at least one car at a time. It will be represented as a 32-pixel wide white square.
    - There should be at least 1 level, meaning the level resets when reaching the top.

2. Validate Objectives - Nice-to-have features

    These objectives are not mandatory to validate the submission to the client. However, these are additions we decided to implement in the final game.

    - The frog shall be shown as a sprite that looks like a real frog and be coloured.
    - A maximum of 16 cars should be present on the screen at a time, each car having the possibility to move at its own pace.
    - There should be at least 8 levels in the game. The difficulty among those levels should be increasing.

3. Test I/O Responsiveness & Accuracy

    As the product will be a game, we need to assess it is playable. Consequemtly, all the outputs will be checked to validate the specifications requirements.

    - All user actions via buttons is captured and triggerred only once per click. Information is correctly processed and moves the frog.
    - Verify correct alignments, with elements appear and update in the correct tiles.
    - The gameplay should be fluid, with a constant framerate and correct timings between interactions.

## 5. Testing Strategy

Our strategy employs a multifaceted approach which will consists in multiple phases of testing to identify issues early on in the project.

The test phase will be ran 

### 5.1. Test Methodology

#### 5.1.1. BlackBox Testing

To ensure a correct delivery in the project's timeframe, we need to validate early on if the functionnalities are working on our app without focusing on the implemetation of those features.

This will allow us to validate the core functionnalities early on and focus on iterating to implement less critical features.

For this test phase, we will solely test the solutions via gameplay sessions.

#### 5.1.2. Simulation Testing

FPGAs are a blackbox executing code without any possibility of simple debugging, apart from creating a logic analyzer will be used only once. Rather than going for this extensive solution, we will use simulation to ensure the states of each component follow the specifications' instructions, but also verify if the specifications themselves are accurate.

As mentionned in the [Test Environment section](#22-software-tools), we are going to use [EDAPlayGround](edaplayground.com), a website on which we can execute our Verilog and test components independently, but also in the game environment.

Simulation testing on EDAPlayGround introduces various keywords helping us getting more precise results on the executed tests:

- `$dumpfile("dump.vcd");`
- `$dumpvars;`
- `assert();`: This statement asserts a component in our FPGA design has the same value as what our exepectation. If the assertion is false, the testing breaks automatically.
- `#10`: 10 here can be replaced by any positive integer to represent the number of clock cycles during which we have to wait to execute the code following this statement.

The simulations tests scripts will be stored in the [simulations folder](./simulations/), and be updated to test every new addition to the Frogger clone.

#### 5.1.3. Hardware Testing



#### 5.1.4. Regression Testing

To validate new additions and fixes to the software, the whole test bed will be ran every time code will be merged 

### 5.2. Test Cases

All of our codebase will be tested following the defined [test cases](./test_cases.md). Those test cases are using all the mehtodologies explained in the [Methodology Section](#51-test-methodology).

### 5.3. Test Reports

Each testing session consists in testing all the existing test cases. After each testing session, the results will be added into a [Google Sheets Document](https://docs.google.com/spreadsheets/d/13jn9MZXwvPJthTED8lPlTzNpH2iK69MnvhQDEM3IoZw/edit?usp=sharing).

This will allow the development team to know which test cases failed on a run by run basis, helping them identify the points where fixes should be made to make the most faithful clone of Frogger. It will also help them track their progression over time, and will help managment know if the allocated time and resources to testing and development are sufficient or not.

After each test execution, a test report will be added to the [Test Reports](./test-reports/) folder, linking all the identified issues and summarizing the overall 

### 5.4. Bug Lifecycle

