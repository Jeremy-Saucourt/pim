function [mt,diffrac] = mt_cdp_reseauLineaire_plotFente( reseau, filtre )
    %% Matrice de diffraction
    L(1) = 1 ;
    itx = 1:(reseau.n-1) ;
    L(itx+1) = sin(2*filtre.gamma*pi*itx/reseau.n)./(2*filtre.gamma*pi*itx/reseau.n) ;
    diffrac = toeplitz(L,L) ;

    %% Matrice de transfert
    mt = filtre.beta*eye(reseau.n) + (exp(1i*filtre.dphi)-filtre.beta)*(sqrt(pi)*filtre.gamma*reseau.eta/reseau.n)*diffrac ;
    mt = mt/max(max(abs(mt))) ; % Normalisation
end

