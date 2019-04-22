# DiamondKnife
A chess engine for MATLAB.

This is a fully-functional chess engine. 

DiamondKnife enjoys a 1700 rapid (15|10) rating on the Free Internet Chess Server. 

Algorithm:
- DiamondKnife uses a tree search design. It employs the Principal Variation Search algorithm, in which non-PV nodes are called with null windows. 
- The heuristic position evaluator computes material, with added bonuses for: bishop pair; rook on open file; castling; advanced pawns; control of the center; simplification given an advantage in the endgame; and others. 
- DiamondKnife uses an iterative deepening approach, in which the main routine is called with successive increases in depth. 
- Efficiency is improved with a transposition table, as well as with a table of killer moves. Killer moves are placed after the last capture, or in order 5, whichever comes first. 
- DiamondKnife also uses a late move reduction scheme, in which moves of order >= 8, in depth >= 3, which are non-captures, and when there is no check, may be called with depth - 2 instead of depth - 1. 

Implementation: 
- The position evaluator and move generator were ported to C using MATLAB's Coder feature. This permitted great increases in efficiency.
- Each node retains a history of all previously-visited nodes, both in-game and in the game tree, permitting easy draw detection. 
- This utility features a GUI and options for human-human, human-computer, and computer-computer play. 

To use, just run chessMain.m. Let me know how it performs, and happy chess playing! 
