! repere.f90

integer*4 function RL0_to_RD0(xL0, az, xD0)
    real*8, intent(in) :: az
    real*8, intent(in) :: xL0(3)
    real*8, intent(out) :: xD0(3)

    real*8 :: x, y, z

    x=xL0(1)
    y=xL0(2)
    z=xL0(3)
      
    xD0(1) = sin(az)*y-cos(az)*z
    xD0(2) = cos(az)*y+sin(az)*z
    xD0(3) = x

    RL0_to_RD0=0
    
end

integer*4 function RL_to_RL0(xL0, theta, xRL0)
    ! Le parametre theta est la commande
    real*8, intent(in) :: theta
    real*8, intent(in) :: xL0(3)
    real*8, intent(out) :: xRL0(3)

    real*8 :: x, y, z

    x=xL0(1)
    y=xL0(2)
    z=xL0(3)

    xRL0(1)=cos(theta)*x - sin(theta)*y
    xRL0(2)=sin(theta)*x + cos(theta)*y
    xRL0(3)=z
    
    RL_to_RL0=0

end

integer*4 function RD0_to_REQ(xD0, xEQ)
    real*8, intent(in) :: xD0(3)
    real*8, intent(out) :: xEQ(3)

    real*8 : x, y, z
    
    x=xD0(1)
    y=xD0(2)
    z=xD0(3)
    
    lambda = env.pdt.longitude
    phig0  = env.pdt.latitude
    
    xEQ(1)=-sin(lambda)*x-cos(lambda)*sin(phig0)*y+cos(lambda)*cos(phig0)*z
    xEQ(2)=cos(lambda)*x-sin(lambda)*sin(phig0)*y+sin(lambda)*cos(phig0)*z
    xEQ(3)=cos(phig0)*y+sin(phig0)*z
    
    RD0_to_REQ=0
    
end

! gfortran -ffree-form -fimplicit-none -ffixed-line-length-none -Wall -Warray-bounds -Wunused-parameter -fbounds-check -c
