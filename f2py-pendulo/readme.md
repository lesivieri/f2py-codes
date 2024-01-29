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
 
   Diferentemente do FTLE, esse método calcula-se o quadrado da distância máxima de um ponto central em relação aos seus vizinhos. 
   
   A distância entre dois pontos em um espaço Euclidiano é a medida da magnitude do vetor que conecta esses dois pontos. No caso de dois pontos $(x_1,y_1)$ e $(x_2,y_2)$ em um plano 2D, a distância entre eles podem ser calculada usando a distância euclidina na forma: 
   $$\sqrt{ (x_2 - x_1)^2 + (y_2 - y_1)^2 }$$

   Em resumo o quadro da distância máxima é uma medida de dispersão dos pontos em um conjunto de dados em relação a um ponto central específico, podendo ser útil em análises estatísticas e de dados, sendo expressa na forma:
   $$\delta_{t_0}^{t_0 + T}(\mathbf{x}) = \frac{1}{T} log\left(max \frac{||\phi_{t_0}^{t_0+T}(\mathbf{x})-\phi_{t_0}^{t_0+T}(n_{j}(\mathbf{x}))||}{||\mathbf{x}-n_{j}(\mathbf{x})||}\right)$$
   
---
## Comentários
  * O tempo de execução do código para uma resolução de $512 \times 512$, utilizando tanto o método tradicional do FTLE como o cálculo do quadrado da distância máxima para o caso do pêndulo simples foi respectivamente _10 minutos 43 segundos_, e _10 minutos e 30 segundos_ para _15  unidades de tempo (u.t.)_, com passo de tempo de _0.02 u.t._
  * É perceptivel através da [figura 1] que o método utilizando o FTLE é relativamente melhor para encontrar LCS, porém a [figura 2] mostra como o método das Distâncias Máximas é uma excelente aproximação do FTLE.

[figura 1]: https://github.com/lesivieri/f2py-codes/blob/main/f2py-pendulo/pend_simples_2_512.png
[figura 2]: https://github.com/lesivieri/f2py-codes/blob/main/f2py-pendulo/pend_simples_512.png
