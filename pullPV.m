function pv = pullPV(currentObj,TTable,zKeys)
        
    pv = '';
    boardTitle = '';
    firstFlag = true; 
    
    subplot(1,2,2);
    RenderBoard(currentObj.position,boardTitle);
   
    
    while true
        
        if isKey(TTable,currentObj.zobristKey)
                        
            myStruct = TTable(currentObj.zobristKey);
            if ~isfield(myStruct,'bestMove')
                if firstFlag; pv = 'Mate.';
                else; pv = strjoin({pv, 'Mate.'},', ');
                end
                break
            elseif isRepeat(currentObj.positionHistory) >= 1
                break
            end
            
            bestMove = myStruct.bestMove;
            promotion = currentObj.position(bestMove(1) + 2,bestMove(2) + 2) ~= bestMove(5);
            moveString = squares2string(bestMove,promotion);
            
            if firstFlag
                pv = moveString;
                firstFlag = false;
                depthReached = myStruct.depth;
                boardTitle = sprintf('Computed PV at depth %d',depthReached);
            else
                pv = strjoin({pv, moveString},', ');
            end
            
            currentObj = generateMovesWrapper(currentObj,zKeys);
            moveList = cat(1,currentObj.children.moveIdentifier);
            index = all(moveList == bestMove,2);
            
            if ~any(index); break; end % I think this is for freak scenarios, like key ambiguity. 
            % Shouldn't really happen under normal practice. 
            
            currentObj = currentObj.children(index); 
            
            subplot(1,2,2);
            RenderBoard(currentObj.position,boardTitle);
            

        else
            break 
        end
    end

end
