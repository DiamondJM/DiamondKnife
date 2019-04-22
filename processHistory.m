function chessObj = processHistory(chessObj) 
    
    
    positionHistory = chessObj.positionHistory; 
    zobristKey = chessObj.zobristKey; 
    
    positionHistory = [positionHistory zobristKey];
    
    chessObj.positionHistory = positionHistory; 
    
end
