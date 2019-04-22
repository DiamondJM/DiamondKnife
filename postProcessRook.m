function currentObj = postProcessRook(currentObj,currentSquare,zKeys)
    %% Unpack
    
    castleRights = currentObj.castleRights;
    if currentObj.currentColor == 1; whiteMove = false;
    else; whiteMove = true;
    end
    % Ungraceful here, but we've already switched the color of this object. Let's switch it
    % Back to accurately reflect castling information. 
    
    zobristKey = currentObj.zobristKey; 
    
    %% Adjust castle rights 
    
    if whiteMove 
        % White just moved its rook. 
        if isequal(currentSquare,[10,3]) % Queenside rook moved from home rank. 
            castleRights(2,4) = 0;
        elseif isequal(currentSquare,[10 10]) % Kingside rook.
            castleRights(1,4) = 0; 
        end
    else % Black moved rook. 
        if isequal(currentSquare,[3 3])
            castleRights(2,3) = 0; 
        elseif isequal(currentSquare,[3 10])
            castleRights(1,3) = 0; 
        end
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
    
    
    