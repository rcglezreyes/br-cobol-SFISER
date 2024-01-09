      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla TIPO DE TARJETA (estructura MPM0026)
      *
      * Dependencias:
      *  - Debe estar declarada la rutina para manejo de errores 
      *    888888-LOGGEAR-TRANSACCION
      *
      * Procesos de uso Publicos:
      *  - ATPC026-CARGAR-ARREGLO
      *  - ATPC026-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------      


      *----------------------------------------------------------------
      * Proceso: ATPC026-CARGAR-ARREGLO
      *----------------------------------------------------------------
      * Se debe cargar una sola vez al iniciar el servicio 
      * Ejemplo:
      *     PERFORM ATPC026-CARGAR-ARREGLO 
      *----------------------------------------------------------------      
       ATPC026-CARGAR-ARREGLO.
           IF WS-ATPC026-TAB-CLAVE(1) = SPACES 
      
              INITIALIZE WS-ATPC026-CONTADOR
                         MQCOPY-CLAVE-FIN

              SET WS-ATPC026-FIN    TO FALSE

              PERFORM UNTIL WS-ATPC026-FIN
                 PERFORM ATPC026-ATOMICO-LLENAR 
                 PERFORM ATPC026-ATOMICO-LLAMAR 
                 PERFORM ATPC026-LLENA-ARREGLO  
                 IF MQCOPY-IND-MAS-DATOS = CT-N 
                    SET WS-ATPC026-FIN TO TRUE
                 ELSE
                    MOVE MQCOPY-CLAVE-FIN TO MQCOPY-CLAVE-INICIO
                    SET  MQCOPY-SIGUIENTE    TO TRUE
                    INITIALIZE MQCOPY-CLAVE-FIN
                 END-IF
              END-PERFORM

              DISPLAY 
           "----------------------------------------------------------"
              DISPLAY 
           "- CARGA DE TABLA DE TIPOS TARJETAS EN MEMORIA (ATPC026)  -"
              DISPLAY "WS-ATPC026-CODENT: [" WS-ATPC026-CODENT "]"
              DISPLAY "Cantidad de Tipo de Tarjetas cargadas: [" 
                      WS-ATPC026-CONTADOR "]"
              DISPLAY " "
           END-IF
           .
      

      *----------------------------------------------------------------
      * Proceso: ATPC026-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------
      * Se le debe especificar los datos de entrada e invocar el proceso
      * Ejemplo:
      *     INITIALIZE WS-ATPC026
      *     MOVE WS-CODENT-A         TO WS-ATPC026-CODENT
      *     MOVE ATDATTAS-MARCA-SAL  TO WS-ATPC026-CODMAR
      *     MOVE ATDATTAS-TIPO-SAL   TO WS-ATPC026-INDTIPT
      *     PERFORM ATPC026-BUSCAR-EN-ARREGLO  
      *     MOVE WS-ATPC026-DESTIPT(1:20)
      *       TO LIB510-TCONT-DESCRIP(WS-SAL)
      *----------------------------------------------------------------      
       ATPC026-BUSCAR-EN-ARREGLO.
           SET WS-ATPC026-TAB-INDICE TO 1
           SEARCH ALL WS-ATPC026-TAB
                  AT END 
                     PERFORM ATPC026-BUSCAR-NO-ENCONTRADO 
                  WHEN WS-ATPC026-TAB-CLAVE (WS-ATPC026-TAB-INDICE) 
                                            = WS-ATPC026-CLAVE
                       PERFORM ATPC026-MOVER-DATOS-RESPUESTA 
           END-SEARCH
           .




      *----------------------------------------------------------------
      * Procesos internos de soporte
      *----------------------------------------------------------------

      *----------------------------------------------------------------
      * Proceso de asignación de condiciones de filtro para la busqueda
      * de Tipos Tarjetas
       ATPC026-ATOMICO-LLENAR.
           INITIALIZE WS-MPM0026
           MOVE WS-ATPC026-CODENT   TO MP026-CODENT
           .


      *----------------------------------------------------------------
      * Proceso de ejecucion de busqueda de Tipos Tarjetas
       ATPC026-ATOMICO-LLAMAR.
           MOVE CT-ATPC026             TO  MQCOPY-PROGRAMA-REAL
           MOVE CT-ATPC026             TO  MQCOPY-PROGRAMA
           MOVE "MPDT026"              TO  MQCOPY-NOMBRE-TABLA
      
           MOVE WS-MPM0026             TO  MQCOPY-MENSAJE
           MOVE ZEROES                 TO  MQCOPY-RETORNO

           IF SI-LOGGEA-SERVICIO
              MOVE "I"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC026          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
      *    Llamado a programa ATPC026 que consulta la tabla MPDT026
      *    con las condiciones expresadas en MQCOPY-MENSAJE
           CALL  CT-ATPC026   USING  WS-MQCOPY
           
           IF SI-LOGGEA-SERVICIO
              MOVE "O"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC026          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           IF MQCOPY-RETORNO = CT-RETORNO-OK
              MOVE MQCOPY-MENSAJE         TO  WS-MPM0026
           END-IF
           .
           

      *----------------------------------------------------------------
      * Proceso de carga de datos en el arreglo de Tipo Tarjetas
       ATPC026-LLENA-ARREGLO.
           INITIALIZE WS-ATPC026-MP026-CONTADOR
           
           PERFORM UNTIL WS-ATPC026-MP026-CONTADOR > 
                              WS-ATPC026-MP026-OCCURS
               
              ADD CT-01                TO WS-ATPC026-CONTADOR
              ADD CT-01                TO WS-ATPC026-MP026-CONTADOR
              
              MOVE WS-ATPC026-CONTADOR TO WS-ATPC026-TAB-OCCURS
              
              MOVE MP026-CODENT
                TO WS-ATPC026-TAB-CODENT(WS-ATPC026-CONTADOR)
              MOVE MP026-CODMAR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-CODMAR(WS-ATPC026-CONTADOR)
              MOVE MP026-INDTIPT(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-INDTIPT(WS-ATPC026-CONTADOR)
                
              MOVE MP026-CODENT-ATR
                TO WS-ATPC026-TAB-CODENT-ATR(WS-ATPC026-CONTADOR) 
              MOVE MP026-CODMAR-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-CODMAR-ATR(WS-ATPC026-CONTADOR) 
              MOVE MP026-DESMAR-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-DESMAR-ATR(WS-ATPC026-CONTADOR) 
              MOVE MP026-DESMAR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-DESMAR(WS-ATPC026-CONTADOR)           
              MOVE MP026-INDTIPT-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-INDTIPT-ATR(WS-ATPC026-CONTADOR)    
              MOVE MP026-CLASE-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-CLASE-ATR(WS-ATPC026-CONTADOR)          
              MOVE MP026-CLASE(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-CLASE(WS-ATPC026-CONTADOR)           
              MOVE MP026-DESTIPT-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-DESTIPT-ATR(WS-ATPC026-CONTADOR)      
              MOVE MP026-DESTIPT(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-DESTIPT(WS-ATPC026-CONTADOR)          
              MOVE MP026-DESTIPTRED-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-DESTIPTRED-ATR(WS-ATPC026-CONTADOR)
              MOVE MP026-DESTIPTRED(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-DESTIPTRED(WS-ATPC026-CONTADOR)       
              MOVE MP026-CONTCUR-ATR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-CONTCUR-ATR(WS-ATPC026-CONTADOR)      
              MOVE MP026-CONTCUR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-CONTCUR(WS-ATPC026-CONTADOR)          
              MOVE MP026-INDCONTINUAR(WS-ATPC026-MP026-CONTADOR)
                TO WS-ATPC026-TAB-INDCONTINUAR(WS-ATPC026-CONTADOR)

      * El caracter @ en el campo MP026-INDCONTINUAR representa que ese
      * es el último dato entregado por la base de datos, por este motivo
      * se utiliza esta "igualdad" para cortar la carga del arreglo
              IF MP026-INDCONTINUAR(WS-ATPC026-MP026-CONTADOR) = '@'
                 MOVE WS-ATPC026-CONTADOR TO WS-ATPC026-TAB-OCCURS
                 EXIT PERFORM
              END-IF
           END-PERFORM
           .

           
      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicación
       ATPC026-MOVER-DATOS-RESPUESTA.
           INITIALIZE WS-ATPC026-RESPUESTA
           
           MOVE WS-ATPC026-TAB-CODENT-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-CODENT-ATR    
           MOVE WS-ATPC026-TAB-CODMAR-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-CODMAR-ATR    
           MOVE WS-ATPC026-TAB-DESMAR-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-DESMAR-ATR    
           MOVE WS-ATPC026-TAB-DESMAR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-DESMAR              
           MOVE WS-ATPC026-TAB-INDTIPT-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-INDTIPT-ATR       
           MOVE WS-ATPC026-TAB-CLASE-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-CLASE-ATR             
           MOVE WS-ATPC026-TAB-CLASE(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-CLASE              
           MOVE WS-ATPC026-TAB-DESTIPT-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-DESTIPT-ATR         
           MOVE WS-ATPC026-TAB-DESTIPT(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-DESTIPT             
           MOVE WS-ATPC026-TAB-DESTIPTRED-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-DESTIPTRED-ATR      
           MOVE WS-ATPC026-TAB-DESTIPTRED(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-DESTIPTRED          
           MOVE WS-ATPC026-TAB-CONTCUR-ATR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-CONTCUR-ATR         
           MOVE WS-ATPC026-TAB-CONTCUR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-CONTCUR             
           MOVE WS-ATPC026-TAB-INDCONTINUAR(WS-ATPC026-TAB-INDICE)
             TO WS-ATPC026-INDCONTINUAR
           .


      *----------------------------------------------------------------
      * Proceso ejecutado cuando no se ha encontrado datos de 
      * Tipos de Tarjetas con los criterios de busquedas recibidos
       ATPC026-BUSCAR-NO-ENCONTRADO.
           SET WS-ATPC026-RETORNO-ERROR      TO TRUE
           STRING "No se encontro el dato buscado en ATPC026." 
                                               DELIMITED BY SIZE
                  " - CODENT:["                DELIMITED BY SIZE
                  WS-ATPC026-CODENT            DELIMITED BY SIZE
                  "] - WS-ATPC026-CODMAR:["    DELIMITED BY SIZE
                  WS-ATPC026-CODMAR            DELIMITED BY SIZE
                  "] - WS-ATPC026-INDTIPT:["   DELIMITED BY SIZE
                  WS-ATPC026-INDTIPT           DELIMITED BY SIZE
                  "]"                          DELIMITED BY SIZE
             INTO WS-ATPC026-RETORNO-DESC
           END-STRING
           .