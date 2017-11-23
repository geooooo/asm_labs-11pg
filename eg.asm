s_s segment stack "stack" 
dw 12 dup(?) 
s_s ends 

d_s segment 
x db 12 dup(?),0ah,0dh,"$" 
y db 12 dup(?),0ah,0dh,"$" 
d_s ends 

c_s segment 
assume ss:s_s,ds:d_s,cs:c_s 
begin: 
mov ax,d_s 
mov ds,ax 
mov si,0 
L1: mov ah,01h 
int 21h 
cmp al,13d 
je L3 
mov x[si],al 
sub x[si],30h 
add bl,x[si] 
add x[si],30h 
inc si 
jmp L1 
L3: 

mov ah,9h 
lea dx,x 
int 21h 
mov ah,9h 
lea dx,y 
int 21h 
mov dl,bl 
L7: cmp dl,9h 
jng L4 
cmp dl,15 
jng L6 
mov bl,dl 
and bl,00001111b 
shr dl,4 
add dl,30h 
mov ah,02h 
int 21h 
mov dl,bl 
jmp L7 
mov dl,bl 
mov ah,02 
jmp L5 
L6: add dl,37h 
jmp L5 
L4: add dl,30h 
L5: mov ah,02 
int 21h 

mov ah,4ch 
int 21h 
int 20h 
c_s ends 
end begin