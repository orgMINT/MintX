
# Tacit Array Language Tutorial: Chapter Two

## Arithmetic, Logic, and Comparison Operations

Arithmetic, logic, and comparison operations are fundamental in Tacit. These operations, applied to scalars and arrays, form the building blocks for mathematical and logical computations. This chapter covers their syntax, usage, and examples.

---

## Arithmetic Operations

Tacit supports standard arithmetic operations for both scalars and arrays. All arithmetic verbs are dyadic unless explicitly made monadic with the `@` modifier.

### Dyadic Arithmetic Verbs

| Verb | Description           | Example Usage            |
|------|-----------------------|--------------------------|
| `+`  | Addition              | `[1 2 3] [4 5 6] + → [5 7 9]` |
| `-`  | Subtraction           | `[5 6 7] [1 2 3] - → [4 4 4]` |
| `*`  | Multiplication        | `[2 3 4] [5 6 7] * → [10 18 28]` |
| `/`  | Division              | `[8 9 10] [2 3 5] / → [4 3 2]` |
| `%`  | Modulus (Remainder)   | `[8 9 10] [3 4 5] % → [2 1 0]` |

### Monadic Arithmetic Verbs

| Verb | Description            | Example Usage            |
|------|------------------------|--------------------------|
| `-`  | Negation               | `[1 -2 3] @ - → [-1 2 -3]` |
| `%`  | Reciprocal             | `[2 4] @ % → [0.5 0.25]`  |
| `%%` | Square root            | `[4 16] @ %% → [2 4]`     |
| `%/` | Logarithm              | `[1 10] @ %/ → [0 1]`     |
| `!`  | Factorial              | `[3 4] @ ! → [6 24]`      |

---

## Logic Operations

Logical operations in Tacit are dyadic and operate element-wise on arrays of equal shape.

| Verb | Description    | Example Usage            |
|------|----------------|--------------------------|
| `&`  | Logical AND    | `[1 0 1] [0 1 1] & → [0 0 1]` |
| `|`  | Logical OR     | `[1 0 1] [0 1 0] | → [1 1 1]` |

---

## Comparison Operations

Comparison verbs evaluate pairs of elements from two arrays of the same shape, returning a Boolean array.

| Verb  | Description              | Example Usage            |
|-------|--------------------------|--------------------------|
| `<`   | Less than                | `[1 2 3] [2 2 2] < → [1 0 0]` |
| `<=`  | Less than or equal       | `[1 2 3] [2 2 2] <= → [1 1 0]` |
| `>`   | Greater than             | `[1 2 3] [2 2 2] > → [0 0 1]` |
| `>=`  | Greater than or equal    | `[1 2 3] [2 2 2] >= → [0 1 1]` |
| `=`   | Equal to                 | `[1 2 3] [1 0 3] = → [1 0 1]`  |
| `<>`  | Not equal to             | `[1 2 3] [1 0 3] <> → [0 1 0]` |

---

## Arithmetic and Logic with Arrays

Tacit automatically applies operations element-wise when working with arrays of the same shape.

#### Example 1: Scalar to Array
```text
[1 2 3] 2 +
```
Result:
```text
[3 4 5]  // Adds 2 to each element
```

#### Example 2: Array to Array
```text
[1 2 3] [4 5 6] +
```
Result:
```text
[5 7 9]  // Adds corresponding elements
```

#### Example 3: Mixed Logic
```text
[1 0 1] [0 1 1] &
```
Result:
```text
[0 0 1]  // Logical AND
```

---

## Summary

In this chapter, we explored:

- Arithmetic operations with scalars and arrays.
- Logical operations like AND and OR.
- Comparison operations such as `<`, `>=`, and `=`.

These foundational operations are the building blocks for more advanced computations in Tacit. In the next chapter, we will dive into array manipulation, including reshaping and slicing arrays.
