function ring = extract_ring(Xp,i,j,r)
    B = size(Xp,3);  
    count = 8*r;    
    ring = zeros(count,B);    
    idx = 1;    
    for dx = -r:r
        for dy = -r:r           
            if abs(dx)==r || abs(dy)==r                
                ring(idx,:) = reshape(Xp(i+r+dx,j+r+dy,:),1,B);
                idx = idx + 1;                
            end            
        end
    end
end