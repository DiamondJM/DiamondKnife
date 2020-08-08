function currentObj = humanMateCheck(currentObj,depth,zKeys)
    
    
    if depth == 0; return; end
    
    currentObj = generateMovesWrapper(currentObj,zKeys);
    for ii = 1:length(currentObj.children)
        currentObj.children(ii) = humanMateCheck(currentObj.children(ii),depth - 1,zKeys);
    end
    
    if depth == 1; return; end

    breakFlag = false; 
    for ii = 1:length(currentObj.children)
        if ~any([currentObj.children(ii).children.lostKing])
            breakFlag = true;
            break
        end
    end
    
    if ~breakFlag
        currentObj.gameOver = true;
    end
    
    % Essentially what we're doing is populating two generations of moves.
    % If our parent node is such that EVERY child has at least one of its
    % children's kings gone, we have a mate (checkmate or stale mate). 
    
    if depth == 2; currentObj.children = []; end
    
end