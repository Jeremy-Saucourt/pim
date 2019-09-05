function [ mt, diffrac ] = mt_cdp( reseau, filtre )
    %% Matrice de couplage diffractif
    [ diffrac, coeff ] = mc_diffrac( reseau, filtre ) ;
    
    %% Matrice 
    switch lower(reseau.maille)
        case 'lineaire'
            % Maille lineaire, plot fente
            mt = filtre.beta*eye(reseau.n) + (exp(1i*filtre.dphi)-filtre.beta)*(sqrt(pi)*filtre.gamma*reseau.eta/reseau.n)*diffrac ;

        case 'carree'
            % Maille carrée, plot carré
            mt = filtre.beta*eye(reseau.n) + (exp(1i*filtre.dphi)-filtre.beta)*(sqrt(pi)*filtre.gamma*reseau.eta/sqrt(reseau.n))^2*diffrac ;
            
        case 'hexagonale'
            % Maille hexa, plot disque
            mt = filtre.beta*eye(reseau.n) + (exp(1i*filtre.dphi)-filtre.beta)*2*pi^2*(0.61*filtre.gamma*reseau.eta/sqrt(reseau.n))^2*diffrac ;
            
        otherwise
            error('Type de réseau non existant ou non implémenté')
    end

    % Normalisation
    mt = mt/max(max(abs(mt))) ;
    
end

