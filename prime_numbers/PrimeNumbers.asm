; Поиск простых чисел

ldi a, 0x80
st a, 0x3F
ldi c, 0x41
main:
  inc b
  ldi d, 0x01
  neg d
loop:
  dec d
  mov a, d
  add a, b
  jz prime
  js prime
  mov a, b
innerloop:
  add a, d
  js loop
  jnz innerloop
  jz main
prime:
  st b, c
  inc c
  inc c
  ld a, nums
  dec a
  jz halt
  st a, nums
  jmp main
halt:
  hlt
nums db 0x10
