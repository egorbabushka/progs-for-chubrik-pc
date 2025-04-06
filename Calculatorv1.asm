; EgorBabushka - Calculator
; https://discord.com/channels/1139657094459560006/1187504690703913170/1193148821023248424

ldi a, 0x80
st a, 0x3F
ldi b, 48
ldi c, 10

input_first:
  ld a, 0x3E
  add a, 0
  jz input_first
  ldi d, 0x80
  st d, 0x40
  sub a, b
  js input_second_start
  mov d, a
  ld a, first_num
  mov c, a
  shl a
  shl a
  shl a
  add a, c
  add a, c
  add a, d
  st a, first_num
  ldi c, 10
  mov a, 0
  st a, 0x3E
  st a, 0x40
  jmp input_first

input_second_start:
  ldi d, 6
  add a, d
  st a, operation
  ldi b, 48
  mov a, 0
  st a, 0x3E
  st a, 0x40

  jmp input_second

offset db 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0

input_second:
  ld a, 0x3E
  add a, 0
  jz input_second
  ldi d, 0x80
  st d, 0x40
  sub a, b
  js start
  sub a, c
  jns start
  add a, c
  mov d, a
  ld a, second_num
  mov c, a
  shl a
  shl a
  shl a
  add a, c
  add a, c
  add a, d
  st a, second_num
  ldi c, 10
  mov a, 0
  st a, 0x3E
  st a, 0x40
  jmp input_second
  
start:
  mov a, 0
  mov c, a
  st a, 0x40
  ld a, operation
  ldi b, operations
  add b, a
  ld b, b
  jmp b

addition:
  ld a, first_num
  ld b, second_num
  add b, a
  mov a, 0
  adc a, 0
  st a, high_byte
  mov a, b
  jmp display

subtraction:
  ld a, first_num
  ld b, second_num
  sub a, b
  jmp display

division:
  mov a, 0
  mov c, a
  ld a, first_num
  ld b, second_num
  loop:
    inc c
    sub a, b
    js display_remainder
    jz end
    jmp loop
  display_remainder:
    add a, b
    st a, 0xC3
    dec c
  end:
    mov a, c
    jmp display

multiplication:
  ld b, first_num
  ld c, second_num
  mov a, b
  sub a, c
  mov a, 0
  js loop_less
  jmp loop_more
  
  loop_more:
    add a, b
    mov d, a
    ld a, high_byte
    adc a, 0
    st a, high_byte
    mov a, d
    dec c
    jnz loop_more
  jmp display
  
  loop_less:
    add a, c
    mov d, a
    ld a, high_byte
    adc a, 0
    st a, high_byte
    mov a, d
    dec b
    jnz loop_less

display:
  st a, 0x41
  ld d, high_byte
  st d, 0x40

halt:
    hlt

high_byte db 0 
first_num db 0
second_num db 0
operation db 0
operations db multiplication, addition, halt, subtraction, halt, division
