function objectArray = generateMoves(currentObj,zKeys)

currentPosition = currentObj.position;
currentColor = currentObj.currentColor;
if currentColor == 1; whiteMove = true;
else; whiteMove = false;
end

targetFile = currentObj.targetFile;
% positionHistory = chessObj.positionHistory;
castleRights = currentObj.castleRights;
% zobristKey = chessObj.zobristKey;


listLength = 0;

coder.varsize('objectArray');
objectArray = generateDummyArray;
coder.varsize('objectArray');


boardInd = find(sign(currentPosition) == currentColor & currentPosition ~= 99);
for iiBoard = 1:length(boardInd)
    % [ii,jj] = ind2sub([12 12],boardInds(boardInd));
    idx = boardInd(iiBoard);
    ii = idx - 1 - 12 * fix((idx - 1) / 12) + 1;
    % ii = rem(idx - 1, 12) + 1;
    jj = (idx - ii) / 12 + 1;
    
    
    currentSquare = [ii jj];
    switch abs(currentPosition(ii,jj))
        case 1  % Pawn
            if (ii == 9 && whiteMove) || (ii == 4 && ~whiteMove) %pawn on home rank. pawn can move up one or two if unobstructed
                if ~currentPosition(ii - currentColor,jj) %considering one past the home rank.
                    %The content of the if statement is - 1 for white
                    %and 1 for black.
                    newSquare = [ii - currentColor, jj];
                    
                    nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                    nodeTemp = processHistory(nodeTemp);
                    listLength = listLength + 1;
                    objectArray(listLength) = nodeTemp;
                    if ~currentPosition(ii - 2 * currentColor,jj) % - 2 for white, 2 for black
                        
                        newSquare = [ii - 2 * currentColor, jj];
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = moveByTwo(nodeTemp,newSquare,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                    end
                end
                for p = [-1 1]
                    if sign(currentPosition(ii - currentColor,jj + p)) == currentColor * - 1 && ...
                            currentPosition(ii - currentColor,jj + p) ~= 99
                        
                        newSquare = [ii - currentColor jj + p];
                        
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                    end
                end
                
            elseif ii <= 8 && ii >= 5
                % Middle ranks. No move up two option
                if ~currentPosition(ii - currentColor,jj)
                    
                    newSquare = [ii - currentColor, jj];
                    
                    nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                    nodeTemp = processHistory(nodeTemp);
                    listLength = listLength + 1;
                    objectArray(listLength) = nodeTemp;
                    
                end
                for p = [-1 1]
                    if sign(currentPosition(ii - currentColor,jj + p)) == currentColor * - 1 ...
                            && currentPosition(ii - currentColor,jj + p) ~= 99
                        
                        newSquare = [ii - currentColor jj + p];
                        
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                    end
                    if targetFile ...
                            && (jj + p == targetFile) ...
                            && ((currentColor == 1 && ii == 6)||(currentColor == - 1 && ii == 7))
                        
                        targetRank = ii;
                        newSquare = [ii - currentColor, jj + p];
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = enpCapture(nodeTemp,targetRank,targetFile,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                    end
                    
                end
            elseif (ii == 4 && whiteMove) || (ii == 9 && ~whiteMove)
                if ~currentPosition(ii - currentColor,jj) %pawn can move up one
                    
                    for q = [2 3 5 9]
                        
                        newSquare = [ii - currentColor, jj];
                        
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,q * currentColor,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                    end
                    
                end
                for p = [-1 1]
                    if sign(currentPosition(ii - currentColor,jj + p)) == currentColor * - 1 && ...
                            currentPosition(ii - currentColor,jj + p) ~= 99
                        
                        for q = [2 3 5 9]
                            
                            newSquare = [ii - currentColor jj + p];
                            nodeTemp = processMove(currentObj,currentSquare,newSquare,q * currentColor,zKeys);
                            nodeTemp = processHistory(nodeTemp);
                            listLength = listLength + 1;
                            objectArray(listLength) = nodeTemp;
                        end
                        
                    end
                end
            end
        case 2 %Knight
            for p = [-2 -1 1 2]
                for q = [-2 -1 1 2]
                    if abs(p) == abs(q); continue; end
                    if sign(currentPosition(ii + p,jj + q)) ~= currentColor ...
                            && currentPosition(ii + p,jj + q) ~= 99
                        
                        newSquare = [ii + p,jj + q];
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                    end
                end
            end
        case 3 %bishop
            for p = [-1 1]
                for q = [-1 1]
                    unblocked = true;
                    k = 1;
                    while unblocked
                        if sign(currentPosition(ii + k * p,jj + k * q)) == currentColor||...
                                currentPosition(ii + k * p,jj + k * q) == 99
                            unblocked = false;
                        else
                            newSquare = [ii + k * p,jj + k * q];
                            nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                            nodeTemp = processHistory(nodeTemp);
                            listLength = listLength + 1;
                            objectArray(listLength) = nodeTemp;
                            
                            if sign(currentPosition(ii + k * p,jj + k * q)) == currentColor * - 1
                                unblocked = false;
                            end
                        end
                        k = k + 1;
                    end
                end
            end
        case 5  % Rook
            p = [-1 1 0 0];
            q = [0 0 -1 1];
            for r = 1:4
                unblocked = true;
                k = 1;
                while unblocked
                    if sign(currentPosition(ii + k * p(r),jj + k * q(r))) == currentColor||...
                            currentPosition(ii + k * p(r),jj + k * q(r)) == 99
                        unblocked = false;
                    else
                        newSquare = [ii + k * p(r),jj + k * q(r)];
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = postProcessRook(nodeTemp,currentSquare,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                        if sign(currentPosition(ii + k * p(r),jj + k * q(r))) == currentColor * -1
                            unblocked = false;
                        end
                    end
                    k = k + 1;
                end
            end
        case 9 %Queen
            for p = [-1 0 1]
                for q = [-1 0 1]
                    unblocked = true;
                    k = 1;
                    while unblocked
                        if sign(currentPosition(ii + k * p,jj + k * q)) == currentColor||...
                                currentPosition(ii + k * p,jj + k * q) == 99
                            unblocked = false;
                        else
                            newSquare = [ii + k * p,jj + k * q];
                            nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                            nodeTemp = processHistory(nodeTemp);
                            listLength = listLength + 1;
                            objectArray(listLength) = nodeTemp;
                            
                            if sign(currentPosition(ii + k * p,jj + k * q)) == currentColor * -1
                                unblocked = false;
                            end
                        end
                        k = k + 1;
                    end
                end
            end
        case 10 %King
            for p = [-1 0 1]
                for q = [-1 0 1]
                    if sign(currentPosition(ii + p,jj + q)) ~= currentColor && ...
                            currentPosition(ii + p,jj + q) ~= 99
                        
                        newSquare = [ii + p,jj + q];
                        nodeTemp = processMove(currentObj,currentSquare,newSquare,-99,zKeys);
                        nodeTemp = postProcessKing(nodeTemp,zKeys);
                        nodeTemp = processHistory(nodeTemp);
                        
                        listLength = listLength + 1;
                        objectArray(listLength) = nodeTemp;
                        
                    end
                end
            end
            
            if castleRights(1,whiteMove + 3) == 1 ...
                    && ((whiteMove && isequal(currentPosition(10,7:10),[10 0 0 5])) ...
                    || ~whiteMove && isequal(currentPosition(3,7:10),[-10 0 0 -5]))
                
                nodeTemp = processCastle(currentObj,true,zKeys);
                nodeTemp = processHistory(nodeTemp);
                listLength = listLength + 1;
                objectArray(listLength) = nodeTemp;
            end
            if castleRights(2,whiteMove + 3) == 1 ...
                    && ((whiteMove && isequal(currentPosition(10,3:7),[5 0 0 0 10])) ...
                    || ~whiteMove && isequal(currentPosition(3,3:7),-[5 0 0 0 10]))
                nodeTemp = processCastle(currentObj,false,zKeys);
                nodeTemp = processHistory(nodeTemp);
                listLength = listLength + 1;
                objectArray(listLength) = nodeTemp;
            end
    end
end


%     stopIndex = 1;
%     winningEvals = zeros(size(objectArray),'int32');
%     for ii = 1:length(objectArray)
%         if objectArray(ii).winningEval == -999
%             % Sentinel value
%             stopIndex = ii;
%             break;
%         end
%
%         objectArray(ii).winningEval = positionEvaluator(objectArray(ii).position,objectArray(ii).castleRights,-currentColor);
%         % We use the color of the player to move AFTER the move has been made
%         winningEvals(ii) = objectArray(ii).winningEval;
%     end
%
%     outputArray = objectArray(1:stopIndex - 1);
%     weShort = winningEvals(1:stopIndex - 1);
% %
% %     objectArray(stopIndex:end) = [];
% %     winningEvals(stopIndex:end) = [];
% %
%     [~,I] = sort(weShort,'ascend');
%
%     outputArray = outputArray(I);
%     % currentObj.children = objectArray(I);
%
%

end
