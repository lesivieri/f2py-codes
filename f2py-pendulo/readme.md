# Notas do Laboratório

Como mencionado anteriormente, o _F2Py_ é uma ferramenta valiosa para facilitar a integração de código Fortran com Python, trazendo diversas vantagens significativas. Uma dessas vantagens é a simplificação dos códigos principais, que é exatamente o que estou buscando. Em essência, isso significa que posso escrever um código principal em Python que faz uso de sub-rotinas escritas em Fortran para realizar cálculos matemáticos específicos.

Com isso em mente, estou iniciando o processo de reescrita e exploração dessa ferramenta usando como exemplo o pêndulo simples, cuja dinâmica é descrita pela equação diferencial $\ddot{x} = -\sin{(x)}$.

  Pontos Principais ::
  * O código principal é  _ftle_main.py_
  * A sub-rotina é  _rk4.f90_
  * Para realizar a integração da sub-rotina em Fortran com o Python é necessário que ::
    * **OBS** _os passos a seguir foram utilizados por linha de comando via terminal no linux_
    * primeiramente é necessário compilar a sub-rotina por meio do _gfortran -c rk4.f90_
    * 
