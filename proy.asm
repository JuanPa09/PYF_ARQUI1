include mproy.asm
include mvproy.asm

.model LARGE
.stack 100h
.data
barras db 0ah,0dh, '=====================================================',0ah,0dh,"$"
datos db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',
	   0ah,0dh, "FACULTAD DE INGENIERIA",
	   0ah,0dh, "CIENCIAS Y SISTEMAS",
	   0ah,0dh, "CURSO: ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1",
	   0ah,0dh, "NOMBRE: JUAN PABLO ARDON LOPEZ",
	   0ah,0dh, "CARNET: 201700450","$"

opciones db 0ah,0dh,0ah,0dh, "1) INGRESAR",
			0ah,0dh, "2) REGISTRAR",
			0ah,0dh, "3) SALIR",
			0ah,0dh, "ESCOJA OPCION: $"

adminop db 0ah,0dh,0ah,0dh, "1) TOP 10 PUNTOS",
			0ah,0dh, "2) TOP 10 TIEMPOS",
			0ah,0dh, "3) SALIR",
			0ah,0dh, "ESCOJA OPCION: $"

otipo	db 0ah,0dh,0ah,0dh, "1) ASCENDENTE",
			0ah,0dh, "2) DESCENDENTE",
			0ah,0dh, "ESCOJA OPCION: $"

edel	db 0ah,0dh,0ah,0dh, "INGRESE VELOCIDAD 0 - 9",
			0ah,0dh, "ESCOJA OPCION: $"

msmError1 	db 0ah,0dh,'Error al abrir archivo','$'
msmError2 	db 0ah,0dh,'Error al leer archivo','$'
msmError3 	db 0ah,0dh,'Error al crear archivo','$'
msmError4 	db 0ah,0dh,'Error al Escribir archivo','$'
msmRutaU	db 10,13, 'Ruta Archivo Usuarios: $'
msmRutaL	db 10,13, 'Ruta Archivo Datos: $'

ff db 10,13,"CF: $"

handleFichero dw ?
rutaArchivo db 15 dup('$')

eusuario db 10,13,"Usuario Encontrado!$",10,13,"$"
nusuario db 10,13,"Usuario No Encontrado!",10,13,"$"
econtrasena db 10,13,"Contrasena Correcta!",10,13,"$"
ncontrasena db 10,13,"Contrasena Incorrecta!",10,13,"$"
usrep		db 10,13,"Usuario Repetido",10,13,"$"
usreg		db 10,13,"Usuario Registrado Con Exito!$"
topptsTag 	db 10,13,"					Top 10 Puntos$"
toptpsTag 	db 10,13,"					Top 10 Tiempo$"
esadmintag 	db 10,13,"Accediste como admin $"

pusuario db 10,13,"Usuario: $"
pcontrasena db 10,13,"Contrasena: $"

ejuego db "   N1   00:00:00   00$"

;yt	db 10,13,"Estas aqui $"

valusuario db 15 dup('$')
valcontrasena db 15 dup('$')

datausuarios 	db 200 dup('$')
;datagame		db 200 dup('$')

lengthh db 3 dup('$')

usadmin db 10 dup('$')
conadmin db 5 dup('$')

;=============VARIABLES ORDENAMIENTO=============
ordenamiento db 200 dup('$') ; Arreglo que contiene los numeros que seran ordenados


;============Numeros Del Ordenamiento===============
num db 10 dup('$')

;===========================Tableros=======================
;320 x 200 pixeles = 64,000 pixeles
tabadmin db 1 dup('$')
atab     db 64000	dup('$')

pelota db 4 dup('$')
;[x]
;[y]
;[mov x]
;[mov y]
.code

	main proc

		;LEER DATOS DEL ARCHIVO USUARIOS Y PASARLOS A LA VARIABLE DATAUSUARIOS
		print msmRutaU
		saveData rutaArchivo
		abrirF rutaArchivo,handleFichero
		leerF SIZEOF datausuarios,datausuarios,handleFichero
		cerrarF handleFichero

		mov rutaArchivo,'$'
		;print msmRutaL
		;saveData rutaArchivo
		;abrirF rutaArchivo,handleFichero
		;leerF SIZEOF datagame,datagame,handleFichero
		;cerrarF handleFichero

		;print datagame
		;getChar


		MENU:
			print datos
			print barras
			print opciones
			getChar
			cmp al,'1'
			je INGRESAR
			cmp al,'2'
			je REGISTRAR
			cmp al,'3'
			je SALIR
			cmp al,'4'
			je ESUSUARIO
			jmp MENU

		INGRESAR:
		;PEDIR DATOS
		print pusuario
		saveData valusuario
		print pcontrasena
		saveData valcontrasena
		verificarUsAdmin ; Verifica si es un admin
		buscarUsuario valusuario,datausuarios ;Busca el usuario en el arreglo correspondiente
		getChar

		jmp MENU

		ESUSUARIO:
		
		;mov atab[0],'1'
		;mov atab[1],'1'
		;mov atab[2],'1'
		;mov atab[3],'1'
		;mov atab[4],'1'
		;mov atab[5],'1'
		;showString atab[0],num
		mov ordenamiento[0],'1'
		mov ordenamiento[1],'8'
		mov ordenamiento[2],','
		mov ordenamiento[3],'9'
		mov ordenamiento[4],','
		mov ordenamiento[5],'4'
		mov ordenamiento[6],'7'
		mov ordenamiento[7],','
		mov ordenamiento[8],'5'
		mov ordenamiento[9],'2'

		;COSAS ADMIN
		;call ordenarBurbujaAscendente
		;call mostrarBarras
		;jmp MENU


		call pantallajuego
		
		;poscursornums  ;SOLO SE LLAMA PARA PONER EL CURSOR EN LA PARTE DE ABAJO PARA LOS NUMEROS DE LAS BARRAS
		;PENDIENTE -> crearBarras 0E10Fh,0E11Eh,64h,00h ; LLENA ARREGLO PARA LA CREACION DE BARRAS (POS INICIAL BARRAS, POS FINAL BARRAS, ALTURA, INDEX ORDENAMIENTO)
		
		jmp MENU

		ESADMIN:
		print barras
		print adminop
		getChar
		cmp al,'1'
		je TOPPTS
		cmp al,'2'
		je TOPTPS
		cmp al,'3'
		je MENU
		jmp ESADMIN

		TOPPTS:
		print barras
		print otipo
		getChar
		cmp al,'1'
		je DOASCENDENTE
		cmp al,'2'
		je DODESECENDENTE
		;====NUMEROS PRUEBA====
		mov ordenamiento[0],'1'
		mov ordenamiento[1],'8'
		mov ordenamiento[2],','
		mov ordenamiento[3],'9'
		mov ordenamiento[4],','
		mov ordenamiento[5],'4'
		mov ordenamiento[6],'7'
		mov ordenamiento[7],','
		mov ordenamiento[8],'5'
		mov ordenamiento[9],'2'

		call ordenarBurbujaAscendente
		jmp ESADMIN

		TOPTPS:

		DOASCENDENTE:
			print edel
			getChar
			jmp EMPEZARORDENAMIENTO
		DODESECENDENTE:
			print edel
			getChar
			jmp EMPEZARORDENAMIENTO

		EMPEZARORDENAMIENTO:
			getChar
			jmp ESADMIN

		ErrorAbrir:
			print msmError1
			jmp MENU

		ErrorLeer:
			print msmError2
			jmp MENU


		REGISTRAR:
			;PEDIR DATOS
			print pusuario
			saveData valusuario
			print pcontrasena
			saveData valcontrasena
			usuariorepetido valusuario,datausuarios
			jmp MENU

		SALIR:
			MOV ah,4ch
			int 21h

	main endp

	ordenarBurbujaDescendente proc
		xor si,si
		xor di,di
		xor ax,ax
		xor bx,bx
		xor cx,cx	

		call buscarNumeros
		call mostrarBarras	;IMPRIME LAS BARRAS POR PRIMERA VEZ
		xor si,si
		
		INICIO:
			xor ax,ax
			xor bx,bx
			mov al,ordenamiento[si]
			mov bl,ordenamiento[si+1]
			cmp al,'$'
			je FIN
			cmp bl,'$'
			je FIN
			esMenor ax,bx,INTERCAMBIAR	;SI BX ES MAYOR QUE AX SALTARA A INTERCAMBIAR
			inc si
			jmp INICIO

		INTERCAMBIAR:
			mov ordenamiento[si],bl
			mov ordenamiento[si+1],al
			inc cx						;Hubo Intercambio
			inc si
			call mostrarBarras			;IMRPIMIR BARRAS DESPUES DE CADA INTERCAMBIO
			jmp INICIO

		IDN:
			;EMPEZAR NUEVO CICLO
			call mostrarBarras
			xor cx,cx
			xor si,si
			jmp INICIO

		FIN:
		cmp cx,00h
		jne IDN
		;showString ordenamiento[0],num
		;showString ordenamiento[1],num
		;showString ordenamiento[2],num
		;showString ordenamiento[3],num
		ret
	ordenarBurbujaDescendente endp

	ordenarBurbujaAscendente proc
		xor si,si
		xor di,di
		xor ax,ax
		xor bx,bx
		xor cx,cx	

		call buscarNumeros
		call mostrarBarras ;IMPRIME EL TABLERO LA PRIMERA VEZ
		xor si,si
		
		INICIO:
			xor ax,ax
			xor bx,bx
			mov al,ordenamiento[si]
			mov bl,ordenamiento[si+1]
			cmp al,'$'
			je FIN
			cmp bl,'$'
			je FIN
			esMayor ax,bx,INTERCAMBIAR	;SI BX ES MAYOR QUE AX SALTARA A INTERCAMBIAR
			inc si
			jmp INICIO

		INTERCAMBIAR:
			mov ordenamiento[si],bl
			mov ordenamiento[si+1],al
			inc cx						;Hubo Intercambio
			inc si
			call mostrarBarras			;IMRPIMIR BARRAS DESPUES DE CADA INTERCAMBIO
			jmp INICIO

		IDN:
			;EMPEZAR NUEVO CICLO
			call mostrarBarras
			xor cx,cx
			xor si,si
			jmp INICIO

		FIN:
		cmp cx,00h
		jne IDN
		;showString ordenamiento[0],num
		;showString ordenamiento[1],num
		;showString ordenamiento[2],num
		;showString ordenamiento[3],num
		ret
	ordenarBurbujaAscendente endp

	buscarNumeros proc
		;BUSCA LOS NUMEROS QUE SE VAN A COMPARAR Y LOS INGRESA AL ARRAY ORDENAMIENTO EN FORMA ASCII PARA PODER SER OPERADOS
			mov num,'$'
			xor di,di
			xor cx,cx

			ENUM:
				cmp ordenamiento[si],','
				je INPILA					;Si encuentra coma ingresa el numero a la pila ya convertido en ascii
				cmp ordenamiento[si],'$'
				je INPILA					
				mov al,ordenamiento[si]
				mov num[di],al
				xor al,al
				inc di
				inc si
				jmp ENUM

			INPILA:
				xor ax,ax 					;Limpiar AX
				convertirascii num 			;convertirascii
				push AX 					;Se ingresa a la pila
				cleararray num				;Se limpia num
				xor di,di 					;Se regresa a la posicion 0
				inc si
				cmp ordenamiento[si],'$'
				je LO					;LLEGA A FIN DE ORDENAMIENTO
				xor ax,ax
				inc cx
				jmp ENUM

			LO:
				;LIMPIAR ORDENAMIENTO YA QUE SERVIRA COMO ARREGLO PARA LA COMPOSICION DE LOS NUMEROS EN LA PILA
				cleararray ordenamiento



			OUTPILA:
				;LOS NUMEROS ESTAN AL REVES EN LA PILA, AQUI SE CORRIGE EL ORDEN
				mov di,cx;
				xor ax,ax
				pop AX
				mov ordenamiento[di],AL
				loop OUTPILA
				pop AX
				mov ordenamiento[0],AL
			ret
		buscarNumeros endp

		iniciarTableroAdmin proc
			;Pintar toda la fila 3
			;Pintar columna 3 y 357
			;pintar toda la fila 197
			;si llevara el conteo del array
			xor si,si
			;dx llevara el conteo de la columna
			xor dx,dx
			;Dejar las tres filas de arriba libres que seria 320 * 3 = 960 + 10 espacios de margen que es 970 que es 3CA en hexadecimal
			mov si,3CAh
			INICIO:
			cmp dx,12Bh			;Fin de Columna -> 319 - 10 = 309 - 10 espacios del margen inicial = 299 = 135  en hexadecimal
			je NI
			mov atab[si],'1'
			inc si
			inc dx
			jmp INICIO

			NI:
			xor dx,dx
			;POSICIONAR SI EN EL PRIMER PIXEL DE COLUMNA QUE HAY QUE PINTAR QUE SERIA (320 * 4) + 10 = 50A en hexadecimal
			mov si,50Ah
			;EL ULTIMO PIXEL ES 299 = 135 EN hexadecimal

			PINTARCOLUMNA:
			;COMPROBAR QUE NO SEA EL FIN DE LOS MARGENES DE LOS LADOS
			cmp si,0F50Ah	;ULTIMA POSICION PARA PINTAR MARGENES LATERALES = 320(199-3)+10 = 62,730 = OF50Ah 
			je PINTARFILA
			;PINTAR PRIMER PIXEL
			mov atab[si],'1'
			;MOVER SI A ULTIMA POSICION -> POS EN SI + 298
			add si,12Ah
			;PINTAR ULTIMO PIXEL
			mov atab[si],'1'
			;MOVER SI HASTA PRIMERA POSICION DE LA SIGUIENTE FILA. SUMAR LAS 22 POSICIONES A SI
			add si,16h
			mov atab[si],'1'
			jmp PINTARCOLUMNA
			
			PINTARFILA:
			cmp dx,12Bh			;Fin de Columna -> 319 - 10 = 309 - 10 espacios del margen inicial = 299 = 135  en hexadecimal
			je SALIR
			mov atab[si],'1'
			inc si
			inc dx
			jmp PINTARFILA

			SALIR:		
			ret
		iniciarTableroAdmin endp

		;barras proc
			;OBTENER EL NUMERO DE ELEMENTOS EN EL ARREGLO ORDENAMIENTO Y MULTIPLICAR EL VALOR POR DOS PARA LOS ESPACIOS
			;HACER LA DIVISION PARA VER LAS POSICIONES DE LOS ELEMENTOS
			;MANDAR A LLAMAR A MACRO ENVIANDOLE COMO PARAMETRO EL NUMERO DE ELEMENTOS (INCLUIDOS LOS ESPACIOS)
		;barras endp

	
	armarBarra proc
		;OBTENER TAMANIO DE ARREGLO ORDENAMIENTO
		getlength ordenamiento ;EL TAMANIO QUEDA GUARDADO EN CL COMO ASCII
		;mov lengthh,cl
		;showString lengthh,num
		xor dx,dx
		mov dl,cl 		;DL GUARDA EL LENGTH DE ORDENAMIENTO

		;MULTIPLICAR RESULTADO POR 2 PARA QUE HAYAN ESPACIOS
		mov al,02h
		imul cl
		mov cl,al
		;HACER LA DIVISION DE EL TAMANIO COMPLETO (289 = 0121H ) ENTRE EL NUMERO DE ELEMENTOS EN EL ARRAY
		;ESTO DEVUELVE LA CANTIDAD DE UNIDADES QUE HAY QUE AUMENTAR PARA PONER LA SIGUIENTE BARRA
		mov ax,0121h
		idiv cl
		;mov lengthh,al
		;showString lengthh,num
		mov cl,al 		;EL RESULTADO DE LA LONGITUD ESTA EN CL

			xor di,di 		;DI MANEJA EL INDICE del ordenamiento
			mov ax,0E10Fh ;POSICION INICIAL DONDE COMIENZAN LAS BARRAS
			;CREAR BARRAS
			CB:
			cmp di,dx
			je FIN 
			mov bx,ax
			add bx,cx
			crearBarras ax,bx,ordenamiento[di],di
			;AUMENTAR TAMANIO A LA SIGUIENTE POSICION DE BARRA
			inc di
			mov ax,bx
			add ax,cx
			;REPETIR HASTA EL ULTIMO ELEMENTO
			jmp CB
			FIN:
		ret
	armarBarra endp

	mostrarBarras proc
		call iniciarTableroAdmin 		;PINTA LOS PIXELES DEL MARCO EN ARRAY atab
		call armarBarra					;ARMA TODAS LAS BARRAS 
		modovideo						;Cambiar A MODO VIDEO
		pintarTablero atab				;PINTA LOS PIXELES QUE SE LLENARON ANTERIORMENTE EN EL ARREGLO
		call mostrarNumeros
		;printOrdenamiento ordenamiento[0]
		esperarTecla
		modoLectura						;CAMBIAR A MODO LECTURA
		cleararray atab
		ret
	mostrarBarras endp

	mostrarNumeros proc
		xor si,si
		xor ax,ax
		xor cx,cx
		irLectura
		getlength ordenamiento ;Length guardado en cl
		irVideo
		poscursornums
		mov ax,cx
		;xor cx,cx
		;jmp FIN
		INIT:
			printOrdenamiento ordenamiento[si]
			inc si
			cmp si,ax
			je FIN
			call aumentarCursor
			call aumentarCursor
			jmp INIT

		FIN:

	mostrarNumeros endp





	pantallajuego proc
		cleararray atab
		call marcojuego
		call initbarra

		

		mov pelota[0],08ch 		;coordenada x
		mov pelota[1],0A0h		;coordenada y
		mov pelota[2],01h 		;movimiento x
		mov al,01h
		neg al
		mov pelota[3],al 		;movimiento y

		modovideo
		pixel 08ch,0A0h,0Fh ;LINEA 140 = 8C Y COLUMNA 160 = A0
		pintarTablero atab
		irLectura
		call tijuego
		call ingame		;INICIA EL JUEGO
		irVideo
		;esperarTecla
		modoLectura
		ret
	pantallajuego endp

	marcojuego proc
		;Pintar toda la fila 3
			;Pintar columna 3 y 357
			;pintar toda la fila 197
			;si llevara el conteo del array
			xor si,si
			;dx llevara el conteo de la columna
			xor dx,dx
			;Dejar las tres filas de arriba libres que seria 320 * 10 = 3200 + 10 espacios de margen que es 3210 que es 3210 en hexadecimal
			mov si,0C8Ah
			INICIO:
			cmp dx,12Bh			;Fin de Columna -> 319 - 10 = 309 - 10 espacios del margen inicial = 299 = 135  en hexadecimal
			je NI
			mov atab[si],'1'
			inc si
			inc dx
			jmp INICIO

			NI:
			xor dx,dx
			;POSICIONAR SI EN EL PRIMER PIXEL DE COLUMNA QUE HAY QUE PINTAR QUE SERIA (320 * 11) + 10 = DCA en hexadecimal
			mov si,0DCAh
			;EL ULTIMO PIXEL ES 299 = 135 EN hexadecimal

			PINTARCOLUMNA:
			;COMPROBAR QUE NO SEA EL FIN DE LOS MARGENES DE LOS LADOS
			cmp si,0F50Ah	;ULTIMA POSICION PARA PINTAR MARGENES LATERALES = 320(199-3)+10 = 62,730 = OF50Ah 
			je PINTARFILA
			;PINTAR PRIMER PIXEL
			mov atab[si],'1'
			;MOVER SI A ULTIMA POSICION -> POS EN SI + 298
			add si,12Ah
			;PINTAR ULTIMO PIXEL
			mov atab[si],'1'
			;MOVER SI HASTA PRIMERA POSICION DE LA SIGUIENTE FILA. SUMAR LAS 22 POSICIONES A SI
			add si,16h
			mov atab[si],'1'
			jmp PINTARCOLUMNA
			
			PINTARFILA:
			cmp dx,12Bh			;Fin de Columna -> 319 - 10 = 309 - 10 espacios del margen inicial = 299 = 135  en hexadecimal
			je SALIR
			mov atab[si],'1'
			inc si
			inc dx
			jmp PINTARFILA

			SALIR:		
			ret
	marcojuego endp

	;=======TITULOS DEL JUEGO=======
	tijuego proc 
		printvideo valusuario
		printvideo ejuego
		;call poscursorpuntaje
		;printvideo pr
		ret
	tijuego endp

	;======POSICION INICIAL BARRA JUEGO====
	initbarra proc
		;POSICIONES DE LA BARRA INICIALES
		;(180*320)+140= 57740
		mov atab[57740],'1'
		mov atab[57741],'1'
		mov atab[57742],'1'
		mov atab[57743],'1'
		mov atab[57744],'1'
		mov atab[57745],'1'
		mov atab[57746],'1'
		mov atab[57747],'1'
		mov atab[57748],'1'
		mov atab[57749],'1'
		mov atab[57750],'1'
		mov atab[57751],'1'
		mov atab[57752],'1'
		mov atab[57753],'1'
		mov atab[57754],'1'
		mov atab[57755],'1'
		mov atab[57756],'1'
		mov atab[57757],'1'


		;INICIAR PELOTA

		;mov atab[54540],'1'


	initbarra endp


;=====================CURSOR=================

	poscursorpuntaje proc
		;POSICIONAR CURSOR EN 20
		mov ah,02h
		xor bx,bx
		mov dh,00h
		mov dl,14h
		int 10h

	poscursorpuntaje endp

		aumentarCursor proc
		push ax
		push dx

		mov ah,03h
		xor bx,bx
		int 10h  	;Busca POSICION DEL CURSOR

		mov ah,02h
		inc DL
		int 10h

		pop dx
		pop ax

		ret
	aumentarCursor endp


	ingame proc


		JUEGO:
			call leertecla
			cmp dx,04h
			je SALIR
			jmp JUEGO
		SALIR:
		ret
	ingame endp

	leertecla proc
		;TECLA A, MOVER IZQUIERDA - 97 en ascii - 61 en hexa
		;TECLA D, MOVER DERECHA - 100 en ascii - 64 en hexa
		;TECLA P, PAUSA - 112 en ascii - 70 en hexa

		mov ah,01h
		int 16h
		jz FIN
		xor ax,ax
		int 16h
		cmp al,70h
		je PAUSA
		cmp al,61h
		je MOVIZQ
		cmp al,64h
		je MOVDER
		cmp al,7Ah;z->122
		je P 
		jmp FIN

		PAUSA:
		mov dx,04h
		jmp FIN

		MOVDER:
		call movimientoderecha
		jmp FIN

		MOVIZQ:
		call movimientoizquierda
		jmp FIN

		P:
		call movimientopelota
		jmp FIN

		FIN:

		ret
	leertecla endp

	movimientoderecha proc
		;BUSCAR PRIMERA POSICION DE COLOR BLANCO
		;SE SABE QUE ESTA EN LA FILA 180  Y 11 DE COLUMNA PARA EVADIR EL MARGEN
		;320*180+11=57611 = E10B
		;HASTA LA POSICION 199-11 -> 57611 + 287 = 57898 

		;COLUMNA 180 (B4), FILA 11
		;COLUMNA 180, FILA 188
		mov si,0Bh ;11 En decimal
		xor di,di
		INICIO:
		cmp si,134h ;320 En decimal
		je FIN
		getpcolor si,0B4h ;si al es 0Fh quiere decir que es la posicion inicial de la barra
		cmp al,0Fh
		je PINTARNEGRO
		inc si
		jmp INICIO
		PINTARNEGRO:
		;pixel si,0B4h,00h
		xor ax,ax
		mov ax,12h 	;LA BARRA TIENE 18 PIXELES = 12h
		add ax,si 	;pos final = 18+si
		push si
			pnegro:
			cmp si,ax
			je IB
			pixel si,0B4h,00h
			inc si
			jmp pnegro
		IB:
			pop si
			inc si
			inc ax
		PINTARBLANCO:
			cmp si,ax
			je FIN
			pixel si,0B4h,0Fh
			inc si
			jmp PINTARBLANCO
		FIN:
		ret
	movimientoderecha endp

	movimientoizquierda proc
		;BUSCAR PRIMERA POSICION DE COLOR BLANCO
		;SE SABE QUE ESTA EN LA FILA 180  Y 11 DE COLUMNA PARA EVADIR EL MARGEN
		;320*180+11=57611 = E10B
		;HASTA LA POSICION 199-11 -> 57611 + 287 = 57898 
		;COLUMNA 180 (B4), FILA 11
		;COLUMNA 180, FILA 188
		mov si,0Bh ;11 En decimal
		xor di,di
		INICIO:
		cmp si,134h ;188 En decimal
		je FIN
		getpcolor si,0B4h ;si al es 0Fh quiere decir que es la posicion inicial de la barra
		cmp al,0Fh
		je PINTARNEGRO
		inc si
		jmp INICIO
		PINTARNEGRO:
		;pixel si,0B4h,00h
		xor ax,ax
		mov ax,12h 	;LA BARRA TIENE 18 PIXELES = 12h
		add ax,si 	;pos final = 18+si
		push si
			pnegro:
			cmp si,ax
			je IB
			pixel si,0B4h,00h
			inc si
			jmp pnegro
		IB:
			pop si
			dec si
			dec ax
		PINTARBLANCO:
			cmp si,ax
			je FIN
			pixel si,0B4h,0Fh
			inc si
			jmp PINTARBLANCO
		FIN:
		ret
	movimientoizquierda endp

	movimientopelota proc
		;PINTAR PIXEL ACTUAL DE NEGRO
		call cambiodireccion
		irLectura
		xor si,si
		xor di,di
		xor ax,ax
		mov al,pelota[0]
		mov si,ax
		mov al,pelota[1]
		mov di,ax
		irVideo
		pixel si,di,00h
		;mover coordenadas de pelota
		irLectura
		xor si,si
		xor di,di
		xor ax,ax
		mov al,pelota[0]
		mov bl,pelota[2]
		add al,bl
		mov pelota[0],al

		mov al,pelota[1]
		mov bl,pelota[3]
		add al,bl
		mov pelota[1],al

		xor ax,ax
		xor bx,bx

		mov al,pelota[0]
		mov si,ax
		mov al,pelota[1]
		mov di,ax
		irVideo
		pixel si,di,0Fh
		ret
	movimientopelota endp

	cambiodireccion proc
		irLectura
		;xor ax,ax
		;mov al,pelota[0]
		;mov si,ax ;X
		;mov al,pelota[1]
		;mov di,ax ;Y
		xor si,si
		xor di,di
		xor ax,ax
		mov al,pelota[0]
		mov si,ax ;X
		mov al,pelota[1]
		mov di,ax ;Y
		irVideo

		
		inc si
		getpcolor si,di ;	VERIFICAR SI HAY OBSTACULO ARRIBA
		cmp al,00h
		jne OAR			;HAY OBSTACULO ARRIBA

		dec si

		dec si
		getpcolor si,di ;VERIFICAR SI HAY OBSTACULO ABAJO
		cmp al,00h
		jne OAB			;HAY OBSTACULO ABAJO

		inc si

		dec di
		getpcolor si,di;VERIFICAR SI HAY OBSTACULO IZQUIERDA
		cmp al,00h
		jne OI			;HAY OBSTACULO IZQUIERDA

		inc di

		inc di
		getpcolor si,di;VERIFICAR SI HAY OBSTACULO DERECHA
		cmp al,00h
		jne OD			;HAY OBSTACULO DERECHA

		jmp FIN

		OAR:
		mov al,01h
		neg al
		irLectura
		mov pelota[2],al
		irVideo
		jmp FIN
		
		OAB:
		mov al,01h
		irLectura
		mov pelota[2],al
		irVideo
		jmp FIN

		OI:
		mov al,01h
		irLectura
		mov pelota[3],al
		irVideo
		jmp FIN

		OD:
		mov al,01h
		neg al
		irLectura
		mov pelota[3],al
		irVideo
		jmp FIN

		FIN:

		ret
	cambiodireccion endp




end