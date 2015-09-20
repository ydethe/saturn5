function m=masse()
    global env;
    global cu;
    m=0;
    for i=1:3
        etage=env.fusee.etages(i);
        m=m+etage.Me+etage.Ms;
    end
    m=m+env.fusee.coiffe_masse + cu;
    
end
