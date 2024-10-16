# 2024 - 2025 Project-1 FPGA Frogger Team-8 - Project Charter

## Project definition

This project aims to create a clone of the classic video game Frogger.

## Scope

This project should be done using Verilog and run on the NANDLAND FPGA Go Board and a VGA screen.

This implementation should only the basic functionality of the game at first. Movement, enemies and win, lose condition.

## Stakeholder

| Role            | Representative                        | Expectation                                                            |
| --------------- | ------------------------------------- | ---------------------------------------------------------------------- |
| School director | Franck JEANNIN (ALGOSUP)              | Clear documentation and management based on the skills learnt in class |

## Team members and responsibilities

| Name | Role | Responsibilities  | Performance criteria  |
| ---------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Max BERNARD  | Project Manager   | Managment (time, resources)<br>Workload distribution<br> Report to stakeholders<br>Risk anticipation and mitigation                  | Project delivered on time <br>Complete software delivered<br>Resource management not exceeding expectations<br>Seamlessly running project |
| David CUAHONTE | Program Manager   | Mock-ups and general design of the software<br>Communication with the client<br>Functional specification delivery<br>Risk management | Functional specification<br>Client approval of the design and functionalities                                                             |
| Aurélien FERNANDEZ   | Technical Leader  | Define coding conventions<br>Choose technical tools used<br>Technical specification delivery<br>Manages developer tasks              | Technical specification                                                                                                                   |
| Quentin CLÉMENT  | Software engineer | Write the code<br>Fix bugs<br>Document the code<br>Create the tests if needed for the code                                           | All required functionalities implemented<br>Bug-free code                                                                                 |
| Mathis KAKAL  | Software engineer | Write the code<br>Fix bugs<br>Document the code<br>Create the tests if needed for the code                                           | All required functionalities implemented<br>Bug-free code                                                                                 |
| Antoine PREVOST     | Quality assurance | Verify documents<br>Test the program<br>Confirm we match the client expectations<br>Test plan delivery                               | Test Plan<br>Identification of bugs<br>Comprehensive and exhaustive documentation                                                         |
| Thibaud MARLIER   | Technical Writer  | Explains complex technical information, making it accessible and easy to understand. | User Manual |

## Project Plan

This project will be using the waterfall project method due to the limited timeframe. However, we plan to use some aspects of SCRUM management with iterations over an MVP. This incrementation will limit the number of bugs by allowing regression testing.

The planning will be made by defining the tasks and objectives pointed out in the brief and during the meeting. Each of these will be sorted by importance and distributed accordingly. To manage them, we will use a GitHub project in our repository to centralize all the resources. Additional management tools will be used to track the achievements and bottlenecks during the project.

After the final presentation which will take place on October, 25th 2024, we will do a post-mortem analysis to summarize what happened.

## Milestones

| Date       | Time   | Milestones                        |
| ---------- | ------ | --------------------------------- |
| 09/23/2024 | 9 A.M. | Project kick-off  |
| 10/07/2024 | 5 P.M. | Functional Specification delivery |
| 10/14/2024 | 5 P.M. | Technical Specification delivery  |
| 10/21/2024 | 5 P.M. | Test Plan delivery                |
| 10/21/2024 | 5 P.M. | Final product codebase delivery   |
| 10/21/2024 | 5 P.M. | User Manual Delivery              |
| 10/25/2024 | 9 A.M. | Final Presentation Pitch          |

## Deliverables

The main deliverable is the source code of the Frogger.

Additional documents will be given to the client:

- Functional Specification
- Technical Specification
- Test Plan
- User Manual
- Management Planning & Weekly reports
- Wiki

In addition, a presentation of our work will be done to the client as a 15-minute long presentation.

## Allocated Resources

Budget: 0€
Hardware : 7 FPGA Go Boards & 2 VGA Screens
Workforce allocated: 7 team members
Work-time: 14 half-days of 3h30 each

Total man hours estimation: 343h

## Risks

| Type                                     | Description                                                                                                                | Likelihood | Impact                  | Mitigation                                                     |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ---------- | ----------------------- | -------------------------------------------------------------- |
| Hardware Failure                         | The FPGA Go Board provided to us by the client may fail from user error or unexpected issue. | Low     | Varies from low to high | Avoidance                                                      |
| Copyright issues | Our copy of frogger may not be allowed by the copyright owner | High     | Low                    | Use the legally distinct name froggo |