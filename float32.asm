; Constant results
zero_result:
    db 0x00, 0x00, 0x00, 0x00    ; Zero result
infinity_result_data:
    db 0x7F, 0x80, 0x00, 0x00    ; Infinity
nan_result_data:
    db 0x7F, 0xC0, 0x00, 0x00    ; NaN

; Floating-point multiply with edge case handling
; Input: HL points to operand A, DE points to operand B
; Output: IX points to result
mul_fp:
    ; Step 1: Unpack operands
    push hl
    call unpack         ; Unpack A
    ld a, e             ; Save sign of A
    push af             ; Push sign
    push bc             ; Save exponent/mantissa of A
    push de
    push hl

    ld hl, de           ; Load operand B
    call unpack         ; Unpack B
    xor a, e            ; XOR signs to calculate result sign
    ld c, a             ; Store result sign in C

    ; Step 2: Handle special cases
    ld a, b             ; Check exponent of A
    cp 255              ; Is A infinity or NaN?
    jr z, handle_a_special
    ld a, (sp)          ; Check exponent of B
    cp 255              ; Is B infinity or NaN?
    jr z, handle_b_special

    ; Check for zero in mantissas
    ld a, d             ; Mantissa high byte of A
    or e                ; Combine with middle byte
    or h                ; Combine with low byte
    jr nz, check_b_zero ; If non-zero, check B
    ld hl, zero_result  ; A is zero, result is zero
    jr finalize

check_b_zero:
    ld a, (sp)          ; Mantissa of B
    or d
    or e
    jr nz, normal_multiply ; If non-zero, perform multiplication
    ld hl, zero_result  ; B is zero, result is zero
    jr finalize

handle_a_special:
    ld a, d             ; Check mantissa of A for NaN
    or e
    or h
    jr nz, nan_result   ; A is NaN
    ld hl, infinity_result ; A is infinity, result depends on B
    jr finalize

handle_b_special:
    ld a, d             ; Check mantissa of B for NaN
    or e
    or h
    jr nz, nan_result   ; B is NaN
    ld hl, infinity_result ; B is infinity, result depends on A
    jr finalize

nan_result:
    ld hl, nan_result_data
    jr finalize

infinity_result:
    ld hl, infinity_result_data
    jr finalize

normal_multiply:
    ; Step 3: Add exponents
    ld a, b             ; Exponent of B
    add a, (sp)         ; Add exponent of A
    sub 127             ; Subtract bias
    ld b, a             ; Store result exponent in B

    ; Step 4: Multiply mantissas
    pop hl              ; Restore mantissa of A
    ld de, hl           ; DE = mantissa of A
    pop hl              ; Restore mantissa of B
    call multiply_24bit ; Multiply mantissas (result in DEHL)

    ; Step 5: Normalize result
    call normalize      ; Normalize mantissa and adjust exponent

    ; Step 6: Check for underflow/overflow
    ld a, b             ; Check exponent
    cp 255              ; Overflow?
    jr c, check_underflow
    ld hl, infinity_result_data ; Overflow result
    jr finalize

check_underflow:
    ld a, b
    cp 0                ; Underflow?
    jr nc, pack_result
    ld hl, zero_result  ; Underflow to zero
    jr finalize

pack_result:
    ; Step 7: Pack result
    ld hl, ix           ; Store result at IX
    call pack           ; Pack components into result
    ret

finalize:
    ld (ix), (hl)       ; Store finalized result in memory
    ld a, (hl+1)
    ld (ix+1), a
    ld a, (hl+2)
    ld (ix+2), a
    ld a, (hl+3)
    ld (ix+3), a
    ret

; Unpack IEEE 754 32-bit float
; Input: HL points to 32-bit float in memory
; Output: A = sign, B = exponent (unbiased), LDE = 24-bit mantissa (with implied leading 1),
;         C = flag for special cases (0 = normal, 1 = zero, 2 = infinity, 3 = NaN, 4 = subnormal)

unpack:
    ; Step 1: Extract sign and exponent
    ld a, (hl)          ; Load the first byte (sign + exponent high bits)
    ld c, a             ; Save full byte in C for later use
    rlca                ; Rotate the high bit (sign) to the carry flag
    and 1               ; Isolate the sign bit in A (0 or 1)
    push af             ; Temporarily store sign on stack

    ld a, c             ; Reload the first byte
    and 0x7F            ; Mask out the sign bit
    ld b, a             ; B = biased exponent (7 bits)
    inc hl              ; Move to the mantissa

    ; Step 2: Load the mantissa (3 bytes)
    ld a, (hl)          ; A = First byte of mantissa
    inc hl
    ld d, (hl)          ; D = Second byte of mantissa
    inc hl
    ld e, (hl)          ; E = Third byte of mantissa (use L for mantissa's last byte)
    ld l,a              ; L = First byte of mantissa

    ; Step 3: Handle special cases
    ld a, b             ; Check exponent
    or l                ; Check if all bits are zero
    or d                ; Combine exponent and mantissa
    or e
    jr nz, check_special ; If not zero, continue to special cases
    pop af              ; Restore sign
    ld c, 1             ; All zero: Set flag for zero
    ret

check_special:
    ld a, b             ; Reload exponent
    cp 0xFF             ; Is the exponent all 1's?
    jr nz, normal       ; If not, normalize the mantissa
                        ; Exponent is all 1's; check mantissa for NaN or Infinity
    ld a, l             ; Check first byte of mantissa
    or d                ; Combine with second byte
    or e                ; Combine with third byte
    jr nz, set_nan      ; If mantissa is non-zero, it's NaN
    pop af              ; Restore sign
    ld c, 2             ; Else, it's Infinity
    ret

set_nan:
    pop af              ; Restore sign
    ld c, 3             ; Set flag for NaN
    ret

normal:                 ; Step 4: Normalize mantissa for normal numbers
    ld a, b             ; Reload exponent
    cp 0                ; Check for subnormal numbers
    jr nz, set_implied   ; If exponent is non-zero, set implied leading 1
    pop af              ; Restore sign
    ld c, 4             ; Set flag for subnormal numbers
    ret

set_implied:
    set 7, d            ; Set implied leading 1 in the highest bit of D
    sub 127             ; Unbias the exponent
    ld b, a             ; Store unbiased exponent in B
    pop af              ; Restore sign
    ld c, 0             ; Flag = normal
    ret

; Pack IEEE 754 32-bit float
; Input: A=sign, B=exponent, DE=mantissa (normalized)
; Output: HL points to packed 32-bit float
pack:
    ld a, b           ; Load exponent
    or e              ; Combine with sign
    ld (hl), a        ; Store first byte (sign + exponent)
    inc hl
    ld a, d           ; High byte of mantissa
    ld (hl), a
    inc hl
    ld a, e           ; Middle byte of mantissa
    ld (hl), a
    inc hl
    ld a, h           ; Low byte of mantissa
    ld (hl), a
    ret

; Normalize mantissa
; Input: B=exponent, DEH=mantissa
; Output: B=normalized exponent, DEH=normalized mantissa
normalize:
    ; Check if leading bit (D[7]) is set
    bit 7, d
    jr nz, normalize_done ; Already normalized
normalize_shift_left:
    sla d               ; Shift mantissa left
    rl e
    rl h
    dec b               ; Decrement exponent
    jr normalize         ; Repeat until normalized

normalize_done:
    ret

; =============================================================================
; Subroutine: mul24
; Purpose   : Perform 24-bit unsigned multiplication (hldebc = hlc * bde).
; 
; Inputs    : 
;   hlc - 24-bit multiplier (high part in hl, low part in c).
;   bde - 24-bit multiplicand (high part in b, middle in de).
;
; Outputs   :
;   hldebc - 24-bit product. High part in hl, middle part in de, low part in bc.
;
; Registers :
;   Uses ix as the intermediate result (24 bits).
;   Uses iy as a temporary storage for propagating carries.

mul24: 
    ld      (iy+0), b         ; Save high byte of the multiplicand (b)
    xor     a                 ; Clear accumulator (a)
    ld      ix, 0             ; Initialize result (ix) to 0
    ld      b, 24             ; Set loop counter to 24 (bits in 24-bit value)

mul24Loop:
    add     ix, ix            ; Shift intermediate result (ix) left by 1
    rla                       ; Rotate a left through carry
    rl      c                 ; Rotate c left through carry
    adc     hl, hl            ; Shift hl left by 1 and add carry

    jr      nc, mul24Next     ; Skip if no carry from hl

    add     ix, de            ; Add multiplicand (de) to intermediate result
    adc     a, (iy+0)         ; Add high byte of multiplicand (b) and carry
    jr      nc, mul24Next     ; Skip if no additional carry
    inc     c                 ; Increment c if carry is set
    jr      nz, mul24Next     ; Skip if increment didn't overflow
    inc     hl                ; Increment hl if carry propagated past c

mul24Next:
    djnz    mul24Loop         ; Decrement loop counter and repeat if not zero

    ld      e, a              ; Store low byte of the result in e
    ld      d, c              ; Store middle byte of the result in d
    push    ix                ; Push intermediate result onto stack
    pop     bc                ; Pop into bc (low part of final result)
    ret                       ; Return to caller

