.model	tiny
.code
org		100h
.186

start:

	mov		ax, 12h
	int		10h
	mov		ax, 0
	int		33h
	mov		ax, 1
	int		33h
	
	mov		ax, 000ch
	mov		cx, 0002h
	mov		dx, offset handler
	int		33h
	
	mov		ah, 0
	int		16h
	mov		ax, 000ch
	mov		cx, 0000h
	int		33h
	mov		ax, 3h
	int		10h
	ret
	
handler:

	push	0a000h
	pop		es
	push	cs
	pop		ds
	push	cx
	push	dx
	
	mov		ax, 2
	int		33h
	
	cmp		word ptr previous_x, -1
	je		first_point
	
	call	line_bresenham

exit_handler:
	
	pop		dx
	pop		cx
	mov		previous_x, cx
	mov		previous_y, dx
	
	mov		ax, 1
	int		33h
	
	retf
	
first_point:

	call	putpixel1b
	jmp		short exit_handler
	
line_bresenham:

	mov		ax, cx
	sub		ax, previous_x
	jns		dx_pos
	neg		ax
	mov		word ptr x_increment, 1
	jmp		short dx_neg
	
dx_pos:

	mov		word ptr x_increment, -1
	
dx_neg:

	mov		bx, dx
	sub		bx, previous_y
	jns		dy_pos
	neg		bx
	mov		word ptr y_increment, 1
	jmp		short dy_neg

dy_pos:
	
	mov		word ptr y_increment, -1

dy_neg:
	
	shl		ax, 1
	shl		bx, 1
	
	call	putpixel1b
	
	cmp		ax, bx
	jna		dx_le_dy
	mov		di, ax
	shr		di, 1
	neg		di
	add		di, bx

cycle:

	cmp		cx, word ptr previous_x
	je		exit_bres
	cmp		di, 0
	jl		fractlt0
	
	add		dx, word ptr y_increment
	sub		di, ax
	
fractlt0:

	add		cx, word ptr x_increment
	add		di, bx
	call	putpixel1b
	jmp		short cycle
	
dx_le_dy:

	mov		di, bx
	shr		di, 1
	neg		di
	add		di, ax

cycle2:
	
	cmp		dx, word ptr previous_y
	je		exit_bres
	cmp		di, 0
	jl		fractlt02
	add		cx, word ptr x_increment
	sub		di, bx
	
fractlt02:
	
	add		dx, word ptr y_increment
	add		di,	ax
	call	putpixel1b
	jmp		short cycle2
	
exit_bres:

	ret
	
putpixel1b:

	pusha
	xor		bx, bx
	imul	ax, ax, 80
	push	cx
	shr		cx, 3
	add		ax, cx
	mov		di, ax
	mov		si, di
	
	pop		cx
	mov		bx, 0080h
	and		cx, 07h
	
	shr		bx, cl
	
	lods	es:byte ptr some_label
	or		ax, bx
	
	stosb	
	popa
	ret

	previous_x		dw		-1
	previous_y		dw		-1
	x_increment		dw		-1
	y_increment		dw		-1
	
some_label:

end start