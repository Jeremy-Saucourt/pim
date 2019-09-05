function [mt,diffrac] = mt_cdp_reseauLineaire( reseau, filtre )

    if ~mod(sqrt(reseau.n),1)
        error('Veuillez entrer un nombre de faisceaux carré (1,4,9,16,25,...)') ;
    else
        nd = sqrt(reseau.n) ;
    end

    %% Matrice de diffraction
    L(1) = 1 ;
    itx = 1:(nd-1) ;
    L(itx+1) = sin(2*filtre.gamma*pi*itx/sqrt(reseau.n))./(2*filtre.gamma*pi*itx/sqrt(reseau.n)) ;
    diffrac = toeplitz(L,L) ;


    %% Matrices de transfert
    mt = filtre.beta*eye(reseau.n) + (exp(1i*filtre.dphi)-filtre.beta)*(sqrt(pi)*filtre.gamma*reseau.eta/reseau.n)*diffrac ;
    mt = mt/max(max(abs(mt))) ; % Normalisation
    
    


    %%% Matrice 1D
    L(1) = 1 ;
    itx = 1:(Nd-1) ;
    L(itx+1) = sin(2*gamma*pi*itx/Nd)./(2*gamma*pi*itx/Nd) ;
    diffrac = toeplitz(L,L) ;
    %%% Matrice 2D
    diffrac1 = diffrac ;
    for xx1=1:(Nd-1)
        diffrac1 = [diffrac1 (sin(2*gamma*pi*xx1/Nd)./(2*gamma*pi*xx1/Nd))*diffrac] ;
    end
    diffrac2 = diffrac1 ;
    diffracF = diffrac1 ; 
    for yy1=1:(Nd-1)
        diffrac2 = [(sin(2*gamma*pi*yy1/Nd)./(2*gamma*pi*yy1/Nd))*diffrac diffrac2] ;
        diffrac2 = diffrac2(:,1:NB) ;
        diffracF = [diffracF ; diffrac2] ;
    end
    %%% Fin de construction de la matrice de couplage diffractif %%%

    %% Matrices de transfert du systï¿½me ï¿½ contraste de phase
    matTransfert =(beta)*(eye(NB))+(exp(1i*dphi)-beta)*(sqrt(pi)*gamma*eta/Nd)^2*diffracF ; % Matrice de transfert
    matDiffrac = diffracF ;
    
end

