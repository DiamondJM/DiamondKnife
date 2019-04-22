function myStruct = populateTTentry(currentObj,alpha,beta,depth,II)
    
    
    myStruct = struct;
    myStruct.depth = depth;
    myStruct.gameOver = currentObj.gameOver;
    myStruct.evaluation = currentObj.winningEval;
    myStruct.bestMove = currentObj.children(II).moveIdentifier;
        
    if currentObj.winningEval <= alpha
        % if ~(currentObj.winningEval <= alpha); keyboard; end
        myStruct.cutFlag = int32(1);  % UPPERBOUND
    elseif currentObj.winningEval >= beta 
        myStruct.cutFlag = int32(2);  % LOWERBOUND
    else        
        myStruct.cutFlag = int32(0); 
    end
            
    myStruct.childLostKing = currentObj.childLostKing;  % Should probably be negative?
    % Cut flags essentially represent direction of bound. Not which side is
    % to move or anything. 
    
    % myStruct.position = currentObj.children(II).position; 
    
    
end