INCLUDE "esfera-navidena.txt"  
INCLUDE "Regalo1.txt"
INCLUDE "Regalo2.txt" 
    
DATOS SEGMENT                                                                         
    ;MENU PRINCIPAL        
        MENSAJE_MENU_PRINCIPAL DB 10,13,'MENU PRINCIPAL',10,13,'SELECCIONE LA OPERACION A REALIZAR: ',10,13
         DB 10,13,'1.-COMPARACION DE DOS NUMEROS Y REPETICION FR CADENA',10,13
         DB '2.-OPERACIONES DE ARCHIVO',10,13
         DB '3.-VISUALIZAR ARTE-PIXEL',10,13
         DB '4.-SALIR',10,13,': $',10,13    
 
        
    ;MENU COMPARA DE DOS NUMEROS
        MENU_COMPARAR_DOS_NUMEROS DB 10,13,'MENU DOS NUMEROS',10,13
        DB 10,13,'1.- COMPARAR NUMERO SI A>B || A<B || A=B || A!=B ',10,13
        DB '2.- REPETIR CADENA A VECES',10,13
        DB '3.- INGRESAR NUEVOS DATOS',10,13 
        DB '4.- REGRESAR AL MENU PRINCIPAL',10,13,': $',10,13
    ;MENSAJE OPCION 1 MENU COMPARA DE DOS NUMEROS
    
        ES_MENOR1 DB 10,13,'EL PRIMER NUMERO INGRESADO ES MENOR$',10,13  
        ES_MAYOR1 DB 10,13, 'EL PRIMER NUMERO INGRESADO ES MAYOR$',10,13  
        ES_IGUAL1 DB 10,13, 'LOS NUMEROS INGRESADOS SON IGUALES$',10,13
        ES_DIFERENTE1 DB 10,13, 'LOS NUMEROS INGRESADOS NO SON IGUALES$',10,13
 
        
    ;MENU REALIZAR OPERACIONES DE UN ARCHIVO     
        MENU_OPERACIONES_ARCHIVO DB 10,13,'MENU OPERACIONES DE ARCHIVOS',10,13
        DB 10,13, '1.- CREAR UN ARCHIVO' ,10,13     
        DB '2.- LEER UN ARCHIVO' ,10,13     
        DB '3.- ESCRIBIR UN ARCHIVO' ,10,13                
        DB '4.- ELIMINAR ARCHIVO' ,10,13
        DB '5.- REGRESAR AL MENU PRINCIPAL' ,10,13,': $',10,13 
    ;MENSAJES MENU ARCHIVOS
        NOM_ARCHI DB 'INGRESE EL NOMBRE DEL ARCHIVO: $',10,13 
        ERROR_CREACION DB 'ERROR AL CREAR EL ARCHIVO$',10,13
        MSG_ARCH_CREADO DB 'EL ARCHIVO SE CREO CORRECTAMENTE$',10,13 
        SALTOLINEA DB 10,13, '$'                                      
        MSG_TEXTO DB 'INGRESE EL CONTENIDO DEL ARCHIVO: $',10,13  
        MSG_MODIFICADO DB 'ARCHIVO MODIFICADO CORRECTAMENTE$',10,13
        MSG_DELETE DB 'ARCHIVO BORRADO CORRECTAMENTE$',10,13
        MSG_ERRORDELETE DB 'ERROR AL BORRAR EL ARCHIVO$',10,13
  
        
        
        
    ;MENU ARTE-PIXEL
        MENU_ARTE_PIXEL DB 10,13,'MENU ARTE-PIXEL',10,13
        DB 10,13, '1.- MOSTRAR ARTE-PIXEL REGALO1',10,13         
        DB '2.- MOSTRAR ARTE-PIXEL REGALO2',10,13         
        DB '3.- MOSTRAR ARTE-PIXEL ESFERA DE NIEVE',10,13         
        DB '4.- REGRESAR AL MENU PRINCIPAL',10,13,': $',10,13 
        
            
        
    
    ;VARIABLE SELECCION MENU ALL
        NUM DB ?          
  
    ;PEDIR VALORES MENSAJE 
        
        INGRESA_VALOR1   DB     'INGRESA EL PRIMER VALOR: $'
        INGRESA_VALOR2   DB     10,13,'INGRESA EL SEGUNDO VALOR: $',10,13
        INGRESA_CADENA   DB     10,13,'INGRESA CADENA DE TEXTO: $',10,13
        
    ;ALMACENAR LOS DOS NUMEROS
        NUMERO1 DB ?
        NUMERO2 DB ?
           
        ;CADENA DB 100,?,20 DUP(' ') 
        CADENA DB 25,?,26 DUP('$')
        SALTO DB 10,13, '$',10,13
        
       
    ;SALIR
        SALIENDO DB 10,13,'SALIENDO...$',10,13                                                                     
    ;NUMERO NO VALIDO
        NUMERO_INVALIDO DB 10,13,'NUMERO NO VALIDO EN EL MENU$',10,13
        
        HANDLER DW ?  
    ;VARIABLE RUTA DONDE SE GUARDARAN LOS ARCHIVOS 
        NAME_ARCHIVO DB 15,?, 15 dup(' ')         
        BUFFER DB 250,0,255 DUP('$') 
        BUFFERLEC DB 20,0,20 DUP('$') 
        FILEHANDLE DW 0,'$';

DATOS ENDS      

CODIGO SEGMENT
             
    ASSUME DS:DATOS,CD:CODIGO  
                
        LIMPIAR_PANTALLA PROC   

        

        mov ah, 0x00
        mov al, 0x03
        int 0x10
        
            RET 
        ENDP  
        
        
        ALMACENAR_VARIABLE MACRO VARI   
        
         
        MOV AH, 01H        ; Codigo de funcion para leer un carácter desde la entrada estandar
        INT 21H            ; Llama a la interrupcion 21H para leer un carácter
        SUB AL, 30H
        MOV VARI, AL 
        ENDM    
            
            
        ALMACENAR_CADENA MACRO CAD
             
        ;MOV CAD,25,000,26 DUP('$')
        
        
        MOV DX, OFFSET CADENA      ; Función 0: Limpia el búfer   
        MOV AH, 0AH  
        INT 21h
          
        ENDM
        
        MOSTRAR_TEXTO MACRO texto
        MOV AH, 09H
        MOV DX, OFFSET texto
        INT 21H
        ENDM

        ;PROCEDIMIENTOS Y MACROS DEL MENU DOS NUMEROS Y CADENA
        PEDIR_DATOS_DOS_NUMEROS_CAD PROC 
            
            MOSTRAR_TEXTO INGRESA_VALOR1
            ALMACENAR_VARIABLE NUMERO1 
            MOSTRAR_TEXTO INGRESA_VALOR2
            ALMACENAR_VARIABLE NUMERO2 
            MOSTRAR_TEXTO INGRESA_CADENA 
            ALMACENAR_CADENA CADENA
        
            RET
        ENDP

        
        VALIDAR_OPCION_SELECCIONADA_OP1 PROC
           CALL LIMPIAR_PANTALLA  
           
           CMP NUM,1 
           JE OP_UNO
 
           CMP NUM,2 
           JE OP_DOS:
            
           CMP NUM,3
           JE OP_TRES
           
           CMP NUM,4
           JE PRINCIPAL   
           
           OP_UNO:    
           
           MOV AL,NUMERO2  
 
           CMP NUMERO1,AL
           JG ES_MAYOR
           JL ES_MENOR
           JE SON_IGUAL 
           
           OP_DOS: 
                   ; Copia el valor de N a BX 
           MOV AL,NUMERO1 
           CBW              ; Extiende AL a AX (registro de 16 bits)
           MOV CX, AX        ; Mueve el valor extendido a CX
           
           IMPRIMIR:  
           MOSTRAR_TEXTO SALTO
           MOV BL,CADENA[1]
           MOV CADENA[BX+2],'$'
           MOV DX, OFFSET CADENA + 2   
           MOV AH,09H
           INT 21H 
           ;MOSTRAR_TEXTO CADENA
            LOOP IMPRIMIR
           
           JMP SALIR1  
           
           OP_TRES: 
 
           JMP MENU_DOSNUMEROS

         
           ES_MENOR:
           MOSTRAR_TEXTO ES_MENOR1
           MOSTRAR_TEXTO ES_DIFERENTE1
           JMP SALIR1
           
           SON_IGUAL:   
           MOSTRAR_TEXTO ES_IGUAL1 
           JMP SALIR1
           
           ES_MAYOR:
           MOSTRAR_TEXTO ES_MAYOR1
           MOSTRAR_TEXTO ES_DIFERENTE1 
           
           SALIR1:
          

         RET  
        ENDP    
        
        VALIDAR_OPCION_SELECCIONADA_OP2 PROC   
            
           CALL LIMPIAR_PANTALLA  
           
           CMP NUM,1 
           JE OPTI_UNO
 
           CMP NUM,2
           JE OPTI_DOS
            
           CMP NUM,3
           JE OPTI_TRES
           
           CMP NUM,4
           JE OPTI_CUATRO 
           
           CMP NUM,5
           JE PRINCIPAL
           
           OPTI_UNO:
                   
           MOSTRAR_TEXTO NOM_ARCHI   
           
           MOV DX, offset NAME_ARCHIVO
           MOV AH, 0Ah
           INT 21h
           XOR BX,BX
           MOV BL, NAME_ARCHIVO[1]
           MOV NAME_ARCHIVO[BX+2],0
           MOV CX,0
           MOV DX,OFFSET NAME_ARCHIVO+2
           MOV AH, 3Ch
           INT 21h
           JC ERROR1
           MOV BX, AX
           MOV AH, 3Eh
           INT 21h 
           MOSTRAR_TEXTO SALTO
           MOSTRAR_TEXTO MSG_ARCH_CREADO
           JMP SALIR2    
                       
           
           OPTI_DOS:
                                   
           MOSTRAR_TEXTO NOM_ARCHI
           mov DX, OFFSET NAME_ARCHIVO
           mov AH, 0Ah
           int 21h
           XOR BX,BX
           MOV BL, NAME_ARCHIVO[1]
           MOV NAME_ARCHIVO[BX+2],0  
          
           MOV AH, 3Dh
           MOV AL, 0
           MOV DX, OFFSET NAME_ARCHIVO+2
           int 21h
          
           JC ERROR1
          
           MOV FILEHANDLE, AX  
           MOV AH, 3Fh
           MOV CX, 25
           MOV DX, OFFSET BUFFER
           MOV BX, FILEHANDLE
           INT 21h
           JC ERROR1
          
    ;      xor bx, bx
    ;      mov bl, ax
    ;      mov buffer[bx], '$'
           MOSTRAR_TEXTO SALTO
           MOSTRAR_TEXTO BUFFER
           MOV DI, OFFSET BUFFER 
           limpiar_bufer:
           MOV byte ptr [DI], 0  ; Llena la ubicación actual del búfer con ceros
           INC DI                ; Avanza al siguiente byte
           LOOP limpiar_bufer     ; Repite el proceso para todo el búfer
                  
           MOV BX, FILEHANDLE
           MOV AH, 3Eh 
           
           INT 21h
          
           JMP SALIR2
             
                   
           OPTI_TRES:
           
           
           ; Limpiar el contenido del buffer antes de solicitar nueva entrada
            MOV DI, OFFSET BUFFERLEC+2 ; Puntero al comienzo del buffer
            MOV CX, 20 ; Longitud máxima del buffer, ajusta según sea necesario
            LIMPIAR_BUFFER2:
                MOV BYTE PTR [DI], 0 ; Establecer el byte actual en cero
                INC DI ; Mover al siguiente byte
            LOOP LIMPIAR_BUFFER2 ; Repetir hasta que todos los bytese hayan establecido en cero
  
            
           MOSTRAR_TEXTO MSG_TEXTO;se muestra el mensaje para que ingreses el texto 
           MOV DX, offset BUFFERLEC ; aqui se almacena el texto que anteriormente se escribio
           MOV AH, 0Ah
           INT 21h
                
                 
           MOSTRAR_TEXTO SALTO      
           MOSTRAR_TEXTO NOM_ARCHI ;se  muestra el mensaje para que se ingrese el nombre del archivo
           MOV DX, OFFSET NAME_ARCHIVO
           MOV AH, 0Ah
           INT 21h 
           XOR BX,BX
           MOV BL, NAME_ARCHIVO[1]
           MOV NAME_ARCHIVO[BX+2],0  
          
           MOV AH, 3Dh
           MOV AL, 1
           MOV DX, offset NAME_ARCHIVO+2
           INT 21h
          
           JC ERROR1
          
           MOV FILEHANDLE, AX  
           MOV  AH, 40h
           MOV  BX, FILEHANDLE
           MOV  CX, 20
           MOV  DX, offset BUFFERLEC+2
           INT 21h 
           
           JC ERROR1   
           
          
           MOV  BX, FILEHANDLE
           MOV  AH, 3Eh
           INT 21h
           
           MOSTRAR_TEXTO SALTO
           MOSTRAR_TEXTO MSG_MODIFICADO 
           
          
           JMP SALIR2
           
           OPTI_CUATRO: 
   
           
           MOSTRAR_TEXTO NOM_ARCHI
           MOV  DX, offset NAME_ARCHIVO 
           MOV  AH, 0Ah            
           INT 21h 
          
           XOR BX,BX
           MOV BL, NAME_ARCHIVO[1]
           MOV  NAME_ARCHIVO[BX+2],0 
          
           MOV  DX,offset NAME_ARCHIVO+2 
           MOV  AH, 41h
           INT 21h
           JC ERROR2
           
           MOSTRAR_TEXTO SALTO
           MOSTRAR_TEXTO MSG_DELETE 
           
           JMP SALIR2 
           
           

           ERROR1:   
           MOSTRAR_TEXTO SALTO
           MOSTRAR_TEXTO ERROR_CREACION    
           JMP SALIR2
           ERROR2:
           MOSTRAR_TEXTO MSG_ERRORDELETE   

           SALIR2:
 
            
            RET
        ENDP     
        
         VALIDAR_OPCION_SELECCIONADA_OP3 PROC
              
                       
           CMP NUM,1 
           JE OPT_UNO
 
           CMP NUM,2
           JE OPT_DOS
            
           CMP NUM,3
           JE OPT_TRES
           
           CMP NUM,4
           JE PRINCIPAL
           
           OPT_UNO:  
           DIBUJARREGALO1 

           JMP SALIR3
              
           OPT_DOS:   
           DIBUJARREGALO2 
           JMP SALIR3        
           
           OPT_TRES:
           DIBUJARESFERA
 
           SALIR3: 
            RET
         ENDP 
         
                     

            
     
    INICIO: 
    
        MOV AX,DATOS
        MOV DS,AX
        
        mov AH, 0Eh
        mov DL, 0
        int 21h  
        
        PRINCIPAL:
        
        MOSTRAR_TEXTO MENSAJE_MENU_PRINCIPAL
        ALMACENAR_VARIABLE NUM

        
        CMP NUM,1
        JE MENU_DOSNUMEROS
     
        CMP NUM,2
        JE MENU_OP_ARCHIVOS
        
        CMP NUM,3
        JE MENU_ART_PIXEL
        
        CMP NUM,4
        JE SALIR
        
        JMP PRINCIPAL 
        
        MENU_DOSNUMEROS: 
        CALL LIMPIAR_PANTALLA
        CALL PEDIR_DATOS_DOS_NUMEROS_CAD 
        REPETIR: 
        MOSTRAR_TEXTO MENU_COMPARAR_DOS_NUMEROS
        ALMACENAR_VARIABLE NUM 
        CALL VALIDAR_OPCION_SELECCIONADA_OP1
        JMP REPETIR
        
        
        MENU_OP_ARCHIVOS:
        CALL LIMPIAR_PANTALLA  
        REPETIR2:
        MOSTRAR_TEXTO MENU_OPERACIONES_ARCHIVO
        ALMACENAR_VARIABLE NUM
        CALL VALIDAR_OPCION_SELECCIONADA_OP2   
        JMP REPETIR2

        
          
        MENU_ART_PIXEL:
        CALL LIMPIAR_PANTALLA
        MOSTRAR_TEXTO MENU_ARTE_PIXEL
        ALMACENAR_VARIABLE NUM
        CALL VALIDAR_OPCION_SELECCIONADA_OP3  
        JMP MENU_ART_PIXEL


        
        SALIR:  
        
        MOSTRAR_TEXTO SALIENDO
        ; Coloca aquí el cOdigo que deseas ejecutar después de mostrar el mensaje correspondiente
    
        ;FIN DEL PROGRAMA
        MOV AH,4CH
        INT 21H
        
        CODIGO ENDS
        
END INICIO