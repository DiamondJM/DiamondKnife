function chessobj = transtable(chessobj,alpha,beta,depth)


 if depth>=1  %Solely evaluation
    
    TRANSTABLE= chessobj.getInstance;
        
    if isKey(TRANSTABLE,chessobj.zobrist)
        
        % Illegal positions
        mystruct=TRANSTABLE(chessobj.zobrist);
        %if ~isequal(chessobj.position,mystruct.position);keyboard;end
        
        
        if abs(mystruct.evaluation)>800 || mystruct.gameOver
            
            if abs(mystruct.evaluation)>800
                
                if sign(mystruct.evaluation)==1
                    %White winning.
                    chessobj.winningeval = 800 + depth * 40;
                else
                    chessobj.winningeval = -800 - depth * 40;
                end
            else
                % Stale mate, no?
                chessobj.winningeval = 0;
            end
            
            
            chessobj.gameOver = mystruct.gameOver;      
            
            
        elseif isRepeat(chessobj.positionHistory) >= 2
            
            % Draw by repetition. 
            chessobj.winningeval = 0;
            
            
        elseif mystruct.depth>=depth...
               && ~isRepeat(chessobj.positionHistory)
        
        %We can use the old guy.
            % Use the old guy
            if ~mystruct.flag %exact value
                
                chessobj.winningeval=mystruct.evaluation;
                return 
                
            elseif mystruct.flag==1
                
                beta=min(beta,mystruct.evaluation);
            elseif mystruct.flag==2
                
                alpha=max(alpha,mystruct.evaluation);
            end
            if beta<=alpha
                chessobj.winningeval=mystruct.evaluation;
                return 
            end
            %Call minimax.
            
            chessobj=listofmoves(chessobj);
            mymove=mystruct.bestmove;
            movelist=cat(1,chessobj.children.oldnew);
            index=find(all(movelist==mymove,2));
            if index>1
                chessobj.children([1 index])=chessobj.children([index 1]);
            end
            %end
            chessobj=minimax_iter(chessobj,alpha,beta,depth);
            
            
            if depth>mystruct.depth
                mystruct=struct;
                %mystruct.zobrist=chessobj.zobrist;
                mystruct.depth=depth;mystruct.gameOver=chessobj.gameOver;
                mystruct.evaluation=chessobj.winningeval;
                mystruct.bestmove=chessobj.children(1).oldnew;

                if chessobj.winningeval<=alpha+0.0001
                    mystruct.flag=1;
                    %Beta flag.
                    %Value is an upper bound. classically, black passes back
                    %these, though white can too.
                elseif chessobj.winningeval>=beta-0.0001
                    mystruct.flag=2;
                else
                    mystruct.flag=0;
                end

                %mystruct.wmove=chessobj.wmove;
                
                TRANSTABLE(chessobj.zobrist)=mystruct;
                
            end
            
            chessobj.children=[];

            
            
        else
            % Move ordering only.
            
            chessobj=listofmoves(chessobj);
            
            mymove=mystruct.bestmove;
            movelist=cat(1,chessobj.children.oldnew);
            index=find(all(movelist==mymove,2));
            if index>1
                chessobj.children([1 index])=chessobj.children([index 1]);
            elseif isempty(index)
               % keyboard %%% I need to look at this. It happens rarely.
               % Probably due to rare key ambiguity 
            end

            chessobj=minimax_iter(chessobj,alpha,beta,depth);

            %Actually, we should be making structs here.
            %Because current depth should be strictly higher than struct depth.

            mystruct=struct;
            %mystruct.zobrist=chessobj.zobrist;
            mystruct.depth=depth;
            mystruct.gameOver=chessobj.gameOver;
            mystruct.evaluation=chessobj.winningeval;
            mystruct.bestmove=chessobj.children(1).oldnew;
            

            if chessobj.winningeval<=alpha+0.0001
                mystruct.flag=1;
                %Beta flag.
                %Value is an upper bound. classically, black passes back
                %these, though white can too.
            elseif chessobj.winningeval>=beta-0.0001
                mystruct.flag=2;
            else
                mystruct.flag=0;
            end

            %mystruct.wmove=chessobj.wmove;
            
            TRANSTABLE(chessobj.zobrist)=mystruct;
            
           chessobj.children=[];
            

        end
    else
       % No entry.        
       %No transtable entry. After check checks, we'll have to run minimax.
       chessobj=listofmoves(chessobj);
       
       if any([chessobj.children.lostking]) %chessobj.children has no king.
           %chessobj is an illegal move.
           chessobj.winningeval = (800 + depth * 40) * (chessobj.wmove-~chessobj.wmove);
          
           chessobj.childLostKing = true;

           mystruct=struct;
           %mystruct.zobrist=chessobj.zobrist;
           %mystruct.depth=depth;
           mystruct.evaluation=chessobj.winningeval;
           mystruct.flag = 0;
           mystruct.gameOver = chessobj.gameOver;
           %mystruct.wmove=chessobj.wmove;
           
           TRANSTABLE(chessobj.zobrist)=mystruct;
           
           chessobj.children=[];
           
       else
           if any([chessobj.children.castlethru]) %We have a possible castle through. Was the
               castletemp=[chessobj.children.castlethru];
                castletemp(castletemp==0)=[];
                for i=1:length(castletemp)
                    
                    if xor(chessobj.castlenew(castletemp(i),~chessobj.wmove+1),...
                            chessobj.castleold(castletemp(i),~chessobj.wmove+1))
                                        
                        chessobj.winningeval=(800 + depth * 40) * (chessobj.wmove-~chessobj.wmove);
                        
                        mystruct=struct;
                        %mystruct.zobrist=chessobj.zobrist;
                        %mystruct.depth=depth;
                        mystruct.evaluation=chessobj.winningeval;
                        mystruct.flag=0;
                        %mystruct.wmove=chessobj.wmove;
                        mystruct.gameOver=chessobj.gameOver;
                        
                        TRANSTABLE(chessobj.zobrist)=mystruct;
                        chessobj.children=[];
                        return
                    end
                end

                [chessobj.children([chessobj.children.castlethru]==1).castlethru]=deal(0);
            end
            
            
            chessobj=minimax_iter(chessobj,alpha,beta,depth);
            

            mystruct=struct;
            %mystruct.zobrist=chessobj.zobrist;
            mystruct.depth=depth;mystruct.gameOver=chessobj.gameOver;
            mystruct.evaluation=chessobj.winningeval;
            mystruct.bestmove=chessobj.children.oldnew;
            %Should be only a single move here. 
            
            
            if chessobj.winningeval<=alpha+0.0001
                mystruct.flag=1;
                %Beta flag.
                %Value is an upper bound. classically, black passes back
                %these, though white can too.
            elseif chessobj.winningeval>=beta-0.0001
                mystruct.flag=2;
            else
                mystruct.flag=0;
            end
            
            %mystruct.flag=flag;
            %mystruct.wmove=chessobj.wmove;
            
            TRANSTABLE(chessobj.zobrist)=mystruct;
            
            chessobj.children=[];
            
            %Weird shit. note that sometimes there WILL be an
            %existing key here, because the same position was
            %seen at a shallower depth (due to piece shuffling,
            %such that they wind up in the same place).
            %But given that we replace by depth, we'll always
            %want to replace that anyway, since we're
            %necessarily at a greater ply here.

            
            
        end
        
   end
 end

 
end

