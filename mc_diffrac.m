function [ diffrac ] = mc_diffrac( reseau, filtre )

    posdiffr = nan(reseau.n) ;
    for i=1:reseau.n
        for j=1:reseau.n
            posdiffr(i,j) = sqrt((reseau.pos.x(i)-reseau.pos.x(j))^2+(reseau.pos.y(i)-reseau.pos.y(j))^2) ;
        end
    end
    
    diffrac = nan(reseau.n) ;
    switch lower(filtre.plot)
        case 'fente'
            for i=1:reseau.n
                for j=1:reseau.n
                    if i==j
                        diffrac(i,j) = 1 ;
                    else
                        diffrac(i,j) = abs( ...
                                            sin(2*filtre.gamma*pi*posdiffr(i,j)/reseau.n) ...
                                            ./(2*filtre.gamma*pi*posdiffr(i,j)/reseau.n) ...
                                          ) ;
                    end
                end
            end
        
        case 'carre'
            for i=1:reseau.n
                for j=1:reseau.n
                    if i==j
                        diffrac(i,j) = 1 ;
                    else
                        diffrac(i,j) = abs( ...
                                            sin(2*filtre.gamma*pi*posdiffr(i,j)/reseau.nd) ...
                                            ./(2*filtre.gamma*pi*posdiffr(i,j)/reseau.nd) ...
                                          ) ;
                    end
                end
            end
            
            
        case 'disque'
            for i=1:reseau.n
                for j=1:reseau.n
                    if i==j
                        diffrac(i,j) = 1 ;
                    else
                        diffrac(i,j) = abs( ...
                                            besselj(1,2*filtre.gamma*pi*posdiffr(i,j)/reseau.nd) ...
                                            ./(2*filtre.gamma*pi*posdiffr(i,j)/reseau.nd) ...
                                          ) ;
                    end
                end
            end

        otherwise
            error('Type de plot déphasant non existant ou non implémenté')
    end
            
    

end

