
# Tacit Array Language Tutorial: Chapter Three

## Array Manipulation

Arrays are central to Tacit's design, providing a foundation for operations on data structures. This chapter explores how to create, reshape, slice, and manipulate arrays, laying the groundwork for advanced computations.

---

## Creating Arrays

Tacit allows you to define one-dimensional arrays using square brackets. All arrays are immutable, ensuring consistency in computations.

#### Examples

- A simple one-dimensional array:
  ```text
  [1 2 3 4 5]
  ```

- An array with floating-point numbers:
  ```text
  [1.1 2.2 3.3]
  ```

---

## Reshaping Arrays

The `$` operator reshapes a one-dimensional array into higher dimensions using a shape array.

#### Syntax
```text
[array] [shape] $
```
- **`array`**: The one-dimensional array to reshape.
- **`shape`**: An array specifying the desired dimensions.

#### Example
```text
[1 2 3 4 5 6] [2 3] $
```
Result:
```text
[[1 2 3]
 [4 5 6]]
```

#### Edge Case: Non-Matching Shape
If the number of elements in the array does not match the product of the dimensions in the shape array, Tacit will raise an error.

---

## Indexing Arrays

The `#` operator retrieves elements from a reshaped array based on an index array.

#### Syntax
```text
[array] [shape] $ [index] #
```
- **`array`**: The original one-dimensional array.
- **`shape`**: The dimensions of the reshaped array.
- **`index`**: An array specifying the location of the desired element.

#### Example
```text
[1 2 3 4 5 6] [2 3] $ [1 2] #
```
Result:
```text
6  // Element at row 2, column 3
```

---

## Slicing Arrays

Slicing allows you to extract subarrays from a larger array. Tacit achieves this using index arrays and reshaping.

#### Example: Row Extraction
```text
[1 2 3 4 5 6] [2 3] $ [0] #
```
Result:
```text
[1 2 3]  // Extracts the first row
```

#### Example: Column Extraction
```text
[1 2 3 4 5 6] [2 3] $ [1] #c
```
Result:
```text
[2 5]  // Extracts the second column
```


---

## Combining Arrays

### Horizontal Concatenation
Tacit supports horizontal concatenation using a proposed `|` operator.

#### Example
```text
[1 2 3] [4 5 6] |
```
Result:
```text
[1 2 3 4 5 6]
```

### Vertical Concatenation
For multidimensional arrays, use reshaping followed by concatenation.

#### Example
```text
[1 2 3 4] [2 2] $ [5 6 7 8] [2 2] $ |
```
Result:
```text
[[1 2]
 [3 4]
 [5 6]
 [7 8]]
```

---

## Array Properties

Tacit provides verbs to retrieve properties of arrays, such as their shape and size.

| Verb  | Description            | Example Usage             |
|-------|------------------------|---------------------------|
| `#s`  | Shape of the array     | `[1 2 3 4] [2 2] $ @ #s → [2 2]` |
| `#n`  | Number of elements     | `[1 2 3 4] @ #n → 4`      |
| `#r`  | Rank (number of dimensions) | `[1 2 3 4] [2 2] $ @ #r → 2` |

---

## Summary

In this chapter, we explored:

- Defining arrays.
- Reshaping arrays using the `$` operator.
- Accessing elements with the `#` operator.
- Extracting subarrays through slicing.
- Concatenating arrays horizontally and vertically.
- Querying array properties like shape and size.

In the next chapter, we will delve into matrix operations, including multiplication, transposition, and determinants.
