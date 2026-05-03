[org 0x7c00]
bits 16
xor ax, ax
mov ds, ax
mov es, ax
mov ah, 0x02
mov al, 5
mov bx, 0x1000
mov ch, 0
mov dh, 0
mov cl, 2
int 0x13
jmp 0x1000
times 510-($-$$) db 0
dw 0xaa55


