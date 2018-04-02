function movestring = squares2string(moveDescrip,promotion)


oldsquare = moveDescrip([1 2]);
newsquare = moveDescrip([3 4]);
mypiece = moveDescrip(5);

conversionletter={'a' 1;'b' 2;'c' 3;'d' 4;'e' 5;'f' 6;'g' 7;'h' 8};
conversionnumber=[1 8;2 7;3 6;4 5;5 4;6 3; 7 2;8 1];


movestring=conversionletter{[conversionletter{:,2}]==oldsquare(2),1};
movestring=strcat(movestring,num2str(conversionnumber(conversionnumber(:,2)==oldsquare(1),1)));
movestring=strcat(movestring,conversionletter{[conversionletter{:,2}]==newsquare(2),1});
movestring=strcat(movestring,num2str(conversionnumber(conversionnumber(:,2)==newsquare(1),1)));

if promotion
    if abs(mypiece)==9
        mypiecechar='Q';
    elseif abs(mypiece)==5
        mypiecechar='R';
    elseif abs(mypiece)==3
        mypiecechar='B';
    elseif abs(mypiece)==2
        mypiecechar='N';
    end
    
    movestring=strcat(movestring,['=' mypiecechar]);
end




end
