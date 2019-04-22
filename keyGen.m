function  zobristKey = keyGen(currentPosition,zKeys)

pieceConverter = [1 1;2 2;3 3;5 4;9 5;10 6;-1 7;-2 8;-3 9;-5 10;-9 11;-10 12];

zobristKey = 0;


for squareInd = 1:64
    [iTemp,jTemp] = ind2sub([8 8],squareInd);
    if currentPosition(iTemp + 2, jTemp+2)
        pieceInd = pieceConverter(pieceConverter(:,1) == currentPosition(iTemp+2, jTemp+2),2);
        zobInd = sub2ind([64 12], squareInd, pieceInd);
        zobristKey = bitxor(zobristKey,zKeys(zobInd));
    end
end


zobristKey = bitxor(zobristKey,zKeys(769));


end
