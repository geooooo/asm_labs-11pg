s_s segment stack "stack"
    	dw 20 dup(?)
s_s ends

info STRUC
	nomer dw 0
	pol db (?) 
	god dw 0
	data_post db '  /  /  '
	data_vipi db '  /  /  '
info ENDS

d_s segment
	k_d dw 0	;���������� ��������� �� ������������ ����
	k_w_d dw 0		;���������� ��������� �������� ����, ������� ���� �������� �� ������������ ����
	g_r dw 0		;��� �������� �������� �� ������ 
	k_m_g dw 0 	;���������� �������� �������� ���� �� ���������� ���� ��������

	mass info <1,'m',1991,'01/12/00','10/07/95'>, <2,'m',1991,'03/07/95','10/07/95'>, <3,'w',1991,'01/12/00','10/07/95'> ;������������� ������ ��������
	
	
	date1	db	'01/12/00'
	date2	db	'10/07/95'
d_s ends

c_s segment
	assume ss:s_s,ds:d_s,cs:c_s
begin:
	mov ax,d_s
	mov ds,ax  
	mov es, ax
	mov bx,type info	;� bx �������� ������ ��������� 
	
	lea bp,mass  	;��������� � di ����� ������ �������
 	mov cx,3		;��������� ���� 3 ����

go:	
	push cx
	
	mov	cx, 8
	lea si,ds:[bp].data_post		;���������� � ��������� �����
	lea di,date1				;���������� � ��������� �����
	
	repe cmpsb					;��������� �����
	cmp cx, 0
	jne m1						;���� �� ����� ������� �� ����� m1
	inc k_d						;����� �������� 1 � ���������� ��������� �� ������������ ����
	m1:
	
	cmp ds:[bp].pol,'w'			;���������� ���� ��������� � 'w'
	jne m2			;���� �� ����� ������� �� ����� m2
	
	mov	cx, 8
	lea si,ds:[bp].data_vipi		;���������� � ��������� �����
	lea di,date2			;���������� � ��������� �����
	
	repe cmpsb					;��������� ����� 
	cmp cx, 0
	jne m2						;���� �� ����� ������� �� ����� m2
	inc k_w_d					;����� �������� 1 � ���������� ��������� �������� ����, ������� ���� �������� �� ������������ ����
	m2:

	cmp ds:[bp].nomer,3			;��������� ���� ��������� � ������� 3
	jne m3						;���� �� ����� ������� �� ����� m3
	mov ax,ds:[bp].god				;����� � ax �������� ��� ��������
	mov g_r,ax					; � �� ax ���������� � g_r ��� �������� �������� �� ������ 
	m3:

	cmp ds:[bp].pol,'m'			;���������� ���� ��������� � 'm'
	jne m4						;���� �� ����� ������� �� ����� m4
	
	cmp ds:[bp].god, 1991				;���������� � ��������� �����
	
	jne m4						;���� �� ����� ������� �� ����� m4
	inc k_m_g					;����� �������� 1 � ���������� �������� �������� ���� �� ���������� ���� ��������
	m4:	
	add bp,bx					;��������� � ������ ������ ������� ������ ��������� ����� ������� �� ��������� ������� �������(�� ��������� ���������)
	
	pop	cx
loop go
 
xor dx,dx						;
add k_d,30h						;	
mov dx,k_d						;����� ���������� ��������� �� ������������ ����
mov ah,2h						;
int 21h							;
 
 
 
xor dx,dx						;
add k_w_d,30h					;
mov dx,k_w_d					;����� ���������� ��������� �������� ����, ������� ���� �������� �� ������������ ����
mov ah,2h						;
int 21h							;
 
xor dx,dx						;
add g_r,30h						;
mov dx,g_r						;������ ��� �������� �������� �� ������(��� ������ ������� ������ �������������� (9h))
mov ah,2h						;
int 21h							;
 
xor dx,dx						;
add k_m_g,30h					;
mov dx,k_m_g					;����� ���������� �������� �������� ���� �� ���������� ���� ��������
mov ah,2h						;
int 21h							;
 
 
 

mov ah, 4ch       
int 21h           
c_s ends
end begin