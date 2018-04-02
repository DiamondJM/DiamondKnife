classdef chessboard_zob
    properties
        position
        wmove
        castleold
        castlenew  %1 black, 2 white
        %[can castlek ... ; can castleq ...; has castled k ...; has castled q]
        
        children
        
        %winningposition
        winningeval;

        lostking=false;
        castlethru=double(0);
        
        targetfile
        
        oldnew
        %mypiece
        caprom = false;
        promotion = false; % Unfortunately needed for FICS
        
        zobrist
        %transchild
        
        %research=0;
        gameOver = false;
        childLostKing = false;
        
        
        positionHistory = zeros(0,1);
        
    end
    methods (Static)
        function singleton = getInstance(myflag)
            
            persistent TRANSTABLE

            if ~nargin

                singleton = TRANSTABLE;
                return
            end

            if nargin==1

                if myflag==1
                    if isempty(TRANSTABLE)
                        TRANSTABLE=containers.Map('KeyType','uint32','ValueType','any');
                        singleton = TRANSTABLE;
                        return
                    end
                else
                    clear TRANSTABLE
                end
            end
        end
        function singleton = getInstanceZob(~)
            
            
            persistent ZOBRISTKEY
            
            if isempty(ZOBRISTKEY) || nargin
                %ZOBRISTKEY=zeros(1,64*12+1+4+8,'uint64');
                %ZOBRISTKEY = randi([2^31 2^32],1,64*12+1+4+8,'uint32');
                ZOBRISTKEY = uint32(randperm(2^32,64*12+1+4+8));
                
                
                
                %ZOBRISTKEY = uint64(randi([2^31 2^32],1,64*12+1+4+8).*randi([2^31 2^32],1,64*12+1+4+8));
                
                
                %for i=1:length(ZOBRISTKEY) 
                 %   ZOBRISTKEY(i)=int64(randi(2^32)*randi(2^32));
                %end
            end
            singleton=ZOBRISTKEY;
        end

 
    end
    
    methods


        function chessobj = chessboard_zob(sentposition,whosmove,castleold,castlenew,positionHistory,oldTarget,targetRank,...
                mypiece,oldsquare,newsquare)
            if nargin==1 %For now, let this be our indicator of a starting position sent from runtime.
                chessobj.wmove=true;
                chessobj.castlenew=logical([1 1;1 1;0 0; 0 0]);%1 black, 2 white
                %Leave castleold blank
                chessobj.position=sentposition;
                chessobj.zobrist=keygen(chessobj.position);
                chessobj.positionHistory = chessobj.zobrist;
                
           elseif nargin==4
                chessobj.position=sentposition;
                chessobj.wmove=whosmove;
                chessobj.castlenew=castlenew;
                chessobj.castleold=castleold;
                chessobj.zobrist=keygen(chessobj.position);


            elseif nargin>=7 %Call from the object methods.
                %%%%%%
                % Basics
                %%%%%%%
                
                
                chessobj.position=sentposition;
                if whosmove
                    oursign=1;
                else
                    oursign=-1;
                end
                chessobj.oldnew=double([oldsquare-2 newsquare-2 mypiece]);
                
                %%%%% 
                % Capture and lost king
                %%%%% 
                if chessobj.position(newsquare(1),newsquare(2))
                    chessobj.caprom=true;
                    if abs(chessobj.position(newsquare(1),newsquare(2)))==10 %King is being taken
                        chessobj.lostking=true;
                        %Could probably just break here, but hardly worth
                        %it
                    end
                end
                
                %%%%% 
                % Castle through check. Should probably check this code.
                %%%%% 
                    
                if any(castleold([3 4],~whosmove+1)) %The opponent has castled
                    if castleold(3,~whosmove+1) %The opponent has castled K
                        if whosmove %We're currently white. We're wondering if our piece can pass through black's has-castled.
                            if isequal(newsquare,[3 7])||isequal(newsquare,[3 8])
                                chessobj.castlethru=double(3);
                            end
                        else %We're black.
                            if isequal(newsquare,[10 7])||isequal(newsquare,[10 8])
                                chessobj.castlethru=double(3);
                            end
                        end
                    else %The opponent has castled Q.
                        if whosmove %We're currently white. We're wondering if our piece can pass through black's has-castled.
                            if isequal(newsquare,[3 7])||isequal(newsquare,[3 6])
                                chessobj.castlethru=double(4);
                            end
                        else %We're black.
                            if isequal(newsquare,[10 7])||isequal(newsquare,[10 6])
                                chessobj.castlethru=double(4);
                            end
                        end
                    end
                end
                
                
                if abs(mypiece)==1&&abs(newsquare(1)-oldsquare(1))==2
                    chessobj.targetfile=double(newsquare(2));
                end
                
                chessobj.wmove=~whosmove;
                chessobj.castleold=castleold;
                if isempty(castlenew) %if not passed, assume no new castle information.
                    chessobj.castlenew=chessobj.castleold;
                else
                    chessobj.castlenew=castlenew;
                end
                
                %%%%%%%
                % promotion
                %%%%%%%
                
                capturepiece=nan;
                if mypiece*oursign~=chessobj.position(oldsquare(1),oldsquare(2)) 

                    chessobj.caprom = true;
                    chessobj.promotion = true;
                    
                    capturepiece = chessobj.position(newsquare(1),newsquare(2));
                    
                    mypiece=[1 * oursign;mypiece];
                    oldsquare=[oldsquare;[nan nan]];
                    newsquare=[[nan nan];newsquare];
                end

                
                if any(any(xor(chessobj.castlenew([3 4],:),chessobj.castleold([3 4],:))))
                    %%%% We're castling. 
                    capturepiece=0;
                    
                    mypiece=[mypiece;5];
                    switch find(reshape(xor(chessobj.castlenew([3 4],:),chessobj.castleold([3 4],:)),1,4))
                        case 1
                            oldsquare=[oldsquare;3, 10];
                            newsquare=[newsquare;3, 8];
                        case 2
                            oldsquare=[oldsquare;3, 3];
                            newsquare=[newsquare;3, 6];
                        case 3
                            oldsquare=[oldsquare;10, 10];
                            newsquare=[newsquare;10 8];
                        case 4
                            oldsquare=[oldsquare;10,3];
                            newsquare=[newsquare;10, 6];
                    end
                            
                end
                
                
                if isempty(positionHistory);keyboard;
                    
                else
                    % Must generate key
                    
                    zobrist = positionHistory(end);
                    
                    if isnan(capturepiece)
                        capturepiece = chessobj.position(newsquare(1),newsquare(2));
                    end
                    
                    %%%%%%
                    % Castling rights, for the purpose of key generation.
                    %%%%%%
                    castleChange=[];
                    if any(any(xor(chessobj.castlenew([1 2],:),chessobj.castleold([1 2],:))))
                        castleChange=reshape(xor(chessobj.castlenew([1 2],:),chessobj.castleold([1 2],:)),1,4);
                    end
                    
                    
                    
                    chessobj.zobrist=keygen_new(zobrist,mypiece.*oursign,oldsquare,newsquare,capturepiece,...
                        castleChange,oldTarget,chessobj.targetfile,targetRank);
                    
                end
                chessobj.position(oldsquare(1,1),oldsquare(1,2))=0;
                
                
                %%%%% Weird, messy, bugprone, but hey. We'll see. 
                useInd=find(~isnan(newsquare(:,1)),1,'first');
                chessobj.position(newsquare(useInd,1),newsquare(useInd,2))=mypiece(useInd)*oursign;
                
                
                chessobj.positionHistory = [positionHistory;chessobj.zobrist];
                

            end
        end
    end
end




