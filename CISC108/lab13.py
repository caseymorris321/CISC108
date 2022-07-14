# Name 1
# Name 2

import random
import numbers

# Attendance: 10 points!


# Constants:



# 1. fast_exp (15 pts):
def fast_exp(b, e):
    if e == 0:
        return 1
    elif e%2 == 0:
        return fast_exp(b*b, e/2)
    else:
        return b*fast_exp(b, e-1)
assert fast_exp(2,10) == 1024

# fast_exp(2, 1000000) : no prob




# A Vector is a non-empty list of numbers.


# 2. make_vec (5 pts):
def make_vec(n):
    v = []
    if n < 1:
        raise ValueError("no")
    for n in range(n):
        v.append(0)
    return v


a = [1, -1, 3]
b = [2, 3, -2]
# 3. inner_prod (5 pts): 
def inner_prod(a, b):
    if a == []:
        raise ValueError("no")
    elif b == []:
        raise ValueError("no")
    elif len(a) < len(b):
        raise ValueError("no")
    return sum([a[i]*b[i]
    for i in range (len(a))])


# 4. examples of matrices and make_mat (10 pts):


# A Matrix is a non-empty list of Vector, with all vectors of the same
# (positive) length.


# Some examples of matrices...

# make_mat:
list1 = [0, 0, 0]
list2 = [0, 0, 0]
list3 = [0, 0, 0]
mat1 = [list1, list2, list3]
mat2 = [list2, list1, list3]
mat3 = [list3, list1, list2]
def make_mat(n, m):
    matrix = []
    if n < 1:
        raise ValueError("no")
    elif m < 1:
        raise ValueError("no")
    for n in range(n):
        matrix += [[0] * m]
    return matrix 

# 5. nrow and ncol (5 pts):
def nrow(mat):
    return len(mat)

def ncol(mat):
    return len(mat[1])

# 6. mat_copy (10 pts):
def mat_copy(matrix):
    copy = []
    n = len(matrix)
    for x in range(n):
        row = []
        for y in range(n):
            row.append(matrix[x][y])
        copy.append(row)
    return copy

# 7. extract_col (5 pts):
def extract_col(mat, j):
    if len(mat) < 1:
        raise ValueError("no")
    elif len(mat) == 1:
        return (mat[0])[j]
    else:
        return list(set([(mat[0])[j]] + [extract_col(mat[1:], j)]))


# 8. mat_mul (10 pts):
mat11 = [[3,2],[1,5],[6,7]]
mat12 = [[10,11,8],[1,2,3]]
def mat_mul(m1, m2):
    if nrow(m1) > ncol(m2):
        raise ValueError("no")
    else:
        result = make_mat(nrow(m1),ncol(m2))
        for i in range(nrow(m1)):
            for j in range(ncol(m2)):
                result[i][j] = inner_prod(m1[i], extract_col(m2, j))
    return result


# A Square Matrix is a matrix with the same number of rows as columns.


# 9. transpose (10 pts):
def transpose(matrix):
    n = nrow(matrix)
    if ncol(matrix) == 0:
            raise ValueError("no")
    else:
        for i in range(n):
            for j in range (i+1, n):
                value = matrix[i][j]
                matrix[i][j] = matrix[j][i]
                matrix[j][i] = value


#### Extra Credit ####

# 10. rand_mat (5 pts):
import random
MAX = 1000
def rand_mat(n):
    matrix = []
    if n < 1:
        raise ValueError("no")
    else:
        v = make_mat(n, n)
        if n < 1:
            raise ValueError("dog")
        for row in range(n):
            for col in range(n): 
                v[row][col] = (random.randint(0,MAX))
        return v     

# 11. commute (5 pts):





# test_commute





# 12. associate (5 pts):





# test_associate:





# 13. transpose_commute (5 pts)





# test_transpose_commute:



#### Final Submission ####

# Turn in this entire file: 5 points!
