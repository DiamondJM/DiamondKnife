function inCheck = isInCheck(currentObj,zKeys)

% Essentially, let's switch the color to move, and generate children. If there's
% a lost king, then the player to move is in check. 

currentObj.currentColor = -currentObj.currentColor;
currentObj.children = [];
currentObj = generateMovesWrapper(currentObj,zKeys);

if any([currentObj.children.lostKing])
    inCheck = true;
else 
    inCheck = false;
end

end