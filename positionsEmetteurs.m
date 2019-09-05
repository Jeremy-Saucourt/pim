function [ pos, nd ] = positionsEmetteurs( reseau )
    switch lower(reseau.maille)
        case 'lineaire'
            [ pos, nd ] = positionsMailleLineaire( reseau ) ;
        case 'carree'
            [ pos, nd ] = positionsMailleCarree( reseau ) ;
        case 'hexagonale'
            [ pos, nd ] = positionsMailleHexagonale( reseau ) ;
        otherwise
            error('Type de réseau non existant ou non implémenté')
    end
end

