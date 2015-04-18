.data
	
	display: .word 0:4096		# Dimension 512x512
					# Base address for display 0x10010000 (static data)
					# Unit width & height = 8	
	obstaculos: .space 800		# Habran 100 obstaculos en cada mapa. Constante.
	# Constantes

	mapaAncho:		.word 64	# Ancho (X) del mapa
	mapaAltura:		.word 64	# Altura (Y) del mapa	
	tiempoDormir:		.word 200	# Milisegundos para cambiar al siguiente cuadro del juego (hilo)
	
	# Variables (Se reserva memoria, pero son inicializadas luego)
	
	largoCola:		.space 4	# El largo de la cola de la serpiente. Cuando comienza el juego esta es 0.
	direccion:		.space 4	# Direccion, hacia donde se mueve la serpiente.
	comidaX:		.space 4	# Posicion X de la comida, dentro de la matriz.
	comidaY:		.space 4	# Posicion Y de la comida, dentro de la matriz.	
	cabezaSerpienteX:	.space 4	# Posicion X de la cabeza de la serpiente.
	cabezaSerpienteY:	.space 4	# Posicion Y de la cabeza de la serpiente.	
	juegoEnMovimiento:	.space 4	# Verdadero o falso. El juego esta o no movimiento (cada partida comienza pausada).
	
	
.text
	
	###################################################################
	###################################################################
	####################### JUEGO PRINCIPAL ###########################
	###################################################################
	###################################################################
	
	Intro: 
	
		jal animacionIntro
	
	Main:		
		
		
		jal iniciarPartidaDesdeCero		
		
		MainJuego:		# Comienza el juego principal	
		
			jal obtenerTeclado

			la $t0, juegoEnMovimiento	# Chequea si el juego esta en movimiento
			lw $t0, 0($t0)			
			bnez $t0, movimientoIniciado	# Si esta en movimiento, saltar a "movimientoIniciado".
			beqz $t0, MainJuego		# Vuelve a hiloPrincipal, sin que se ejecute el resto del hilo	
								
			movimientoIniciado:
			
				jal despintarRegionesRedibujo	
				jal moverColaSerpiente
						
				jal moverCabezaSerpiente
				
				jal chequearComeComida			
				
				jal pintarTodo
				jal chequearColisionConsigoMisma
				bnez $v0,perderPartida
				
				la $a0, cabezaSerpienteX
				lw $a0, 0($a0)
				la $a1, cabezaSerpienteY
				lw $a1, 0($a1)
				jal chequearColisionObstaculos
				bnez $v0,perderPartida
			
				jal dormir
				
		j MainJuego		
		
		perderPartida:
			li $a0, 3000
			jal dormirUsandoOtroValorDeTiempo
			j Main
		
		# terminar ejecucion
		li $v0, 10	
		syscall
		
		
	###################################################################
	###################################################################
	################## DEFINICION DE SUBRUTINAS #######################
	###################################################################
	###################################################################
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Animacion para la intro
	animacionIntro:
		move $s0, $ra
		li $a0, 0xff0000
		jal pintarFondo	
		
		
	li $a0, 5
	li $a1, 8
	jal pintarCuadro
	li $a0, 6
	li $a1, 8
	jal pintarCuadro
	li $a0, 7
	li $a1, 8
	jal pintarCuadro
	li $a0, 8
	li $a1, 8
	jal pintarCuadro
	li $a0, 9
	li $a1, 8
	jal pintarCuadro
	li $a0, 12
	li $a1, 8
	jal pintarCuadro
	li $a0, 19
	li $a1, 8
	jal pintarCuadro
	li $a0, 25
	li $a1, 8
	jal pintarCuadro
	li $a0, 31
	li $a1, 8
	jal pintarCuadro
	li $a0, 35
	li $a1, 8
	jal pintarCuadro
	li $a0, 39
	li $a1, 8
	jal pintarCuadro
	li $a0, 40
	li $a1, 8
	jal pintarCuadro
	li $a0, 41
	li $a1, 8
	jal pintarCuadro
	li $a0, 42
	li $a1, 8
	jal pintarCuadro
	li $a0, 43
	li $a1, 8
	jal pintarCuadro
	li $a0, 44
	li $a1, 8
	jal pintarCuadro
	li $a0, 4
	li $a1, 9
	jal pintarCuadro
	li $a0, 12
	li $a1, 9
	jal pintarCuadro
	li $a0, 13
	li $a1, 9
	jal pintarCuadro
	li $a0, 19
	li $a1, 9
	jal pintarCuadro
	li $a0, 24
	li $a1, 9
	jal pintarCuadro
	li $a0, 26
	li $a1, 9
	jal pintarCuadro
	li $a0, 31
	li $a1, 9
	jal pintarCuadro
	li $a0, 34
	li $a1, 9
	jal pintarCuadro
	li $a0, 39
	li $a1, 9
	jal pintarCuadro
	li $a0, 4
	li $a1, 10
	jal pintarCuadro
	li $a0, 12
	li $a1, 10
	jal pintarCuadro
	li $a0, 14
	li $a1, 10
	jal pintarCuadro
	li $a0, 19
	li $a1, 10
	jal pintarCuadro
	li $a0, 23
	li $a1, 10
	jal pintarCuadro
	li $a0, 27
	li $a1, 10
	jal pintarCuadro
	li $a0, 31
	li $a1, 10
	jal pintarCuadro
	li $a0, 33
	li $a1, 10
	jal pintarCuadro
	li $a0, 39
	li $a1, 10
	jal pintarCuadro
	li $a0, 4
	li $a1, 11
	jal pintarCuadro
	li $a0, 12
	li $a1, 11
	jal pintarCuadro
	li $a0, 15
	li $a1, 11
	jal pintarCuadro
	li $a0, 19
	li $a1, 11
	jal pintarCuadro
	li $a0, 22
	li $a1, 11
	jal pintarCuadro
	li $a0, 28
	li $a1, 11
	jal pintarCuadro
	li $a0, 31
	li $a1, 11
	jal pintarCuadro
	li $a0, 32
	li $a1, 11
	jal pintarCuadro
	li $a0, 39
	li $a1, 11
	jal pintarCuadro
	li $a0, 40
	li $a1, 11
	jal pintarCuadro
	li $a0, 41
	li $a1, 11
	jal pintarCuadro
	li $a0, 42
	li $a1, 11
	jal pintarCuadro
	li $a0, 43
	li $a1, 11
	jal pintarCuadro
	li $a0, 44
	li $a1, 11
	jal pintarCuadro
	li $a0, 5
	li $a1, 12
	jal pintarCuadro
	li $a0, 6
	li $a1, 12
	jal pintarCuadro
	li $a0, 7
	li $a1, 12
	jal pintarCuadro
	li $a0, 8
	li $a1, 12
	jal pintarCuadro
	li $a0, 12
	li $a1, 12
	jal pintarCuadro
	li $a0, 16
	li $a1, 12
	jal pintarCuadro
	li $a0, 19
	li $a1, 12
	jal pintarCuadro
	li $a0, 22
	li $a1, 12
	jal pintarCuadro
	li $a0, 28
	li $a1, 12
	jal pintarCuadro
	li $a0, 31
	li $a1, 12
	jal pintarCuadro
	li $a0, 33
	li $a1, 12
	jal pintarCuadro
	li $a0, 39
	li $a1, 12
	jal pintarCuadro
	li $a0, 9
	li $a1, 13
	jal pintarCuadro
	li $a0, 12
	li $a1, 13
	jal pintarCuadro
	li $a0, 17
	li $a1, 13
	jal pintarCuadro
	li $a0, 19
	li $a1, 13
	jal pintarCuadro
	li $a0, 22
	li $a1, 13
	jal pintarCuadro
	li $a0, 23
	li $a1, 13
	jal pintarCuadro
	li $a0, 24
	li $a1, 13
	jal pintarCuadro
	li $a0, 25
	li $a1, 13
	jal pintarCuadro
	li $a0, 26
	li $a1, 13
	jal pintarCuadro
	li $a0, 27
	li $a1, 13
	jal pintarCuadro
	li $a0, 28
	li $a1, 13
	jal pintarCuadro
	li $a0, 31
	li $a1, 13
	jal pintarCuadro
	li $a0, 34
	li $a1, 13
	jal pintarCuadro
	li $a0, 39
	li $a1, 13
	jal pintarCuadro
	li $a0, 9
	li $a1, 14
	jal pintarCuadro
	li $a0, 12
	li $a1, 14
	jal pintarCuadro
	li $a0, 18
	li $a1, 14
	jal pintarCuadro
	li $a0, 19
	li $a1, 14
	jal pintarCuadro
	li $a0, 22
	li $a1, 14
	jal pintarCuadro
	li $a0, 28
	li $a1, 14
	jal pintarCuadro
	li $a0, 31
	li $a1, 14
	jal pintarCuadro
	li $a0, 35
	li $a1, 14
	jal pintarCuadro
	li $a0, 39
	li $a1, 14
	jal pintarCuadro
	li $a0, 4
	li $a1, 15
	jal pintarCuadro
	li $a0, 5
	li $a1, 15
	jal pintarCuadro
	li $a0, 6
	li $a1, 15
	jal pintarCuadro
	li $a0, 7
	li $a1, 15
	jal pintarCuadro
	li $a0, 8
	li $a1, 15
	jal pintarCuadro
	li $a0, 12
	li $a1, 15
	jal pintarCuadro
	li $a0, 19
	li $a1, 15
	jal pintarCuadro
	li $a0, 22
	li $a1, 15
	jal pintarCuadro
	li $a0, 28
	li $a1, 15
	jal pintarCuadro
	li $a0, 31
	li $a1, 15
	jal pintarCuadro
	li $a0, 36
	li $a1, 15
	jal pintarCuadro
	li $a0, 39
	li $a1, 15
	jal pintarCuadro
	li $a0, 40
	li $a1, 15
	jal pintarCuadro
	li $a0, 41
	li $a1, 15
	jal pintarCuadro
	li $a0, 42
	li $a1, 15
	jal pintarCuadro
	li $a0, 43
	li $a1, 15
	jal pintarCuadro
	li $a0, 44
	li $a1, 15
	jal pintarCuadro


		#############################################
		
		li $a0, 3000
		jal dormirUsandoOtroValorDeTiempo
		move $ra, $s0
		jr $ra
	
	
	
	# Argumentos: -
	# Retorno: $v0
	# Descripcion: Retorna el valor alojado en el teclado
	obtenerTeclado:
		move $s7, $ra
		li $t0, 0xffff0004
		lw $t1, 0($t0)
		
		la $t0, direccion
		lw $t2, 0($t0)		# t2 = direccion actual
		
		# Cheat para agregar un elemento a la cola
		beq $t1, 0x20, espacio		# barra espaciadora
		
		# Con minusculas
		beq $t1, 0x61, izq		# izquierda
		beq $t1, 0x77, up		# arriba
		beq $t1, 0x73, down		# abajo
		beq $t1, 0x64, der		# derecha
		beq $t1, 0x71, terminarPartida  # terminar partida
		
		# Con mayusaculas
		beq $t1, 0x41, izq		# izquierda
		beq $t1, 0x57, up		# arriba
		beq $t1, 0x53, down		# abajo
		beq $t1, 0x44, der		# derecha
		beq $t1, 0x51, terminarPartida  # terminar partida
		
		j obtenerTeclado_FinFuncion
		
		espacio:		
			la $t3, juegoEnMovimiento
			lw $t3, 0($t3)
			beqz $t3, obtenerTeclado_FinFuncion	# Si el juego no se ha empezado a mover, no ejecutar lo siguiente
			jal crecerCola			
			j obtenerTeclado_FinFuncion
			
		terminarPartida:
			j perderPartida
		izq:
			# direccion = 1	
			beq $t2, 3, obtenerTeclado_FinFuncion
			li $t1, 1
			sw $t1, 0($t0)	
			j setearJuegoEnMovimiento
		up:
			# direccion = 2
			beq $t2, 4, obtenerTeclado_FinFuncion
			li $t1, 2
			sw $t1, 0($t0)
			j setearJuegoEnMovimiento
		der:
			# direccion = 3
			beq $t2, 1, obtenerTeclado_FinFuncion
			li $t1, 3
			sw $t1, 0($t0)
			j setearJuegoEnMovimiento
		down:
			# direccion = 4
			beq $t2, 2, obtenerTeclado_FinFuncion
			li $t1, 4
			sw $t1, 0($t0)
			j setearJuegoEnMovimiento
		
		setearJuegoEnMovimiento:
			# juegoEnMovimiento = 1
			la $t0, juegoEnMovimiento
			li $t1, 1
			sw $t1, 0($t0)
		
		obtenerTeclado_FinFuncion:
		move $ra, $s7
		jr $ra
		
	# Argumentos: $a0, $a1. (ESTAN MALOS, Solo se usa el argumento a1, para generar un 0<=int<=a1)
	# Retorno: $v0, 
	# Descripcion: numero al azar entre los argumentos, incluyendolos.
	numeroAzar:
			
			# ESTA FUNCION, ASI COMO ESTA, SOLO RETORNA UN NUMERO ENTRE
			# 0 Y OTRO NUMERO
		
		li $v0, 42		# syscall 42
		syscall			# retorna a a0
		move $v0, $a0		# t2 = primer random number
		
		jr $ra
	
	# Argumentos: -
	# Retorno: - 
	# Descripcion: Detiene la ejecucion esperando "tiempoDormir" milisegundos (definida en constantes).
	dormir:
		li $v0, 32
		li $a0, 1000
		syscall
		jr $ra	
	
	# Argumentos: $a0
	# Retorno: - 
	# Descripcion: Detiene la ejecucion esperando $a0 milisegundos. Usada en situaciones especiales en donde
	# se requiere un tiempo distinto al comun.
	dormirUsandoOtroValorDeTiempo:
		li $v0, 32
		syscall
		jr $ra	
		
	# Argumentos: -
	# Retorno: -
	# Descripcion: Borra la cola, reinicia el puntaje a 0 (largo de cola), la cabeza de la serpiente vuelva a su posicion inicial, el juego no esta en movimiento (serpiente aun no empieza a moverse),
	# aparece una nueva comida en algun lugar nuevo.
	iniciarPartidaDesdeCero:
	
		# Guardar la direccion de retorno
		move $s0, $ra
		
		jal setCabezaPosicionInicial
		jal vaciarColaSerpienteMemoria		
		jal generarObstaculos
		jal aparecerComidaEnLugarNuevo
		
		# tecla del teclado = 0x00000000
		sw $zero, 0xffff0004
		
		# direccion = 0
		la $t0, direccion
		sw $zero, 0($t0)		
		
		# largoCola = 0
		la $t0, largoCola
		sw $zero, 0($t0)
		
		# juegoEnMovimiento = 0
		la $t0, juegoEnMovimiento
		sw $zero, 0($t0)		
		
		# Pintar fondo
		li $a0, 0x000000
		jal pintarFondo
		
		# Pintar obstaculos
		li $a2, 0xa034ab
		jal pintarObstaculos
		
		# Pintar todo
		jal pintarTodo	
		
		# Obtener nuevamente la direccion de retorno
		move $ra, $s0
		jr $ra
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Hace que la cabeza de la serpiente aparezca en la posicion inicial, la cual es 
	# encontrada como el punto medio del mapa
	setCabezaPosicionInicial:
	
		# $t0 = ancho mapa
		la $t0, mapaAncho
		lw $t0, 0($t0)
		
		# cabezaSerpienteX = mapaAncho / 2
		srl $t0, $t0, 1
		la $t1, cabezaSerpienteX
		sw $t0, 0($t1)
		
		# $t0 = altura mapa
		la $t0, mapaAltura
		lw $t0, 0($t0)
		
		# cabezaSerpienteX = mapaAltura / 2
		srl $t0, $t0, 1
		la $t1, cabezaSerpienteY
		sw $t0, 0($t1)	
		
		jr $ra
	
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Borra la cola de la serpiente en memoria, volviendo todos los valores a 0.
	vaciarColaSerpienteMemoria:
		la $t0, largoCola
		lw $t0, 0($t0)		# t0 = largoCola
		li $t1, 0		# t1 = 0 ... i=0 
		li $t2, 0x10040000	# direccion heap
		
		forVaciarCola:
			beq $t1, $t0, finVaciarCola			
				sw $zero, 0($t2)
				sw $zero, 4($t2)				
				addi $t2, $t2, 8
		
			addi $t1, $t1, 1	# i++
			j forVaciarCola
		finVaciarCola:
		jr $ra
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: La posicion de la comida cambia a otro lugar
	aparecerComidaEnLugarNuevo:	
		move $s2, $ra
		la $s6, mapaAncho
		lw $s6, 0($s6)		
		addi $s6, $s6, -1
		
		la $s7, mapaAltura
		lw $s7, 0($s7)		
		addi $s7, $s7, -1	
		
		# s6 = ancho - 1
		# s7 = altura - 1		
		
		aparecerComidaEnLugarNuevoGenerarRandom:
		move $a1, $s6		# preparar argumento para la funcion "azar", a1 = ancho-1
		jal numeroAzar		
		move $t3, $v0		# t3 = primer random number
		
		move $a1, $s7		# preparar argumento para la funcion "azar", a1 = altura-1
		jal numeroAzar
		move $t4, $v0		# t4 = primer random number	
					
					# Argumentos para chequear colision
		move $a0, $t3		# a0 = numero random X
		move $a1, $t4		# a1 = numero random Y

		jal chequearColisionObstaculos	# usa t0, t1, a0 a1		# Si la comida colisiona con un obstaculo
		beqz $v0, aparecerComidaEnLugarNuevoNoColisionaConObstaculo	# repetir busqueda de numero random
		
		# Insertar codigo aca en caso de que se haya detectado una colision 
		# al generar una comida, con un obstaculo
		# (no hacer nada, ya que el codigo para generar comida
		# se repetira hasta que no colisione nada)
		
		j aparecerComidaEnLugarNuevoGenerarRandom
		aparecerComidaEnLugarNuevoNoColisionaConObstaculo:
		# comidaX = random
		la $t1, comidaX
		sw $t3, 0($t1)
				
		# comidaY = random
		la $t1, comidaY
		sw $t4, 0($t1)		

		
		move $ra, $s2			
		jr $ra
			
	# Argumentos: -
	# Retorno: -
	# Descripcion: Genera los obstaculos para el nivel
	generarObstaculos:		
		move $s1, $ra		
		la $t0, obstaculos
		li $t1, 0		# t1 = 0, i=0

		generarObstaculosFor:
			beq $t1, 100, generarObstaculosFinFor
			
			li $a0, 0		# rango para numero al azar
			li $a1, 64			
			jal numeroAzar
			sw $v0, 0($t0)
			
			li $a0, 0		# rango para numero al azar
			li $a1, 64
			jal numeroAzar
			sw $v0, 4($t0)
			
			addi $t0, $t0, 8	# siguiente dato del arreglo			
			addi $t1, $t1, 1	# i++
			j generarObstaculosFor
		generarObstaculosFinFor:
		move $ra, $s1
		jr $ra
		
	# Argumentos: a2
	# Retorno: -
	# Descripcion: Pinta los obstaculos en el mapa, del color a0
	pintarObstaculos:		
		move $s1, $ra		
		la $t3, obstaculos
		li $t4, 0		# t1 = 0, i=0
		pintarObstaculosFor:
			beq $t4, 100, pintarObstaculosFinFor
			
			lw $a0, 0($t3)	# X del obstaculo
			lw $a1, 4($t3)	# Y del obstaculo
			jal pintarCuadro
			
			addi $t3, $t3, 8	# siguiente dato del arreglo			
			addi $t4, $t4, 1	# i++
			j pintarObstaculosFor
		pintarObstaculosFinFor:
		move $ra, $s1
		jr $ra
			
	# Argumentos: -
	# Retorno: -
	# Descripcion: Crea un nuevo elemento para la cola. Este elemento tiene inicialmente la misma posicion
	# que el elemento anterior a el (otro elemento de la cola, o bien la cabeza).
	crecerCola:		
	
		la $t0, largoCola		# largoCola ++
		lw $t1, 0($t0)
		addi $t1, $t1, 1
		sw $t1, 0($t0)
				
		la $t1, largoCola		# t1 = direccion largoCola
		lw $t1, 0($t1)			# t1 = largo cola
		move $t2, $t1			# t2 = largo cola (copia)
		beq $t1, $zero, crecerCola_fin	# Si no hay cola, ir a FIN
		addi $t1, $t1, -1		# t1 --	
		sll $t1, $t1, 3			# t1 = largoCola*8
		
		li $t0, 0x10040000		# direccion inicial del heap
		add $t0, $t0, $t1		# t0 = direccion inicial heap + t1
		
		# Ahora se tiene la direccion ($t0) de donde va la nueva estructura
		# de dato X,Y para el nuevo elemento de la cola
		sgt $t1, $t2, 1			# if( largoCola > 1) { $t1 = true }
		beq $t1, $zero, copiarPosCabeza	# Si t1=false, solo hay un elemento en la cola. Copiar la posicion de la cabeza
		
		copiarPosElementoAnterior:
			move $t1, $t0		# t1 = posicion en el heap que contiene el elemento recien agregado
			addi $t1, $t1, -8	# t1 = posicion en el heap del elemento anterior (coordenada X)
			lw $t2, 0($t1)		# t2 = coordenada X del elemento anterior
			sw $t2, 0($t0)		# guardar coordenada X del elem. anterior, en la X del elemento nuevo
			addi $t0, $t0, 4	# +4 para ahora trabajar con la posicion Y del elemento nuevo
			addi $t1, $t1, 4	# +4 para ahora trabajar con la posicion Y del elemento anterior
			
			lw $t1, 0($t1)		# t1 = coordenada Y del elemento anterior
			sw $t1, 0($t0)		# guardar coordenada Y del elem. anterior, en la Y del elemento nuevo			
			
		j crecerCola_fin		# Terminar ejecucion
		copiarPosCabeza:
			la $t1, cabezaSerpienteX	# t1 = direccion cabeza.x
			lw $t1, 0($t1)			# t1 = cabeza.x
			sw $t1, 0($t0)			# guardar cabeza.x en la posicion X del nuevo elemento
			addi $t0, $t0, 4		# +4 para ahora trabajar con la posicion Y
			
			la $t1, cabezaSerpienteY	# t1 = direccion cabeza.y
			lw $t1, 0($t1)			# t1 = cabeza.y
			sw $t1, 0($t0)			# guardar cabeza.y en la posicion Y del nuevo elemento
			
		crecerCola_fin:
		jr $ra
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Verifica si se come una comida y aumenta el puntaje y crea otra nueva comida.
	chequearComeComida:	
		move $s3, $ra
		
		# Primero se chequea si las X==X de la cabeza serpiente y comida
		
		la $t0, comidaX			# t0 = comida.x
		lw $t0, 0($t0)		
		la $t1, cabezaSerpienteX	# t1 = cabeza.x
		lw $t1, 0($t1)
		beq $t0, $t1, chequearComeComida2		
		jr $ra
		
		# En caso de que se continue ejecutando la funcion
		# se chequea si las coordenadas Y son iguales
		
		chequearComeComida2:
		la $t2, comidaY			# t2 = comida.y
		lw $t2, 0($t2)		
		la $t3, cabezaSerpienteY	# t3 = cabeza.y
		lw $t3, 0($t3)
		beq $t2, $t3, chequearComeComidaVERDADERO
		jr $ra
		
		chequearComeComidaVERDADERO:

		jal aparecerComidaEnLugarNuevo			
		
		jal crecerCola			# crecer cola (agregar nuevo elemento)
		
		move $ra, $s3
		jr $ra		
	
	# Argumentos: -
	# Retorno: v0
	# Descripcion: Retorna verdadero si la serpiente ha tocado con su cabeza, alguna parte de su cola.
	chequearColisionConsigoMisma:
		li $v0, 0		# falso por default
		la $t0, largoCola
		lw $t0, 0($t0)		# t0 = largoCola
		li $t1, 3		# t1 = 3 ... i=3 
		li $t2, 0x10040018	# direccion heap
		
		la $t6, cabezaSerpienteX
		lw $t6, 0($t6)
		la $t7, cabezaSerpienteY
		lw $t7, 0($t7)
		
		forColisionConsigoMisma:
			sge $t3, $t1, $t0			# if (i >= largoCola) {
			bgtz $t3, finForColisionConsigoMisma	# 	return;
								# }						
				lw $t4, 0($t2)			# X del elemento i de la cola
				bne $t4, $t6, forColisionConsigoMismaIncremento
				
				lw $t4, 4($t2)			# Y del elemento i de la cola
				beq $t4, $t7, huboColisionConsigoMisma
				
				forColisionConsigoMismaIncremento:					
				addi $t2, $t2, 8		
				addi $t1, $t1, 1	# i++
			j forColisionConsigoMisma
			
			huboColisionConsigoMisma:
			li $v0, 1
		finForColisionConsigoMisma:
		jr $ra
	
		
	# Argumentos: a0, a1
	# Retorno: v0
	# Descripcion: Retorna verdadero si un objeto de coordenadas a0, a1 ha tocado un obstaculo.
	chequearColisionObstaculos:
	
		la $t0, obstaculos
		li $t1, 0		# t1 = 0, i=0
		li $v0, 0		# no hay colision, retorno default

		chequearColisionObstaculosFor:
			beq $t1, 100, chequearColisionObstaculosFinFor
						
			lw $t4, 0($t0)	# X del obstaculo
			bne $t4, $a0, chequearColisionObstaculosForIncrementar
						
			lw $t4, 4($t0)	# Y del obstaculo
			beq $t4, $a1, huboColisionObstaculo
			
			chequearColisionObstaculosForIncrementar:
			addi $t0, $t0, 8	# siguiente dato del arreglo			
			addi $t1, $t1, 1	# i++
			j chequearColisionObstaculosFor
			
			huboColisionObstaculo:
			li $v0, 1
		chequearColisionObstaculosFinFor:

	jr $ra
	
	# Argumentos: $a0, $a1
	# Retorno: $v0, $v1
	# Descripcion: Esta funcion retorna la posicion X,Y de la cabeza de la serpiente, la cual corresponde a
	# la posicion en la que aparece al atravesar la muralla limite y volver por el lado contrario. Esta funcion retorna un valor igual al de
	# los argumentos en caso de que no se haya atravesado la muralla (por ejemplo, si el limite es x=50, y la cabeza ha pasado a x=51, esta
	# funcion retorna 1.)
	cabezaDentroDeLimites:
		
		move $v0, $a0
		move $v1, $a1
				
		# debe solucionarse el problema para cuando esta por sobre o por debajo de los limites,
		# por ejemplo, bajo 0, o sobre el margen del mapa
		
		la $t0, mapaAncho			# t0 = mapa ancho
		lw $t0, 0($t0)
		beq $t0, $a0, excesoX			# mapa ancho == X (entrada)
		beq $a0, -1, deficitX			# -1 == X (entrada)
		
		j calcularLimitesY			# bypass ambos casos
		excesoX:
			li $v0, 0			# X = 0		
			j calcularLimitesY		# saltarse la linea siguiente
		deficitX:
			addi $t0, $t0, -1
			move $v0, $t0			# situar la X al margen del mapa
			
		calcularLimitesY:
		
		la $t0, mapaAltura			# t0 = mapa altura
		lw $t0, 0($t0)
		beq $t0, $a1, excesoY			# mapa altura == Y (entrada)
		beq $a1, -1, deficitY			# -1 == Y (entrada)
		
		j calcularLimitesFin			# bypass ambos casos
		excesoY:
			li $v1, 0			# Y = 0			
			j calcularLimitesFin
		deficitY:
			addi $t0, $t0, -1
			move $v1, $t0
		calcularLimitesFin:
		
		jr $ra
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Mueve la cabeza de la serpiente, utilizando el valor de la "direccion" para definir hacia donde debe moverse.
	moverCabezaSerpiente:
		move $s0, $ra
		la $t0, direccion
		lw $t0, 0($t0)
		
		li $t1, 1
		beq $t0, $t1, moverCabezaSerpiente_left
		li $t1, 2
		beq $t0, $t1, moverCabezaSerpiente_up
		li $t1, 3
		beq $t0, $t1, moverCabezaSerpiente_right
		li $t1, 4
		beq $t0, $t1, moverCabezaSerpiente_down
		
		moverCabezaSerpiente_left:
			la $t0, cabezaSerpienteX
			lw $t1, 0($t0)
			addi $t1, $t1, -1
			sw $t1, 0($t0)			
			j moverCabezaSerpiente_fin
		moverCabezaSerpiente_up:
			la $t0, cabezaSerpienteY
			lw $t1, 0($t0)
			addi $t1, $t1, -1
			sw $t1, 0($t0)	
			j moverCabezaSerpiente_fin
		moverCabezaSerpiente_right:
			la $t0, cabezaSerpienteX
			lw $t1, 0($t0)
			addi $t1, $t1, 1
			sw $t1, 0($t0)	
			j moverCabezaSerpiente_fin
		moverCabezaSerpiente_down:
			la $t0, cabezaSerpienteY
			lw $t1, 0($t0)
			addi $t1, $t1, 1
			sw $t1, 0($t0)	
			j moverCabezaSerpiente_fin
			
		moverCabezaSerpiente_fin:
		
		la $t4, cabezaSerpienteX		# Procesar los cambios de coordenadas de la cabeza
		lw $a0, 0($t4)				# para asi hacer que al atravesar una pared
		la $t5, cabezaSerpienteY		# salga por el lado contrario
		lw $a1, 0($t5)
		
		jal cabezaDentroDeLimites
		sw $v0, 0($t4)
		sw $v1, 0($t5)
		
		move $ra, $s0				# recuperar direccion para volver el caller
		jr $ra
	# Argumentos: -
	# Retorno: -
	# Descripcion: Mueve la cola de la serpiente. El algoritmo usado es, empezar desde el ultimo elemento de la cola (el mas lejano a
	# la cabeza, y asignarle a este, la posicion del anterior. Iterando se llega hasta el primer elemento de la cola, el cual copia
	# la posicion de la cabeza.
	moverColaSerpiente:
		la $t0, largoCola		# t0 = largoCola
		lw $t0, 0($t0)
		
		
		# Si la cantidad de elementos en la cola es 0 o 1
		li $t2, 1
		beq $t0, $t2, moverColaSerpiente_finFor		# si es 1
		beqz $t0, moverColaSerpiente_finFor		# si es 0
		
		addi $t0, $t0, -1
		li $t1, 0x10040000		# dir. inicial heap
		move $t2, $t0			# t2 = largoCola
		#addi $t2, $t2, -1		# t2 --
		sll $t2, $t2, 3			# t2 *= 8
		add $t2, $t1, $t2		# direccion del ultimo elemento de la cola
		li $t3, 0			# t3=0 , i=0
		
		moverColaSerpiente_for:
			beq $t2, 0x10040000, moverColaSerpiente_finFor # Salirse del for si i==largoCola	
			
			lw $t1, -8($t2)				# t1 = valor de X del elemento anterior
			sw $t1, 0($t2)				# guardar t1 en el X del elemento actual
			
			lw $t1, -4($t2)				# t1 = valor de Y del elemento anterior
			sw $t1, 4($t2)				# guardar t1 en el Y del elemento actual
			
			addi $t2, $t2, -8			
			#addi $t3, $t3, 1
			
			j moverColaSerpiente_for
		moverColaSerpiente_finFor:	
		
		la $t0, cabezaSerpienteX
		lw $t0, 0($t0)			# t0 cabeza.x (serpiente)
		sw $t0, 0x10040000
		la $t0, cabezaSerpienteY
		lw $t0, 0($t0)			# t0 cabeza.y (serpiente)
		sw $t0, 0x10040004
		
	
		jr $ra

		
	# Argumentos: $a0
	# Retorno: -
	# Descripcion: Pinta el mapa entero del color $a0
	pintarFondo:
		# Obtener la direccion del display
		la $t0, display
		
		# Borrar todo el mapa, pintandolo de negro
		li $t1, 0		# i = 0
		add $t2, $t0, $zero	# t2 = direccion display
		li $t3, 4096		# dimension total del display
		add $t4, $zero, $a0	# color del fondo		
				
		pintarFondo_borrarMapa_for:
			beq $t1, $t3, pintarFondo_borrarMapa_finFor	# si i=t3, ir a fin de for			 			
			sw $t4, 0($t2)					# pintar t2 con el color t5
			addi $t2, $t2, 4				# dimension += 4			
			addi $t1, $t1, 1				# i++
			j pintarFondo_borrarMapa_for
		pintarFondo_borrarMapa_finFor:
	jr $ra
		
	# Argumentos: -
	# Retorno: -
	# Descripcion: Pinta la serpiente, comidas, y puntaje, con el color de fondo, borrando asi solo lo que sea necesario.
	# (funcion creada en respuesta al inmenso lag producido por repintar todo el escenario)
	
	despintarRegionesRedibujo:
		move $s0, $ra
		# desPintar cabeza
		
		li $a2, 0x000000	# color para la cabeza
		la $t3, cabezaSerpienteX
		lw $a0, 0($t3)		# a0 = cabeza.x
		
		la $t4, cabezaSerpienteY
		lw $a1, 0($t4)		# a1 = cabeza.y		
		jal pintarCuadro
		
		# desPintar comida
		
		li $a2, 0x000000	# color para la comida
		la $t3, comidaX
		lw $a0, 0($t3)		# a0 = comida.x
		
		la $t4, comidaY
		lw $a1, 0($t4)		# a1 = comida.y		
		jal pintarCuadro
		
		
		# desPintar cola serpiente
		li $a2, 0x000000
		jal pintarColaSerpiente	
		
		move $ra, $s0
	jr $ra
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Pinta en el mapa, la comida y cabeza de la serpiente. (La cola de la serpiente se pinta usando otra funcion.)
	pintarTodo:	
		move $s1, $ra
		li $a0, 0x00
		
		# Obtener la direccion del display
		la $t0, display		# t0 = direccion del display
		
		# Pintar puntaje
		
		jal pintarDigitosPuntaje	
		
		# Pintar cabeza
		
		li $a2, 0xff0000	# color para la cabeza
		la $t3, cabezaSerpienteX
		lw $a0, 0($t3)		# a0 = cabeza.x
		
		la $t4, cabezaSerpienteY
		lw $a1, 0($t4)		# a1 = cabeza.y		
		jal pintarCuadro

		# Pintar comida
		
		li $a2, 0xffff00	# color para la comida
		la $t3, comidaX
		lw $a0, 0($t3)		# a0 = comida.x
		
		la $t4, comidaY
		lw $a1, 0($t4)		# a1 = comida.y		
		jal pintarCuadro
				
		# Pintar cola serpiente
		li $a2, 0xff0000
		jal pintarColaSerpiente		
				
						
	
		move $ra, $s1
	jr $ra
	
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Pinta los digitos del puntaje, en pantalla.
	pintarDigitosPuntaje:
		move $s2, $ra
		
		
		jal pintarContenedorNegroDisplayPuntaje	
		
		# Conseguir las unidades y decenas

		la $t0, largoCola
		lw $t0, 0($t0)
		li $t1, 0		# t1 = 0
		li $t2, 10		# t2 = 10
		
		obtenerDigitoUnidadWhile:
			div $t0, $t2
			mfhi $t3
			beqz $t3, obtenerDigitoUnidadWhileFin
			addi $t0, $t0, -1	# t0--
			addi $t1, $t1, 1	# contador de unidades
		
		j obtenerDigitoUnidadWhile
		obtenerDigitoUnidadWhileFin:
		mflo $a2		# contiene la decena
		move $t9, $t1		# t9 = contiene las unidades
		
		# pasar el numero como $a2 a pintarDigito	
		

		li $a0, 3
		li $a1, 3
		jal pintarDigito
		
		move $a2, $t9
		li $a0, 7
		li $a1, 3
		jal pintarDigito		
		
		move $ra, $s2	
	jr $ra	
	
	
	# Argumentos: a0, a1, a2
	# Retorno: -
	# Descripcion: Pinta un digito (a2), usando como desplazamiento el vector (a0,a1)
	pintarDigito:		
		move $s3, $ra		
		
		beq $a2, 0, pintar0
		beq $a2, 1, pintar1
		beq $a2, 2, pintar2
		beq $a2, 3, pintar3
		beq $a2, 4, pintar4
		beq $a2, 5, pintar5
		beq $a2, 6, pintar6
		beq $a2, 7, pintar7
		beq $a2, 8, pintar8
		beq $a2, 9, pintar9
		j finPintarDigito
		
		# Los argumentos a0 y a1 se pasan nuevamente
		# a las siguientes funciones
		
		pintar0:
			li $a2, 1
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
			li $a2, 4
			jal pintarSegmento
			li $a2, 5
			jal pintarSegmento
			li $a2, 6
			jal pintarSegmento
		j finPintarDigito
		pintar1:
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
		
		j finPintarDigito
		pintar2:
			li $a2, 1
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
			li $a2, 5
			jal pintarSegmento
			li $a2, 4
			jal pintarSegmento
		
		j finPintarDigito
		pintar3:
			li $a2, 1
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
			li $a2, 4
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
		
		j finPintarDigito
		pintar4:
			li $a2, 6
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
		
		j finPintarDigito
		pintar5:
			li $a2, 1
			jal pintarSegmento
			li $a2, 6
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
			li $a2, 4
			jal pintarSegmento
		
		j finPintarDigito
		pintar6:
			li $a2, 1
			jal pintarSegmento
			li $a2, 6
			jal pintarSegmento
			li $a2, 5
			jal pintarSegmento
			li $a2, 4
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
		
		j finPintarDigito
		pintar7:
			li $a2, 1
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
		
		j finPintarDigito
		pintar8:
			li $a2, 1
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
			li $a2, 4
			jal pintarSegmento
			li $a2, 5
			jal pintarSegmento
			li $a2, 6
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
		
		j finPintarDigito
		pintar9:
			li $a2, 1
			jal pintarSegmento
			li $a2, 2
			jal pintarSegmento
			li $a2, 3
			jal pintarSegmento
			li $a2, 6
			jal pintarSegmento
			li $a2, 7
			jal pintarSegmento
		
		finPintarDigito:
		
	move $ra, $s3
	jr $ra
	
	
	# Argumentos: a0, a1, a2
	# Retorno: -
	# Descripcion: Pinta un segmento (similar a los de los display de 7 trazos). Pinta el segmento a2, con un desplace de a0,a1 (X,Y)
	pintarSegmento:
		move $s4, $ra	
		
		move $t4, $a0		# respaldar a0 = X
		move $t5, $a1		# respaldar a1 = Y
		move $t3, $a2		# respaldar a2 = segmento
		li $a2, 0x000000ff	# Color para pintar los numeros
		beq $t3, 1, seg1
		beq $t3, 2, seg2
		beq $t3, 3, seg3
		beq $t3, 4, seg4
		beq $t3, 5, seg5
		beq $t3, 6, seg6
		beq $t3, 7, seg7
		j finPintarSegmento

		seg1:
			add $a0, $t4, 0		# conseguir posicion X
			add $a1, $t5, 0		# conseguir posicion Y
			jal pintarCuadro
			
			add $a0, $t4, 1		# conseguir posicion X
			jal pintarCuadro
			
			add $a0, $t4, 2		# conseguir posicion X
			jal pintarCuadro
		
		
		j finPintarSegmento
		seg2:
			add $a0, $t4, 2		# conseguir posicion X
			add $a1, $t5, 0		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 1		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 2		# conseguir posicion Y
			jal pintarCuadro
		
		j finPintarSegmento
		seg3:
			add $a0, $t4, 2		# conseguir posicion X
			add $a1, $t5, 2		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 3		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 4		# conseguir posicion Y
			jal pintarCuadro
		
		j finPintarSegmento
		seg4:
			add $a0, $t4, 0		# conseguir posicion X
			add $a1, $t5, 4		# conseguir posicion Y
			jal pintarCuadro
			
			add $a0, $t4, 1		# conseguir posicion X
			jal pintarCuadro
			
			add $a0, $t4, 2		# conseguir posicion X
			jal pintarCuadro
		
		j finPintarSegmento
		seg5:
			add $a0, $t4, 0		# conseguir posicion X
			add $a1, $t5, 2		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 3		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 4		# conseguir posicion Y
			jal pintarCuadro
		
		j finPintarSegmento
		seg6:
			add $a0, $t4, 0		# conseguir posicion X
			add $a1, $t5, 0		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 1		# conseguir posicion Y
			jal pintarCuadro
			
			add $a1, $t5, 2		# conseguir posicion Y
			jal pintarCuadro
		
		j finPintarSegmento
		seg7:
			add $a0, $t4, 0		# conseguir posicion X
			add $a1, $t5, 2		# conseguir posicion Y
			jal pintarCuadro
			
			add $a0, $t4, 1		# conseguir posicion X
			jal pintarCuadro
			
			add $a0, $t4, 2		# conseguir posicion X
			jal pintarCuadro
		
		j finPintarSegmento
		
		finPintarSegmento:
		move $a0, $t4
		move $a1, $t5
		
	move $ra, $s4	
	jr $ra	
	
	# Argumentos: a2
	# Retorno: -
	# Descripcion: Pintar cola de la serpiente, color = a2
	pintarColaSerpiente:	
		move $s2, $ra
		la $s4, largoCola
		lw $s4, 0($s4)					# s4 = largo cola
		li $s3, 0					# s3 = 0 .. i=0
		li $s5, 0x10040000				# s5 = dir. heap
				
		pintarColaSerpiente_for:
			beq $s3, $s4, pintarColaSerpiente_finFor # Salirse del for si i==largoCola			
			
			lw $a0, 0($s5)				# obtener X
			lw $a1, 4($s5)				# obtener Y			
			jal pintarCuadro			# pintar el cuadro			
			
			addi $s5, $s5, 8			# pasar al siguiente dato
		
			addi $s3, $s3, 1			# i++	
			
			j pintarColaSerpiente_for
		pintarColaSerpiente_finFor:
		move $ra, $s2
	jr $ra	

	# Argumentos: $a0, $a1, $a2
	# Retorno: -
	# Descripcion: Obtiene un par ordenado X,Y, un color, y dibuja este cuadro en la posicion que debiera
	# estar para que aparezca bien en el display.
	pintarCuadro:	
		la $t0, mapaAncho	# t0 = direccion de mapaAncho
		lw $t0, 0($t0)		# t0 = mapaAncho
		add $t2, $a0, $zero	# t2 = X (a0)
		add $t1, $a1, $zero	# t1 = Y (a1)
		mult $t1, $t0		# Y * mapaAncho
		mflo $t1		# t1 = resultado de la multiplicacion anterior
		add $t2, $t2, $t1	# t2 = X + (Y*mapaAncho)
		sll $t2, $t2, 2		# *=4		
		la $t0, display		# t0 = display
		add $t0, $t0, $t2	# t0 = display + X + (Y*mapaAncho)	
		
		sw $a2, 0($t0)		# pintar el color a2 en la direccion t0		
	jr $ra
	
	# Argumentos: -
	# Retorno: -
	# Descripcion: Pinta un rectangulo negro, contenedor del display de puntaje
	pintarContenedorNegroDisplayPuntaje:
		move $s3, $ra
		li $t5, 3
		li $t6, 3
		li $a2, 0x000000
		
		for_ContainerNegro2:
		beq $t6, 8, finFor_ContainerNegro2
		
		for_ContainerNegro:
		beq $t5, 10, finFor_ContainerNegro
			move $a0, $t5
			move $a1, $t6
			jal pintarCuadro
		
		addi $t5, $t5, 1
		j for_ContainerNegro
		finFor_ContainerNegro:
		
		li $t5, 3
		
		
		addi $t6, $t6, 1
		j for_ContainerNegro2
		finFor_ContainerNegro2:
		
	move $ra, $s3
	jr $ra

