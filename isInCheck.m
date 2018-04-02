function inCheck = isInCheck(chessobj)

% Essentially, let's switch the color to move, and generate children. If there's
% a lost king, then the player to move is in check. 

chessobj.wmove = ~chessobj.wmove;
chessobj.children = [];
chessobj = listofmoves(chessobj);

if any([chessobj.children.lostking])
    inCheck = true;
else 
    inCheck = false;
end

end