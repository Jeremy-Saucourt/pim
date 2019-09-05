function [ Q, phi ] = pim_loop( algo )

    Q = nan(algo.nbMoy,algo.nbActionMax) ;
    phi = nan(algo.nbMoy,algo.nbActionMax,algo.n) ;

    for m=1:algo.nbMoy
        for k=1:algo.nbActionMax
            if k==1
                champk = abs(algo.xc).*exp(1i*2*pi*rand(algo.n,1)) ;
        %         champk = abs(algo.xc).*exp(1i*angle(algo.xc)) ; % Test de stabilité
            end
            phi(m,k,:) = angle(champk) ;
            Q(m,k) = abs(sum(champk.*conj(algo.xc))).^2 / sum(abs(champk.*conj(algo.xc))).^2 ;

            b = abs(algo.mt*champk).*exp(1i*angle(algo.yc)) ;
            corr = angle(algo.mti*b) ;

            champk = champk.*exp(-1i*corr).*exp(1i*angle(algo.xc)) ;
        end
    end
end

