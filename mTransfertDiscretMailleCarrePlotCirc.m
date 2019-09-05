function [ matTransfert, matDiffrac ] = mTransfertDiscretMailleCarrePlotCirc( gamma, beta2, Nd, pitch, w0, lambda, foc, dphi )
% mTransfertDiscretMailleCarrePlotCirc : Calcul de la matrice de transfert
% d'un système à contraste de phase d'un champ proche en maille carrée,
% pour un filtre de plot déphasant circulaire
%
%   Mandatory input arguments :
%       gamma : rapport taille plot déphasant/diamètre lobe central champ lointain
%       beta2 : transmission périphérique (en intensité)
%       Nd : Nombre de faisceaux sur la diagonale (nombre total de faisceaux = Nd²)
%       pitch : pas de la maille carrée [m]
%       w0 : rayon à 1/e² d'un faisceau gaussien en champ proche [m]
%       lambda : longueur d'onde du rayonnement [m]
%       foc : focale avant le filtre à contraste de phase [m]
%       dphi : déphasage du plot déphasant
%
%   Output :
%       matTransfert : matrice de transfert du système CdP choisi

    NB = Nd^2 ;
    eta = 2*w0/pitch ;
    beta = sqrt(beta2) ;         
    %% Construction de la matrice de couplage diffractif utilis�e dans la matrice de transfert g�n�rale
    diamLobCentr = 2*lambda*foc/((Nd-1)*pitch+2*w0) ; % Diam�tre du lobe central
    A = gamma*diamLobCentr ; % Diam�tre du filtre � contraste de phase
    %%% Matrice 1D
    L(1) = 1 ;
    itx = 1:(Nd-1) ;
    L(itx+1) = besselj(1,2*gamma*pi*itx/Nd)./(2*gamma*pi*itx/Nd) ;
    diffrac = toeplitz(L,L) ;
    %%% Matrice 2D
    diffrac1 = diffrac ;
    for xx1=1:(Nd-1)
        diffrac1 = [diffrac1 (besselj(1,2*gamma*pi*xx1/Nd)./(2*gamma*pi*xx1/Nd))*diffrac] ;
    end
    diffrac2 = diffrac1 ;
    diffracF = diffrac1 ; 
    for yy1=1:(Nd-1)
        diffrac2 = [(besselj(1,2*gamma*pi*yy1/Nd)./(2*gamma*pi*yy1/Nd))*diffrac diffrac2] ;
        diffrac2 = diffrac2(:,1:NB) ;
        diffracF = [diffracF ; diffrac2] ;
    end
    %%% Fin de construction de la matrice de couplage diffractif %%%


    %% Matrices de transfert du syst�me � contraste de phase
    matTransfert =(beta)*(eye(NB))+2*pi^2*(exp(1i*dphi)-beta)*(0.5*gamma*eta/Nd)^2*diffracF ; % Matrice de transfert
    matDiffrac = diffracF ;
end
