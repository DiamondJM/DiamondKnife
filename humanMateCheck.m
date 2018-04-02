function chessobj = humanMateCheck(chessobj,depth)



if depth>=1
    if isempty(chessobj.children)
        chessobj=listofmoves(chessobj);
    end
    for ii=1:length(chessobj.children)
        chessobj.children(ii) = humanMateCheck(chessobj.children(ii),depth-1);
    end
end

if depth ~=2;return;end

for ii = 1:length(chessobj.children)
    if ~any([chessobj.children(ii).children.lostking])
        break
    end
end


if ii==length(chessobj.children)
    chessobj.gameOver = true;
end




end 