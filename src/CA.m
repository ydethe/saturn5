function y=CA(M)
    CAt=[0.294728289
    0.315839195
    0.346812023
    0.389810831
    0.461330129
    0.504966738
    0.54863645
    0.588650146
    0.624985958
    0.662643487
    0.681263741
    0.700164301
    0.717806308
    0.735748457
    0.753481845
    0.767426522
    0.721221158
    0.680373401
    0.648657535
    0.622556101
    0.602847012
    0.584026567
    0.569920301
    0.555547977
    0.544357909
    0.536751636
    0.529453616
    0.522619277
    0.516794239
    0.51109835
    0.504702382
    0.499881229
    0.495730802
    0.490184137
    ];
    Mt=[0.5
    0.6
    0.7
    0.8
    0.9
    0.92
    0.94
    0.96
    0.98
    1
    1.02
    1.04
    1.06
    1.08
    1.1
    1.3
    1.5
    1.7
    1.9
    2.1
    2.3
    2.5
    2.7
    2.9
    3.1
    3.3
    3.5
    3.7
    3.9
    4.1
    4.3
    4.5
    4.7
    4.9];
    if M > 4.9
        y = 0;
    elseif  M < 0.5
        y = CAt(1);
    else
        y=interp1(Mt,CAt,M);
    end
end