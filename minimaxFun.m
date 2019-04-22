function [currentObj,TTable] = minimaxFun(currentObj,alpha,beta,depth,TTable,zKeys)


breakFlag = false;
tol = 0.0001;

%%%%%%
% Regarding tolerance 
% It's tricky what we're doing, but we're actually promoting cuts, not
% preventing them. 
% The point is that, if we _just barely_ decide to cut, and do so because
% of a floating point error, we actually don't lose much. We prevent one
% side from knowing that a _slightly_ better move exists. But the upside is
% that we save a lot of time. 
% A weird consequence of this, though, could be more re-searches. 

if currentObj.whiteMove; compareEval = -Inf; 
else; compareEval = Inf; 
end

if currentObj.whiteMove
   
    
    for ii = 1:length(currentObj.children)
        
%        if ii > 1 ...
%                && ~currentObj.children(ii).caProm ...
%                && depth >= 5 ...
%                && ~currentObj.caProm
%            % For now, let's allow for abbreviated search in castles. 
%             
%            [currentObj.children(ii), TTable] = manageTranstable(currentObj.children(ii),alpha,beta,depth-3,TTable,zKeys);
%            
%        else

            [currentObj.children(ii), TTable] = manageTranstable(currentObj.children(ii),alpha,beta,depth-1,TTable,zKeys);

%        end

        if currentObj.children(ii).winningEval > compareEval
            compareEval = currentObj.children(ii).winningEval;
            currentObj.winningEval = currentObj.children(ii).winningEval;
        end
        
        alpha = max(alpha,currentObj.children(ii).winningEval);
                
        if beta <= alpha + tol
            breakFlag = true;
            break
        end
    end
else  % Black's move.
    
    for ii = 1:length(currentObj.children)

        % Late move reduction 
%         if ii > 1 ...
%                 && ~currentObj.children(ii).caProm ...
%                 && depth >= 5 ...
%                 && ~currentObj.caProm
%             
%             [currentObj.children(ii), TTable] = manageTranstable(currentObj.children(ii),alpha,beta,depth-3,TTable,zKeys);
% 
%         else
            [currentObj.children(ii), TTable] = manageTranstable(currentObj.children(ii),alpha,beta,depth-1,TTable,zKeys);
%         end
        
        if currentObj.children(ii).winningEval < compareEval
            compareEval = currentObj.children(ii).winningEval;
            currentObj.winningEval = currentObj.children(ii).winningEval;
        end
        
        
        beta = min(beta,currentObj.children(ii).winningEval);
        
        
        if beta <= alpha + tol 
            breakFlag = true;
            break
        end
    end
end

%%%%%%%%%%%%%%%%%
% Are we in a losing position? 
%%%%%%%%%%%%%%%%

if all([currentObj.children.childLostKing]) 
    if ~isInCheck(currentObj,zKeys)
        % Stalemate
        currentObj.winningEval = 0;
    end 
    currentObj.gameOver = true;
else
    if ~breakFlag
        evals = [currentObj.children.winningEval];
        if currentObj.whiteMove
            [~,I] = max(evals);
        else
            [~,I] = min(evals);
        end
        currentObj.children = currentObj.children(I);
    else
        currentObj.children = currentObj.children(ii);
    end
end


end
