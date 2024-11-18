;
; transmit a character in a
;--------------------------
putChar:
        push  bc
        ld    b,a                   ;save the character  for later
putChar1: 
        in    a,(STATUS)            ;get the ACIA status
        bit   1,a
        jr    z,putChar1            ;no, the TDR is not empty
        ld    a,b                   ;yes, get the character
        out   (TDR),a               ;and put it in the TDR
        pop   bc
        ret

printStr:                           
    EX (SP),hl		                ; swap			
    call putStr		
    inc hl			                ; inc past null
    EX (SP),hl		                ; put it back	
    ret

putStr0:                            
    call putChar
    inc hl
putStr:
    ld a,(hl)
    or A
    jr NZ,putStr0
    ret

; hl = value
printDec:    
    bit 7,h
    jr z,printDec2
    ld a,'-'
    call putChar
    xor a  
    sub l  
    ld l,a
    sbc a,a  
    sub h  
    ld h,a
printDec2:        
    push bc
    ld c,0                      ; leading zeros flag = false
    ld de,-10000
    call printDec4
    ld de,-1000
    call printDec4
    ld de,-100
    call printDec4
    ld e,-10
    call printDec4
    inc c                       ; flag = true for at least digit
    ld e,-1
    call printDec4
    pop bc
    ret
printDec4:
    ld b,'0'-1
printDec5:	    
    inc b
    add hl,de
    jr c,printDec5
    sbc hl,de
    ld a,'0'
    cp b
    jr nz,printDec6
    xor a
    or c
    ret z
    jr printDec7
printDec6:	    
    inc c
printDec7:	    
    ld a,b
    jp putChar
