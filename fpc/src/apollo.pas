program apollo(input,output);
{Rocket simulation program written by Steven S. Pietrobon  6 Oct 1995.
 Revised 29 Dec 1997}

{$I earth.pas}
{$I const.pas}
{$I rocket.pas}
{$I stage1.pas}
{$I stage2.pas}
{$I stage3.pas}

begin{main}
  init;
  assign(speed,'speed.dat');
  rewrite(speed);
  assign(height,'height.dat');
  rewrite(height);
  continue := 'y';
  repeat
    stage1;
    stage2;
    stage3;
  until (continue <> 'y') and (continue <> 'Y');
  99:;
  close(speed);
  close(height);
  close(output);
end.{main}
