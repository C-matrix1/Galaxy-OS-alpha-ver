[org 0x1000]
bits 16
start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov si, welcome_msg
	mov di, shell_buffer
	call print_string
	call get_input
print_string:
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	je .done
	int 0x10
	jmp .loop
.done:
	ret

get_input:
	mov ah,0x00
	int 0x16

	cmp al, 0x0D
	je .process_command
	stosb

	mov ah, 0x0e
	int 0x10
	jmp get_input
.process_command:
	mov al, 0
	stosb
	call handle_command
	mov di, shell_buffer
	jmp .new_line
.new_line:
	mov ah, 0x0e
	mov al, 0x0D
	int 0x10
	mov al, 0x0A
	int 0x10
	jmp get_input

welcome_msg db 'Galaxy OS V1 alpha-ver -Unix-like-CLI', 0

shell_buffer times 64 db 0


handle_command:
    mov si, shell_buffer
    mov di, cmd_help
    call compare_string
    je .show_help_label

    mov si, shell_buffer
    mov di, cmd_clear
    call compare_string
    je .do_clear_label

    mov si, shell_buffer
    mov di, cmd_exit
    call compare_string
    je .do_exit_label
    ret

.show_help_label:
    mov si, help_msg
    call print_string
    ret

.do_clear_label:
    call clear_screen
    ret

.do_exit_label:
    call power_off
    ret

clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ret

power_off:
    mov ax, 0x2000
    mov dx, 0x604
    out dx, ax
    ret
compare_string:
.loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .done

    cmp al, 0
    je .check_bl

    inc si
    inc di
    jmp .loop

.check_bl:
    cmp bl, 0
    je .done
.done:
    ret

cmd_help db 'help', 0
help_msg db 0x0D, 0x0A, 'Galaxy OS Commands: help, clear, exit', 0
cmd_exit db 'exit', 0
cmd_clear db 'clear', 0
