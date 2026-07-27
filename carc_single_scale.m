function out = carc_single_scale(X,r)
    [H,W,B] = size(X);
    pad = r; 
    Xp = padarray(X,[pad pad 0],'symmetric');  
    out = zeros(H,W);
    for i = 1:H
        for j = 1:W
            
            %% central spectrum
            center = reshape(Xp(i+pad,j+pad,:),1,B);
            
            %% ring neighborhood
            ring = extract_ring(Xp,i,j,r);
            m = size(ring,1);
            
            %% spectral difference
            diff = sum(abs(ring - center),2);
            
            %% statistical features
            mu = mean(diff);
            sigma = std(diff);
            rho = sum(diff > mu)/m;
            
            %% component identification
            if mu < 0.5*1e-3                                % background              
                C = 0;                
            elseif sigma > 0.4*mu && rho>0.45 && rho<0.55   % edge              
                small = diff(diff<=mu);
                large = diff(diff>mu);              
                if isempty(large)
                    C = 0;
                else
                    C = (mean(small)/(mean(large)+eps));
                end                
            else                                           % anomaly        
                C = min(diff);               
            end            
            out(i,j) = C;            
        end
    end
end