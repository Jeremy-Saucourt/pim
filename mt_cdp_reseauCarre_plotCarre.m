function [mt,diffrac] = mt_cdp_reseauCarre_plotCarre( reseau, filtre )

    if mod(sqrt(reseau.n),1)
        error('Veuillez entrer un nombre de faisceaux carré (1,4,9,16,25,...)') ;
    else
        nd = sqrt(reseau.n) ;
    end


    
    %% Matrice de diffraction
    %%% Matrice de diffraction d'une ligne
    L(1) = 1 ;
    itx = 1:(nd-1) ;
    L(itx+1) = sin(2*filtre.gamma*pi*itx/sqrt(reseau.n))./(2*filtre.gamma*pi*itx/sqrt(reseau.n)) ;
    diffrac = toeplitz(L,L) ;

    %%% Matrice 2D
    diffracx = diffrac ;
    for x=1:(nd-1)
        diffracx = [diffracx (sin(2*filtre.gamma*pi*x/nd)./(2*filtre.gamma*pi*x/nd))*diffrac] ;
    end
    
    diffracy = diffracx ;
    diffracF = diffracx ; 
    for y=1:(nd-1)
        diffracy = [(sin(2*filtre.gamma*pi*y/nd)./(2*filtre.gamma*pi*y/nd))*diffrac diffracy] ;
        diffracy = diffracy(:,1:reseau.n) ;

        diffracF = [diffracF ; diffracy] ;
    end


    %% Matrice de transfert
    mt =(filtre.beta)*(eye(reseau.n))+(exp(1i*filtre.dphi)-filtre.beta)*(sqrt(pi)*filtre.gamma*reseau.eta/sqrt(reseau.n))^2*diffracF ; % Matrice de transfert
    mt = mt/max(max(abs(mt))) ; % Normalisation
    diffrac = diffracF ;
end

