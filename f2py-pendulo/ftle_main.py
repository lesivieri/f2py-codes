import numpy as np
import math
from scipy.linalg import eigvals
import rk4library
print(rk4library.__doc__)

position = np.zeros(2, dtype=np.float64)

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
x1 = np.zeros((nx, ny, 5))
y1 = np.zeros((nx, ny, 5))

# Initialize the FTLE (Finite-Time Lyapunov Exponent) array
sigma = np.zeros((nx, ny))

# Loop through the grid points
for i in range(1, nx - 1):
    for j in range(1, ny - 1):
        xci = (i) * dx - pi
        yci = (j) * dy - pi
        #print("i=",i,"j =", j)  # Print the value of i

        for p in range(5):
            # Parameters of the initial conditions + minus pertubation
            position[0] = xci + del_x[p]
            position[1] = yci + del_y[p]

            # Parameters of time integration
            t = 0.0
            dt = 0.02
            tfinal = 15
            while abs(t) <= abs(tfinal):
                rk4library.rk4(t,dt,position)
                t = t + dt
                
            # Save the final position value after the integration  
            x1[i, j, p] = position[0]
            y1[i, j, p] = position[1]

# Parameters of the matrix to calculate the Jacobian Flow and the FTLE
df = np.zeros((2, 2))  # Jacobian matrix
df_t = df
for i in range(1, nx - 1):
    for j in range(1, ny - 1):
        #print("i=",i,"j =", j)  # Print the value of i

        # BOTH METHODS BELOW ARE WORKING

        # Calculating the square of the maximum distance of a central point from its neighbors
        # is a good approximation to the traditional method of calculating eigenvalues
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

# Save data by matrix
filename = "output6.data"  # Choose your desired output file name
with open(filename, "w") as file:
    for j in range(ny - 1, 1, -1):
        formatted_data = " ".join([f"{sigma[i][j]:16.8e}" for i in range(nx - 1, 1, -1)])
        file.write(formatted_data + "\n")
