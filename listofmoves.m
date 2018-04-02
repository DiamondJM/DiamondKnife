function chessobj = listofmoves(chessobj)
if chessobj.wmove
    oursign=double(1);
else
    oursign=double(-1);
end


listlength=double(0);
objectarray=chessboard_zob.empty(50,0);


for i=double(3):double(10)
    for j=double(3):double(10)
        if sign(chessobj.position(i,j))==oursign
            if abs(chessobj.position(i,j))==1
                if (i==9 && chessobj.wmove) || (i==4 && ~chessobj.wmove) %pawn on home rank. pawn can move up one or two if unobstructed
                    if ~chessobj.position(i-oursign,j) %considering one past the home rank.
                        %The content of the if statement is -1 for white
                        %and 1 for black.
                        
                        listlength=listlength+1;
                        objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                            chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                            double(1),[i j],[i-oursign j]); %Note: no change in castling rights. Pass new to old; leave new blank.
                        
                        
                        if ~chessobj.position(i-2*oursign,j) %-2 for white, 2 for black
                            listlength=listlength+1;
                            objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                double(1),[i j],[i-2*oursign j]);
                        end
                    end
                    for p=double([-1 1])
                        if sign(chessobj.position(i-oursign,j+p))==oursign*-1&&...
                                chessobj.position(i-oursign,j+p)~=99
                            
                            listlength=listlength+1;
                            objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                double(1),[i j],[i-oursign j+p]);
                        end
                    end
                    
                elseif i<=8 && i >=5
                    if ~chessobj.position(i-oursign,j)
                        listlength=listlength+1;
                        objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                            chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                            double(1),[i j],[i-oursign j]);
                    end
                    for p=double([-1 1])
                        if sign(chessobj.position(i-oursign,j+p))==oursign*-1&&...
                                chessobj.position(i-oursign,j+p)~=99
                            listlength=listlength+1;
                            objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                double(1),[i j],[i-oursign j+p]);
                        end
                        %if isequal([i-oursign j+p],chessobj.targetsquare)
                        if ~isempty(chessobj.targetfile)&&...
                                ((oursign==1&&i==6)||(oursign==-1&&i==7))&&(j+p==chessobj.targetfile)
                            
                            if oursign==1;targetRank=6;else;targetRank=7;end
                            
                            listlength=listlength+1;
                            myposition=chessobj.position;
                            myposition(targetRank, chessobj.targetfile)=0;
                            objectarray(listlength)=chessboard_zob(myposition,chessobj.wmove,...
                                chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,targetRank,...
                                double(1),[i j],[i-oursign j+p]);
                        end
                        
                    end
                elseif (i==4 && chessobj.wmove) || (i==9 && ~chessobj.wmove)
                    if ~chessobj.position(i-oursign,j) %pawn can move up one
                        
                        for q=double([2 3 5 9])
                            listlength=listlength+1;
                            objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                q,[i j],[i-oursign j]);
                        end
                        
                    end
                    for p=double([-1 1])
                        if sign(chessobj.position(i-oursign,j+p))==oursign*-1&&...
                                chessobj.position(i-oursign,j+p)~=99
                            
                            for q=double([2 3 5 9])
                                listlength=listlength+1;
                                objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                    chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                    q,[i j],[i-oursign j+p]);
                            end
                            
                        end
                    end
                end
            elseif abs(chessobj.position(i,j))==2 %Knight
                for p = double([-2 -1 1 2])
                    for q=double([-2 -1 1 2])
                        if abs(p)~=abs(q)
                            if sign(chessobj.position(i+p,j+q))~=oursign&&...
                                    chessobj.position(i+p,j+q)~=99
                                listlength=listlength+1;
                                objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                    chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                    double(2),[i j],[i+p j+q]);
                            end
                        end
                    end
                end
            elseif abs(chessobj.position(i,j))==3 %bishop
                for p=double([-1 1])
                    for q=double([-1 1])
                        unblocked = true;
                        k=double(1);
                        while unblocked
                            if sign(chessobj.position(i+k*p,j+k*q))==oursign||...
                                    chessobj.position(i+k*p,j+k*q)==99
                                unblocked = false;
                            else
                                listlength=listlength+1;
                                objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                    chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                    double(3),[i j],[i+k*p j+k*q]);
                                if sign(chessobj.position(i+k*p,j+k*q))==oursign*-1
                                    unblocked=false;
                                end
                            end
                            k=k+1;
                        end
                    end
                end
            elseif abs(chessobj.position(i,j))==5 %Rook
                p = double([-1 1 0 0]);
                q=double([0 0 -1 1]);
                for r=1:4
                    unblocked = true;
                    k=double(1);
                    while unblocked
                        
                        if sign(chessobj.position(i+k*p(r),j+k*q(r)))==oursign||...
                                chessobj.position(i+k*p(r),j+k*q(r))==99
                            unblocked=false;
                        else
                            
                            listlength=listlength+1;
                            castlenew_matrix=chessobj.castlenew;
                            if j==3
                                castlenew_matrix(2,chessobj.wmove+1)=0;
                            elseif j==10
                                castlenew_matrix(1,chessobj.wmove+1)=0;
                            end
                            objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                chessobj.castlenew,castlenew_matrix,chessobj.positionHistory,chessobj.targetfile,[],...
                                double(5),[i j],[i+k*p(r) j+k*q(r)]);
                            if sign(chessobj.position(i+k*p(r),j+k*q(r)))==oursign*-1
                                unblocked=false;
                            end
                        end
                        k=k+1;
                    end
                end
            elseif abs(chessobj.position(i,j))==9 %Queen
                for p=double([-1 0 1])
                    for q=double([-1 0 1])
                        unblocked=true;
                        k=double(1);
                        while unblocked
                            if sign(chessobj.position(i+k*p,j+k*q))==oursign||...
                                    chessobj.position(i+k*p,j+k*q)==99
                                unblocked=false;
                            else
                                listlength=listlength+1;
                                objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                    chessobj.castlenew,[],chessobj.positionHistory,chessobj.targetfile,[],...
                                    double(9),[i j],[i+k*p j+k*q]);
                                if sign(chessobj.position(i+k*p,j+k*q))==oursign*-1
                                    unblocked=false;
                                end
                            end
                            k=k+1;
                        end
                    end
                end
            elseif abs(chessobj.position(i,j))==10 %King
                for p=double([-1 0 1])
                    for q=double([-1 0 1])
                        if sign(chessobj.position(i+p,j+q))~=oursign &&...
                                chessobj.position(i+p,j+q)~=99
                            
                            listlength=listlength+1;
                            castlenew_matrix=chessobj.castlenew;
                            castlenew_matrix(1,chessobj.wmove+1)=0;
                            castlenew_matrix(2,chessobj.wmove+1)=0;
                            objectarray(listlength)=chessboard_zob(chessobj.position,chessobj.wmove,...
                                chessobj.castlenew,castlenew_matrix,chessobj.positionHistory,chessobj.targetfile,[],...
                                double(10),[i j],[i+p j+q]);
                        end
                    end
                end
                
                if chessobj.castlenew(1,chessobj.wmove+1)==1 && ~chessobj.position(i,j+1) && ~chessobj.position(i,j+2) &&chessobj.position(i,j+3)==5*oursign %kingside
                    
                    listlength=listlength+1;
                    myposition=chessobj.position;
                    
                    
                    myposition(i,j+3)=0;
                    myposition(i,j+1)=5*oursign;
                    
                    castlenew_matrix=chessobj.castlenew;
                    castlenew_matrix(1,chessobj.wmove+1)=0;
                    castlenew_matrix(2,chessobj.wmove+1)=0;
                    castlenew_matrix(3,chessobj.wmove+1)=1;
                    
                    objectarray(listlength)=chessboard_zob(myposition,chessobj.wmove,...
                        chessobj.castlenew,castlenew_matrix,chessobj.positionHistory,chessobj.targetfile,[],...
                        double(10),[i j],[i j+2]);
                    
                end
                if chessobj.castlenew(2,chessobj.wmove+1)==1 && ~chessobj.position(i,j-1) && ~chessobj.position(i,j-2) && ~chessobj.position(i,j-3) &&chessobj.position(i,j-4)==5*oursign %Queenside
                    
                    listlength=listlength+1;
                    myposition=chessobj.position;
                    
                    myposition(i,j-4)=0;
                    myposition(i,j-1)=5*oursign;
                    
                    castlenew_matrix=chessobj.castlenew;
                    castlenew_matrix(1,chessobj.wmove+1)=0;
                    castlenew_matrix(2,chessobj.wmove+1)=0;
                    castlenew_matrix(4,chessobj.wmove+1)=1;
                    
                    objectarray(listlength)=chessboard_zob(myposition,chessobj.wmove,...
                        chessobj.castlenew,castlenew_matrix,chessobj.positionHistory,chessobj.targetfile,[],...
                        double(10),[i j],[i j-2]);
                end
            end
        end
    end
end

for i=1:length(objectarray)
    objectarray(i).winningeval=positionevaluator(objectarray(i).position,objectarray(i).castlenew);
end


if chessobj.wmove
    [~,I]=sort([objectarray.winningeval],'descend');
else
    [~,I]=sort([objectarray.winningeval],'ascend');
end
chessobj.children=objectarray(I);

%chessobj.children=objectarray;

end
