; Лабораторная работа 6


S_S segment stack
	db	100h dup(?)		; Резервируем память
S_S ends


D_S segment

	; Содержит информацию о пациенте
	Person struc
		card_number		db		0			; Номер медкарты
		gender			db		?			; Пол
		birthyear		dw		0			; Год рождения
		date_in			db		11 dup(?)	; Дата поступления
		date_out		db		11 dup(?)	; Дата выписки
	Person ends
	
	; Описание пациентов
	psn1	Person		<0, 'm', 1970, '30.02.1990$', '08.12.1984$'>
	psn2	Person		<1, 'f', 2000, '30.02.1990$', '10.10.2005$'>
	psn3	Person		<2, 'm', 2000, '01.10.2005$', '10.10.2005$'>
	
	; Сообщения-приглашения для ввода
	msg_inp_date		db		0ah,0dh,'Input date: $'
	msg_count_psn		db		0ah,0dh,'Person count: $'
	msg_inp_year		db		0ah,0dh,'Input year: $'
	msg_inp_card_number db		0ah,0dh,'Input card number: $'
	
	date		db		11, 0, '**.**.****$'		; Дата в формате: **.**.****
	
D_S ends


C_S segment
assume ss:S_S, cs:C_S, ds:D_S, es:D_S
start:

	; Инициализация сегментных регистров
	mov		ax, D_S
	mov		ds, ax
	mov		es, ax
	
	; Вывод сообщения-приглашения к вводу даты
	mov		ah, 09h
	mov		dx, offset msg_inp_date
	int		21h
	; Ввод даты, для подсчёта поступивших пациентов
	; Ввод надо осуществлять в строгом формате: **.**.**** без лишних пробелов
	mov		ah, 0ah
	mov		dx, offset date
	int		21h
	; Подсчёт количества пациентов, поступивших на введённую дату
	; cx - количество символов в дате
	xor		bx, bx				; Количество пациентов, поступивших на введённую дату изначально 0
	; Сравнение введённой даты с датой поступления 1-ого пациента
	mov		si, offset date+2	; Сравниваемая введёная дата
	mov		di, offset psn1.date_in
	mov		cx, 10
	repe	cmpsb
	; Если cx > 0, то даты не совпадают
	cmp		cx, 0
	ja		CMP_DATE_PSN2		; Если cx > 0
	inc		bx					; Если cx = 0
CMP_DATE_PSN2:
	; Сравнение введённой даты с датой поступления 2-ого пациента
	mov		si, offset date+2	; Сравниваемая введёная дата
	mov		di, offset psn2.date_in
	mov		cx, 10
	repe	cmpsb
	; Если cx > 0, то даты не совпадают
	cmp		cx, 0
	ja		CMP_DATE_PSN3		; Если cx > 0
	inc		bx					; Если cx = 0
CMP_DATE_PSN3:
	; Сравнение введённой даты с датой поступления 3-ого пациента
	mov		si, offset date+2	; Сравниваемая введёная дата
	mov		di, offset psn3.date_in
	mov		cx, 10
	repe	cmpsb
	; Если cx > 0, то даты не совпадают
	cmp		cx, 0
	ja		CMP_PSN_COUNT_OUT	; Если cx > 0
	inc		bx					; Если cx = 0
CMP_PSN_COUNT_OUT:
	; Вывод количества пациентов, поступивших на введённую дату
	; Вывод сообщения
	mov		ah, 09h
	mov		dx, offset msg_count_psn
	int		21h
	; Вывод количества
	add		bx, '0'				; Преобразование числа в символ
	mov		ah, 06h
	mov		dl, bl
	int		21h
	
	; Вывод сообщения-приглашения к вводу даты
	mov		ah, 09h
	mov		dx, offset msg_inp_date
	int		21h
	; Ввод даты, для подсчёта количества пациентов-женщин, выписанных в заданное время
	; Ввод надо осуществлять в строгом формате: **.**.**** без лишних пробелов
	mov		ah, 0ah
	mov		dx, offset date
	int		21h
	; Подсчёт количества пациентов-женщин, выписанных в заданное время
	; cx - количество символов в дате
	xor		bx, bx				; Количество пациентов-женщин, выписанных в заданное время изначально 0
	; Проверка, что 1-ый пациент - женщина
	cmp		psn1.gender, 'f'
	jnz		CMP_DATE_FPSN2		; Если psn1.gender != 'f'
	; Сравнение введённой даты с датой выписки 1-ого пациента
	mov		si, offset date+2	; Сравниваемая введёная дата
	mov		di, offset psn1.date_out
	mov		cx, 10
	repe	cmpsb
	; Если cx > 0, то даты не совпадают
	cmp		cx, 0
	ja		CMP_DATE_FPSN2		; Если cx > 0
	inc		bx					; Если cx = 0
CMP_DATE_FPSN2:
	; Проверка, что 2-ой пациент - женщина
	cmp		psn2.gender, 'f'
	jnz		CMP_DATE_FPSN3		; Если psn2.gender != 'f'
	; Сравнение введённой даты с датой выписки 1-ого пациента
	mov		si, offset date+2	; Сравниваемая введёная дата
	mov		di, offset psn2.date_out
	mov		cx, 10
	repe	cmpsb
	; Если cx > 0, то даты не совпадают
	cmp		cx, 0
	ja		CMP_DATE_FPSN3		; Если cx > 0
	inc		bx					; Если cx = 0
CMP_DATE_FPSN3:
	; Проверка, что 3-ий пациент - женщина
	cmp		psn3.gender, 'f'
	jnz		CMP_FPSN_COUNT_OUT	; Если psn3.gender != 'f'
	; Сравнение введённой даты с датой выписки 1-ого пациента
	mov		si, offset date+2	; Сравниваемая введёная дата
	mov		di, offset psn3.date_out
	mov		cx, 10
	repe	cmpsb
	; Если cx > 0, то даты не совпадают
	cmp		cx, 0
	ja		CMP_FPSN_COUNT_OUT	; Если cx > 0
	inc		bx					; Если cx = 0
CMP_FPSN_COUNT_OUT:
	; Вывод количества пациентов-женщин, выписанных в заданное время
	; Вывод сообщения
	mov		ah, 09h
	mov		dx, offset msg_count_psn
	int		21h
	; Вывод количества
	add		bx, '0'				; Преобразование числа в символ
	mov		ah, 06h
	mov		dl, bl
	int		21h
	
	; Поиск года рождения по номеру медкарты
	; Вывод сообщения-приглашения к вводу номера карты
	; Результат в dx, 0 - год рождения не был найден
	mov		ah, 09h
	mov		dx, offset msg_inp_card_number
	int		21h
	xor		dx, dx
	; Ввод номера медкарты
	mov		ah, 01h
	int		21h			; al - номер карты
	sub		al, '0'		; Преобразование символа в число
	; Сравнение введённого номера медкарты с номерами карт пациентов
	; Пациент 1
	cmp		psn1.card_number, al
	jnz		CMP_CNUM_PSN2		; Если psn1.card_number != al
	; Иначе номера совпали
	mov		dx, psn1.birthyear
CMP_CNUM_PSN2:	
	; Пациент 2
	cmp		psn2.card_number, al
	jnz		CMP_CNUM_PSN3		; Если psn2.card_number != al
	; Иначе номера совпали
	mov		dx, psn2.birthyear
CMP_CNUM_PSN3:	
	; Пациент 3
	cmp		psn3.card_number, al
	jnz		CMP_CNUM_END		; Если psn3.card_number != al
	; Иначе номера совпали
	mov		dx, psn3.birthyear
CMP_CNUM_END:

	; Поиск количество пациентов мужского пола по указанному году рождения
	; dx - год рождения, по которому осуществляется поиск
	mov		dx, 1970
	xor		cx, cx				; Количество пациентов, изначально 0
	; Пациент 1
	; Является ли пациент мужчиной
	cmp		psn1.gender, 'm'
	jnz		CMP_YEAR_PSN2		; psn1.gender != 'm'
	cmp		psn1.birthyear, dx
	jnz		CMP_YEAR_PSN2		; psn1.birthyear != dx
	inc		cx					; Нашли подходящего пациента
CMP_YEAR_PSN2:
	; Пациент 2
	; Является ли пациент мужчиной
	cmp		psn2.gender, 'm'
	jnz		CMP_YEAR_PSN3		; psn2.gender != 'm'
	cmp		psn2.birthyear, dx
	jnz		CMP_YEAR_PSN3		; psn2.birthyear != dx
	inc		cx					; Нашли подходящего пациента
CMP_YEAR_PSN3:
	; Пациент 3
	; Является ли пациент мужчиной
	cmp		psn3.gender, 'm'
	jnz		CMP_YEAR_END		; psn3.gender != 'm'
	cmp		psn3.birthyear, dx
	jnz		CMP_YEAR_END		; psn3.birthyear != dx
	inc		cx					; Нашли подходящего пациента
CMP_YEAR_END:
	; cx - результат
	
	; Завершение программы
	mov		ax, 4c00h
	int		21h

C_S ends
end start