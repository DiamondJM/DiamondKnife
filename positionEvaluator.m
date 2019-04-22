function currentEval = positionEvaluator(currentPosition,castleRights,color)
    
    %% Preamble 
    
    countBishops = [0 0]; %First is black second is white
    
    bishopPair = 0.2;
    undevelopedPiece = 0.4;
    castleBonus = 0.3;
    developedCenterPawn = 0.4;
    developedCPawn = 0.1;
    fPawn = .2;
    cantCastle = 0.4;
    mobileQueen = 0.2;
    knightRim = .1;
    % taperlate = 1.2;
    disruptPawnBonus = .8;
    deepPawn = .8;
    
    rookOpen = .5;
    
    simplifyBonus = 10;
    
    
    
    %% Count pieces
    
    currentEval = 0;
    boardInd = find(logical(currentPosition) & currentPosition ~= 99 & currentPosition ~= 10)';
    for iiBoard = 1:length(boardInd)
        % [iiTemp,jjTemp] = ind2sub([12 12],boardInd(iiBoard));
        idx = boardInd(iiBoard);
        
        ii = idx - 1 - 12 * fix((idx - 1) / 12) + 1; 
        jj = (idx - ii) / 12 + 1;
        
        currentPiece = currentPosition(ii,jj);
        if currentPiece && abs(currentPiece)~= 10
            if abs(currentPiece) == 2
                currentEval = currentEval + sign(currentPiece) * 3.25;
                if jj == 3||jj == 10
                    currentEval = currentEval - sign(currentPiece) * knightRim;
                    %white knight; worse for white; eval decreases
                end
            elseif abs(currentPiece) == 3
                currentEval = currentEval + sign(currentPiece) * 3.75;
                countBishops(~((1-sign(currentPiece))/2) + 1) = countBishops(~((1-sign(currentPiece))/2) + 1) + 1;
                
            elseif abs(currentPiece) == 1
                
                currentEval = currentEval + currentPiece;  % * 1.1;
                if jj == 6||jj == 7
                    if (ii>= 6 && currentPiece == -1)||(ii<= 7 && currentPiece == 1)
                        
                        currentEval = currentEval + developedCenterPawn * currentPiece;
                    end
                elseif jj == 8
                    if (ii == 4 && currentPiece == -1)||(ii == 9 && currentPiece == 1)
                        currentEval = currentEval + fPawn * currentPiece;
                    end
                elseif jj == 5
                    if(ii>= 6 && currentPiece == -1)||(ii<= 7 && currentPiece == 1)
                        currentEval = currentEval + developedCPawn * currentPiece;
                    end
                end
                
                if ii<= 5 && currentPiece == 1||ii>= 8 && currentPiece == -1
                    currentEval = currentEval + deepPawn * currentPiece;
                end
                
                
            elseif abs(currentPiece) == 5
                currentEval = currentEval + currentPiece;
                if ~any(abs(currentPosition(3:10,jj)) == 1)
                    currentEval = currentEval + rookOpen * sign(currentPiece);
                end
            else
                currentEval = currentEval + currentPiece;
            end
            
            if ii == 3
                if currentPiece == -3||currentPiece == -2
                    currentEval = currentEval + undevelopedPiece; %Worse for black; better for white
                    if currentPosition(3,6)~= -9 && any(any(abs(currentPosition) == -9))
                        currentEval = currentEval + mobileQueen;
                    end
                end
            end
            if ii == 10
                if currentPiece == 3||currentPiece == 2
                    currentEval = currentEval - undevelopedPiece; %Worse for black; better for white
                    if currentPosition(10,6)~= 9 && any(any(abs(currentPosition) == 9))
                        currentEval = currentEval - mobileQueen;
                    end
                end
            end
        end
    end
    
    %% Extras
    % Bishop pair
    if countBishops(1) == 2 %%Black has two bishops
        currentEval = currentEval - bishopPair;
    end
    if countBishops(2) == 2
        currentEval = currentEval + bishopPair;
    end
  
    % Castling
    currentEval = currentEval - any(castleRights([3 4],3)) * castleBonus + any(castleRights([3 4],4)) * castleBonus;
    currentEval = currentEval + ~any(castleRights(:,3)) * cantCastle - ~any(castleRights(:,4)) * cantCastle;
    
    castleInds = find(castleRights([3 4],[3 4]));
    for ii = 1:length(castleInds)
        switch castleInds(ii)
            case 1 %black king
                if all(sign(currentPosition(4,8:9)) == -1)
                    currentEval = currentEval-disruptPawnBonus;%Better for black;
                end
            case 2 %black queen
                if all(sign(currentPosition(4,4:5)) == -1)
                    currentEval = currentEval - disruptPawnBonus;%Better for black;
                end
            case 3
                if all(sign(currentPosition(9,8:9)) == 1)
                    currentEval = currentEval + disruptPawnBonus;
                end
            case 4
                if all(sign(currentPosition(9,4:5)) == 1)
                    currentEval = currentEval + disruptPawnBonus;
                end
        end
    end
    
    %% Taper late in the game 
    
    totalSum = sum(sum(abs(currentPosition(3:10,3:10))));
    percentSum = currentEval / totalSum;
    
    % Let's say you get 10 points extra if you have 100% of the evaluation.
    
    currentEval = currentEval + percentSum * simplifyBonus;
    
    %% Wrap up 
    
    % Times color
    currentEval = currentEval * color;
    % We use the color of the player to move AFTER the move has been made 
    
    % Convert to centipawn int 
    
    currentEval = int32(currentEval * 100);
    
    
    
end
