function h= keygen(position)


ZOBRISTKEY=chessboard_zob.getInstanceZob;

piececonverter=[1 1;2 2;3 3;5 4;9 5;10 6;-1 7;-2 8;-3 9;-5 10;-9 11;-10 12];

h=0;

%position=position(3:10,3:10);
for ii=1:64
    [itemp,jtemp]= ind2sub([8 8],ii);
    if position(itemp+2,jtemp+2)
        master_ind=sub2ind([64 12],ii,piececonverter(piececonverter(:,1)==position(itemp+2,jtemp+2),2));
        h=bitxor(h,ZOBRISTKEY(master_ind));
    end
end


h=bitxor(h,ZOBRISTKEY(769));


end
