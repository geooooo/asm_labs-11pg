;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Вывод таблицы ASCII символов  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



.model tiny

sseg segment
assume cs:sseg, ds:sseg, es:sseg, ss:sseg
org 100h
start:
	
	; Установка текстового 16 цветного видеорежима 80x25 и чистка экрана 
	
	mov			ax, 3h
	int			10h
	
	; Установка видеостраницы 0
	
	mov			ax, 500h
	int			10h
	
	; Формирование таблицы символов в памяти
	
	mov			al, 1					; Коды символов 1..255
	mov			cx, 255
	mov			di, offset ctable		; Помещаем сиволы в заданную таблицу
	cld
	
load_ctable:

	stosb
	inc			al						; Получаем код следующего символа
	loop		short load_ctable
		
	; Отрисовка заголовка таблицы
	
	;mov			ax, 1300h				; Функция вывода строки
	 mov			bx, 11111b				; Белый символ на тёмно-синем фоне
	;mov			cx, caption_len			; Длинна строки
	;xor			dh, dh					; Вывод заголовка в левом верхнем углу
	;xor			dl, dl					
	;mov			bp, offset caption		
	;int			10h	
	
	; Отрисовка таблицы символов
	mov			ah, 0ah					; Функция вывода символа
	mov			cx, 1					; Число повторений символа
	mov			si, offset ctable
	
out_chr:
	
	
	lodsb
	int			10h
	cmp			al, 255
	jnz			short out_chr
	
	; Ожидание нажатия любой клавиши

	mov			ah, 10h
	int			16h
	
	;mov			al, ' '
	;int			10h
	
	
	ret
	
	
	
	caption		db		"ASCII TABLE"	; Заголовок таблицы
	caption_len	equ		$-caption		; Длинна заголовка таблицы 
	ctable		db		255 dup(?)		; Буфер для хранения символов

sseg ends
end start