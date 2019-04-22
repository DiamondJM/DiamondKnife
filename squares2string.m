function moveString = squares2string(moveDescrip,promotion)


oldSquare = moveDescrip([1 2]);
newSquare = moveDescrip([3 4]);
currentPiece = moveDescrip(5);

conversionLetter = {'a' 1;'b' 2;'c' 3;'d' 4;'e' 5;'f' 6;'g' 7;'h' 8};
conversionnumber = [1 8;2 7;3 6;4 5;5 4;6 3; 7 2;8 1];


moveString = conversionLetter{[conversionLetter{:,2}]==oldSquare(2),1};
moveString = [moveString num2str(conversionnumber(conversionnumber(:,2)==oldSquare(1),1))];
moveString = [moveString conversionLetter{[conversionLetter{:,2}]==newSquare(2),1}];
moveString = [moveString num2str(conversionnumber(conversionnumber(:,2)==newSquare(1),1))];

if promotion
    if abs(currentPiece)==9
        pieceChar = 'Q';
    elseif abs(currentPiece)==5
        pieceChar = 'R';
    elseif abs(currentPiece)==3
        pieceChar = 'B';
    elseif abs(currentPiece)==2
        pieceChar = 'N';
    end
    
    moveString = [moveString '=' pieceChar];
end




end
