function [currentObj,TTable,killerMoves] = manageTranstable(currentObj,alpha,beta,depth,TTable,zKeys,killerMoves)
    
    %% Base case
    if depth == 0; return; end
    
    %% Process TT entry 
    isValid = false;
    if isKey(TTable,currentObj.zobristKey)
        isValid = true;
        myStruct = TTable(currentObj.zobristKey);
        
        %%%%%%%%%%%%
        % Terminal nodes 
        %%%%%%%%%%%%
        
        if myStruct.gameOver ...
                || (abs(myStruct.evaluation) > 10000 && myStruct.cutFlag == int32(0))
            % To my understanding, this will ALWAYS be positive except in
            % mating situations.
            if abs(myStruct.evaluation) > 10000
                currentObj.winningEval = (100 + 10 * depth) * int32(100) * sign(myStruct.evaluation);
            else
                % Stale mate, no?
                currentObj.winningEval = int32(0);
            end
            currentObj.gameOver = myStruct.gameOver;
            currentObj.childLostKing = myStruct.childLostKing;
            return
        elseif isRepeat(currentObj.positionHistory) >= 1
            
            % Draw by repetition.
            currentObj.winningEval = int32(0); % Discourage draws
            return
        elseif myStruct.depth >= depth
            
            % We can use the old guy.
            if myStruct.cutFlag == int32(0)  % exact value
                currentObj.winningEval = myStruct.evaluation;
                return
            elseif myStruct.cutFlag == int32(1) % UPPERBOUND
                beta = min(beta, myStruct.evaluation);
            elseif myStruct.cutFlag == int32(2) % LOWERBOUND
                alpha = max(alpha, myStruct.evaluation);
            end
            if beta <= alpha
                currentObj.winningEval = myStruct.evaluation;
                return
            end
        end
    end
    
    %% Generate and re-order moves 
    
    
    
    currentObj = generateMovesWrapper(currentObj,zKeys);
    
    if any([currentObj.children.lostKing])
        % Every time we generate move, we have to check for lost
        % king children, so as to check for illegality.
        % That's true even if there's a previous entry....
        currentObj.winningEval = (100 + 10 * depth) * int32(100);
        
        currentObj.childLostKing = true;
        
        if any([currentObj.children.lostKing] == 2)
            return 
            % This is this tricky case where we're actually not sure
            % positions with a lost king, due to castle through check, are
            % actually losing. 
            % This can actually just look illegal because a transposition
            % was illegal. 
            % As of now, the easiest solution I can think of is just to not
            % create a transposition table entry. 
        end
        
        myStruct = struct;
        myStruct.evaluation = currentObj.winningEval;
        myStruct.cutFlag = int32(0);
        myStruct.gameOver = currentObj.gameOver;
        
        myStruct.childLostKing = currentObj.childLostKing;
        
        TTable(currentObj.zobristKey) = myStruct;
        currentObj.children = [];
        
        return 
    end
        
    if isValid
        currentObj = reorderMoves(currentObj,myStruct,killerMoves,depth);
    end
    
    %% Initiate negascout 
    
    breakFlag = false;
    tol = int32(1);
  
    compareEval = -Inf;
    
    aOrig = alpha;
    for ii = 1:length(currentObj.children)        
        
        if ii == 1 
            % Open windows             
            [currentObj.children(ii), TTable, killerMoves] = ...
                manageTranstable(currentObj.children(ii), -beta, -alpha, depth - 1, TTable,zKeys,killerMoves);
            currentScore = -currentObj.children(ii).winningEval;
        elseif ii > 8 ...
                && depth > 3 ...
                && beta - alpha == 1 ...
                && ~currentObj.children(ii).caProm ... 
                && sum([currentObj.children.childLostKing]) < 2
            [currentObj.children(ii), TTable, killerMoves] = ...
                manageTranstable(currentObj.children(ii), -alpha - tol, -alpha, depth - 2, TTable,zKeys,killerMoves);
            currentScore = -currentObj.children(ii).winningEval;
            
            if currentScore > alpha
                [currentObj.children(ii), TTable, killerMoves] = ...
                    manageTranstable(currentObj.children(ii), -alpha - tol, -alpha, depth - 1, TTable,zKeys,killerMoves);
                currentScore = -currentObj.children(ii).winningEval;
            end

        else
            % Zero window
            [currentObj.children(ii), TTable, killerMoves] = ...
                manageTranstable(currentObj.children(ii), -alpha - tol, -alpha, depth - 1, TTable,zKeys,killerMoves);
            currentScore = -currentObj.children(ii).winningEval;
            
            if currentScore > alpha && currentScore < beta
                % Research 
                [currentObj.children(ii), TTable, killerMoves] = ...
                    manageTranstable(currentObj.children(ii), -beta, -currentScore, depth - 1, TTable,zKeys,killerMoves);
                currentScore = -currentObj.children(ii).winningEval;
            end
            
        end
        
        currentObj.children(ii).winningEval = currentScore;
        
        % Update score
        if currentScore > compareEval
            compareEval = currentScore;
            currentObj.winningEval = currentScore;
        end
        
        % Update alpha 
        alpha = max(alpha,compareEval);
        if alpha >= beta
            breakFlag = true;
            
            % Add to killers table 
            if currentObj.children(ii).caProm; break; end
            if ii == 1 && isValid; break; end
            
            moveIdentifier = currentObj.children(ii).moveIdentifier;
            killerList = killerMoves([depth * 2 - 1 depth * 2],:);
            
            placeIndex = find(all(killerList == moveIdentifier,2),1);
            
            if placeIndex == 1  % Do nothing
            elseif placeIndex == 2
                % Move in the table, but second. Let's add to first.
                killerMoves([depth * 2 - 1 depth * 2],:) = killerMoves([depth * 2 depth * 2 - 1],:);
            else
                % Move not in the table. Let's add it to the first
                % available slot. 
                placeIndex = find(killerMoves([depth * 2 - 1 depth * 2],1) == 0,1);
                if isempty(placeIndex) 
                    killerMoves(depth * 2,:) = moveIdentifier; 
                else
                    killerMoves((depth - 1) * 2 + placeIndex,:) = moveIdentifier;
                end
            end
            break
        end
    end
    
    
    %% Handle mating positions
    
    if all([currentObj.children.childLostKing])
        if ~isInCheck(currentObj,zKeys)
            % Stalemate
            currentObj.winningEval = int32(0);
        end
        currentObj.gameOver = true;
        
        myStruct = struct;
        myStruct.evaluation = currentObj.winningEval;
        myStruct.cutFlag = int32(0);
        myStruct.gameOver = currentObj.gameOver;
        
        myStruct.childLostKing = currentObj.childLostKing;  % Should probably always be false
        
        TTable(currentObj.zobristKey) = myStruct;
        currentObj.children = [];
        
        return
    end
        
    %% Populate TT entry
    
    if breakFlag
        II = ii;
    else
        evals = [currentObj.children.winningEval];
        [~,II] = max(evals);
    end
    
    myStruct = populateTTentry(currentObj,aOrig,beta,depth,II);
    TTable(currentObj.zobristKey) = myStruct;
    currentObj.children = [];
    
end

