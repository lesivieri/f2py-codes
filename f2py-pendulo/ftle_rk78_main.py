import numpy as np
import math
from scipy.linalg import eigvals
#import rk4library
#print(rk4library.__doc__)
import rkf78teste
print(rkf78teste.__doc__)

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

# Define grid parameters
nx = 128
ny = 128
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
x1 = np.zeros((nx, ny, 5))
y1 = np.zeros((nx, ny, 5))

# Initialize the FTLE (Finite-Time Lyapunov Exponent) array
sigma = np.zeros((nx, ny))

relerr = [1.0e-14, 1.0e-14]
abserr = [1.0e-15, 1.0e-15]

dt_min = 0.1
dt_max = 0.6
tole = 10e-15
count_del = 1e-5

# Loop through the grid points
for i in range(1, nx - 1):
    for j in range(1, ny - 1):
        xci = (i) * dx - pi
        yci = (j) * dy - pi
        print("i=",i,"j =", j)  # Print the value of i
        
        for p in range(5):
            position[0] = xci + del_x[p]
            position[1] = yci + del_y[p]
            t = np.array(a)
            dt = dt_min
            dtout = np.array(dt_min)
            tnext = np.array(t + dt)
            tfinal = 10
            iflags = np.array(1)
            neqn = np.array(2)
            while abs(t) < abs(tfinal):
                rkf78teste.rkf78(neqn,position,t,tnext,relerr,abserr,iflags,work,dtout)
                if iflags != 2:
                    print('iflag=', iflags)
                    input("Press Enter to continue...")
                if abs(dtout)>abs(dt_max):
                     tnext = t + dt_max
                elif abs(dtout)<abs(dt_min):
                    tnext = t + dt_min
                else:
                     tnext = t + dtout
                if abs(tnext)>abs(tfinal):
                     tnext = tfinal
                
            x1[i, j, p] = position[0]
            y1[i, j, p] = position[1]

df = np.zeros((2, 2))  # Jacobian matrix
df_t = df

for i in range(1, nx - 1):
    for j in range(1, ny - 1):
        print("i=",i,"j =", j)  # Print the value of i

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
        
        # Calculating th Finite Time Lyapunov Exponent by matrix and eigenvalues
        #df[0, 0] = dist2 * (x1[i, j, 0] - x1[i, j, 1])
        #df[0, 1] = dist2 * (x1[i, j, 2] - x1[i, j, 3])
        #df[1, 0] = dist2 * (y1[i, j, 0] - y1[i, j, 1])
        #df[1, 1] = dist2 * (y1[i, j, 2] - y1[i, j, 3])
        #df_t = np.transpose(df)
        #result_matrix = np.dot(df_t, df)
        #eigenvalues = eigvals(result_matrix)
        #max_lambda = np.max(eigenvalues)
        #if max_lambda <= 0:
        #    sigma[i, j] = 0.0
        #else:
        #    sigma[i, j] = (np.log(np.sqrt(max_lambda)).real)/abs(tfinal)

#################################################################################
# Save the data

# Save data by columns
#with open("matrix5.dat", "w") as data_file:
#    for i in range(1, nx):
#        for j in range(1, ny):
#        		formatted_data = "{:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e} {:16.8e}".format(x1[i,j,0],x1[i,j,1],x1[i,j,2],x1[i,j,3],y1[i,j,0],y1[i,j,1],y1[i,j,2],y1[i,j,3])
#        		data_file.write(formatted_data + "\n")

# Save the initial contidions of the central point of the grid

with open("ics.data", "w") as data_file:
    for i in range(1, nx - 1):
        for j in range(1, ny - 1):
            xci = (i - 1) * dx - pi
            yci = (j - 1) * dy - pi
            formatted_data = "{:16.8e} {:16.8e}".format(xci, yci)
            data_file.write(formatted_data + "\n")

filename = "output8.data"  # Choose your desired output file name
with open(filename, "w") as file:
    for j in range(ny - 1, 1, -1):
        formatted_data = " ".join([f"{sigma[i][j]:16.8e}" for i in range(nx - 1, 1, -1)])
        file.write(formatted_data + "\n")
