function TraceSol(lati, longi)
    worldmap world;
    load coast;
    hold on;
    % Dessin des cotes
    plotm(lat, long);
    % Dessin du tableau de latitudes et longitudes passés en argument
    plotm(lati,longi,'r-');
    hold off;
end
