
# Tacit Array Language Tutorial: Chapter One

## Introduction

Welcome to the Tacit Array Language tutorial! This language is a stack-based array-oriented programming language inspired by J and Reverse Polish Notation (RPN). It emphasizes concise syntax, immutability, and compositional power, making it ideal for numerical computation and functional programming. Let's explore the fundamental concepts.

---

## Basic Concepts

### Literals

Literals are the building blocks of the language. They come in several forms:

- **Scalars**: Single values, e.g., `42`.
- **Vectors**: Sequences of values, e.g., `[ 1 2 3 ]`.
- **Matrices**: Multi-dimensional arrays, e.g., `[ 1 2 , 3 4 ]`.

Literals are immutable, which means they cannot be changed once defined. You can think of them as constants. This immutability ensures that operations on data are predictable and without side effects.

---

### The Stack

Tacit Array Language operates on a stack, where data is pushed and popped as operations are performed. Each operation takes its arguments from the top of the stack and places the result back onto the stack. This stack-based nature follows Reverse Polish Notation (RPN) principles.

#### Example: Adding Numbers

```text
3 4 +  // Adds 3 and 4, producing 7
```

Explanation:
1. Push `3` onto the stack.
2. Push `4` onto the stack.
3. The `+` operation consumes the top two elements (3 and 4), calculates their sum, and pushes the result `7` back onto the stack.

---

### Comments

Comments begin with `//` and can be added anywhere in your code. They are ignored during execution and serve to explain or document your code.

#### Example

```text
// This line adds two numbers
3 4 +
```

---

## Built-In Verbs

Verbs in Tacit Array Language are the fundamental operations applied to stack elements. Verbs are categorized into **monadic** (operating on one argument) and **dyadic** (operating on two arguments). These verbs cover arithmetic, logical, and structural operations.

### Monadic Verbs

Monadic verbs operate on a single argument and are essential for transforming individual values or arrays.

#### Table of Monadic Verbs

| Verb    | Description                                       | Example Usage                      |
|---------|---------------------------------------------------|-------------------------------------|
| `-`     | Negates a number or array element-wise.           | `[ 1 -2 3 ] - → [-1 2 -3 ]`        |
| `%`     | Normalizes a vector to the range `[0, 1]`.        | `[ 10 20 30 ] % → [ 0.0 0.5 1.0 ]` |
| `/`     | Converts each element to its reciprocal.          | `[ 2 4 8 ] / → [ 0.5 0.25 0.125 ]` |
| `<`     | Finds the smallest value in an array.             | `[ 1 2 3 4 5 ] < → 1`              |
| `>`     | Finds the largest value in an array.              | `[ 1 2 3 4 5 ] > → 5`              |
| `/:`    | Flattens a multi-dimensional array into a vector. | `[ 1 2 , 3 4 ] /: → [ 1 2 3 4 ]`   |
| `|:`    | Transposes a matrix.                              | `[ 1 2 , 3 4 ] \|: → [ 1 3 , 2 4 ]` |

---

### Dyadic Verbs

Dyadic verbs operate on two arguments and perform pairwise or aggregate operations. These verbs are key to combining and comparing arrays or values.

#### Table of Dyadic Verbs

| Verb    | Description                                                       | Example Usage                          |
|---------|-------------------------------------------------------------------|----------------------------------------|
| `+`     | Adds two numbers or arrays element-wise.                          | `[ 1 2 3 ] [ 4 5 6 ] + → [ 5 7 9 ]`    |
| `-`     | Subtracts the second number from the first.                       | `[ 5 6 7 ] [ 1 2 3 ] - → [ 4 4 4 ]`    |
| `*`     | Multiplies two numbers or arrays element-wise.                    | `[ 2 3 4 ] [ 5 6 7 ] * → [ 10 18 28 ]` |
| `/`     | Divides the first number by the second.                           | `[ 8 6 4 ] [ 2 3 4 ] / → [ 4 2 1 ]`    |
| `%`     | Computes the remainder of division.                               | `[ 8 6 4 ] [ 3 2 2 ] % → [ 2 0 0 ]`    |
| `<>`    | Checks if two elements are not equal.                             | `[ 1 2 3 ] [ 1 0 3 ] <> → [ 0 1 0 ]`   |
| `=`     | Checks if two elements are equal.                                 | `[ 1 2 3 ] [ 1 0 3 ] = → [ 1 0 1 ]`    |
| `<`     | Checks if the first value is less than the second.                | `[ 1 2 3 ] [ 2 2 2 ] < → [ 1 0 0 ]`    |
| `<=`    | Checks if the first value is less than or equal to the second.    | `[ 1 2 3 ] [ 2 2 2 ] <= → [ 1 1 0 ]`   |
| `>`     | Checks if the first value is greater than the second.             | `[ 1 2 3 ] [ 2 2 2 ] > → [ 0 0 1 ]`    |
| `>=`    | Checks if the first value is greater than or equal to the second. | `[ 1 2 3 ] [ 2 2 2 ] >= → [ 0 1 1 ]`   |
| `|`     | Logical OR.                                                       | `[ 0 1 ] [ 1 0 ] \| → [ 1 1 ]`        |
| `&`     | Logical AND.                                                      | `[ 0 1 ] [ 1 0 ] & → [ 0 0 ]`          |
| `$`     | Reshapes an array.                                                | `[ 1 2 3 4 ] [ 2 2 ] $ → [ 1 2 , 3 4 ]`|

---

### Modifiers and Monadic Versions of Dyadic Verbs

Modifiers allow you to adapt dyadic verbs into monadic behaviors. The `@` modifier forces a dyadic verb to act as monadic.

#### Examples with the `@` Modifier

- **Negation (`@ -`)**: Forces subtraction to act as negation.
  ```text
  3 @ -  // Produces -3
  ```

- **Scalar Addition (`@ +`)**: Adds a scalar to all elements of a vector.
  ```text
  [ 1 2 3 ] 5 @ +  // Produces [ 6 7 8 ]
  ```

- **Scalar Multiplication (`@ *`)**: Multiplies each element by a scalar.
  ```text
  [ 1 2 3 ] 2 @ *  // Produces [ 2 4 6 ]
  ```

---

## Example: Combining Verbs

By combining verbs, you can build powerful operations. Let’s see an example:

#### Example: Dot Product

The dot product of two vectors is the sum of the products of their corresponding elements.

```text
[ 1 2 3 ] [ 4 5 6 ] { * } /m { + } /r
```

Explanation:
1. `{ * } /m` performs element-wise multiplication, producing `[ 4 10 18 ]`.
2. `{ + } /r` sums the results, producing `32`.

---

## Higher-Dimensional Arrays

In addition to 1D vectors and 2D matrices, the Tacit Array Language supports higher-dimensional arrays such as 3D and 4D arrays. These arrays are defined by providing their data followed by shape information.

### Defining a 3D Array

A 3D array can be thought of as a stack of 2D matrices. For example, a 3x2x2 array consists of three matrices, each with 2 rows and 2 columns. In Tacit syntax, this can be expressed as:

```text
[ 1 2 3 4 5 6 7 8 9 10 11 12 ] [ 3 2 2 ] $
```

Explanation:
1. **Data**: `[ 1 2 3 4 5 6 7 8 9 10 11 12 ]` is the flattened representation of all elements.
2. **Shape**: `[ 3 2 2 ]` specifies that the data should be reshaped into 3 layers, each a 2x2 matrix.
3. **Result**:
   ```text
   [ [ 1 2 , 3 4 ] , [ 5 6 , 7 8 ] , [ 9 10 , 11 12 ] ]
   ```

### Defining a 4D Array

A 4D array extends this concept further, adding another level of dimensionality. For instance, a 2x2x2x2 array can be defined as:

```text
[ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ] [ 2 2 2 2 ] $
```

Explanation:
1. **Data**: `[ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ]` is the flattened representation.
2. **Shape**: `[ 2 2 2 2 ]` indicates 2 groups of 2x2x2 arrays.
3. **Result**:
   ```text
   [ [ [ 1 2 , 3 4 ] , [ 5 6 , 7 8 ] ] , [ [ 9 10 , 11 12 ] , [ 13 14 , 15 16 ] ] ]
   ```

### Accessing Elements

Elements in higher-dimensional arrays can be accessed by indexing into each dimension. For example:

```text
:Arr [ 1 2 3 4 5 6 7 8 ] [ 2 2 2 ] $
Arr 1 0 1  // Access the element in layer 1, row 0, column 1
```
This returns the value `6` from the array.

### Practical Example: 3D Transformation

Consider performing element-wise operations on a 3D array:

```text
:Arr [ 1 2 3 4 5 6 7 8 9 10 11 12 ] [ 3 2 2 ] $
Arr { 2 * } /m  // Multiply every element by 2
```

Result:

```text
[ [ 2 4 , 6 8 ] , [ 10 12 , 14 16 ] , [ 18 20 , 22 24 ] ]
```

---

## Conclusion

In this chapter, you learned:

- The fundamental concepts of the Tacit Array Language.
- The role of literals, the stack, and comments.
- How to use built-in verbs, categorized into monadic and dyadic types.
- How to adapt dyadic verbs into monadic ones using the `@` modifier.

In the next chapter, we’ll explore **adverbs**, **deferred code**, and more advanced array manipulations. Stay tuned!
