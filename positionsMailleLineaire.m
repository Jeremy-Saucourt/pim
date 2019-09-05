function [ pos, nd ] = positionsMailleLineaire( reseau )
    nd = reseau.n ;
    pos.x = (-(reseau.n-1)/2+(0:(reseau.n-1)))' ; % Coordonnée x
    pos.y = zeros(reseau.n,1) ; % Coordonnée y
end

