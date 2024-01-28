! Subroutine for the fourth-order Runge-Kutta method

SUBROUTINE rk4(t, h, y)
    REAL(8), INTENT(INOUT) :: t, h, y(2)
    REAL(8) :: k1(2), k2(2), k3(2), k4(2), fR(2), ydumb(2)
    REAL(8) :: hh, h6, th

    INTERFACE TESTE
        SUBROUTINE derivs(t, xi, xf)
            REAL(8), INTENT(IN) :: t, xi(2)
            REAL(8), INTENT(OUT) :: xf(2)
        END SUBROUTINE derivs
    END INTERFACE TESTE

!   FIRTS TEST RK4 METHOD
!    CALL derivs(t, y, k1)  ! k1 = derivs(t, y)
!    ydumb = y + k1 / 2.0d0
!    CALL derivs(t + h / 2.0d0, ydumb, k2)  ! k2 = derivs(t + h / 2.0d0, y + k1 / 2.0d0)
!    ydumb = y + k2 / 2.0d0
!    CALL derivs(t + h / 2.0d0, ydumb, k3)  ! k3 = derivs(t + h / 2.0d0, y + k2 / 2.0d0)
!    ydumb = y + k3
!    CALL derivs(t + h, ydumb, k4)  ! k4 = derivs(t + h, y + k3)
!    y = y + (k1 + 2.0d0 * (k2 + k3) + k4) * h / 6.0d0

!   NUMERICAL RECIPES FORTRAN 90
    hh = h*0.5
    h6 = h/6.0
    th = t + hh
    CALL derivs(t, y, k1)
    ydumb = y + hh*k1 ! first step
    CALL derivs(th,ydumb,k2) ! second step
    ydumb = y + hh*k2
    CALL derivs(th,ydumb,k3) ! third step
    ydumb = y + h*k3
    k3 = k3 + k2
    CALL derivs(t+h,ydumb,k4) ! fourth step
    ydumb = y + h6*(k1+k4+2*k3)
    y = ydumb

END SUBROUTINE rk4



SUBROUTINE derivs(t, xi, xf)
    REAL(8), INTENT(IN) :: t, xi(2)
    REAL(8), INTENT(OUT) :: xf(2)
    REAL(8) :: a
    INTEGER :: signal

    signal = 1
   
    xf(1) = xi(2)
    xf(2) = -sin(xi(1))

!    xf(1) = (xi(2))*signal
!    xf(2) = ((2.5d0*cos(5.0d0*t)-1.0d0)*sin(xi(1)))*signal

    RETURN
END SUBROUTINE derivs
