# Cophasage d'un réseau de lasers en utilisant la méthode PIM

Le fichier principal est le script `pim.m`.

Ce script permet de calculer la matrice de transfert d'un filtre à contraste de phase pour :
	* Un réseau de faisceaux en arrangement linéaire, et un filtre à fente déphasante
	* Un réseau de faisceaux en arrangement carré, et un filtre à plot déphasant de forme carré ou disque
	* Un réseau de faisceaux en arrangement hexagonal, et un fitlre à plot déphasant de forme carré ou disque

Les paramètres variables sont :
	* Le nombre total `n` de faisceaux du réseau :
		* Quelconque pour un arrangement linéaire.
		* Pour un arrangement carré, `n` doit respecter l'équation suivante `mod(sqrt(n),1)==0`.
		* Pour un arrangement hexagonal, `n` doit respecter l'équation suivante `mod(nc,1)==0` avec `nc = (-3+sqrt(9-12*(1-)))/6`. `nc` est en fait le nombre de couronnes du réseau hexagonal.
	* Le taux de remplissage `eta` du réseau.
	* La longueur d'onde `lambda` des rayonnements.
	* Le type de `maille` du réseau : `lineaire`,`carree`, ou `hexagonale`.
	* Le rapport `gamma` entre le diamètre plot déphasant du filtre et le diamètre du lobe central du champ loitain cophésé du réseau.
	* La transmissivité périphérique en intensité `beta2` du filtre.
	* Le déphasage `dphi` entre le plot central et la périphérie du filtre.
	* Le type de plot déphasant : `fente`,`carre`, ou `disque`.

L'algorithme PIM, développé et présenté dans la [thèse de David Kabeya](https://www.theses.fr/197605575), est ensuite lancé. Les paramètres accessibles sont :
	* Le nombre d'essais à phases initiales aléatoires `nbMoy`.
	* Le nombre maximal d'actionnements des modulateurs de phase optique, ou encore le nombre maximal d'itérations de la boucle opto-numérique, noté `nbActionMax`.
	* Le vecteur cible du réseau `xc = ones(algo.n,1)`.
	* Le `gain` de la boucle opto-numérique.
Les sorties de la boucle de mise en phase sont :
	* La qualité de cophasage `Q = (abs(sum(x.*conj(xc)))/sum(abs(x.*conj(xc))))^2` au fil des itérations opto-numériques et des essais.
	* Les phases `phi` du réseau d'émetteurs au fil des itérations numériques et des essais.

Les données tracées sur les figures sont les suivantes :
	1. Le module, la phase, et la partie de couplage diffractif de la matrice de transfert du filtre à contraste de phase.
	2. La qualité de cophasage au fil des itérations opto-numériques et des essais.
	3. L'évolution des phases du réseau de lasers au fil des itérations opto-numériques pour un essai donné.

Si besoin, contacter 
