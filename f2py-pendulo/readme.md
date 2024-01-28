# Notas do Laboratório

Como mencionado anteriormente, o _F2Py_ é uma ferramenta valiosa para facilitar a integração de código Fortran com Python, trazendo diversas vantagens significativas. Uma dessas vantagens é a simplificação dos códigos principais, que é exatamente o que estou buscando. Em essência, isso significa que posso escrever um código principal em Python que faz uso de sub-rotinas escritas em Fortran para realizar cálculos matemáticos específicos.

Com isso em mente, estou iniciando o processo de reescrita e exploração dessa ferramenta usando como exemplo o pêndulo simples, cuja dinâmica é descrita pela equação diferencial $\ddot{x} = -\sin{(x)}$.

##  Pontos Principais
  * Os passos a seguir foram utilizados por linha de comando via terminal no linux.
  * O código principal é  _ftle_main.py_ .
  * A sub-rotina é  _rk4.f90_ .
    * ***Obs ::*** Caso a sua sub-rotina em Fortran necessite chamar outras sub-rotinas que se encontrem no mesmo arquivo, é necessário usar a função ```interface```, pois permite definir outras sub-rotinas ou funções, incluindo o tipo de dados dos argumentos que serão utilizados.
  * Para realizar a integração da sub-rotina em Fortran com o Python é necessário que ::
    * Primeiramente é necessário compilar a sub-rotina por meio do comando ```gfortran -c rk4.f90``` .
      * _gfortran_ - é o compilador Fortran GNU.
      * _-c_ - instrui o compilador a gerar o código objeto ( _.o_ ).
    * Em seguida crie o modulo por meio do código ```f2py -c rk4.f90 -m rk4library``` que será importado no código principal.
      * _f2py_ - é o comando principal da ferramenta responsável por gerar interfaces python para funções e sub-rotinas escritas em Fortran.
      *  _-c file.f90_ - especifica o arquivo em Fortran que será usado para gerar a interface Python.
      *  _-m filename_ - define o nome do módulo em Python que será criado.
      *  _--verbose_ - instrui o _f2py_ a fornecer informações detalhadas sobre o processo de geração de interface.
      *  _--opt='o2'_ - define as opções de otimização para o compilador, neste caso _o2_ indica que deve aplicar otimizações de nível 2 para melhorar o desempenho do código gerado. 
    * Certifique-se de que no código principal foi importado corretamente o módulo que acabou de criar ::
      * No início do código ::
        ```python
        import rk4library
        print(rk4library.__doc__)
        ```
      * E quando for utilizar a sub-rotina ::
        ```python
        rk4library.rk4(...)
        ```
---
## Métodos Matemáticos
### Runge-Kutta de 4º Ordem - RK4
### Expoente de Lyapunov de Tempo Finito - FTLE ( _Finite Time Lyapunov Exponent_ )
### Cálculo do Quadrado da Distância Máxima
---
## Comentários
  * O tempo de execução do código para uma resolução de $512 \times 512$, utilizando tanto o método tradicional do FTLE como o cálculo do quadrado da distância máxima para o caso do pêndulo simples foi respectivamente _10 minutos 43 segundos_, e _10 minutos e 30 segundos_ para _15  unidades de tempo (u.t.)_, com passo de tempo de _0.02 u.t._
