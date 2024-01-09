      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla FECHAS DE LIQUIDACIONES (estructura MPM0086)
      *
      * Dependencias:
      *  - Debe estar declarada la rutina para manejo de errores 
      *    888888-LOGGEAR-TRANSACCION
      *
      * Procesos de uso Publicos:
      *  - ATPC086-CARGAR-ARREGLO
      *  - ATPC086-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------      


      *----------------------------------------------------------------
      * Proceso: ATPC086-CARGAR-ARREGLO
      *----------------------------------------------------------------
      * Se debe cargar una sola vez al iniciar el servicio
      * Ejemplo:
      *     PERFORM ATPC086-CARGAR-ARREGLO
      *----------------------------------------------------------------      
       ATPC086-CARGAR-ARREGLO.
           IF WS-ATPC086-TAB-CLAVE(1) = SPACES 

              INITIALIZE WS-ATPC086-CONTADOR
                         MQCOPY-CLAVE-FIN

              SET WS-ATPC086-FIN    TO FALSE

              PERFORM UNTIL WS-ATPC086-FIN
                 PERFORM ATPC086-ATOMICO-LLENAR
                 PERFORM ATPC086-ATOMICO-LLAMAR
                 EVALUATE TRUE
                   WHEN WS-ATPC086-RETORNO-OK
                      PERFORM ATPC086-LLENA-ARREGLO
                      IF MQCOPY-IND-MAS-DATOS = CT-N
                         SET WS-ATPC086-FIN TO TRUE
                      ELSE
                         MOVE MQCOPY-CLAVE-FIN TO MQCOPY-CLAVE-INICIO
                         SET  MQCOPY-SIGUIENTE    TO TRUE
                         INITIALIZE MQCOPY-CLAVE-FIN
                      END-IF
                    WHEN OTHER
                      SET WS-ATPC086-FIN TO TRUE 
                 END-EVALUATE
              END-PERFORM
              
               DISPLAY 
           "----------------------------------------------------------"
              DISPLAY 
           "- CARGA DE TABLA DE FECHAS EN MEMORIA (ATPC086)          -"
              DISPLAY "WS-ATPC086-CODENT....: "
                      "[" WS-ATPC086-CODENT "]"
              DISPLAY "WS-ATPC086-CODPROCESO: "
                      "[" WS-ATPC086-CODPROCESO "]"
              DISPLAY "WS-ATPC086-CODGRUPO..: "
                      "[" WS-ATPC086-CODGRUPO "]"
              DISPLAY "Cantidad de Fechas cargadas: "
                      "[" WS-ATPC086-CONTADOR "]"
              DISPLAY " "             
           END-IF
           .
      

      *----------------------------------------------------------------
      * Proceso: ATPC086-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------
      * Se le debe especificar los datos de entrada e invocar el proceso
      * Ejemplo:
      *     INITIALIZE  WS-ATPC086
      *     MOVE LIB510-CODENT         TO WS-ATPC086-CODENT
      *     MOVE CT-01                 TO WS-ATPC086-CODPROCESO
      *     MOVE ATDATTAS-GRUPOLIQ-SAL TO WS-ATPC086-CODGRUPO
      *     PERFORM ATPC086-BUSCAR-EN-ARREGLO  
      *     MOVE WS-ATPC086-DESTIPT(1:20)
      *       TO LIB510-TCONT-DESCRIP(WS-SAL)
      *----------------------------------------------------------------      
       ATPC086-BUSCAR-EN-ARREGLO.
           INITIALIZE WS-ATPC086-RETORNO

           SET WS-ATPC086-TAB-INDICE TO 1
           SEARCH ALL WS-ATPC086-TAB
                  AT END 
                     PERFORM ATPC086-BUSCAR-NO-ENCONTRADO
                  WHEN WS-ATPC086-TAB-CLAVE (WS-ATPC086-TAB-INDICE) 
                                           = WS-ATPC086-CLAVE
                       PERFORM ATPC086-MOVER-DATOS-RESPUESTA
           END-SEARCH
           .




      *----------------------------------------------------------------
      * Procesos internos de soporte
      *----------------------------------------------------------------

      * Proceso de asignación de condiciones de filtro para la busqueda
      * de Fechas Liquidaciones
       ATPC086-ATOMICO-LLENAR.
           INITIALIZE WS-MPM0086
           MOVE WS-ATPC086-CODENT   TO MP086-CODENT
           .


      *----------------------------------------------------------------
      * Proceso de ejecucion de busqueda de Fechas Liquidaciones
       ATPC086-ATOMICO-LLAMAR.
           MOVE CT-ATPC086             TO  MQCOPY-PROGRAMA-REAL
           MOVE CT-ATPC086             TO  MQCOPY-PROGRAMA
           MOVE "MPDT086"              TO  MQCOPY-NOMBRE-TABLA
           
           MOVE WS-MPM0086             TO  MQCOPY-MENSAJE
           MOVE ZEROES                 TO  MQCOPY-RETORNO

           IF SI-LOGGEA-SERVICIO
              MOVE "I"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC086          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
      *    Llamado a programa ATPC086 que consulta la tabla MPDT086
      *    con las condiciones expresadas en MQCOPY-MENSAJE
           CALL  CT-ATPC086   USING  WS-MQCOPY
           
           IF SI-LOGGEA-SERVICIO
              MOVE "O"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC086          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
           EVALUATE MQCOPY-RETORNO
              WHEN CT-RETORNO-OK
                   SET WS-ATPC086-RETORNO-OK    TO TRUE
                   MOVE MQCOPY-MENSAJE         TO  WS-MPM0086
              WHEN CT-MQCOPY-INFOR
                   SET WS-ATPC086-RETORNO-INFO  TO TRUE     
              WHEN OTHER
                   SET WS-ATPC086-RETORNO-ERROR TO TRUE
           END-EVALUATE
           .


      *----------------------------------------------------------------
      * Proceso de carga de datos en el arreglo de Fechas Liquidaciones
       ATPC086-LLENA-ARREGLO.
      
           INITIALIZE WS-ATPC086-MP086-CONTADOR
           PERFORM UNTIL WS-ATPC086-MP086-CONTADOR > 
                             WS-ATPC086-MP086-OCCURS
                             
              ADD CT-01         TO WS-ATPC086-CONTADOR
              ADD CT-01         TO WS-ATPC086-MP086-CONTADOR
              
              MOVE WS-ATPC086-CONTADOR TO WS-ATPC086-TAB-OCCURS
              
              MOVE MP086-CODENT
                TO WS-ATPC086-TAB-CODENT(WS-ATPC086-CONTADOR)

              MOVE MP086-CODENT-ATR     
                TO WS-ATPC086-TAB-CODENT-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-CODPROCESO-ATR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-CODPROCESO-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-CODPROCESO(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-CODPROCESO(WS-ATPC086-CONTADOR)
              MOVE MP086-DESPROCESO-ATR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-DESPROCESO-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-DESPROCESO(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-DESPROCESO(WS-ATPC086-CONTADOR)
              MOVE MP086-CODGRUPO-ATR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-CODGRUPO-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-CODGRUPO(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-CODGRUPO(WS-ATPC086-CONTADOR)
              MOVE MP086-DESCRIPCION-ATR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-DESCRIPCION-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-DESCRIPCION(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-DESCRIPCION(WS-ATPC086-CONTADOR)
              MOVE MP086-DESCRED-ATR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-DESCRED-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-DESCRED(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-DESCRED(WS-ATPC086-CONTADOR)
              MOVE MP086-CONTCUR-ATR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-CONTCUR-ATR(WS-ATPC086-CONTADOR)
              MOVE MP086-CONTCUR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-CONTCUR(WS-ATPC086-CONTADOR)
              MOVE MP086-INDCONTINUAR(WS-ATPC086-MP086-CONTADOR)
                TO WS-ATPC086-TAB-INDCONTINUAR(WS-ATPC086-CONTADOR)
                
      * El caracter @ en el campo MP086-INDCONTINUAR representa que ese
      * es el último dato entregado por la base de datos, por este motivo
      * se utiliza esta "igualdad" para cortar la carga del arreglo
              IF MP086-INDCONTINUAR(WS-ATPC086-MP086-CONTADOR) = '@'
                 EXIT PERFORM
              END-IF

           END-PERFORM
           .


      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicación
       ATPC086-MOVER-DATOS-RESPUESTA.
           INITIALIZE WS-ATPC086-RESPUESTA

           MOVE WS-ATPC086-TAB-CODENT-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CODENT-ATR
           MOVE WS-ATPC086-TAB-CODPROCESO-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CODPROCESO-ATR
           MOVE WS-ATPC086-TAB-CODPROCESO(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CODPROCESO
           MOVE WS-ATPC086-TAB-DESPROCESO-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-DESPROCESO-ATR
           MOVE WS-ATPC086-TAB-DESPROCESO(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-DESPROCESO
           MOVE WS-ATPC086-TAB-CODGRUPO-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CODGRUPO-ATR
           MOVE WS-ATPC086-TAB-CODGRUPO(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CODGRUPO
           MOVE WS-ATPC086-TAB-DESCRIPCION-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-DESCRIPCION-ATR
           MOVE WS-ATPC086-TAB-DESCRIPCION(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-DESCRIPCION
           MOVE WS-ATPC086-TAB-DESCRED-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-DESCRED-ATR
           MOVE WS-ATPC086-TAB-DESCRED(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-DESCRED
           MOVE WS-ATPC086-TAB-CONTCUR-ATR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CONTCUR-ATR
           MOVE WS-ATPC086-TAB-CONTCUR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-CONTCUR
           MOVE WS-ATPC086-TAB-INDCONTINUAR(WS-ATPC086-TAB-INDICE)
             TO WS-ATPC086-INDCONTINUAR
           
           SET WS-ATPC086-RETORNO-OK         TO TRUE
           .

 
      *----------------------------------------------------------------
      * Proceso ejecutado cuando no se ha encontrado datos de 
      * Tipos de Tarjetas con los criterios de busquedas recibidos          
       ATPC086-BUSCAR-NO-ENCONTRADO.
           SET WS-ATPC086-RETORNO-ERROR      TO TRUE
           STRING "No se encontro el dato buscado en ATPC086." 
                                               DELIMITED BY SIZE
                  " - CODENT:["                DELIMITED BY SIZE
                  WS-ATPC086-CODENT            DELIMITED BY SIZE
                  "] - CODPROCESO:["           DELIMITED BY SIZE
                  WS-ATPC086-CODPROCESO        DELIMITED BY SIZE
                  "] - CODGRUPO:["             DELIMITED BY SIZE
                  WS-ATPC086-CODGRUPO          DELIMITED BY SIZE
                  "]"                          DELIMITED BY SIZE
            INTO WS-ATPC086-RETORNO-DESC
           END-STRING
           .