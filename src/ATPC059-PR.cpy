      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * Tabla: FACTURA / CONCEPTOS ECONOMICOS 
      * (Estructura MPM0059 - Tabla MPDT059)
      *
      * Dependencias:
      *  - Debe estar declarada la rutina para manejo de errores 
      *    888888-LOGGEAR-TRANSACCION
      *
      * Procesos de uso Publicos:
      *  - ATPC059-CARGAR-ARREGLO
      *  - ATPC059-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------      


      *----------------------------------------------------------------
      * Proceso: ATPC059-CARGAR-ARREGLO
      *----------------------------------------------------------------
      * Se debe cargar una sola vez al iniciar el servicio
      * Ejemplo:
      *     PERFORM ATPC059-CARGAR-ARREGLO
      *----------------------------------------------------------------      
       ATPC059-CARGAR-ARREGLO.
           IF WS-ATPC059-TAB-CLAVE(1) = SPACES 
              INITIALIZE WS-ATPC059-CONTADOR
                         DATOS-PREVIOS-ENTRADA

              SET WS-ATPC059-FIN    TO FALSE
              
      *       Tipo de Paginacion (IND-PAGINACION)                                       
              SET MQCOPY-SIGUIENTE  TO TRUE

              PERFORM UNTIL WS-ATPC059-FIN
                 PERFORM ATPC059-ATOMICO-LLENAR
                 PERFORM ATPC059-ATOMICO-LLAMAR
                 EVALUATE TRUE
                   WHEN WS-ATPC059-RETORNO-OK
                      PERFORM ATPC059-LLENA-ARREGLO
                      IF MQCOPY-IND-MAS-DATOS = CT-N
                         SET WS-ATPC059-FIN TO TRUE
                      ELSE
                         MOVE MQCOPY-CLAVE-FIN TO MQCOPY-CLAVE-INICIO
                         SET  MQCOPY-SIGUIENTE    TO TRUE
                         INITIALIZE MQCOPY-CLAVE-FIN
      * Asignos datos claves para la siguiente busqueda                           
                         MOVE MP059-CODENT    
                           TO MQCOPY-CLAVE-FIN(14:4)
                         MOVE MP059-TIPOFAC(WS-ATPC059-MP059-CONTADOR)   
                           TO MQCOPY-CLAVE-FIN(21:4)
                         MOVE MP059-CODCONECO(WS-ATPC059-MP059-CONTADOR)
                           TO MQCOPY-CLAVE-FIN(57:4)
                      END-IF
                    WHEN OTHER
                      SET WS-ATPC059-FIN TO TRUE 
                 END-EVALUATE
              END-PERFORM
              
              DISPLAY 
           "----------------------------------------------------------"
              DISPLAY 
           "- CARGA DE TABLA EN MEMORIA (ATPC059)          -"
              DISPLAY "WS-ATPC059-CODENT....: "
                      "[" WS-ATPC059-CODENT "]"
              DISPLAY "WS-ATPC059-CODCONECO.: "
                      "[" WS-ATPC059-CODCONECO "]"
              
              DISPLAY "Cantidad de registros cargados: "
                      "[" WS-ATPC059-CONTADOR "]"
              DISPLAY " "             
           END-IF
           .
      

      *----------------------------------------------------------------
      * Proceso: ATPC059-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------
      * Se le debe especificar los datos de entrada e invocar el proceso
      * Ejemplo:
      *     INITIALIZE  WS-ATPC059
      *     INITIALIZE WS-MPM0059
      *     MOVE LIB611-ENTIDAD     TO WS-ATPC059-CODENT
      *     PERFORM ATPC059-BUSCAR-EN-ARREGLO  
      *----------------------------------------------------------------      
       ATPC059-BUSCAR-EN-ARREGLO.
           INITIALIZE WS-ATPC059-RETORNO
                      WS-ATPC059-RESPUESTA
           SET WS-ATPC059-TAB-INDICE TO 1
           SEARCH ALL WS-ATPC059-TAB
                  AT END 
                     PERFORM ATPC059-BUSCAR-NO-ENCONTRADO
                  WHEN WS-ATPC059-TAB-CLAVE (WS-ATPC059-TAB-INDICE) 
                                           = WS-ATPC059-CLAVE
                     PERFORM ATPC059-MOVER-DATOS-RESPUESTA
           END-SEARCH
           .




      *----------------------------------------------------------------
      * Procesos internos de soporte
      *----------------------------------------------------------------

      * Proceso de asignación de condiciones de filtro para la busqueda
       ATPC059-ATOMICO-LLENAR.
           INITIALIZE WS-MPM0059
           MOVE WS-ATPC059-CODENT    TO MP059-CODENT
           MOVE WS-ATPC059-CODCONECO TO MP059-CODCONECO(1)
           .


      *----------------------------------------------------------------
      * Proceso de ejecucion de busqueda
       ATPC059-ATOMICO-LLAMAR.
           MOVE CT-ATPC059             TO  MQCOPY-PROGRAMA-REAL
           MOVE CT-ATPC059             TO  MQCOPY-PROGRAMA
           MOVE "MPDT059"              TO  MQCOPY-NOMBRE-TABLA
           
           MOVE WS-MPM0059             TO  MQCOPY-MENSAJE
           MOVE ZEROES                 TO  MQCOPY-RETORNO

           IF SI-LOGGEA-SERVICIO
              MOVE "I"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC059          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
      *    Llamado a programa ATPC059 que consulta la tabla MPDT059
      *    con las condiciones expresadas en MQCOPY-MENSAJE
           CALL  CT-ATPC059   USING  WS-MQCOPY
           
           IF SI-LOGGEA-SERVICIO
              MOVE "O"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC059          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
           EVALUATE MQCOPY-RETORNO
              WHEN CT-RETORNO-OK
                   SET WS-ATPC059-RETORNO-OK    TO TRUE
                   MOVE MQCOPY-MENSAJE         TO  WS-MPM0059
              WHEN CT-MQCOPY-INFOR
                   SET WS-ATPC059-RETORNO-INFO  TO TRUE     
              WHEN OTHER
                   SET WS-ATPC059-RETORNO-ERROR TO TRUE
                   
                   DISPLAY "ATPC059 - MQCOPY-COD-ERROR:"
                           "[" MQCOPY-COD-ERROR "]"
                   DISPLAY "ATPC059 - MQCOPY-RETORNO:"
                           "[" MQCOPY-RETORNO "]"
           END-EVALUATE
           .


      *----------------------------------------------------------------
      * Proceso de carga de datos en el arreglo
       ATPC059-LLENA-ARREGLO.
      
           INITIALIZE WS-ATPC059-MP059-CONTADOR
           PERFORM UNTIL WS-ATPC059-MP059-CONTADOR > 
                             WS-ATPC059-MP059-OCCURS
                             
              ADD CT-01         TO WS-ATPC059-CONTADOR
              ADD CT-01         TO WS-ATPC059-MP059-CONTADOR
              
              MOVE WS-ATPC059-CONTADOR TO WS-ATPC059-TAB-OCCURS
              
              MOVE MP059-CODENT-ATR        
                TO WS-ATPC059-TAB-CODENT-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-CODENT            
                TO WS-ATPC059-TAB-CODENT(WS-ATPC059-CONTADOR)
                
              MOVE MP059-INDNORCOR-ATR(WS-ATPC059-MP059-CONTADOR)     
                TO WS-ATPC059-TAB-INDNORCOR-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-INDNORCOR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-INDNORCOR(WS-ATPC059-CONTADOR)
              MOVE MP059-TIPOFAC-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-TIPOFAC-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-TIPOFAC(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-TIPOFAC(WS-ATPC059-CONTADOR)
              MOVE MP059-DESTIPFAC-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-DESTIPFAC-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-DESTIPFAC(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-DESTIPFAC(WS-ATPC059-CONTADOR)
              MOVE MP059-CODCONECO-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-CODCONECO-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-CODCONECO(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-CODCONECO(WS-ATPC059-CONTADOR)
              MOVE MP059-DESCONECO-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-DESCONECO-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-DESCONECO(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-DESCONECO(WS-ATPC059-CONTADOR)
              MOVE MP059-INDAPLCON-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-INDAPLCON-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-INDAPLCON(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-INDAPLCON(WS-ATPC059-CONTADOR)
              MOVE MP059-INDAPLDEBCRE-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-INDAPLDEBCRE-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-INDAPLDEBCRE(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-INDAPLDEBCRE(WS-ATPC059-CONTADOR)
              MOVE MP059-FECALTA-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-FECALTA-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-FECALTA(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-FECALTA(WS-ATPC059-CONTADOR)
              MOVE MP059-CONTCUR-ATR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-CONTCUR-ATR(WS-ATPC059-CONTADOR)
              MOVE MP059-CONTCUR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-CONTCUR(WS-ATPC059-CONTADOR)
              MOVE MP059-INDCONTINUAR(WS-ATPC059-MP059-CONTADOR)
                TO WS-ATPC059-TAB-INDCONTINUAR(WS-ATPC059-CONTADOR)
                
      * El caracter @ en el campo MP059-INDCONTINUAR representa que ese
      * es el último dato entregado por la base de datos, por este motivo
      * se utiliza esta "igualdad" para cortar la carga del arreglo
              IF MP059-INDCONTINUAR(WS-ATPC059-MP059-CONTADOR) = '@'
                 EXIT PERFORM
              END-IF

           END-PERFORM
           .


      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicación
       ATPC059-MOVER-DATOS-RESPUESTA.
           INITIALIZE WS-ATPC059-RESPUESTA

           MOVE WS-ATPC059-TAB-CODENT-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-CODENT-ATR
           MOVE WS-ATPC059-TAB-CODENT(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-CODENT
           MOVE WS-ATPC059-TAB-INDNORCOR-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDNORCOR-ATR
           MOVE WS-ATPC059-TAB-INDNORCOR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDNORCOR
           MOVE WS-ATPC059-TAB-TIPOFAC-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-TIPOFAC-ATR
           MOVE WS-ATPC059-TAB-TIPOFAC(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-TIPOFAC
           MOVE WS-ATPC059-TAB-DESTIPFAC-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-DESTIPFAC-ATR
           MOVE WS-ATPC059-TAB-DESTIPFAC(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-DESTIPFAC
           MOVE WS-ATPC059-TAB-CODCONECO-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-CODCONECO-ATR
           MOVE WS-ATPC059-TAB-CODCONECO(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-CODCONECO
           MOVE WS-ATPC059-TAB-DESCONECO-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-DESCONECO-ATR
           MOVE WS-ATPC059-TAB-DESCONECO(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-DESCONECO
           MOVE WS-ATPC059-TAB-INDAPLCON-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDAPLCON-ATR
           MOVE WS-ATPC059-TAB-INDAPLCON(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDAPLCON
           MOVE WS-ATPC059-TAB-INDAPLDEBCRE-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDAPLDEBCRE-ATR
           MOVE WS-ATPC059-TAB-INDAPLDEBCRE(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDAPLDEBCRE
           MOVE WS-ATPC059-TAB-FECALTA-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-FECALTA-ATR
           MOVE WS-ATPC059-TAB-FECALTA(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-FECALTA
           MOVE WS-ATPC059-TAB-CONTCUR-ATR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-CONTCUR-ATR
           MOVE WS-ATPC059-TAB-CONTCUR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-CONTCUR
           MOVE WS-ATPC059-TAB-INDCONTINUAR(WS-ATPC059-TAB-INDICE)
             TO WS-ATPC059-INDCONTINUAR
           
           SET WS-ATPC059-RETORNO-OK         TO TRUE
           .

 
      *----------------------------------------------------------------
      * Proceso ejecutado cuando no se ha encontrado datos de 
      * Tipos de Tarjetas con los criterios de busquedas recibidos          
       ATPC059-BUSCAR-NO-ENCONTRADO.
           SET WS-ATPC059-RETORNO-ERROR      TO TRUE
           STRING "No se encontro el dato buscado en ATPC059." 
                                                    DELIMITED BY SIZE
                  " - CODENT:"                      DELIMITED BY SIZE
                  "[" WS-ATPC059-CODENT "]"         DELIMITED BY SIZE
                  " - INDNORCOR:"                   DELIMITED BY SIZE
                  "[" WS-ATPC059-INDNORCOR "]"      DELIMITED BY SIZE
                  " - TIPOFAC:"                     DELIMITED BY SIZE
                  "[" WS-ATPC059-TIPOFAC "]"        DELIMITED BY SIZE
                  " - INDAPLCON:"                   DELIMITED BY SIZE
                  "[" WS-ATPC059-INDAPLCON "]"      DELIMITED BY SIZE
                  " - INDAPLDEBCRE:"                DELIMITED BY SIZE
                  "[" WS-ATPC059-INDAPLDEBCRE "]"   DELIMITED BY SIZE
             INTO WS-ATPC059-RETORNO-DESC
           END-STRING
           .
