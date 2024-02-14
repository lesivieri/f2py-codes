      SUBROUTINE rkf78(NX,X,T,TOUT,RELERR,ABSERR,IFLAG,WORK,DT)
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ! É NECESSÁRIO INFORMAR AQUI E NO CÓDIGO PRINCIPAL A QUANTIDADE DE EQUAÇÕES NO VALOR NEQN, BEM COMO O TAMANHO DO VETOR X, WORK, RELERR, ABSERR, DXDY
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      !INTEGER :: NEQN = 2
      INTEGER, INTENT(IN) :: NX
      INTEGER :: NEQN = 2
      INTEGER, INTENT(INOUT) :: IFLAG
      INTEGER :: NEQ, BOBO
      REAL(8), DIMENSION(2), INTENT(INOUT) :: X
      REAL(8), DIMENSION(2*14), INTENT(INOUT) :: WORK
      REAL(8), DIMENSION(2), INTENT(IN) :: RELERR, ABSERR
      REAL(8), DIMENSION(2) :: DXDY

      REAL(8), INTENT(INOUT) :: T, DT
      REAL(8), INTENT(IN) :: TOUT
      REAL(8) :: A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
      REAL(8) :: A12,B10,B20,B21,B30,B31,B32,B40,B41,B42
      REAL(8) :: B43,B50,B51,B52,B53,B54,B60,B61,B62,B63
      REAL(8) :: B64,B65,B70,B71,B72,B73,B74,B75,B76,B80
      REAL(8) :: B81,B82,B83,B84,B85,B86,B87,B90,B91,B92
      REAL(8) :: B93,B94,B95,B96,B97,B98,B100,B101,B102
      REAL(8) :: B103,B104,B105,B106,B107,B108,B109,B110
      REAL(8) :: B111,B112,B113,B114,B115,B116,B117,B118
      REAL(8) :: B119,B1110,B120,B121,B122,B123,B124
      REAL(8) :: B125,B126,B127,B128,B129,B1210,B1211
      REAL(8) :: CH0,CH1,CH2,CH3,CH4,CH5,CH6,CH7,CH8,CH9
      REAL(8) :: CH10,CH11,CH12,E0,E1,E2,E3,E4,E5,E6,E7
      REAL(8) :: E8,E9,E10,E11,E12,B,BLO,BUP,REMIN,DTINC
      REAL(8) :: DTDEC,MAXREJ
      REAL(8) :: T0, RTE
      INTEGER :: N,N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11
      INTEGER :: N12,N13
      REAL(8) :: D0, D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12
      REAL(8) :: NREJ,NSTP,DTOLD,RER,SCALE,TE,XMAG,PCT,ZZZUTV,NREJT,DELT

      LOGICAL DTFAIL,DTFIX

      INTERFACE TESTE
            SUBROUTINE derivs(time, xi, xf)
                  REAL(8), DIMENSION(2), INTENT(IN) :: xi
                  REAL(8), DIMENSION(2), INTENT(OUT) :: xf
                  REAL(8), INTENT(IN) :: time
            END SUBROUTINE derivs
      END INTERFACE TESTE
      
      IF (IFLAG.NE.1) GO TO 5
      
      MAXREJ = 10
      DTINC = 20.D0
      DTDEC = 0.025D0
      REMIN = 3.0D-15
      B = 0.85D0
            
      A0 = 0.D0
      A1 = 2.D0/27.D0
      A2 = 1.D0/9.D0
      A3 = 1.D0/6.D0
      A4 = 5.D0/12.D0
      A5 = 1.D0/2.D0
      A6 = 5.D0/6.D0
      A7 = 1.D0/6.D0
      A8 = 2.D0/3.D0
      A9 = 1.D0/3.D0
      A10 = 1.D0
      A11 = 0.D0
      A12 = 1.D0
            
      B10 = 2.D0/27.D0
      B20 = 1.D0/36.D0
      B21 = 1.D0/12.D0
      B30 = 1.D0/24.D0
      B31 = 0.D0
      B32 = 1.D0/8.D0
      B40 = 5.D0/12.D0
      B41 = 0.D0
      B42 = -25.D0/16.D0
      B43 = 25.D0/16.D0
      B50 = 1.D0/20.D0
      B51 = 0.D0
      B52 = 0.D0
      B53 = 1.D0/4.D0
      B54 = 1.D0/5.D0
      B60 = -25.D0/108.D0
      B61 = 0.D0
      B62 = 0.D0
      B63 = 125.D0/108.D0
      B64 = -65.D0/27.D0
      B65 = 125.D0/54.D0
      B70 = 31.D0/300.D0
      B71 = 0.D0
      B72 = 0.D0
      B73 = 0.D0
      B74 = 61.D0/225.D0
      B75 = -2.D0/9.D0
      B76 = 13.D0/900.D0
      B80 = 2.D0
      B81 = 0.D0
      B82 = 0.D0
      B83 = -53.D0/6.D0
      B84 = 704.D0/45.D0
      B85 = -107.D0/9.D0
      B86 = 67.D0/90.D0
      B87 = 3.D0
      B90 = -91.D0/108.D0
      B91 = 0.D0
      B92 = 0.D0
      B93 = 23.D0/108.D0
      B94 = -976.D0/135.D0
      B95 = 311.D0/54.D0
      B96 = -19.D0/60.D0
      B97 = 17.D0/6.D0
      B98 = -1.D0/12.D0
      B100 = 2383.D0/4100.D0
      B101 = 0.D0
      B102 = 0.D0
      B103 = -341.D0/164.D0
      B104 = 4496.D0/1025.D0
      B105 = -301.D0/82.D0
      B106 = 2133.D0/4100.D0
      B107 = 45.D0/82.D0
      B108 = 45.D0/164.D0
      B109 = 18.D0/41.D0
      B110 = 3.D0/205.D0
      B111 = 0.D0
      B112 = 0.D0
      B113 = 0.D0
      B114 = 0.D0
      B115 = -6.D0/41.D0
      B116 = -3.D0/205.D0
      B117 = -3.D0/41.D0
      B118 = 3.D0/41.D0
      B119 = 6.D0/41.D0
      B1110 = 0.D0
      B120 = -1777.D0/4100.D0
      B121 = 0.D0
      B122 = 0.D00
      B123 = -341.D0/164.D0
      B124 = 4496.D0/1025.D0
      B125 = -289.D0/82.D0
      B126 = 2193.D0/4100.D0
      B127 = 51.D0/82.D0
      B128 = 33.D0/164.D0
      B129 = 12.D0/41.D0
      B1210 = 0.D0
      B1211 = 1.D0
            
      CH0 = 0.D0
      CH1 = 0.D0
      CH2 = 0.D0
      CH3 = 0.D0
      CH4 = 0.D0
      CH5 = 34.D0/105.D0
      CH6 = 9.D0/35.D0
      CH7 = 9.D0/35.D0
      CH8 = 9.D0/280.D0
      CH9 = 9.D0/280.D0
      CH10 = 0.D0
      CH11 = 41.D0/840.D0
      CH12 = 41.D0/840.D0
            
      E0 = 41.D0/840.D0
      E1 = 0.D0
      E2 = 0.D0
      E3 = 0.D0
      E4 = 0.D0
      E5 = 0.D0
      E6 = 0.D0
      E7 = 0.D0
      E8 = 0.D0
      E9 = 0.D0
      E10 = 41.D0/840.D0
      E11 = -41.D0/840.D0
      E12 = -41.D0/840.D0
            
          
      BUP = (B/DTDEC)**8
      BLO = (B/DTINC)**8
         

      N = NEQN
      N1 = N
      N2 = 2*N
      N3 = 3*N
      N4 = 4*N
      N5 = 5*N
      N6 = 6*N
      N7 = 7*N
      N8 = 8*N
      N9 = 9*N
      N10 = 10*N
      N11 = 11*N
      N12 = 12*N
      N13 = 13*N
   5  NREJT = 0
      NSTP = 0
      
      DO NEQ = 1, NEQN
            DXDY(NEQ)=0.0
      END DO
      DTFIX = .FALSE.
      DO NEQ = 1,N
        IF(ABSERR(NEQ).EQ.0.0D0.AND.RELERR(NEQ).EQ.0.0D0)THEN
           DTFIX = .TRUE.
        END IF
      END DO
      DTOLD = DT
  20  DTFAIL = .FALSE.
      NREJ = 0
      DELT = TOUT-T
      IF (abs(DT).LT.abs(DELT)) GO TO 25
      DT = DELT
      GO TO 30
  25  IF (abs(DT+DT).LT.abs(DELT)) GO TO 30
      DT = DELT/2.D0
  30  IF(abs(DT).LT.1.D-15*abs(T)) GO TO 160
      T0 = T
      DO 35 NEQ = 1,N
        WORK(NEQ) = X(NEQ)
  35  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N1+NEQ) = DXDY(NEQ)
      END DO

  40  T = T0+A1*DT
      D0 = B10*DT
      DO 45 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+WORK(NEQ)
  45  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N2+NEQ) = DXDY(NEQ)
      END DO

      T = T0+A2*DT
      D0 = B20*DT
      D1 = B21*DT
      DO 50 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+WORK(NEQ)
  50  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N3+NEQ) = DXDY(NEQ)
      END DO
      T = T0+A3*DT
      D0 = B30*DT
      D1 = B31*DT
      D2 = B32*DT
      DO 55 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+WORK(NEQ)
  55  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N4+NEQ) = DXDY(NEQ)
      END DO

      T = T0+A4*DT
      D0 = B40*DT
      D1 = B41*DT
      D2 = B42*DT
      D3 = B43*DT
      DO 60 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+D3*WORK(N4+NEQ)+WORK(NEQ)
  60  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N5+NEQ) = DXDY(NEQ)
      ENDDO
      
      T = T0+A5*DT
      D0 = B50*DT
      D1 = B51*DT
      D2 = B52*DT
      D3 = B53*DT
      D4 = B54*DT
      DO 65 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+WORK(NEQ)
  65  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N6+NEQ) = DXDY(NEQ)
      END DO
      T = T0+A6*DT
      D0 = B60*DT
      D1 = B61*DT
      D2 = B62*DT
      D3 = B63*DT
      D4 = B64*DT
      D5 = B65*DT
      DO 70 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+ &
                & D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
                &  WORK(NEQ)
  70  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N7+NEQ) = DXDY(NEQ)
      END DO
      T = T0+A7*DT
      D0 = B70*DT
      D1 = B71*DT
      D2 = B72*DT
      D3 = B73*DT
      D4 = B74*DT
      D5 = B75*DT
      D6 = B76*DT
      DO 75 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+ &
               &  D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               &  D6*WORK(N7+NEQ)+WORK(NEQ)
  75  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N8+NEQ) = DXDY(NEQ)
      END DO
      T = T0+A8*DT
      D0 = B80*DT
      D1 = B81*DT
      D2 = B82*DT
      D3 = B83*DT
      D4 = B84*DT
      D5 = B85*DT
      D6 = B86*DT
      D7 = B87*DT
      DO 80 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+ &
               & D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               & D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+WORK(NEQ)
  80  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N9+NEQ) = DXDY(NEQ)
      END DO

      T = T0+A9*DT
      D0 = B90*DT
      D1 = B91*DT
      D2 = B92*DT
      D3 = B93*DT
      D4 = B94*DT
      D5 = B95*DT
      D6 = B96*DT
      D7 = B97*DT
      D8 = B98*DT
      DO 85 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+ &
               & D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               & D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+D8*WORK(N9+NEQ)+ &
               & WORK(NEQ)
  85  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N10+NEQ) = DXDY(NEQ)
      END DO
      T = T0+A10*DT
      D0 = B100*DT
      D1 = B101*DT
      D2 = B102*DT
      D3 = B103*DT
      D4 = B104*DT
      D5 = B105*DT
      D6 = B106*DT
      D7 = B107*DT
      D8 = B108*DT
      D9 = B109*DT
      DO 90 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+  &
               &  D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               &  D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+D8*WORK(N9+NEQ)+ &
               &  D9*WORK(N10+NEQ)+WORK(NEQ)
  90  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N11+NEQ) = DXDY(NEQ)
      END DO

      T = T0+A11*DT
      D0 = B110*DT
      D1 = B111*DT
      D2 = B112*DT
      D3 = B113*DT
      D4 = B114*DT
      D5 = B115*DT
      D6 = B116*DT
      D7 = B117*DT
      D8 = B118*DT
      D9 = B119*DT
      D10 = B1110*DT
      DO 95 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+  &
               &  D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               &  D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+D8*WORK(N9+NEQ)+ &
               &  D9*WORK(N10+NEQ)+D10*WORK(N11+NEQ)+WORK(NEQ)
  95  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N12+NEQ) = DXDY(NEQ)
      END DO
      
      T = T0+A12*DT
      D0 = B120*DT
      D1 = B121*DT
      D2 = B122*DT
      D3 = B123*DT
      D4 = B124*DT
      D5 = B125*DT
      D6 = B126*DT
      D7 = B127*DT
      D8 = B128*DT
      D9 = B129*DT
      D10 = B1210*DT
      D11 = B1211*DT
      DO 100 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+  &
               &  D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               &  D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+D8*WORK(N9+NEQ)+ &
               &  D9*WORK(N10+NEQ)+D10*WORK(N11+NEQ)+D11*WORK(N12+NEQ)+ &
               &  WORK(NEQ)
 100  CONTINUE
      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N13+NEQ) = DXDY(NEQ)
      END DO
      
      D0 = CH0*DT
      D1 = CH1*DT
      D2 = CH2*DT
      D3 = CH3*DT
      D4 = CH4*DT
      D5 = CH5*DT
      D6 = CH6*DT
      D7 = CH7*DT
      D8 = CH8*DT
      D9 = CH9*DT
      D10 = CH10*DT
      D11 = CH11*DT
      D12 = CH12*DT
      DO 105 NEQ = 1,N
        X(NEQ) = D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+ &
               &  D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
               &  D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+D8*WORK(N9+NEQ)+ &
               &  D9*WORK(N10+NEQ)+D10*WORK(N11+NEQ)+D11*WORK(N12+NEQ)+ &
               &  D12*WORK(N13+NEQ)+WORK(NEQ)
 105  CONTINUE

      IF (DTFIX) GO TO 140

      RTE = 0.D0
      D0 = E0*DT
      D1 = E1*DT
      D2 = E2*DT
      D3 = E3*DT
      D4 = E4*DT
      D5 = E5*DT
      D6 = E6*DT
      D7 = E7*DT
      D8 = E8*DT
      D9 = E9*DT
      D10 = E10*DT
      D11 = E11*DT
      D12 = E12*DT
      DO 110 NEQ = 1,N
        RER = DMAX1(RELERR(NEQ),1.D-16+REMIN)
        SCALE = RER/2.D0
        TE = abs(D0*WORK(N1+NEQ)+D1*WORK(N2+NEQ)+D2*WORK(N3+NEQ)+ &
           &  D3*WORK(N4+NEQ)+D4*WORK(N5+NEQ)+D5*WORK(N6+NEQ)+ &
           &  D6*WORK(N7+NEQ)+D7*WORK(N8+NEQ)+D8*WORK(N9+NEQ)+ &
           &  D9*WORK(N10+NEQ)+D10*WORK(N11+NEQ)+D11*WORK(N12+NEQ)+ &
           &  D12*WORK(N13+NEQ))
        XMAG = (abs(X(NEQ))+abs(WORK(NEQ)))*SCALE+ABSERR(NEQ)+1.0D-15
        RTE = DMAX1(RTE,TE/XMAG)
 110  CONTINUE
      IF(RTE.LT.1.D0) GO TO 140

      DTFAIL = .TRUE.
      NREJ = NREJ+1
      NREJT = NREJT+1
      IF (NREJ.LT.MAXREJ) GO TO 130
      DO 120 NEQ = 1,N
        X(NEQ) = WORK(NEQ)
 120  CONTINUE
      T = T0
      IFLAG = 7
      RETURN
 130  PCT = DTDEC
      IF (RTE.LT.BUP)THEN
        ZZZUTV = .125D0
        PCT = B/RTE**ZZZUTV
      ENDIF
      DT = PCT*DT
      DTOLD = DT
      GO TO 40


 140  T = T0+DT
      NSTP = NSTP+1
      IF (abs(TOUT-T).GT.1.0D-15) GO TO 150
      DT = DTOLD
      IFLAG = 2
      RETURN
 150  IF (DTFIX) GO TO 20
      PCT = DTINC
      IF (RTE.GT.BLO)THEN
        ZZZUTV = .125D0
        PCT = B/RTE**ZZZUTV
      ENDIF
      IF (DTFAIL) THEN
        ZZZUTV = 1.D0
        PCT = DMIN1(PCT,ZZZUTV)
      ENDIF
      DT = DT*PCT
      DTOLD = DT
      GO TO 20

 160  IF (abs(DELT).GT.abs(DT)) GO TO 180

      CALL derivs(T,X,DXDY)
      DO NEQ = 1,N
            WORK(N1+NEQ) = DXDY(NEQ)
      ENDDO
      DO 170 NEQ = 1,N
         X(NEQ) = DT*WORK(N1+NEQ)+X(NEQ)
 170  CONTINUE
      T = T+DT
      DT = DTOLD
      IFLAG = 2
      RETURN
 180  IFLAG = 8
      RETURN

      END SUBROUTINE rkf78

      SUBROUTINE derivs(time, xi, xf)
            REAL(8), DIMENSION(2), INTENT(IN) :: xi
            REAL(8), DIMENSION(2), INTENT(OUT) :: xf
            REAL(8), INTENT(IN) :: time
            
            !xf(1) = xi(2)
            !xf(2) = -SIN(xi(1))

            xf(1) = (xi(2))
            xf(2) = ((2.5d0*cos(5.0d0*time)-1.0d0)*sin(xi(1)))

            RETURN
      END SUBROUTINE derivs
