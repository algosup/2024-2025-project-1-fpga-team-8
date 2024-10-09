<center>

# Technical specifications

<hr>
Created by: Aurélien FERNANDEZ
<hr>
</center>


<details>
<summary>Table of content</summary>

- [Technical specifications](#technical-specifications)
  - [1 - Project definitions](#1---project-definitions)
  - [1.1 - What is this project?](#11---what-is-this-project)
  - [1.2 - Provided hardware](#12---provided-hardware)
    - [1.2.1 - Go boards](#121---go-boards)
      - [1.2.1.1- Overview](#1211--overview)
      - [1.2.1.1 - Components of the board](#1211---components-of-the-board)
    - [1.2.2 - Screen](#122---screen)
  - [2 - Development environment](#2---development-environment)
    - [2.1 - Computers](#21---computers)
    - [2.2 - Programming language](#22---programming-language)
      - [2.2.1 What is an FPGA?](#221-what-is-an-fpga)
      - [2.2.2 - What is Verilog?](#222---what-is-verilog)
      - [2.2.3 - Why Verilog?](#223---why-verilog)
  - [3 - Development rules](#3---development-rules)
    - [3.1 Naming conventions](#31-naming-conventions)
    - [3.2 - Comments](#32---comments)
    - [3.3 - Code conventions](#33---code-conventions)
  - [4 - Technical implementations](#4---technical-implementations)
    - [4.1 - Features required](#41---features-required)
    - [4.2 - Display the game](#42---display-the-game)
    - [4.2.1 - Frame management](#421---frame-management)
    - [4.2.2 - Creating the map](#422---creating-the-map)
      - [4.2.2.1 - The grid](#4221---the-grid)
      - [4.2.2.2 - Bitmap](#4222---bitmap)
    - [4.2.3 - Sprites](#423---sprites)
    - [4.3 - Control the frog](#43---control-the-frog)
    - [4.4 - Lane](#44---lane)
    - [4.5 - Cars](#45---cars)
      - [4.5 - Logs](#45---logs)
  - [Glossary](#glossary)
</details>


## 1 - Project definitions

## 1.1 - What is this project?

This project is a reproduction of the game "Frogger" published in 1981 by Konami.

## 1.2 - Provided hardware

### 1.2.1 - Go boards

#### 1.2.1.1- Overview
For this project, we were given a total of 7 [go boards](https://nandland.com/the-go-board/) which can be programmed using Verilog[^1].

A go board is an FPGA[^2] that can be reprogrammed at any time. it has been created by the company [NandLand](https://nandland.com/) to allow students and beginners to learn about FPGAs[^2].

Along with the boards we were given 7 books written by Russell MERRICK, our teacher for this project. This book contains the different usages and subtleties of Verilog.

#### 1.2.1.1 - Components of the board


- Lattice ICE40 HX1K FPGA
- Mini USB
- Four Settable LEDs
- Four Push-Buttons
- A Dual 7-Segment LED Display
- VGA Connector
- External Connector (PMOD)
- 25 MHz on-board clock
- 1Mb Flash for booting up the FPGA

| Component   | Name used in code | Pin |
| ----------- | ----------------- | --- |
| LED 1       | o_LED_1           | 056 |
| LED 2       | o_LED_2           | 057 |
| LED 3       | o_LED_3           | 059 |
| LED 4       | o_LED_4           | 060 |
| Switch 1    | i_Switch_1        | 053 |
| Switch 2    | i_Switch_2        | 051 |
| Switch 3    | i_Switch_3        | 054 |
| Switch 4    | i_Switch_4        | 052 |
| VGA HSync   | o_VGA_HSync       | 026 |
| VGA VSync   | o_VGA_VSync       | 027 |
| VGA red 0   | o_VGA_Red_0       | 036 |
| VGA red 1   | o_VGA_Red_1       | 037 |
| VGA red 2   | o_VGA_Red_2       | 040 |
| VGA green 0 | o_VGA_Grn_0       | 029 |
| VGA green 1 | o_VGA_Grn_1       | 030 |
| VGA green 2 | o_VGA_Grn_2       | 033 |
| VGA blue 0  | o_VGA_Blu_0       | 028 |
| VGA blue 1  | o_VGA_Blu_1       | 041 |
| VGA blue 2  | o_VGA_Blu_2       | 042 |
| PMOD 1      | io_PMOD_1         | 065 |
| PMOD 2      | io_PMOD_2         | 064 |
| PMOD 3      | io_PMOD_3         | 063 |
| PMOD 4      | io_PMOD_4         | 062 |
| PMOD 5      | /                 | /   |
| PMOD 6      | /                 | /   |
| PMOD 7      | io_PMOD_7         | 078 |
| PMOD 8      | io_PMOD_8         | 079 |
| PMOD 9      | io_PMOD_9         | 080 |
| PMOD 10     | io_PMOD_10        | 081 |
| Segment 1 A | o_Segment1[0]     | 003 |
| Segment 1 B | o_Segment1[1]     | 004 |
| Segment 1 C | o_Segment1[2]     | 093 |
| Segment 1 D | o_Segment1[3]     | 091 |
| Segment 1 E | o_Segment1[4]     | 090 |
| Segment 1 F | o_Segment1[5]     | 001 |
| Segment 1 G | o_Segment1[6]     | 002 |
| Segment 2 A | o_Segment2[0]     | 100 |
| Segment 2 B | o_Segment2[1]     | 099 |
| Segment 2 C | o_Segment2[2]     | 097 |
| Segment 2 D | o_Segment2[3]     | 095 |
| Segment 2 E | o_Segment2[4]     | 094 |
| Segment 2 F | o_Segment2[5]     | 008 |
| Segment 2 G | o_Segment2[6]     | 096 |
| Clock       | i_Clk             | 015 |
| UART RX     | i_UART_RX         | 073 |
| UART TX     | i_UART_TX         | 074 |

![](./images/fpga.png)

The clock, operating at a frequency of 25Mhz, performs 25 000 000 cycles per second. 

The default parameters of the go board will remain unchanged, which means no component is added, removed or modified and the clock will hold the same frequency throughout the project.

### 1.2.2 - Screen

We were also given a screen of  1920 pixels width by 1080 pixels height, along with a VGA cable to connect a board to the screen. The specific model of our screen is the LCD monitor EK1 Series-EK251Q.

## 2 - Development environment

### 2.1 - Computers

Our team uses multiple machines to work on this project, such as:
- 2 IBM-compatible laptops operating on Windows 11,
- 5 MacBooks operating on MacOS Sequoia 15.0.

As for the IDE, we are using Visual Studio Code. Finally, to be able to upload a program to the board we all installed the tool [Apio](https://github.com/FPGAwars/apio/) on our machines.

### 2.2 - Programming language

#### 2.2.1 What is an FPGA?

Fields ProGramable Arrays, in short FPGA, are alternatives to processors capable of executing multiple instructions at the same time whereas processors are executing the instructions sequentialy, one at the time. The logic blocks of the FPGA, used to perform the different calculations are configurable, this allows FPGAs to be highly versatile. All these advantages allow FPGAs to be faster than regular processors in terms of calculations per cycles.

To summarise, here is the list of the different advantages of FPGAs:
- Highly flexible,
- Parallel processing,
- Reconfigurability,
- Rapide prototyping.

FPGAs also possess downsides, here is the list of the different downsides:
- They cost more to produce than traditional circuit boards,
- They require more power to run than specialised circuit boards,
- They may be less performant than specialised circuit boards,
- They are generaly bigger physically than traditional circuit boards due to the fact that logic blocks are not centralised in a single unit but physcial components.

FPGAs are used in very specific fields, more precisely in military projects, in radars and in aerospace project such as satellites, they can also be used for projects requiring fast calculations or video processing.

#### 2.2.2 - What is Verilog?

The programming language used for this project is Verilog. It is a programming language specialised in the programming of FPGAs[^2]. Verilog possesses multiple particularities listed as:
- There is no order of execution, meaning that all lines present in a module are executed simultaneously, the only exceptions being the lines requiring specific conditions such as "always" and if-else conditions.
- Verilog belongs to a type of programming languages known as "hardware description languages" which are languages that are used to model electronic systems. Although the language is easier to read than assembly languages due to a syntax similar to C-like languages it manages component in a lower level than assembly language as it interacts directly with wires.

A verilog project is composed of multiple type of files such as:
- apio.ini: This is the file containing two value "top-module" and "board".
- .v files: Standing for verilog files, they contain the different functions used for the project, the file named after the "top-module" value is the one called upon running the program, the module contained in this file must have the same name as the file.
- .pcf file: This is the file containing the different inputs and outputs used for this project. The file must be named after the "board" value.
- .mem: Standing for memory, this file stores a matrix of values separated by whitespaces, the values can be called in the program at any given time.

#### 2.2.3 - Why Verilog?

Verilog is not the only HDL to exist, VHDL is another popular HDL compatible with our programming board. Here is the list following the reasoning as to why we are using Verilog:
- The use of Verilog is a requirement of the project.
- Verilog is the most popular hardware description language when working on FPGAs[^2].

## 3 - Development rules

In order to keep the repository clean and maintainable, we choose to follow specific conventions.

### 3.1 Naming conventions

Here is the list of the naming conventions regarding the repository and the file architecture of the project:
- **Branches**: pascalCase,
- **Folder & files**: snake_case,

Here is the naming conventions regarding Verilog:
- **Modules[^3]**: snake_case,
- **Wires**: w_[Name],
- **Registers**: r_[Name],
- **Inputs**: i_[Name],
- **Outputs**: o_[Name],
- **Parameters & defines**: [NAME].

Note that [Name] symbolises the name given to the element. \
e.g: 
```
reg r_Clock;
assign o_My_Led=1;
parameter MYPARAM = 20;
```

### 3.2 - Comments

The use of comments is crucial for the maintainability of a project is the use of comments. It allows collaborators and future developer to maintain and update the code without struggling on understanding the inner part of a program.

In Verilog comments can be written in multiple ways: 

In a Verilog file:
``` 
// This is a single line comment

/*
This is a multiline
comment
*/
```

In a PCF file:
```
## This is a comment
```

Comments should be regularly written to ensure the comprehension of the code of current and future developers and reviewers. 

### 3.3 - Code conventions

The code must follow few but strict rules such as:

- The module contained in a file must have the same name as its file,
- The spacing 4 spaces between each level of indentation.

## 4 - Technical implementations

### 4.1 - Features required

Here is a short summary of the features that are required for the success of this project. For a more detailed version of these features, refer to the [functional specifications](../functional_specifications/functional_specifications.md)
| Feature name | Description                                                                                                                                                                                                               |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Move         | The player can move a playable character.                                                                                                                                                                                 |
| Life system  | The player possesses 3 lives, when this number reaches 0, a game over screen appears and the game resets.                                                                                                                 |
| Grid         | The screen is divided by a 13x13 grid, where each tiles is 32x32 pixels.                                                                                                                                                  |
| Grass        | 2 rows on the grid are composed of "grass" tiles, one at the bottom, the second in the middle of the screen.                                                                                                              |
| Road         | 5 rows on the grid are composed of "road" tiles, they all are between the two rows of "grass".                                                                                                                            |
| water        | 5 rows on the grid are composed of "water" tiles, they all are between the second rows of "grass" and the last row.                                                                                                       |
| Lilypads     | The last row is composed of 5 lilypads with walls on the left and right of each lilypad. When the player collides with every lilypads, the player wins, when the player collides with the walls, the player loses a life. |
| Cars         | Cars are moving through the screen from left to right or  from right to left, they can only appear on roads. When the player collides with a car, the player loses a life.                                                |
| Crocodiles   | Crocodiles are moving through the screen from left to right or from right to left, they can only appear on water. When the player collides with the mouth of a crocodile, the player loses a life.                        |
| turtles      | Turtles are moving through the screen from left to right or from right to left, they can only appear on water. Some turtles can go under water.                                                                           |
| Snakes       | Snakes are moving through the screen from left to right or from right to left, they can only appear on the second "grass" row. When the player collides with one, the player loses a life.                                |

### 4.2 - Display the game

To display images on our screen, we are using a VGA cable, due to the technical limitations of a VGA cable, we are limited to a size of 640x480 pixels as the active area with an inactive area of 794x525 pixels as seen in the following image.
![](./images/display.png)

### 4.2.1 - Frame management

 Knowing that our board has a frequency of 25Mhz, and that the screen used is of 794x525, translating to 416,850 pixels we can calculate the time needed to change a frame on the screen. For this, we only have to divide the number of pixels to change by the frequency of the clock:

 416850 / 25000000 = 0.01667

 Following this calculus, we can conclude it takes 0.01667 seconds to change a frame. Finally we can deduce that we can manage a framerate of 60 frame per second exceeding the limit of 30 frame per second of VGA.

### 4.2.2 - Creating the map

#### 4.2.2.1 - The grid
To create the map we are using a grid system, dividing the screen into 32x32 pixels tiles. With 32x32 cells, the grid result with a size of 15x13 cells filling the width as 15 cells equals 480 pixels. The height however leaves 224 pixels, which is intentional as in the original game this space is used to display the score and the high-score.

Here is the representation of the grid on our screen.

![](./images/grid_display.png)

#### 4.2.2.2 - Bitmap

Additionally to the use of a grid, we are using a bitmap, the bitmap is a table representing the type of tiles the grid is composed of, we currently have 5 types of tiles:
- Grass/safe area,
- Road,
- Water,
- Lilypad,
- wall.

The bitmap is created as a two-dimensional array presented as such:
<center>

```
040040040040
222222222222
222222222222
222222222222
222222222222
222222222222
333333333333
111111111111
111111111111
111111111111
111111111111
111111111111
333333333333
```
</center>

Where, every value is an int that can be interpreted as such:
- 0 -> wall,
- 1 -> road,
- 2 -> water,
- 3 -> grass,
- 4 -> lilypad.

Finally, the origin, 0x0, is placed at the bottom left of the grid.

### 4.2.3 - Sprites

TODO

### 4.3 - Control the frog 

To control the frog we are using two value:
- w_Frogger_X, to control the x position of the frog,
- w_Frogger_Y, to control the y position of the frog.

These two value indicate the position of the frog on the grid.

e.g: If the frog has a position of: X=3, Y=5:

<center>

![](./images/position.png)

</center>

To move the frog, the player can use the 4 push-buttons present on the go-board:
- button 1 -> increase Y
- button 2 -> decrease Y
- button 3 -> decrease X
- button 4 -> increase X

Finally, the 4 buttons are subject to a side-effect called "boucing". The boucing is a common problem of physical switches, when you are pressing a button, two metal parts connect to let electricty pass, the contact is not made instantly, in the span of 1 millisecond, multiple contacts are made which in turn distort the desired result by repeatedly turning on and off.

Here is the representation of a boucing:
![](./images/bouncing.png)

To overcome this effect, we can wait for a certain number of cycles before taking the change of state into account. For this project waiting 25 000 cycles (1 millisecond) before reacting to the change is sufficient enough to overcome this effect without impacting the game itself.

### 4.4 - Lane

To manage the different obstacles we are using a system of lanes, these lanes are use to choose the Y position, the direction, the type of obstacle, their numbers and the interval in cycles between each obstacle.

Here are the different input of the lane:

| Name     | Descrition                                                                     | Type             | Default value |
| -------- | ------------------------------------------------------------------------------ | ---------------- | ------------- |
| INIT_Y   | The initial Y position of the lane                                             | constant int     | 1             |
| DIR      | The direction the obstacle is heading. 0 = right, 1 = left                     | constant boolean | 0             |
| TYPE     | The type of osbtacle the lane contains, 0 = car, 1 = log, 2 = snake 4 = turtle | constant int     | 0             |
| COUNT    | The number of obstacle on the lane at the same time                            | constant int     | 1             |
| INTERVAL | The number of cycles between two obstacle                                      | constant int     | 20 000        |

### 4.5 - Cars

The cars are instances possessing a few values:

**inputs:**
| Name            | Description                                           | Type               | Default value |
| --------------- | ----------------------------------------------------- | ------------------ | ------------- |
| MAX_X           | The maximum speed a car can have                      | constant int       | 20            |
| CAR_SPEED       | The speed of the car                                  | constant int       | 1             |
| SLOW_COUNT      | A counter which, once finished allows the car to move | constant int       | 4 000 000     |
| INIT_X          | The base X position of the car                        | constant int       | 0             |
| INIT_Y          | The base Y position of the car                        | constant int       | 13            |
| i_Clk           | The clock                                             | boolean            | None          |
| i_Col_Count_Div | The X position of the car                             | 6-bit positive int | None          |
| i_Row_Count_Div | The Y position of the car                             | 6-bit positive int | None          |

**output**
| name    | description                                                           | type               |
| ------- | --------------------------------------------------------------------- | ------------------ |
| o_Car_X | The current X position of the car, this value is used to draw the car | 6 bit positive int |
| o_Car_Y | The current Y position of the car, this value is used to draw the car | 6 bit positive int |

#### 4.5 - Logs

## Glossary
[^1]: Verilog: A programming language used to program and/or simulate circuit boards. Verilog is notably used with specific hardware such as FPGAs.
[^2]: FPGA: A Field-Programmable Gate Array is a type of integrated circuit that can be programmed after manufacturing, it is notably used to create satellites, military equipment, or other devices requiring low-latency operations.
[^3]: Module: The equivalent of other languages' functions. It is used to create and store the logic of the program.