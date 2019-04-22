
function currentObj = moveByTwo(currentObj,newSquare,zKeys)
    
    %% Unpack 
    
    zobristKey = currentObj.zobristKey; 

    
    newTargetFile = newSquare(2);
    
    %% Xor in new target file  
    
    zobristKey = bitxor(zobristKey,zKeys(773 + newTargetFile - 2));
    
    %% Add target file to object 
    % And otherwise pack up 
    
    
    currentObj.targetFile = newTargetFile; 
    currentObj.zobristKey = zobristKey; 
    
end