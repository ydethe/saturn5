set terminal postscript landscape monochrome "Times-Roman" 14
set output 'speed.ps'
set noclip points
set clip one
set noclip two
set border
set dummy x,y
set format x "%g"
set format y "%g"
set format z "%g"
set grid
set key 
set nokey
set nolabel
set noarrow
set logscale 
set nologscale
set offsets 0, 0, 0, 0
set nopolar
set angles radians
set noparametric
set view 60, 30, 1, 1
set samples 100
set isosamples 10
set surface
set nocontour
set cntrparam order 4
set cntrparam linear
set cntrparam points 5
set size 1.0,1.0
set data style points
set function style lines
set tics in
set ticslevel .5
set xtics 
set ytics
set ztics
set title "Figure 1: Speed versus time for Saturn V" 0,0
set notime
set rrange [0 : 10]
set trange [-5 : 5]
set xlabel "Time (s)" 0,0
set xrange [0 : 800]
set ylabel "Speed (m/s)" 0,0
set yrange [0 : 7000]
set zlabel "" 0,0
set zrange [-10 : 10]
set autoscale r
set autoscale t
set autoscale xy
set autoscale z
set zero 1e-08
plot "speed.dat" with lines
