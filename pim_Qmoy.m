%{
    Cophasage d'un réseau de lasers par la méthode PIM.

    Jérémy Saucourt, le 04/09/2019
%}
clear all ;


%% Paramètres du réseau
reseau.n = 3 ; % Nombre de faisceaux
reseau.p = 500e-6 ; % Entraxe des faisceaux [m]
reseau.w0 = 60e-6 ; % Demi-largeur des faisceaux à 1/e² en intensité [m]
reseau.eta = 2*reseau.w0/reseau.p ; % Taux de remplissage du réseau
reseau.lambda = 980e-9 ; % Longueur d'onde du rayonnement [m]


%% Paramètres du filtre spatial
filtre.gamma = 0.3 ; % Rapport entre le diamètre du filtre et le diamètre du lobe central en champ lointain
filtre.beta2 = 0.04 ; % Transmissivité périphérique en intensité
filtre.beta = sqrt(filtre.beta2) ; % Transmissivité périphérique en champ
filtre.dphi = pi/2 ; % Déphasage entre le plot central et la périphérie [rad]


%% Matrice de couplage diffractif
[ mt,diffrac ] = mt_cdp_reseauLineaire_plotFente( reseau, filtre ) ;

%%
algo.n = reseau.n ;
algo.nbMoy = 100 ;
algo.nbActionMax = 20 ; % Nombre d'actionnement maximal des modulateurs de phase
algo.xc = ones(algo.n,1) ; % Champ complexe cible
algo.mt = mt ;
algo.mti = inv(mt) ;
algo.yc = algo.mt*algo.xc ;

rng('shuffle') ;




for m=1:algo.nbMoy
    for k=1:algo.nbActionMax
        if k==1
            champk = abs(algo.xc).*exp(1i*2*pi*rand(algo.n,1)) ;
    %         champk = abs(algo.xc).*exp(1i*angle(algo.xc)) ; % Test de stabilité
        end
        phasage(m,k) = abs(sum(champk.*conj(algo.xc))).^2 / sum(abs(champk.*conj(algo.xc))).^2 ;

        b = abs(algo.mt*champk).*exp(1i*angle(algo.yc)) ;
        corr = angle(algo.mti*b) ;

        champk = champk.*exp(-1i*corr).*exp(1i*angle(algo.xc)) ;
    end
end


%% Graphiques
figure(1),clf,hold on
    errorfill(1:algo.nbActionMax,mean(phasage),std(phasage),'b',[0.2 0.5])
    axis([0 algo.nbActionMax 0 1])
    box on, grid on
    
    