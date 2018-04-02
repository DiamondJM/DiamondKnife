# DiamondKnife
A chess engine for MATLAB.

This is a fully-functional chess engine. 

Strength isn't great, as I think I was starting to hit the ceiling on computational power. Was able to reach around 1100 elo on online servers. 

Features include support for human vs. computer, human vs. human, and computer vs. computer. Features GUI with chessboard figure. Stalemate and 3-move repeat detection are active. 

Chess engine features alpha beta pruning; a transposition table using MATLAB's containers.Map feature; iterative deepening; and late move reduction. 

Give it a try, and let me know how it performs! To use, just run chessMain.m. Bug discoveries are welcome. 
