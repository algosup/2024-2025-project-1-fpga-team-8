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
    - [1.2.2 - Screen](#122---screen)
  - [2 - Development environment](#2---development-environment)
  - [3 - Development rules](#3---development-rules)
    - [3.1 Naming conventions](#31-naming-conventions)
    - [3.2 Comments](#32-comments)
  - [Glossary](#glossary)
</details>


## 1 - Project definitions

## 1.1 - What is this project?

This project is a reproduction of the game "Frogger" published in 1981 by Konami.

## 1.2 - Provided hardware

### 1.2.1 - Go boards

For this project, we were given a total of 7 [go boards](https://nandland.com/the-go-board/) which can be programmed using Verilog[^1].

A go board is a FPGA[^2] that can be reprogrammed at any time. it has been created by the company [NandLand](https://nandland.com/) to allow students and beginners to learn about FPGAs[^2].

Along with the boards we were given 7 books written by Russell MERRICK, our teacher during this project. This book contains the different usages and subtleties of Verilog.

### 1.2.2 - Screen

We were also given a screen of  [SIZE TO DEFINE], along with a VGA cable to connect a board to the screen,

## 2 - Development environment

Our team uses multiple machines to work on this project, such as:
- 2 IBM-compatible laptops operating on Windows 11,
- 5 MacBooks operating on MacOS Sequoia 15.0.

As for the IDE, we are using Visual Studio Code. Finally, to be able to upload a program to the board we all installed the tool [Apio](https://github.com/FPGAwars/apio/) on our machines.


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
- **Outputs**: o_[Name].

Note that [Name] symbolizes the name given to the element. \
e.g: ```r_Clock```

### 3.2 Comments

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

## Glossary
[^1]: Verilog: A programming language used to program and/or simulate circuit boards. Verilog is notably used with specific hardware such as FPGAs[^2].
[^2]: FPGA: A Field-Programmable Gate Array is a type of integrated circuit that can be programmed after manufacturing, it is notably used to create satellites, military equipment, or other devices requiring low-latency operations.
[^3]: Module: The equivalent of other languages' functions. It is used to create and store the logic of the program.