
# Tacit Array Language Tutorial: Chapter Four

## Matrix Operations

Matrices are a key data structure in Tacit, enabling complex numerical computations. This chapter explores fundamental matrix operations, including multiplication, transposition, and determinants, as well as advanced techniques like solving linear equations.

---

## Matrix Basics

A matrix in Tacit is represented as a one-dimensional array reshaped into two dimensions using the `$` operator.

#### Example

```text
[1 2 3 4] [2 2] $
```

Result:

```text
[[1 2]
 [3 4]]
```

---

## Matrix Transposition

The transpose of a matrix flips its rows and columns. Tacit uses the `\|:` operator for this purpose.

#### Example

```text
[1 2 3 4] [2 2] $ \|:
```

Result:

```text
[[1 3]
 [2 4]]
```

---

## Matrix Multiplication

Matrix multiplication in Tacit follows the standard linear algebra rules. To distinguish matrix multiplication from element-wise multiplication, Tacit uses a distinct operator `*m` for matrix operations and reserves `*` for item-wise multiplication.

#### Syntax

```text
[matrix1] [matrix2] *m
```

#### Example

```text
[1 2 3 4] [2 2] $ [5 6 7 8] [2 2] $ *m
```

Result:

```text
[[19 22]
 [43 50]]
```

Steps:

- Multiply rows of the first matrix by columns of the second matrix.
- Sum the products for each element.

### Item-Wise Multiplication

Item-wise multiplication is performed element-by-element for arrays of the same shape.

#### Syntax

```text
[array1] [array2] *
```

#### Example

```text
[1 2 3] [4 5 6] *
```

Result:

```text
[4 10 18]
```

---

## Determinant of a Matrix

The determinant provides a scalar value that characterizes a square matrix. Tacit uses a distinct operator `*d` for computing the determinant.

#### Example

```text
[1 2 3 4] [2 2] $ *d
```

Result:

```text
-2  // Determinant of the 2x2 matrix
```

---

## Solving Linear Equations

Tacit enables solving systems of linear equations using matrix operations. The equation `Ax = B` can be solved using the inverse of `A`. To distinguish inversion as a distinct operation, Tacit uses the operator `*i` for matrix inversion.

#### Syntax
```text
[vector] [matrix] *i
```
Note: The matrix inversion operator `*i` must always be paired with a valid matrix and a vector for solving linear equations.

#### Example
```text
[1 2 3 4] [2 2] $ *i [5 6] $ *
```

Result:
```text
[-4.0 4.5]  // Solution to the system of equations
```

Steps:
1. Compute the inverse of `A` using `*i`.
2. Multiply the result by `B`.

---

## Advanced Matrix Operations

### Eigenvalues and Eigenvectors

Use the operator `*e` to compute eigenvalues and eigenvectors of a square matrix.

#### Example
```text
[1 2 3 4] [2 2] $ *e
```

Result:
```text
Eigenvalues: [-0.372 5.372]
Eigenvectors: [[-0.824 0.416]
               [0.566 -0.909]]
```

### Matrix Inversion

The inverse of a matrix is computed using the `*i` operator. This operation is only valid for non-singular square matrices.

#### Example
```text
[1 2 3 4] [2 2] $ *i
```

Result:

```text
[[-2.0 1.0]
 [1.5 -0.5]]
```

---

## Summary

In this chapter, we covered:

- Representing matrices using the `$` operator.
- Transposing matrices with `\|:`.
- Performing matrix multiplication and computing determinants.
- Solving systems of linear equations using matrix inversion.
- Advanced techniques, including eigenvalues, eigenvectors, and matrix inversion.

In the next chapter, we will explore eigenvalues, eigenvectors, and their applications in greater detail.
