function y=CA(M)
    CAt=[
    0.3
    0.26
    0.4
    0.55
    0.35
    0.23
    0.2
    0.26
    ];
    Mt=[
    0
    0.5
    1
    1.4
    2.5
    3.5
    5
    8.5
    ];
    if M > 8.5
        y = CAt(end);
    else
        y=interp1(Mt,CAt,M);
    end
end