;*********************************
;	 ������������ ������ �1   ;
;*********************************
.model	small
assume  ES:D_S, DS:D_S, CS:C_S, SS:S_S
D_S segment memory 'data'
	x		db	10d		; 1-�� ����������-�������
	y		db	27d		; 2-�� ����������-�������
	rsum		db	0		; ���������� �����
	rsub		db	0		; ��������� ���������
	rmul		dw	1		; ��������� ������������
	c		db	?		; ������� �� �������
	o		db	?		; ������� �� �������	
	example		db	1111b		; ������ ������� ��������� ��������
D_S ends
S_S segment stack 'stack'
S_S ends
C_S segment private 'code'
start:
	; ������������� ���������� ���������
	mov		ax, D_S
	mov		ds, ax
	mov		es, ax
	; 1.3
	mov	al,   x
	add	al,   y
	mov	rsum, al  				
	; 1.4
	mov	al,   x
	sub	al,   y
	mov	rsub, al
	; 1.5
	mov	al,   y
	neg	al 
	mov	ah,   x
	sub	ah,   al	
	mov	rsub, ah
	; 1.6
	; � ������ �����
	mov	ah,   y
	neg	ah
	mov	al,   x
	imul	ah
	mov	rmul, ax
	; ��� ����� �����
	mov	rmul, 0					; ��� ����������� � ���������
	mov	ah,   y
	neg	ah
	mov	al,   x
	mul	ah     
	mov	rmul, ax
	; 1.7        
	mov	al, y
	xor	ah, ah
	mov	bl, x
	div	bl
	mov	c,  al
	mov	o,  ah
	; 1.8
	mov	ah, y
	or	ah, 1100b
	not	ah
	and	ah, 00011111b
	; 1.9
	mov	bl, x
	mov	bh, ah
	xor	bh, bl
	; Exit
	mov	ax, 4c00h
	int	21h
C_S ends
end start
