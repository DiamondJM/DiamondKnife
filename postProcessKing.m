function currentObj = postProcessKing(currentObj,zKeys)
    %% Unpack
    
    castleRights = currentObj.castleRights;
    if currentObj.currentColor == 1; whiteMove = false;
    else; whiteMove = true;
    end
    
    
    % Ungraceful here, but we've already switched the mover of this object. Let's switch it
    % Back to accurately reflect castling information. 
    
    zobristKey = currentObj.zobristKey; 
    
    %% Adjust castle rights 
    
    if whiteMove 
        % White just moved king 
        castleRights([1 2],4) = 0;
    else
        castleRights([1 2],3) = 0;
    end
    
    %% Adjust zobrist key 
    
    castleChange = xor(castleRights(1:2,1:2),castleRights(1:2,3:4));
    castleChangeInds = find(castleChange)';
    for ii = 1:length(castleChangeInds)
        zobristKey = bitxor(zobristKey, zKeys(769 + castleChangeInds(ii)));
    end
    
    %% Pack 
    
    currentObj.castleRights = castleRights; 
    currentObj.zobristKey = zobristKey; 
    
end
    
    
    