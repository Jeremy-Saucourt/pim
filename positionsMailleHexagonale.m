function [ pos, nd ] = positionsMailleHexagonale( reseau )
    Nc = (-3+sqrt(9-12*(1-reseau.n)))/6 ;
    nd = 2*Nc+1 ;
    if mod(Nc,1)
        error('Veuillez entrer un nombre de faisceaux valable (7, 19, 37, 61, 91, 127, ...) !')
    else
        pos.x = nan(reseau.n,1) ; % Coordonnée x
        pos.y = nan(reseau.n,1) ; % Coordonnée y

        k=0;
        for i=Nc:-1:0
            ylin = sqrt(3)*i/2 ;
            for j=1:(2*Nc+1-i)
                k = k+1 ;
                pos.x(k) = (-(2*Nc-i)-2)/2 + j ;
                pos.y(k) = ylin ;
            end
        end

        xTmp = pos.x(1:((reseau.n-1)/2-Nc),1);
        yTmp = pos.y(1:((reseau.n-1)/2-Nc),1);

        % Rotation 180°
        xTmp = cos(pi)*xTmp - sin(pi)*yTmp ; 
        yTmp = sin(pi)*xTmp + cos(pi)*yTmp ;

        pos.x = [pos.x ; flip(xTmp)] ;
        pos.y = [pos.y ; flip(yTmp)] ;
        
        pos.x = pos.x(~isnan(pos.x)) ;
        pos.y = pos.y(~isnan(pos.y)) ;
end

