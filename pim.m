%{
    Cophasage d'un réseau de lasers par la méthode PIM.

    Jérémy Saucourt, le 04/09/2019
%}
clear all ;
rng('shuffle') ;


%% Paramètres du réseau
reseau.n = 16 ; % Nombre de faisceaux
reseau.p = 500e-6 ; % Entraxe des faisceaux [m]
reseau.w0 = 200e-6 ; % Demi-largeur des faisceaux à 1/e² en intensité [m]
reseau.eta = 2*reseau.w0/reseau.p ; % Taux de remplissage du réseau
reseau.lambda = 980e-9 ; % Longueur d'onde du rayonnement [m]


%% Paramètres du filtre spatial
filtre.gamma = 0.5 ; % Rapport entre le diamètre du filtre et le diamètre du lobe central en champ lointain
filtre.beta2 = 0.04 ; % Transmissivité périphérique en intensité
filtre.beta = sqrt(filtre.beta2) ; % Transmissivité périphérique en champ
filtre.dphi = pi/2 ; % Déphasage entre le plot central et la périphérie [rad]


%% Matrice de couplage diffractif
% [ mt,diffrac ] = mt_cdp_reseauLineaire_plotFente( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCarre( reseau, filtre ) ;
[mt,diffrac] = mt_cdp_reseauCarre_plotCirc( reseau, filtre ) ;

%% Paramètres de l'algorithme PIM
algo.n = reseau.n ;
algo.nbMoy = 100 ;
algo.nbActionMax = 30 ; % Nombre d'actionnement maximal des modulateurs de phase
algo.xc = ones(algo.n,1) ; % Champ complexe cible
algo.mt = mt ;
algo.mti = inv(mt) ;
algo.yc = algo.mt*algo.xc ;


%% Boucle PIM
[ algo.Q, algo.phi ] = pim_loop( algo ) ;




%% Graphiques
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
    legend([hd(1),hs.meanplot,hs.fillplot],'Un essai','Moyenne','Ecart-type','Location','SouthEast')
    
    