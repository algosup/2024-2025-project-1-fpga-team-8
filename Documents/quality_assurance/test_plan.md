# Test plan

<details>
<summary>Table of contents</summary>

- [Test plan](#test-plan)
  - [1. Introduction](#1-introduction)
  - [2. Test Environment](#2-test-environment)
    - [2.1 Hardware Platform](#21-hardware-platform)
      - [2.1.1 FPGA Board](#211-fpga-board)
      - [2.1.2 Interfaces](#212-interfaces)
    - [2.2 Software Tools](#22-software-tools)
    - [2.3 Test Equipment](#23-test-equipment)
  - [3. Test Objectives](#3-test-objectives)

</details>

## 1. Introduction

This document outlines the test plan for verifying and validating the Frogger game developed in Verilog for execution on the Go Board FPGA platform. The objective is to ensure that the game functions correctly, both in terms of gameplay logic and interaction with the hardware peripherals (7-segment displays, switches, LEDs).

## 2. Test Environment

The test environement includes the hardware, the software and the development tools necessary for testing the Frogger game that will be uploaded on the FPGA.

### 2.1 Hardware Platform

#### 2.1.1 FPGA Board

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

#### 2.1.2 Interfaces

**Input:**

- Push-Buttons for Frogger control

**Output:** 

- VGA Display for rendering game visuals
- Settable LEDs to display the remaining lives and status of the game
- Dual 7-Segment LED Display to indicate the score of the user

### 2.2 Software Tools

**Language:**

- Verilog HDL (Hardware Description Language): This language will be used to design and verify the electronic systems of our game. It is the support of the game mechanics and the display management.

**Simulation Tool:** 

- [EDAPlayGround](edaplayground.com) - This website will be used to test throughly the code before being synthesized and deployed to hardware.
  - **Simulator Used:** Icarus Verilog 12.0
  - **Compile Options:** -Wall -g2012
  - **Additional Tools:** Usage of EPWave to verify the state of every variable.

**Synthesis Tool:**

- [Apio](https://apiodoc.readthedocs.io/en/stable/index.html) will be used for synthesizing the Verilog code and to create the bitstream for the FPGA.

<!-- Potentially missing STA Tools, further investigations on this subject will be done -->

### 2.3 Test Equipment

- **Monitor:** <!-- Check the complete specifications  -->
- **Input Device:** The only inputs will be the Physical buttons located on the Go Board FPGA
- **Non-Graphical Outputs:** 4 Settable LEDs and Dual 7-Segment LED Display wired on the Go Board

## 3. Test Objectives

The objective of the testing phase of Frogger is to rigorously evaluate that our clone meets the original game performance and behaviour.

