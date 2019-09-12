%{
    Cophasage d'un réseau de lasers par la méthode PIM.

    Jérémy Saucourt, le 04/09/2019
%}
clear all ;
rng('shuffle') ;


%% Paramètres du réseau
reseau.n = 7 ; % Nombre de faisceaux
reseau.p = 500e-6 ; % Entraxe des faisceaux [m]
reseau.w0 = 60e-6 ; % Demi-largeur des faisceaux à 1/e² en intensité [m]
reseau.eta = 2*reseau.w0/reseau.p ; % Taux de remplissage du réseau
reseau.lambda = 980e-9 ; % Longueur d'onde du rayonnement [m]
reseau.maille = 'lineaire' ; % Type de maille ('lineaire','carree' ou 'hexagonale')
[ reseau.pos, reseau.nd ] = positionsEmetteurs( reseau ) ;


%% Paramètres du filtre spatial
filtre.gamma = 1 ; % Rapport entre le diamètre du filtre et le diamètre du lobe central en champ lointain
filtre.beta2 = 0.04 ; % Transmissivité périphérique en intensité
filtre.beta = sqrt(filtre.beta2) ; % Transmissivité périphérique en champ
filtre.dphi = pi/2 ; % Déphasage entre le plot central et la périphérie [rad]
filtre.plot = 'disque' ; % Type de plot déphasant : 'carre' ou 'disque'


%% Matrice de transfert (conversion phase intensité)
load('test.mat') ;
mt2 = mt ;
[ mt, diffrac ] = mt_cdp( reseau, filtre ) ;
% csvwrite('FTORe3.csv',real(mt))
% csvwrite('FTOIm3.csv',imag(mt))

% [ mt,diffrac ] = mt_cdp_reseauLineaire_plotFente( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCarre( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCarre_pos( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCirc( reseau, filtre ) ;


%% Paramètres de l'algorithme PIM
algo.n = reseau.n ; % Nombre d'émetteurs à cophaser
algo.nbMoy = 100 ; % Nombre de tirages à phases aléatoires à réaliser
algo.nbActionMax = 80 ; % Nombre d'actionnement maximal des modulateurs de phase
% load('matrice_meprep2.mat') ;
% mt = M ;
% mt = mt/abs(max(max(mt))) ;

algo.mt = mt ; % Matrice de transfert de la conversion phase-intensité
algo.mti = inv(mt) ; % Inverse de la matrice de transfert de la conversion phase-intensité
algo.xc = ones(algo.n,1) ;%  .*exp(1i*[0 0.1 0.2 ]') ; % Champ complexe cible
algo.yc = algo.mt*algo.xc ; % Champ complexe cible après filtrage
algo.gain = abs( 1 + 0*rand(algo.n,1) ) ;

% algo.mt = algo.mt.*exp(1i*[0 0.6 0.25]) ;
% algo.mt = algo.mt.*exp(1i*1*eye(algo.n)) ;


%%% Boucle PIM
%{
    Renvoie la qualité de cophasage au fil des actuations (colonnes) et au
    fil des tirages (lignes), ainsi que les phases du réseau (plan) au fil 
    des actuations (colonnes) et au fil des tirages (lignes)
%}
[ algo.Q, algo.phi ] = pim_loop( algo ) ;


%%% Graphiques
figure(1),clf,colormap viridis
    subplot(2,2,1)
        imagesc(abs(mt))
        colorbar,caxis([0 1]),axis square
        title('abs(mt)'),xlabel('N° émetteur'),ylabel('N° détecteur')
    subplot(2,2,3)
        imagesc(angle(mt))
        colorbar,caxis(pi*[-1 1]),axis square
        title('angle(mt)'),xlabel('N° émetteur'),ylabel('N° détecteur')
    subplot(2,2,[2 4])
        imagesc(diffrac)
        colorbar,caxis([0 1]),axis square
        title('diffraction'),xlabel('N° émetteur'),ylabel('N° détecteur')

figure(2),clf,hold on
    hd = plot(1:algo.nbActionMax,algo.Q,'Color','b') ;
    hs = errorfill(1:algo.nbActionMax,mean(algo.Q),std(algo.Q),'r',[0.2 0.7]) ;
    axis([0 algo.nbActionMax 0 1])
    box on,grid on
    title({['Qualité de cophasage'],['(statistiques calculées à partir de ' num2str(algo.nbMoy) ' tirages)']}),xlabel('N° actionnement'),ylabel('Q')
    legend([hd(1),hs.meanplot,hs.fillplot],'Un tirage','Moyenne','Ecart-type','Location','SouthEast')
    
figure(3),clf,hold on
    plot(1:algo.nbActionMax,squeeze(algo.phi(1,:,:))) ;
    axis([0 algo.nbActionMax -pi pi])
    box on,grid on
    title({['Evolution des phases du réseau pour un test']}),xlabel('N° actionnement'),ylabel('Phase [rad]')
      