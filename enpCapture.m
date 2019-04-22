function chessObj = enpCapture(chessObj,targetRank,targetFile,zKeys)
    %% Unpack 
    
    zobristKey = chessObj.zobristKey; 
    
    pieceConverter = [1 1; 2 2; 3 3; 5 4; 9 5; 10 6; -1 7; -2 8; -3 9; -5 10; -9 11; -10 12];
   
    currentPosition = chessObj.position; 
    
    %% Xor out the captured pawn 
    
    currentPiece = currentPosition(targetRank,targetFile);
    squareInd = sub2ind([8 8],targetRank - 2,targetFile - 2);
    pieceInd = pieceConverter(pieceConverter(:,1) == currentPiece,2);
    pieceInd = pieceInd(1);
    zobInd = sub2ind([64 12], squareInd, pieceInd);
    zobristKey = bitxor(zobristKey,zKeys(zobInd));
    
    %% Eliminate the captured pawn 
    
    currentPosition(targetRank,targetFile) = 0; 
    
    %% Pack up 
    
    
    chessObj.zobristKey = zobristKey; 
    chessObj.position = currentPosition; 
    
end