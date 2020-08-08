function [currentObj,TTable] = orchestrateMove(currentGame,currentObj,TTable,zKeys)
    
    if currentObj.currentColor == 1
        if currentGame.whiteHuman; currentObj = humanMove(currentObj,zKeys);
        else; [currentObj,TTable] = computerMove(currentObj,TTable,zKeys);
        end
    else
        if currentGame.blackHuman; currentObj = humanMove(currentObj,zKeys);
        else; [currentObj,TTable] = computerMove(currentObj,TTable,zKeys);
        end
    end
end
function [currentObj,TTable] = computerMove(currentObj,TTable,zKeys)

    if currentObj.currentColor == 1; moveString = 'White';
    else; moveString = 'Black'; 
    end
    
    fprintf('\nComputer to move as %s.\n',moveString);
    searchDepth = 15;
    
    [currentObj,TTable] = iterativeDeep(currentObj,searchDepth,TTable,zKeys);
    if currentObj.gameOver; return; end  % Probably will never get here.
   
    currentObj = generateMovesWrapper(currentObj,zKeys);

    bestMove = TTable(currentObj.zobristKey).bestMove;
    moveList = cat(1,currentObj.children.moveIdentifier);
    index = all(moveList == bestMove,2);

    
    
    currentObj = currentObj.children(index);
    % currentObj = humanMateCheck(currentObj,2,zKeys);
    
    myStruct = TTable(currentObj.zobristKey);
    if myStruct.gameOver; currentObj.gameOver = true; end

end


function currentObj = humanMove(currentObj,zKeys)
    
    if currentObj.currentColor == 1; moveString = 'White';
    else; moveString = 'Black';
    end
    
    fprintf('\nHuman to move as %s. \n',moveString);
    currentObj = generateMovesWrapper(currentObj,zKeys);
    
    moveList = cell(1,length(currentObj.children));
    for ii = 1:length(moveList)
        moveIdentifier = currentObj.children(ii).moveIdentifier;
        
        promotion = currentObj.position(moveIdentifier(1) + 2,moveIdentifier(2) + 2) ~= moveIdentifier(5);
        moveList{ii} = squares2string(moveIdentifier,promotion);
    end
    
    moveChoice = input('Please provide move. For instructions, press 1. \n','s');
    
    if isequal(moveChoice,'1')
        fprintf(['Give move as from square and to square. \n' ...
            'For instance, e4d5. \n' ...
            'For promotions, format as b2a1=N. \n' ...
            'For castling, give o-o or o-o-o. \n'])
        
        currentObj.children = [];
        currentObj = humanMove(currentObj,zKeys);
        return
        
    else
        if isequal(moveChoice,'o-o') % The opponent castled. Are they white or black?
            if currentObj.currentColor == 1
                moveChoice = 'e1g1';
            else
                moveChoice = 'e8g8';
            end
        elseif isequal(moveChoice,'o-o-o')
            if currentObj.currentColor == 1
                moveChoice = 'e1c1';
            else
                moveChoice = 'e8c8';
            end
        end
        
        index = strcmpi(moveChoice,moveList);
        if ~any(index)
            disp('Incorrect move. ');
            currentObj.children = [];
            currentObj = humanMove(currentObj,zKeys);
            return
        else
            currentObj = currentObj.children(index);
            currentObj.children = [];
        end
    end
    currentObj = humanMateCheck(currentObj,2,zKeys);
    
end