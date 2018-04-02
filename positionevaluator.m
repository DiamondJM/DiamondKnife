function eval = positionevaluator(myposition,mycastlenew)
countbishops = [0 0]; %First is black second is white

bishoppair = (0.2);
undevelopedpiece = (0.4);
castled=(0.3);
rankcenter4=(0.2);
developedcpawn=(0.1);
fpawn=(.2);
cantcastle=(0.4);
mobilequeen=(0.1);
knightrim=(.1);
%taperlate=1.2;
disruptPawnBonus=0.5;
deepPawn=.5;

eval=(0);

for i=3:10
    for j = 3:10
        piece=double(myposition(i,j));
        if piece&&abs(piece)~=10
            if abs(piece)==2
                eval=eval+sign(piece)*3.25;
                if j==3||j==10
                    eval=eval-sign(piece)*knightrim;
                    %white knight; worse for white; eval decreases
                end
            elseif abs(piece)==3
                eval=eval+sign(piece)*3.75;
                countbishops(~((1-sign(piece))/2)+1) = countbishops(~((1-sign(piece))/2)+1)+1;
                
            elseif abs(piece)==1
                
                
                
                eval=eval+piece;
                if j==6||j==7
                    if (i>=6&&piece==-1)||(i<=7&&piece==1)
                        
                        eval=eval+rankcenter4*piece;
                    end
                elseif j==8
                    if (i==4&&piece==-1)||(i==9&&piece==1)
                        eval=eval+fpawn*piece;
                    end
                elseif j==5
                    if(i>=6&&piece==-1)||(i<=7&&piece==1)
                        eval=eval+developedcpawn*piece;
                    end
                end
                
                if i<=5&&piece==1||i>=8&&piece==-1
                    eval=eval+deepPawn*piece;
                end
                
                
            else
                eval=eval+piece;
            end
            
            if i==3
                if piece==-3||piece==-2
                    eval=eval+undevelopedpiece; %Worse for black; better for white
                    if myposition(3,6)~=-9&&any(any(abs(myposition)==-9))
                        eval=eval+mobilequeen;
                    end
                end
            end
            if i==10
                if piece==3||piece==2
                    eval=eval-undevelopedpiece; %Worse for black; better for white
                    if myposition(10,6)~=9&&any(any(abs(myposition)==9))
                        eval=eval-mobilequeen;
                    end
                end
            end
        end
    end
end


%Bishop pair
if countbishops(1)==2 %%Black has two bishops
    eval=eval-bishoppair;
end
if countbishops(2)==2
    eval=eval+bishoppair;
end

% sumwhite=sum(myposition(myposition~=99&sign(myposition)==1&abs(myposition)~=10));
% sumblack=-sum(myposition(sign(myposition)==-1&abs(myposition)~=10));
% 
% eval=eval*(1+(74-max(sumwhite+sumblack,15))/59/3);
% 


%Castling
eval=eval-any(mycastlenew([3 4],1))*castled+any(mycastlenew([3 4],2))*castled;

eval=eval+~any(mycastlenew(:,1))*cantcastle-~any(mycastlenew(:,2))*cantcastle;

if any(any(mycastlenew([3 4],:)))
    castleInds=find(reshape(mycastlenew([3 4],:),1,4));
    for i=castleInds
        switch i
            case 1 %black king
                if all(sign(myposition(4,8:9))==-1)
                    eval=eval-disruptPawnBonus;%Better for black;
                end
            case 2 %black queen
                if all(sign(myposition(4,4:5))==-1)
                    eval=eval-disruptPawnBonus;%Better for black;
                end
            case 3
                if all(sign(myposition(9,8:9))==1)
                    eval=eval+disruptPawnBonus;
                end
            case 4 
                if all(sign(myposition(9,4:5))==1)
                    eval=eval+disruptPawnBonus;
                end
        end
    end
end


end
