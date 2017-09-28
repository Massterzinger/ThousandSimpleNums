.386
.model flat, stdcall
option casemap: none
include D:\Programs\masm32\include\windows.inc
include D:\Programs\masm32\include\user32.inc
include D:\Programs\masm32\include\kernel32.inc
includelib D:\Programs\masm32\lib\user32.lib
includelib D:\Programs\masm32\lib\kernel32.lib

SSIZE equ 1000
BSIZE equ 5
RCOUNTT equ 4

.data
data32d DWORD ?
data32c DWORD ?
rCount WORD ?
ifmt db "%d",0
buf db BSIZE dup (?)
crlf db 0dh, 0ah
stdout dd ?
cWritten dd ?

.data?
smpl dd SSIZE dup(?)

.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov stdout, eax
    mov rCount, RCOUNTT; ConsoleOutputCounter
    mov ebx,3
    mov edi,0
    mov ebp, 0
    nxtdig:
        mov edx,0
        mov eax, ebx
        mov ecx, ebx

	push eax
	push edx
	push esi
	mov edx, 0
	mov eax, ecx
	mov esi, 2
	div esi
	pop esi
	pop edx
	mov esi, eax
	pop eax

        sub ecx, 2
        mov esi, 2
        nxtpr:
            div esi
            cmp edx, 0
            jz skip
            mov edx, 0
            mov eax, ebx
            inc esi
            loop nxtpr
        mov smpl [edi], ebx

        mov data32c, ecx
        mov data32d, ebx
        invoke wsprintf, ADDR buf, ADDR ifmt, ebx
        invoke WriteConsoleA, stdout, ADDR buf, BSIZE, ADDR cWritten, NULL
        cmp rCount, 1
        jz NewLineCode
        dec rCount
        jmp AfterNewLine
        NewLineCode:
            invoke WriteConsoleA, stdout, ADDR crlf, 2, ADDR cWritten, NULL
            mov rCount, RCOUNTT
        AfterNewLine:
        mov ecx, data32c
        mov ebx, data32d

        inc ebp
        cmp ebp, SSIZE
        jz done
        add edi, 4
        skip:
            inc ebx
            jmp nxtdig
        done:
            invoke ExitProcess, 0
end start

