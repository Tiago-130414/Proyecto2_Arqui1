include macros.asm
.model small
.stack
.data
    ;////////////////PARA MENU PRINCIPAL
    strConsola         db  'consolaP2> ','$'
    strSalto           db  ' ',10,13,'$'
    
    ;////////////////PARA COMANDOS
    comando                     db  100 dup('$')
    contadorCaracteresComando   dw  0d
    comandosIguales             db  0d
    ;--------------------------------
    strPromedio                 db  'cprom','$'
    strMediana                  db  'cmediana','$'
    strModa                     db  'cmoda','$'
    strMax                      db  'cmax','$'
    strMin                      db  'cmin','$'
    strGbarra_asc               db  'gbarra_asc','$'
    strGbarra_desc              db  'gbarra_desc','$'
    strGhist                    db  'ghist','$'
    strGlinea                   db  'glinea','$'
    strLimpiar                  db  'limpiar','$'
    strReporte                  db  'reporte','$'
    strInfo                     db  'info','$'
    strSalir                    db  'salir','$'
    strEncabezado               db  '   ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13
                                db  '   SECCION A',10,13
                                db  '   PRIMER SEMESTRE 2,021',10,13
                                db  '   Santiago Gilberto Antonio Rivadeneira Ruano',10,13
                                db  '   201313722',10,13
                                db  '   PROYECTO 2 ASSEMBLER',10,10,13,'$' 
    strErrorComando             db  'comando erroneo','$'
    ;-->PARA COMANDO ABRIR
    letraC_Abrir                db  ' ','$'
    contadorLetrasAbrir         dw  0d
    ruta                        db  100 dup('$')
    letraRuta                   db  0d
    contVectRuta                dw  0d
    ;-->PARA LEER ARCHIVO
    vecTempNumeros              db  2000 dup ('$')
    texto                       db  2 dup('$')
    msjErrorApertura  db 'Error: No se pudo abrir el archivo','$'
    msjErrorLectura   db 'Error: No se completo lectura de archivo','$'
    espacio_          db ' ','$'
    handler           dw ?
    boolErrorLectura  db 0d
    separador         db ',','$' 
    puntoDec          db '.','$'
    digitosIngresados dw 0d               ;contador de digitos ingresados
    posVector         dw 0d               ;contador que me indica la posicion libre del vector temporal de numeros
    posTempVector     dw 0d               ;contador temporal que se multiplica para guardar el binario
    contForIngresoN   dw 0d               ;contador para for que guarda los numeros en binario cuando se lee el archivo
    numeroBinarioG    dw 0d               ;numero binario que se guardara
     ;/////////////////////////////////////////PARA MACRO INSERTAR/MOSTRAR VECTOR
    valVector         dw 0d               ;variable que guarda temporalmente el valor leido de un vector
    contadorFor       dw 0d               ;contador para metodos de vector
    indiceTemp16Bits  dw 0d               ;indice temporal que se multiplica por 2 para acceder a vector de 16 bits
    ;////IMPRIMIR BINARIO
    auxImpPila        dw 0
    contDigitosImp    dw 0
    numResultado      dw 0
    ;////PARA GUARDAR NUMEROS EN VECTOR BINARIO
    vecNumeros        dw 500 dup('$')     ;vector original de numeros   
    vecNumerosCopia   dw 500 dup('$')     ;vector copia para comandos
    contVector        dw 0d               ;contador para insertar valores en vecNumeros
    contPila          dw 0d               ;cuenta los caracteres ingresados a la pila
    val               db 0d
    numTemp           dw 0d
    contadorI         dw 0d
    multiplicador     dw 0d 
    ;////VARIABLES PARA ORDENAMIENTO DE VECTOR (ORDENAMIENTO BURBUJA)
    contadorForBurbuja        dw 0d
    contadorForBurbuja2       dw 0d
    temp              dw 0d               ;guarda el valor temporalmente
    temp2             dw 0d               ;guarda el valor temporalmente
    posSig            dw 0d               ;guarda la posicion siguiente j+1 
    ;////VARIABLE PARA COMANDO MAX y MIN
    val_max           dw 0d
    val_min           dw 0d
    posValMax_Min     dw 0d
    msjErrorValMax_Min     db 'Error: Vector de numeros vacio','$'
    ;////VARIABLES PARA PROMEDIO
    contForSumaProm   dw 0d
    valSumarProm      dw 0d
    sumaProm          dw 0d
    parteEntera       dw 0d
    parteDecimal      dw 0d
    decimal           dw 0d
    residuo           dw 0d
    contForDecimales  dw 0d
    contForFormarDec  dw 0d
    multiploDecimales dw 0d ;multiplica el numero para obtener el valor completo
    valor_promedio    dw 0d
    valor_dec_prom    dw 0d
    ;////VARIABLES PARA TABLA DE FRECUENCIAS
    tablaFrecuencias  dw 500 dup ('$')
    numeroFrecuencia  dw 500 dup ('$')
    contadorForFrec   dw 0d
    contForFrecSig    dw 0d
    valorFrecuencia   dw 0d 
    valorFrecuencia2  dw 0d
    repitoFrecuencia  dw 0d ;valor que guarda la repitencia
    contFrecuencias   dw 0d
    impFrec           dw 0d
    impRepi           dw 0d
    c_escape          dw '$'
    ;////VARIABLES PARA MODA
    val_frec          dw 0d   ;frecuencia1  sirve para ordenar tabla de frecuencias por frecuencia
    val_frec2         dw 0d   ;frecuencia2  sirve para ordenar tabla de frecuencias por frecuencia
    val_num           dw 0d   ;numero1      sirve para ordenar tabla de frecuencias por frecuencia
    val_num2          dw 0d   ;numero2      sirve para ordenar tabla de frecuencias por frecuencia
    posModa           dw 0d   ;guarda la posicion en la tabla de frecuencias de la moda
    valModa           dw 0d   ;guarda el valor de la moda
    ;////VARIABLES PARA MEDIANA
    par_impar         dw 0d   ;variable que me dice si es par o impar
    pos_mediana       dw 0d
    ind_sup           dw 0d
    val1_med          dw 0d
    val2_med          dw 0d
    divi_med          dw 2d
    valor_mediana     dw 0d
    valor_dec_med     dw 0d
    ;////VARIABLES PARA REPORTE
    direccionArchivo        db '201313722.txt',0
    handler2                dw ?
    errorGreporte           db '-> Problema al generar reporte',10,13,'$' 
    errorEscrituraReporte   db '-> Problema al escribir en el archivo de reporte','$'
    strEncabezadoR          db  'PROYECTO 2 ASSEMBLER',13,
                            db  'Santiago Gilberto Antonio Rivadeneira Ruano',13
                            db  '201313722',13,0
    strDiagonal             db  '/',0
    strDosPuntos            db  ':',0
    strPuntoR               db  '.',0
    strSaltoAr              db  '',13,0
    dia                     db  0d 
    mes                     db  0d
    ano                     dw  0d
    hora                    db  0d
    min                     db  0d
    seg                     db  0d
    strPromedioR            db 'Promedio: ',0
    strMedianaR             db 'Mediana: ',0 
    strModaR                db 'Moda: ',0 
    strMaxR                 db 'Maximo: ',0    
    strMinR                 db 'Minimo: ',0
    strTablaR               db 'Tabla De Frecuencias: ',13,0 
    strTabulacionR          db '    ',0
.code 

;/////////////////////////////////
;macro que se encarga de limpiar la pantalla
;haciendo uso del modo de video 10h
limpiarPantalla macro
    MOV ah, 0           ; se limpia parte alta de ax
    MOV al, 3h          ; modo texto
    INT 10h             ; interrupcion de video
endm 

;/////////////////////////////////
pausa MACRO                        ;macro que recibe una tecla para simular una pausa
   mov ah,08
   int 21h
ENDM

;///////////////////////////////// 
compararCadenas macro comando_a_evaluar
    local iguales,diferentes,salirComparacionCadenas
    ;limpiando variables y registros
    mov si,0d
    mov di,0d
    xor ax,ax
    xor cx,cx
    mov comandosIguales, 0d ;variable booleana que indica si son iguales o no

    ;push ES
    
    mov ax,ds
    mov ES,ax
    
    mov cx,contadorCaracteresComando
    LEA si,comando
    LEA di,comando_a_evaluar
    repe cmpsb
    jne diferentes

   ;pop ES
    
    iguales:
        mov comandosIguales,1d
        jmp salirComparacionCadenas

    diferentes:
        mov comandosIguales,0d
    
    salirComparacionCadenas:
endm


main proc 
    
    mov dx, @data
    mov ds, dx
    
    
    limpiarPantalla
    ;///////////////////////////MENU DE COMANDOS
    menu:
    
        imprimir strConsola
        
        mov contadorCaracteresComando,0
        leer:                                              ;inicia la lectura de 
            cmp  contadorCaracteresComando,99d              ;si el contador es igual al tamanio del vector
            jge  terminoComando                            ;se sale de la lectura si son iguales
            
            mov   ah,01                                    ;se pide un valor para insertar al vector
            int   21h           
            
            cmp al,13d                                     ;si es un enter se sale de la lectura
            je terminoComando
            
            mov si,contadorCaracteresComando
            mov comando[si],al                             ;se guarda en el vector el caracter leido
            inc contadorCaracteresComando                  ;se incrementa el indice
            jmp leer                                       ;se reinicia el ciclo
        
        terminoComando:
            mov si,contadorCaracteresComando               ;etiqueta de salida de la lectura del comando
            mov comando[si],'$'                            ;se guarda en el vector el caracter de finalizacion    
        
        ;---COMANDO LIMPIAR
        compararCadenas strLimpiar
        cmp comandosIguales,1d
        je comando_limpiar
        
        ;---COMANDO INFO
        compararCadenas strInfo
        cmp comandosIguales,1d
        je comando_info 
        
        ;---COMANDO CMAX 
        compararCadenas strMax
        cmp comandosIguales,1d
        je comando_max
        
        ;---COMANDO CMIN 
        compararCadenas strMin
        cmp comandosIguales,1d
        je comando_min
        
        ;---COMANDO CPROM 
        compararCadenas strPromedio
        cmp comandosIguales,1d
        je comando_prom
        
        ;---COMANDO MEDIANA
        compararCadenas strMediana
        cmp comandosIguales,1d
        je  comando_cmediana
        
        ;---COMANDO MODA
        compararCadenas strModa
        cmp comandosIguales,1d
        je  comando_cmoda
        
        ;---COMANDO REPORTE
        compararCadenas strReporte
        cmp comandosIguales,1d
        je  comando_reporte

        ;---COMANDO SALIR 
        compararCadenas strSalir
        cmp comandosIguales,1d
        je salir
        
        ;---COMANDO ABRIR
        comando_abrir:      
            mov comandosIguales,0d
            
            obtenerValorVector letraC_Abrir,comando,0d   
            cmp letraC_Abrir,97 ;A
            je comp_b
            jmp error_comando
            
            comp_b:
                obtenerValorVector letraC_Abrir,comando,1d
                cmp letraC_Abrir,98 ;B
                je comp_r
                jmp error_comando
            
            comp_r:
                obtenerValorVector letraC_Abrir,comando,2d
                cmp letraC_Abrir,114 ;R
                je comp_i
                jmp error_comando
            
            comp_i:
                obtenerValorVector letraC_Abrir,comando,3d
                cmp letraC_Abrir,105 ;I
                je comp_r2
                jmp error_comando
            
            comp_r2:
                obtenerValorVector letraC_Abrir,comando,4d
                cmp letraC_Abrir,114 ;R
                je comp_g
                jmp error_comando
                
            comp_g:
                obtenerValorVector letraC_Abrir,comando,5d
                cmp letraC_Abrir,95 ;_
                je ejecutar_abrir
        
        ;---SI NO ES NINGUN COMANDO DE LOS PERMITIDOS ES ERROR
        jmp error_comando

    ;/////////////PARA COMANDO ABRIR
    
        ejecutar_abrir:
            and cx,0d           
            mov contadorLetrasAbrir,6d
            mov contVectRuta,0d
            mov posVector,0d
            
            for_abrir:
                mov cx,contadorCaracteresComando
                cmp contadorLetrasAbrir,cx
                jge fin_for_abrir
                
                obtenerValorVector letraRuta,comando,contadorLetrasAbrir
                insertarVector ruta,contVectRuta,letraRuta
                    
                inc contadorLetrasAbrir
                inc contVectRuta
            jmp for_abrir
            
            fin_for_abrir:
            
            insertarVector ruta,contVectRuta,0
            
            ;/////////////////INICIA APERTURA DE ARCHIVO
            abrir:
                mov ah, 3dh                    ;se abre directamente el archivo
                mov al , 0                     ;se lee la ruta obtenida
                mov dx, offset ruta
                int 21h
                jc errorApertura               ;si dio error se activo la bander a de carrie y se envia a error de apertura
                mov handler, ax                ;si no dio error se mueve el valor obtenido de ax a la variable handler
                
            ;//////////////////INICIA LECTURA DE ARCHIVO
            leerArchivo:
                mov ah,3fh
                mov bx, handler                 ;se inicia la lectura del archivo
                mov dx, offset texto            ;se copia la posicion de memoria de variable texto
                mov cx, 1                       ;se indica cuantos caracteres se leen en mi caso 1
                int 21h                         ;interrupcion 21h
                jc  errorLectura                ;si da un error de lectura se envia a error de lectura
                cmp ax,0d                       ;si en ax se encuentra un 0 es por que se finalizo la lectura
                jz fin                          ;se enciende bandera 0 si ya se concluyo la lectura
                                       
                cmp texto,47                    ;se valida si el texto leido es mayor que 0
                jg validarNumero                ;si es mayor se continua con la validacion de numero
                jmp noSoyNumero                 ;si no es mayor automaticamente se continua con la lectura
                
                validarNumero:
                    cmp texto,58                ;si el numero leido es menor que el ascii 58 (:)
                    jl soyNumero                ;se completo la validacion de numero
                    cmp texto,60                ;de lo contrario se valida si el ascii que viene es 60 (<)
                    je  validaComa              ;si el ascii es (<) se valida para agregar separador de numero
                    jmp noSoyNumero             ;si no se cumple ninguna de las validaciones anteriores se continua leyendo el archivo
                    
                validaComa:
                    cmp digitosIngresados,1d    ;si llego hasta aca y la cantidad de numeros leidos es 1
                    je  imprimirComa            ;se envia a imprimir coma
                    cmp digitosIngresados,2d    ;si los digitos leidos llegaron a 2
                    je  imprimirComa            ;se envia a imprimir una coma
                    cmp digitosIngresados,3d    ;si los digitos leidos llegaron a 3
                    je  imprimirComa            ;se envia a imprimir una coma
                    jmp noSoyNumero             ;si no se cumple ninguna de las anteriores se continua con la lectura
                           
                imprimirComa:
                    mov digitosIngresados,0d    ;se limpia el contador de digitos ingresados
                    ;imprimir separador          ;se imprime una coma
                    mov si,posVector            ;se mueve al registro si el contador de posiciones en vector
                    mov cx,0                    ;se limpia registro cx
                    mov cl,separador            ;se guarda en la parte baja de cx lo que se insertara en el vector en mi caso una coma
                    mov vecTempNumeros[si],cl   ;se inserta en el vector la coma
                    inc posVector               ;se incrementa el contador de posiciones
                    jmp noSoyNumero             ;luego se continua con la lectura
                    
                soyNumero:
                    ;imprimir texto              ;si es un numero
                    mov si,posVector            ;se mueve el contador de digitos a si
                    mov cx,0                    ;se limpia el registro cx
                    mov cl,texto                ;se guarda el numero que cumplio con las validaciones en cl
                    mov vecTempNumeros[si],cl   ;se guarda en el vector el numero leido
                    inc posVector               ;se incrementa el contador de posiciones
                    inc digitosIngresados       ;se incrementa el contador de digitos
                    
                noSoyNumero:    
                    jmp leerArchivo             ;para continuar con la lectura
            
            errorLectura:
                mov boolErrorLectura, 1d        ;booleana por si hay error de lectura
                imprimir msjErrorLectura        ;se imprime error de lectura
                jmp fin                         ;se termina la lectura del archivo
                
            ;//////////////////CERRAR ARCHIVO
            fin:
                mov ah,3eh                      ;se cierra el archivo
                mov bx,handler                  ;se termina la lectura
                int 21H
                jmp fin_lecturaAR
    
            errorApertura:
                imprimir msjErrorApertura       ;si dio error al leer ruta o comprobar archivo se imprime error
                impS                            
                jmp salirAb
                
            fin_lecturaAR:
            
            cmp boolErrorLectura,1d
            je salirAb
                     
            mov si,posVector                    ;se obtiene la ultima posicion libre del vector segun el contador
            mov vecTempNumeros[si],'$'          ;se coloca caracter de finalizacion en el vector
           
            guardarNumeros
            imprimir strConsola
            mostrarVector vecNumeros,contVector
            impS
            
            salirAb:
                
        jmp menu
    ;/////////////PARA COMANDO LIMPIAR
    comando_limpiar:
        limpiarPantalla
        jmp menu
    
    ;/////////////PARA COMANDO INFO
    comando_info:
        imprimir strConsola
        impS
        imprimir strEncabezado
        jmp menu
    ;/////////////PARA COMANDO MAX    
    comando_max:
        mov posValMax_Min,0d 
        mov ax,contVector
        sub ax,1
        mov posValMax_Min,ax
        xor ax,ax
        
         
        cmp posValMax_Min,0d
        jl  com_max_sal 
         
         
        imprimir strConsola
        obtenerValorVector16Bits val_max, vecNumeros,posValMax_Min
        imprimirNum16B val_max
        impS
        jmp menu
        
        com_max_sal:
            imprimir msjErrorValMax_Min
            impS
        jmp menu                  
        
    ;/////////////PARA COMANDO MIN    
    comando_min:
        mov posValMax_Min,0d 
        imprimir strConsola
        obtenerValorVector16Bits val_min, vecNumeros,posValMax_Min
        imprimirNum16B val_min
        impS
        jmp menu 
    ;/////////////PARA COMANDO PROMEDIO
    comando_prom:
        sumarNumerosVector
        hacerPromedio
        jmp menu
    ;/////////////PARA COMANDO MODA
    comando_cmoda:
        realizarFrecuencias                     ;realizando tabla de frecuencias
        comando_moda valModa,contFrecuencias    ;realizando ordenamiento para moda
        imprimir strConsola                     ;imprimiendo valores
        imprimirNum16B valModa
        impS
        jmp menu
    
    ;/////////////PARA COMANDO MEDIANA    
    comando_cmediana:
        and ax,0d
        and dx,0d
        and bx,0d
        
        mov ax,contVector
        mov bx,2d
        div bx
        mov par_impar,dx
        mov pos_mediana,ax
        
        mov val1_med, 0d
        mov val2_med, 0d
        mov valor_mediana,0d
        mov valor_dec_med,0d
        
        cmp par_impar,0d
        je  soy_par_med
        jmp soy_impar_med
        
        soy_par_med:
                     
            and ax,0d
            mov ax,pos_mediana
            add ax,1d
            mov ind_sup,ax          
            
            obtenerValorVector16Bits val1_med, vecNumeros,pos_mediana
            obtenerValorVector16Bits val2_med, vecNumeros,ind_sup
            
            and ax,0d
            mov ax,val1_med
            add ax,val2_med
            mov valor_mediana,ax
            
            dividirNumero valor_mediana,2d
            
            jmp fin_mediana
            
        soy_impar_med:
            
            obtenerValorVector16Bits valor_mediana, vecNumeros,pos_mediana
            imprimir strConsola                     ;imprimiendo valores
            imprimirNum16B valor_mediana
            impS

        fin_mediana:
        jmp menu 
        
    ;/////////////COMANDO REPORTE
    comando_reporte:
            ;creando archivo
            mov ah,3Ch
            mov cx,0
            mov dx,offset direccionArchivo
            int 21h
            
            ;si hay error
            jc errorReporte
            mov handler2,ax
            ;de lo contrario escribo en el archivo
            
            ;escribiendo encabezado
            escribirArchivo strEncabezadoR,75d
            jc errorEscReporte
            
            ;obteniendo fecha
            mov ah,2Ah
            int 21h
 
            mov dia,dl
            mov mes,dh
            mov ano,cx
            
            ;escribiendo fecha en el reporte
            escribirBinarioReporte dia
            escribirArchivo strDiagonal,1d
            escribirBinarioReporte mes
            escribirArchivo strDiagonal,1d
            escribirBinarioReporte16B ano
            escribirArchivo strSaltoAr,1d
            
            ;obteniendo hora
            
            mov ah,2Ch
            int 21h
            
            mov hora,ch
            mov min,cl
            mov seg,dh
            
            ;escribiendo hora
            
            escribirBinarioReporte hora
            escribirArchivo strDosPuntos,1d
            
            escribirBinarioReporte min
            escribirArchivo strDosPuntos,1d
            
            escribirBinarioReporte seg
            escribirArchivo strSaltoAr,1d
            escribirArchivo strSaltoAr,1d
            
            ;escribiendo promedio
            escribirArchivo strPromedioR,10 
            escribirBinarioReporte16B valor_promedio
            escribirArchivo strPuntoR,1d
            escribirBinarioReporte16B valor_dec_prom
            escribirArchivo strSaltoAr,1d
            
            ;escribiendo mediana
            escribirArchivo strMedianaR,9
            escribirBinarioReporte16B valor_mediana
            escribirArchivo strPuntoR,1d
            escribirBinarioReporte16B valor_dec_med
            escribirArchivo strSaltoAr,1d
            
            ;escribiendo moda
            escribirArchivo strModaR,6
            escribirBinarioReporte16B valModa
            escribirArchivo strSaltoAr,1d
            
            ;escribiendo maximo
            escribirArchivo strMaxR,8
            escribirBinarioReporte16B val_max
            escribirArchivo strSaltoAr,1d
            
            ;escribiendo minimo
            escribirArchivo strMinR,8
            escribirBinarioReporte16B val_min
            escribirArchivo strSaltoAr,1d
            escribirArchivo strSaltoAr,1d
            
            ;escribiendo tabla de frecuencias
            escribirArchivo strTablaR,23
            escribirArchivo strSaltoAr,1d
            
            escribirTabla contFrecuencias 
                     
            ;cerrando el archivo
            mov ah,3eh
            mov bx,handler2
            int 21h
                    
            jmp finalizarReporte
            
        errorReporte:
            imprimir  errorGreporte
            jmp finalizarReporte
            
        errorEscReporte:
            imprimir errorEscrituraReporte   
            
        finalizarReporte:
                
        jmp menu
    ;/////////////ERROR DE COMANDO
    error_comando:
        imprimir strConsola
        imprimir strErrorComando
        impS
        jmp menu
    
    ;/////////////PARA COMANDO SALIR
    salir:
        .exit
    
       
main endp
end main