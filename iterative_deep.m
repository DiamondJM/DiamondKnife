function chessobj = iterative_deep(chessobj,searchdepth)

%chessobj.elapsedTime(1);

currentTime = zeros(1,0);

for depth=1:searchdepth
    tic
    chessobj=transtable(chessobj,-Inf,Inf,depth);
    toc
    
    
    currentTime = [currentTime toc];
    
    if sum(currentTime) > 8
        break
    end
    
end

end