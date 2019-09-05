function [ mt,diffrac ] = mt_cdp_reseauCarre_plotCarre_pos( reseau, filtre )

    if mod(sqrt(reseau.n),1)
        error('Veuillez entrer un nombre de faisceaux carré (1,4,9,16,25,...)') ;
    else
        nd = sqrt(reseau.n) ;
    end
    
    %% Autre méthode de matrice de diffraction
    pos.x = nan(sqrt(reseau.n)) ; % Coordonnée x
    pos.y = nan(sqrt(reseau.n)) ; % Coordonnée y
    for i=1:sqrt(reseau.n)
        pos.x(i,1:sqrt(reseau.n)) = (-(sqrt(reseau.n)-1)/2+(0:(sqrt(reseau.n)-1))) ;
        pos.y(1:sqrt(reseau.n),i) = (-(sqrt(reseau.n)-1)/2+(0:(sqrt(reseau.n)-1))) ;
    end
    pos.x = reshape(pos.x,[numel(pos.x) 1]) ;
    pos.y = reshape(pos.y,[numel(pos.y) 1]) ;
    
    diffrac = nan(reseau.n) ;
    for i=1:reseau.n
        for j=1:reseau.n
            if i==j
                diffrac(i,j) = 1 ;
            else
                posdiff = sqrt((pos.x(i)-pos.x(j))^2+(pos.y(i)-pos.y(j))^2) 
                diffrac(i,j) = abs(sin(2*filtre.gamma*pi*posdiff/sqrt(reseau.n))./(2*filtre.gamma*pi*posdiff/sqrt(reseau.n))) ;
            end
        end
    end


    %% Matrice de transfert
    mt =(filtre.beta)*(eye(reseau.n))+(exp(1i*filtre.dphi)-filtre.beta)*(sqrt(pi)*filtre.gamma*reseau.eta/sqrt(reseau.n))^2*diffrac ; % Matrice de transfert
    mt = mt/max(max(abs(mt))) ; % Normalisation

end

