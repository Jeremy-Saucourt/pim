function [ pos, nd ] = positionsMailleCarree( reseau )
    nd = sqrt(reseau.n) ;
    if mod(nd,1)
        error('Veuillez entrer un nombre de faisceaux valable (1,4,9,16,25, ...) !')
    else

    pos.x = nan(sqrt(reseau.n)) ; % Coordonnée x
    pos.y = nan(sqrt(reseau.n)) ; % Coordonnée y
    for i=1:sqrt(reseau.n)
        pos.x(i,1:sqrt(reseau.n)) = (-(sqrt(reseau.n)-1)/2+(0:(sqrt(reseau.n)-1))) ;
        pos.y(1:sqrt(reseau.n),i) = (-(sqrt(reseau.n)-1)/2+(0:(sqrt(reseau.n)-1))) ;
    end
    pos.x = reshape(pos.x,[numel(pos.x) 1]) ;
    pos.y = reshape(pos.y,[numel(pos.y) 1]) ;
end

