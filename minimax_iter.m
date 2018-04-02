function chessobj = minimax_iter(chessobj,alpha,beta,depth)


flag = 0;
compareeval = -1200*chessobj.wmove+1200*~chessobj.wmove;


if chessobj.wmove
   
    
    for ii = 1:length(chessobj.children)
        
       if ii > 1 && ~chessobj.children(ii).caprom&&depth >= 5 &&~chessobj.caprom&&...
               ~(any(chessobj.children(ii).castlenew([3 4],chessobj.wmove+1))&&...
               ~any(chessobj.children(ii).castleold([3 4],chessobj.wmove+1)))
            
            
           chessobj.children(ii) = transtable(chessobj.children(ii),alpha,beta,depth-3);
           %%%%%%%
           % Research
           %%%%%%%%
%            if chessobj.children(ii).winningeval>= alpha-.0001
%                chessobj.children(ii) = transtable(chessobj.children(ii),alpha,beta,depth-1);
%            end
       else

            chessobj.children(ii) = transtable(chessobj.children(ii),alpha,beta,depth-1);

       end

        if chessobj.children(ii).winningeval>compareeval
            compareeval = chessobj.children(ii).winningeval;
            chessobj.winningeval = chessobj.children(ii).winningeval;
        end
        
        alpha = max(alpha,chessobj.children(ii).winningeval);
        
        %if compareeval>= beta&&i<length(chessobj.children)
        
        if beta<= alpha ...
                && ~any([chessobj.children.winningeval].* (~chessobj.wmove * 1 + chessobj.wmove * -1) ==  840)
            flag = 1;
            break
        end
    end
else %black's move.
    
    for ii = 1:length(chessobj.children)

        % Late move reduction 
        if ii > 1 &&~chessobj.children(ii).caprom && depth >= 5 && ~chessobj.caprom &&...
                ~(any(chessobj.children(ii).castlenew([3 4],chessobj.wmove+1))&&...
                ~any(chessobj.children(ii).castleold([3 4],chessobj.wmove+1)))
            
            chessobj.children(ii) = transtable(chessobj.children(ii),alpha,beta,depth-3);

            %%%%%%%
            % Research 
            %%%%%%%%
%             if chessobj.children(ii).winningeval<= beta+.0001
%                 chessobj.children(ii) = transtable(chessobj.children(ii),alpha,beta,depth-1);
%             end
        else
            chessobj.children(ii) = transtable(chessobj.children(ii),alpha,beta,depth-1);
        end
        
        if chessobj.children(ii).winningeval<compareeval
            compareeval = chessobj.children(ii).winningeval;
            chessobj.winningeval = chessobj.children(ii).winningeval;
        end
        
        
        beta = min(beta,chessobj.children(ii).winningeval);
        
        
        if beta <= alpha ...
                && ~any([chessobj.children.childLostKing])
            
            %%%%%
            % Pretty subtle, but we shouldn't be having cuts in mating
            % situations. 
            % A cut might seem obvious, but lead us to stalemate. 
            % We need to explore all children to know if we're in an
            % imminent mating situation, at which point stalemate may be
            % evaluated. 
            %%%%%%
            flag = 1;
            break
        end
    end
end

%%%%%%%%%%%%%%%%%
% Are we in a losing position? 
%%%%%%%%%%%%%%%%

if all([chessobj.children.childLostKing]) 
    if ~isInCheck(chessobj)
        % Stalemate
        chessobj.winningeval = 0;
    end 
    chessobj.gameOver = true;
else
    if ~flag
        evals = [chessobj.children.winningeval];
        if chessobj.wmove
            [~,I] = max(evals);
        else
            [~,I] = min(evals);
        end
        chessobj.children = chessobj.children(I);
    else
        chessobj.children = chessobj.children(ii);
    end
end


end
