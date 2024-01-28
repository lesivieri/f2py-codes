#import fortran
import numpy as np
import math
from scipy.linalg import eigvals
#import fortran
#import librarykf78
#import rk4
#import fortranlibrary
#print(fortranlibrary.__doc__)
import rk4library
print(rk4library.__doc__)
#import novoeispack
#print(novoeispack.__doc__)
#print(librarykf78.__doc__)

# Define parameters for rkf78
position = np.zeros(2, dtype=np.float64)
relerr = np.zeros(2, dtype=np.float64)
abserr = np.zeros(2, dtype=np.float64)
work = np.zeros(28, dtype=np.float64)

# Define parameters for eispack to calculate eigenvalues
wr = np.zeros(2, dtype=np.float64)
wi = np.zeros(2, dtype=np.float64)
eigvec = np.zeros((2,2), dtype=np.float64)
ierr = 0 #np.zeros(1, dtype=np.int32)
matz = 0 #np.zeros(1, dtype=np.int32)
lambda1 = np.zeros(2, dtype=np.float64)

# Initialization
a = 0.0
b = 50
n = 100
h = (b - a) / n
#tstep = 0.5

# Define grid parameters
nx = 512
ny = 512
pi = math.acos(-1.)
Lx = 2 * pi
Ly = 2 * pi
dx = Lx / (nx - 1)
dy = Ly / (ny - 1)
dist = 1e-12
dist2 = 1 / (2 * dist)

# Define del_x and del_y as NumPy arrays
del_x = np.array([dist, -dist, 0.0, 0.0, 0.0])
del_y = np.array([0.0, 0.0, dist, -dist, 0.0])

# Create arrays for x and y coordinates
#x = np.zeros(nx, dtype=np.float64)
#y = np.zeros(ny, dtype=np.float64)

x1 = np.zeros((nx, ny, 5))
y1 = np.zeros((nx, ny, 5))

# Initialize the FTLE (Finite-Time Lyapunov Exponent) array
sigma = np.zeros((nx, ny))

relerr = 1.0e-14
abserr = 1.0e-15

#relerr = [1.0e-14, 1.0e-14]
#abserr = [1.0e-15, 1.0e-15]

dt_min = 0.02
dt_max = 0.2
tole = 10e-15
count_del = 1e-5

# Loop through the grid points
for i in range(1, nx - 1):
    for j in range(1, ny - 1):
        #xci = (i - 1) * dx - pi
        #yci = (j - 1) * dy - pi
        xci = (i) * dx - pi
        yci = (j) * dy - pi
        #position[0] = (i - 1) * dx - pi
        #position[1] = (j - 1) * dy - pi
        #print("i=",i,"j =", j)  # Print the value of i

        for p in range(5):
            position[0] = xci + del_x[p]
            position[1] = yci + del_y[p]
            #print(position[0],position[1])
            #input("Press Enter to continue...")
            t = a
            iflag = 1
            dt = dt_min
            dtout = dt_min
            tnext = t + dt
            tfinal = 15
            #iflag = 1
            #print(t)
            while abs(t) <= abs(tfinal):
                #fortranlibrary.rkf78(2,position,t,tnext, relerr,abserr,dtout)
                #fortranlibrary.rkf78(t, position, dt, tole)
                #print(position[0],position[1],t)
                #input("Press Enter to continue...")
                #fortranlibrary.rk4(t,dt,position)
                rk4library.rk4(t,dt,position)
                #print(position[0],position[1],t)
                #input("Press Enter to continue...")
                #print(t)
                #print("t= ",t,"tnext= ", tnext, "dtout= ", dtout)
                #if ((t + tstep) > b):
                #    tstep = b - t
                #rkf78(derivs, neqn, x, t, tout, relerr, abserr, iflag, work, dtout)
                #rkf78.rkf78(derivs, 2, position, t, tnext, relerr, abserr, iflag, work, dtout)
                #if iflag != 1:
                #    print('iflag=', iflag)
                #    input("Press Enter to continue...")
                #if abs(dtout)>abs(dt_max):
                #     tnext = t + dt_max
                #else:
                #     tnext = t + dtout
                #if abs(tnext)>abs(tfinal):
                #     tnext = tfinal
                #t = t + tnext
                t = t + dt

            x1[i, j, p] = position[0]
            y1[i, j, p] = position[1]

df = np.zeros((2, 2))  # Jacobian matrix
df_t = df


#print("COMPUTE THE JACOBIAN FLOW AND FTLE")
#input("Press Enter to continue...")
for i in range(1, nx - 1):
    for j in range(1, ny - 1):
        #print("i=",i,"j =", j)  # Print the value of i

        # Teste calculando Padberg
        max_dist = 0.0
        for k in range(4):
            distancia = np.sqrt( (x1[i,j,k]-x1[i,j,4])**2 + (y1[i,j,k]-y1[i,j,4])**2 ) / dist
            if distancia>=max_dist :
             max_dist = distancia
        if max_dist == 0.0:
             sigma[i,j] =  0.0
        else:
             sigma[i,j] = np.log(max_dist)/abs(tfinal)
        

        # Teste calculando os auto valores
        #df[0, 0] = dist2 * (x1[i, j, 0] - x1[i, j, 1])
        #df[0, 1] = dist2 * (x1[i, j, 2] - x1[i, j, 3])
        #df[1, 0] = dist2 * (y1[i, j, 0] - y1[i, j, 1])
        #df[1, 1] = dist2 * (y1[i, j, 2] - y1[i, j, 3])
        #df_t = np.transpose(df)
        #result_matrix = np.dot(df_t, df)
        #result_matrix_size = np.shape(result_matrix)
        #print("Size of result_matrix:", result_matrix_size)
        # Print the values of result_matrix
        #print("Values of result_matrix:")
        #for row in result_matrix:
        #    print(row)
        #input("Press Enter to continue...")
        #eigenvalues = eigvals(result_matrix)
        #max_lambda = np.max(eigenvalues)

        #teste eispack
        #novoeispack.rg(2,result_matrix,wr,wi,matz,eigvec,ierr)
        #lambda1 = wr
        #max_lambda=lambda1(0)

        #if max_lambda <= 0:
        #    sigma[i, j] = 0.0
        #else:
        #    sigma[i, j] = (np.log(np.sqrt(max_lambda)).real)/abs(tfinal)

# The rest of your code for saving data remains the same.

# Load sigma.data, process data, and create visualizations as needed.


#with open("matrix5.dat", "w") as data_file:
#    for i in range(1, nx):
#        for j in range(1, ny):
#        		formatted_data = "{:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e}".format(x1[i,j,0],x1[i,j,1],x1[i,j,2],x1[i,j,3],y1[i,j,0],y1[i,j,1],y1[i,j,2],y1[i,j,3])
#        		data_file.write(formatted_data + "\n")

with open("ics.data", "w") as data_file:
    for i in range(1, nx - 1):
        for j in range(1, ny - 1):
            xci = (i - 1) * dx - pi
            yci = (j - 1) * dy - pi
            formatted_data = "{:16.8e} {:16.8e}".format(xci, yci)
            data_file.write(formatted_data + "\n")

#with open("xics.data", "w") as data_file:
#    for i in range(2, nx - 1):
#        for j in range(2, ny - 1):
#            xci = (i - 1) * dx - pi
#            yci = (j - 1) * dy - pi
#            formatted_data = "{:16.8e} {:16.8e} {:16.8e} {:16.8e}".format(xci+del_x[0],xci+del_x[1],xci+del_x[2],xci+del_x[3])
#            data_file.write(formatted_data + "\n")
        
#with open("yics.data", "w") as data_file:
#    for i in range(2, nx - 1):
#        for j in range(2, ny - 1):
#            xci = (i - 1) * dx - pi
#            yci = (j - 1) * dy - pi
#            formatted_data = "{:16.8e} {:16.8e} {:16.8e} {:16.8e}".format(yci+del_x[0],yci+del_x[1],yci+del_x[2],yci+del_x[3])
#            data_file.write(formatted_data + "\n")

# Save the data to a .data file
#with open("sigma.data", "w") as data_file:
#    for i in range(2, nx - 1):
#        for j in range(2, ny - 1):
#            xci = (i - 1) * dx - pi
#            yci = (j - 1) * dy - pi
#            data = sigma[i - 1, j - 1]
#            formatted_data = f"{t:16.8e} {xci:16.8e} {yci:16.8e} {data:16.8e}"
#            data_file.write(formatted_data + "\n")

filename = "output6.data"  # Choose your desired output file name

with open(filename, "w") as file:
    for j in range(ny - 1, 1, -1):
        formatted_data = " ".join([f"{sigma[i][j]:16.8e}" for i in range(nx - 1, 1, -1)])
        file.write(formatted_data + "\n")
            
            
            
#load sigma.data 
#x = sigma(:,2);
#y = sigma(:,3);
#z = sigma(:,4);
#intensity = z;
#imagesc(unique(x), unique(y), reshape(intensity, length(unique(x)), length(unique(y))));
