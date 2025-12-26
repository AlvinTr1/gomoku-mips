# gomoku-mips
This project is a complete implementation of Gomoku (Five in a Row) written in MIPS assembly language.
The game runs in a MIPS simulator and supports human vs CPU gameplay, turn-based input, and automatic win detection.

The goal of the project was to explore low-level program design, including memory management, control flow, and modular assembly programming.

**Two players:**
X — Human player
O — CPU
Players take turns placing a piece on the board.
The first player to get five in a row (horizontal, vertical, or diagonal) wins.

**Features:**
Fully implemented Gomoku game logic in MIPS
Modular assembly structure (separate files for logic and checks)
Board state stored and updated in memory
Automatic win detection
Input parsing using grid-style coordinates (e.g., 2 A)
CPU opponent (basic move logic)

**Technologies Used**
Language: MIPS Assembly
Simulator: MARS / QtSPIM (or your simulator)
Platform: Command-line / simulator console

**How to run:**
1. Open the project in a MIPS simulator (MARS or QtSPIM)
2. Load main.asm
3. Assemble and run the program
4. Follow the on-screen instructions to enter moves

**Learning Outcomes:**
Gained hands-on experience with low-level programming
Improved understanding of memory addressing and control flow
Practiced designing a non-trivial program in assembly language
Reinforced algorithmic thinking without high-level abstractions
