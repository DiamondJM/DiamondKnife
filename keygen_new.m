function h= keygen_new(h,mypiece,oldsquare,newsquare,capturepiece,...
    castleChange,oldTarget,newTarget,targetRank)

ZOBRISTKEY=chessboard_zob.getInstanceZob;

piececonverter=[1 1;2 2;3 3;5 4;9 5;10 6;-1 7;-2 8;-3 9;-5 10;-9 11;-10 12];


oldsquare=oldsquare-2;newsquare=newsquare-2;
oldTarget=oldTarget-2;newTarget=newTarget-2;
targetRank=targetRank-2;

for jj=1:size(mypiece,1)
    %%% Xor out 
    
    if all(~isnan(oldsquare(jj,:)))
    
        ii=sub2ind([8 8],oldsquare(jj,1),oldsquare(jj,2));
        m_ind=sub2ind([64 12],ii,piececonverter(piececonverter(:,1)==mypiece(jj),2));
        h=bitxor(h,ZOBRISTKEY(m_ind));
    end
    
    %%% Xor in
    if all(~isnan(newsquare(jj,:)))
        
        ii=sub2ind([8 8],newsquare(jj,1),newsquare(jj,2));
        m_ind=sub2ind([64 12],ii,piececonverter(piececonverter(:,1)==mypiece(jj),2));
        h=bitxor(h,ZOBRISTKEY(m_ind));
    end
end

if capturepiece
    
    m_ind=sub2ind([64 12],ii,piececonverter(piececonverter(:,1)==capturepiece,2));
    h=bitxor(h,ZOBRISTKEY(m_ind));
    
end

h=bitxor(h,ZOBRISTKEY(769));

if ~isempty(castleChange)
    castleInds=find(castleChange);
    for ii=castleInds
        h=bitxor(h,ZOBRISTKEY(769+ii));
    end
end

if ~isempty(oldTarget)%;keyboard;
    h=bitxor(h,ZOBRISTKEY(773+oldTarget));
end
if ~isempty(newTarget)%;keyboard;
    h=bitxor(h,ZOBRISTKEY(773+newTarget));
end

if ~isempty(targetRank)
    %We had an en passant capture.
    %Must xor out the pawn that goes.
    
    ii=sub2ind([8 8],targetRank,oldTarget);
    if abs(mypiece)~=1;keyboard;end
    m_ind=sub2ind([64 12],ii,piececonverter(piececonverter(:,1)==mypiece*-1,2));
    h=bitxor(h,ZOBRISTKEY(m_ind));
    

end