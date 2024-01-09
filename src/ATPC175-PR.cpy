      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla de DESCRIPC. ESTADO CUENTA O REPACTACION (estructura MPM0175)
      *
      * Dependencias:
      *  - Debe estar declarada la rutina para manejo de errores 
      *    888888-LOGGEAR-TRANSACCION
      *
      * Procesos de uso Publicos:
      *  - ATPC175-CARGAR-ARREGLO
      *  - ATPC175-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------      


      *----------------------------------------------------------------
      * Proceso: ATPC175-CARGAR-ARREGLO
      *----------------------------------------------------------------
      * Se debe cargar una sola vez al iniciar el servicio
      * Ejemplo:
      *     PERFORM ATPC175-CARGAR-ARREGLO
      *----------------------------------------------------------------      
       ATPC175-CARGAR-ARREGLO.
           IF WS-ATPC175-TAB-CLAVE(1) = SPACES 

              INITIALIZE WS-ATPC175-CONTADOR
                         MQCOPY-CLAVE-FIN

              SET WS-ATPC175-FIN    TO FALSE

              PERFORM UNTIL WS-ATPC175-FIN
                 PERFORM ATPC175-ATOMICO-LLENAR
                 PERFORM ATPC175-ATOMICO-LLAMAR
                 EVALUATE TRUE
                   WHEN WS-ATPC175-RETORNO-OK
                      PERFORM ATPC175-LLENA-ARREGLO
                      IF MQCOPY-IND-MAS-DATOS = CT-N
                         SET WS-ATPC175-FIN TO TRUE
                      ELSE
                         MOVE MQCOPY-CLAVE-FIN TO MQCOPY-CLAVE-INICIO
                         SET  MQCOPY-SIGUIENTE    TO TRUE
                         INITIALIZE MQCOPY-CLAVE-FIN
                      END-IF
                    WHEN OTHER
                      SET WS-ATPC175-FIN TO TRUE 
                 END-EVALUATE
              END-PERFORM
              
               DISPLAY 
           "----------------------------------------------------------"
              DISPLAY 
           "- CARGA DE TABLA DE FECHAS EN MEMORIA (ATPC175)          -"
              DISPLAY "WS-ATPC175-CODENT....: "
                      "[" WS-ATPC175-CODENT "]"
              DISPLAY "Cantidad de Fechas cargadas: "
                      "[" WS-ATPC175-CONTADOR "]"
              DISPLAY " "             
           END-IF
           .
      

      *----------------------------------------------------------------
      * Proceso: ATPC175-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------
      * Se le debe especificar los datos de entrada e invocar el proceso
      * Ejemplo:
      *     INITIALIZE  WS-ATPC175
      *     MOVE LIB075R-CODENT            TO WS-ATPC175-CODENT
      *     MOVE LIB075R-CODESTCTA         TO WS-ATPC175-CODESTCTA
      *     PERFORM ATPC175-BUSCAR-EN-ARREGLO  
      *     MOVE WS-ATPC175-DESESTCTA    (1)  TO L300C-DESESTCTA
      *     MOVE WS-ATPC175-DESESTCTARED (1)  TO L300C-DESESTCTARED
      *----------------------------------------------------------------      
       ATPC175-BUSCAR-EN-ARREGLO.
           INITIALIZE WS-ATPC175-RETORNO
                      WS-ATPC175-RESPUESTA
           SET WS-ATPC175-TAB-INDICE TO 1
           SEARCH ALL WS-ATPC175-TAB
                  AT END 
                     PERFORM ATPC175-BUSCAR-NO-ENCONTRADO
                  WHEN WS-ATPC175-TAB-CLAVE (WS-ATPC175-TAB-INDICE) 
                                           = WS-ATPC175-CLAVE
                     PERFORM ATPC175-MOVER-DATOS-RESPUESTA
           END-SEARCH
           .




      *----------------------------------------------------------------
      * Procesos internos de soporte
      *----------------------------------------------------------------

      * Proceso de asignación de condiciones de filtro para la busqueda
      * de Fechas Liquidaciones
       ATPC175-ATOMICO-LLENAR.
           INITIALIZE WS-MPM0175
           MOVE WS-ATPC175-CODENT   TO MP175-CODENT
           .


      *----------------------------------------------------------------
      * Proceso de ejecucion de busqueda de Fechas Liquidaciones
       ATPC175-ATOMICO-LLAMAR.
           MOVE CT-ATPC175             TO  MQCOPY-PROGRAMA-REAL
           MOVE CT-ATPC175             TO  MQCOPY-PROGRAMA
           MOVE "MPDT175"              TO  MQCOPY-NOMBRE-TABLA
           
           MOVE WS-MPM0175             TO  MQCOPY-MENSAJE
           MOVE ZEROES                 TO  MQCOPY-RETORNO

           IF SI-LOGGEA-SERVICIO
              MOVE "I"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC175          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
      *    Llamado a programa ATPC175 que consulta la tabla MPDT175
      *    con las condiciones expresadas en MQCOPY-MENSAJE
           CALL  CT-ATPC175   USING  WS-MQCOPY
           
           IF SI-LOGGEA-SERVICIO
              MOVE "O"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC175          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
           EVALUATE MQCOPY-RETORNO
              WHEN CT-RETORNO-OK
                   SET WS-ATPC175-RETORNO-OK    TO TRUE
                   MOVE MQCOPY-MENSAJE         TO  WS-MPM0175
              WHEN CT-MQCOPY-INFOR
                   SET WS-ATPC175-RETORNO-INFO  TO TRUE     
              WHEN OTHER
                   SET WS-ATPC175-RETORNO-ERROR TO TRUE
           END-EVALUATE
           .


      *----------------------------------------------------------------
      * Proceso de carga de datos en el arreglo de Fechas Liquidaciones
       ATPC175-LLENA-ARREGLO.
      
           INITIALIZE WS-ATPC175-MP175-CONTADOR
           PERFORM UNTIL WS-ATPC175-MP175-CONTADOR > 
                             WS-ATPC175-MP175-OCCURS
                             
              ADD CT-01         TO WS-ATPC175-CONTADOR
              ADD CT-01         TO WS-ATPC175-MP175-CONTADOR
              
              MOVE WS-ATPC175-CONTADOR TO WS-ATPC175-TAB-OCCURS
              
              MOVE MP175-CODENT
                TO WS-ATPC175-TAB-CODENT(WS-ATPC175-CONTADOR)

              MOVE MP175-CODENT-ATR     
                TO WS-ATPC175-TAB-CODENT-ATR(WS-ATPC175-CONTADOR)

              MOVE MP175-CODESTCTA-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CODESTCTA-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-CODESTCTA(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CODESTCTA(WS-ATPC175-CONTADOR)
              MOVE MP175-LINEA-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-LINEA-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-LINEA(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-LINEA(WS-ATPC175-CONTADOR)
              MOVE MP175-TIPESTCTA-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-TIPESTCTA-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-TIPESTCTA(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-TIPESTCTA(WS-ATPC175-CONTADOR)
              MOVE MP175-DESESTCTA-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-DESESTCTA-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-DESESTCTA(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-DESESTCTA(WS-ATPC175-CONTADOR)
              MOVE MP175-DESESTCTARED-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-DESESTCTARED-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-DESESTCTARED(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-DESESTCTARED(WS-ATPC175-CONTADOR)
              MOVE MP175-NUMDIASACT-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-NUMDIASACT-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-NUMDIASACT(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-NUMDIASACT(WS-ATPC175-CONTADOR)
              MOVE MP175-CLASIFCONT-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CLASIFCONT-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-CLASIFCONT(WS-ATPC175-MP175-CONTADOR)  
                TO WS-ATPC175-TAB-CLASIFCONT(WS-ATPC175-CONTADOR)
              MOVE MP175-CODBLQ-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CODBLQ-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-CODBLQ(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CODBLQ(WS-ATPC175-CONTADOR)
              MOVE MP175-DESBLQ-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-DESBLQ-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-DESBLQ(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-DESBLQ(WS-ATPC175-CONTADOR)
              MOVE MP175-INDACEDEU-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-INDACEDEU-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-INDACEDEU(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-INDACEDEU(WS-ATPC175-CONTADOR)
              MOVE MP175-CONTCUR-ATR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CONTCUR-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-CONTCUR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-CONTCUR(WS-ATPC175-CONTADOR)
              MOVE MP175-INDCONTINUAR(WS-ATPC175-MP175-CONTADOR) 
                TO WS-ATPC175-TAB-INDCONTINUAR(WS-ATPC175-CONTADOR)

              MOVE MP175-CONTCUR-ATR(WS-ATPC175-MP175-CONTADOR)
                TO WS-ATPC175-TAB-CONTCUR-ATR(WS-ATPC175-CONTADOR)
              MOVE MP175-CONTCUR(WS-ATPC175-MP175-CONTADOR)
                TO WS-ATPC175-TAB-CONTCUR(WS-ATPC175-CONTADOR)
              MOVE MP175-INDCONTINUAR(WS-ATPC175-MP175-CONTADOR)
                TO WS-ATPC175-TAB-INDCONTINUAR(WS-ATPC175-CONTADOR)
                
      * El caracter @ en el campo MP175-INDCONTINUAR representa que ese
      * es el último dato entregado por la base de datos, por este motivo
      * se utiliza esta "igualdad" para cortar la carga del arreglo
              IF MP175-INDCONTINUAR(WS-ATPC175-MP175-CONTADOR) = '@'
                 EXIT PERFORM
              END-IF

           END-PERFORM
           .


      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicación
       ATPC175-MOVER-DATOS-RESPUESTA.
           INITIALIZE WS-ATPC175-RESPUESTA

           MOVE WS-ATPC175-TAB-CODENT-ATR(WS-ATPC175-TAB-INDICE)
             TO WS-ATPC175-CODENT-ATR

           MOVE WS-ATPC175-TAB-CODESTCTA-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CODESTCTA-ATR
           MOVE WS-ATPC175-TAB-CODESTCTA(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CODESTCTA
           MOVE WS-ATPC175-TAB-LINEA-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-LINEA-ATR
           MOVE WS-ATPC175-TAB-LINEA(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-LINEA
           MOVE WS-ATPC175-TAB-TIPESTCTA-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-TIPESTCTA-ATR
           MOVE WS-ATPC175-TAB-TIPESTCTA(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-TIPESTCTA
           MOVE WS-ATPC175-TAB-DESESTCTA-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-DESESTCTA-ATR
           MOVE WS-ATPC175-TAB-DESESTCTA(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-DESESTCTA
           MOVE WS-ATPC175-TAB-DESESTCTARED-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-DESESTCTARED-ATR
           MOVE WS-ATPC175-TAB-DESESTCTARED(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-DESESTCTARED
           MOVE WS-ATPC175-TAB-NUMDIASACT-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-NUMDIASACT-ATR
           MOVE WS-ATPC175-TAB-NUMDIASACT(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-NUMDIASACT
           MOVE WS-ATPC175-TAB-CLASIFCONT-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CLASIFCONT-ATR
           MOVE WS-ATPC175-TAB-CLASIFCONT(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CLASIFCONT
           MOVE WS-ATPC175-TAB-CODBLQ-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CODBLQ-ATR
           MOVE WS-ATPC175-TAB-CODBLQ(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CODBLQ
           MOVE WS-ATPC175-TAB-DESBLQ-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-DESBLQ-ATR
           MOVE WS-ATPC175-TAB-DESBLQ(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-DESBLQ
           MOVE WS-ATPC175-TAB-INDACEDEU-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-INDACEDEU-ATR
           MOVE WS-ATPC175-TAB-INDACEDEU(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-INDACEDEU
           MOVE WS-ATPC175-TAB-CONTCUR-ATR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CONTCUR-ATR
           MOVE WS-ATPC175-TAB-CONTCUR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-CONTCUR
           MOVE WS-ATPC175-TAB-INDCONTINUAR(WS-ATPC175-TAB-INDICE) 
             TO WS-ATPC175-INDCONTINUAR

           MOVE WS-ATPC175-TAB-CONTCUR-ATR(WS-ATPC175-TAB-INDICE)
             TO WS-ATPC175-CONTCUR-ATR
           MOVE WS-ATPC175-TAB-CONTCUR(WS-ATPC175-TAB-INDICE)
             TO WS-ATPC175-CONTCUR
           MOVE WS-ATPC175-TAB-INDCONTINUAR(WS-ATPC175-TAB-INDICE)
             TO WS-ATPC175-INDCONTINUAR
           
           SET WS-ATPC175-RETORNO-OK         TO TRUE
           .

 
      *----------------------------------------------------------------
      * Proceso ejecutado cuando no se ha encontrado datos de 
      * Tipos de Tarjetas con los criterios de busquedas recibidos          
       ATPC175-BUSCAR-NO-ENCONTRADO.
           SET WS-ATPC175-RETORNO-ERROR      TO TRUE
           STRING "No se encontro el dato buscado en ATPC175." 
                                               DELIMITED BY SIZE
                  " - CODENT:"                 DELIMITED BY SIZE
                  "[" WS-ATPC175-CODENT "]"    DELIMITED BY SIZE
                  " - CODESTCTA:"              DELIMITED BY SIZE
                  "[" WS-ATPC175-CODESTCTA "]" DELIMITED BY SIZE
            INTO WS-ATPC175-RETORNO-DESC
           END-STRING
           .