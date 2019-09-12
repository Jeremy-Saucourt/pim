%{
    Cophasage d'un r�seau de lasers par la m�thode PIM.

    J�r�my Saucourt, le 04/09/2019
%}
clear all ;
rng('shuffle') ;


%% Param�tres du r�seau
reseau.n = 7 ; % Nombre de faisceaux
reseau.p = 500e-6 ; % Entraxe des faisceaux [m]
reseau.w0 = 60e-6 ; % Demi-largeur des faisceaux � 1/e� en intensit� [m]
reseau.eta = 2*reseau.w0/reseau.p ; % Taux de remplissage du r�seau
reseau.lambda = 980e-9 ; % Longueur d'onde du rayonnement [m]
reseau.maille = 'lineaire' ; % Type de maille ('lineaire','carree' ou 'hexagonale')
[ reseau.pos, reseau.nd ] = positionsEmetteurs( reseau ) ;


%% Param�tres du filtre spatial
filtre.gamma = 1 ; % Rapport entre le diam�tre du filtre et le diam�tre du lobe central en champ lointain
filtre.beta2 = 0.04 ; % Transmissivit� p�riph�rique en intensit�
filtre.beta = sqrt(filtre.beta2) ; % Transmissivit� p�riph�rique en champ
filtre.dphi = pi/2 ; % D�phasage entre le plot central et la p�riph�rie [rad]
filtre.plot = 'disque' ; % Type de plot d�phasant : 'carre' ou 'disque'


%% Matrice de transfert (conversion phase intensit�)
load('test.mat') ;
mt2 = mt ;
[ mt, diffrac ] = mt_cdp( reseau, filtre ) ;
% csvwrite('FTORe3.csv',real(mt))
% csvwrite('FTOIm3.csv',imag(mt))

% [ mt,diffrac ] = mt_cdp_reseauLineaire_plotFente( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCarre( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCarre_pos( reseau, filtre ) ;
% [ mt,diffrac ] = mt_cdp_reseauCarre_plotCirc( reseau, filtre ) ;


%% Param�tres de l'algorithme PIM
algo.n = reseau.n ; % Nombre d'�metteurs � cophaser
algo.nbMoy = 100 ; % Nombre de tirages � phases al�atoires � r�aliser
algo.nbActionMax = 80 ; % Nombre d'actionnement maximal des modulateurs de phase
% load('matrice_meprep2.mat') ;
% mt = M ;
% mt = mt/abs(max(max(mt))) ;

algo.mt = mt ; % Matrice de transfert de la conversion phase-intensit�
algo.mti = inv(mt) ; % Inverse de la matrice de transfert de la conversion phase-intensit�
algo.xc = ones(algo.n,1) ;%  .*exp(1i*[0 0.1 0.2 ]') ; % Champ complexe cible
algo.yc = algo.mt*algo.xc ; % Champ complexe cible apr�s filtrage
algo.gain = abs( 1 + 0*rand(algo.n,1) ) ;

% algo.mt = algo.mt.*exp(1i*[0 0.6 0.25]) ;
% algo.mt = algo.mt.*exp(1i*1*eye(algo.n)) ;


%%% Boucle PIM
%{
    Renvoie la qualit� de cophasage au fil des actuations (colonnes) et au
    fil des tirages (lignes), ainsi que les phases du r�seau (plan) au fil 
    des actuations (colonnes) et au fil des tirages (lignes)
%}
[ algo.Q, algo.phi ] = pim_loop( algo ) ;


%%% Graphiques
figure(1),clf,colormap viridis
    subplot(2,2,1)
        imagesc(abs(mt))
        colorbar,caxis([0 1]),axis square
        title('abs(mt)'),xlabel('N� �metteur'),ylabel('N� d�tecteur')
    subplot(2,2,3)
        imagesc(angle(mt))
        colorbar,caxis(pi*[-1 1]),axis square
        title('angle(mt)'),xlabel('N� �metteur'),ylabel('N� d�tecteur')
    subplot(2,2,[2 4])
        imagesc(diffrac)
        colorbar,caxis([0 1]),axis square
        title('diffraction'),xlabel('N� �metteur'),ylabel('N� d�tecteur')

figure(2),clf,hold on
    hd = plot(1:algo.nbActionMax,algo.Q,'Color','b') ;
    hs = errorfill(1:algo.nbActionMax,mean(algo.Q),std(algo.Q),'r',[0.2 0.7]) ;
    axis([0 algo.nbActionMax 0 1])
    box on,grid on
    title({['Qualit� de cophasage'],['(statistiques calcul�es � partir de ' num2str(algo.nbMoy) ' tirages)']}),xlabel('N� actionnement'),ylabel('Q')
    legend([hd(1),hs.meanplot,hs.fillplot],'Un tirage','Moyenne','Ecart-type','Location','SouthEast')
    
figure(3),clf,hold on
    plot(1:algo.nbActionMax,squeeze(algo.phi(1,:,:))) ;
    axis([0 algo.nbActionMax -pi pi])
    box on,grid on
    title({['Evolution des phases du r�seau pour un test']}),xlabel('N� actionnement'),ylabel('Phase [rad]')
      