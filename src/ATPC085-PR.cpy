      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla FECHAS DE FACTURACION (estructura MPM0085)
      *
      * Dependencias:
      *  - Debe estar declarada la rutina para manejo de errores 
      *    888888-LOGGEAR-TRANSACCION
      *
      * Procesos de uso Publicos:
      *  - ATPC085-CARGAR-ARREGLO
      *  - ATPC085-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------      


      *----------------------------------------------------------------
      * Proceso: ATPC085-CARGAR-ARREGLO
      *----------------------------------------------------------------
      * Se debe cargar una sola vez al iniciar el programa 
      * Ejemplo:
      *     PERFORM ATPC085-CARGAR-ARREGLO
      *----------------------------------------------------------------      
       ATPC085-CARGAR-ARREGLO.
           IF WS-ATPC085-TAB-CLAVE(1) = SPACES 
           
            INITIALIZE        WS-ATPC085-CONTADOR-COD-GRUPO
           
            PERFORM ATPC085-CALCULAR-FECHA-ANT
           
            PERFORM UNTIL WS-ATPC085-CONTADOR-COD-GRUPO >=
                              WS-ATPC085-TOTAL-COD-GRUPO
           
              INITIALIZE WS-ATPC085-CONTADOR
                         MQCOPY-CLAVE-FIN
                         WS-I

              SET WS-ATPC085-FIN    TO FALSE
              
              ADD 1 TO WS-ATPC085-CONTADOR-COD-GRUPO

              SET MQCOPY-SIGUIENTE        TO TRUE
              SET WS-ATPC085-CARGAR-FECHA TO FALSE 

              PERFORM UNTIL WS-ATPC085-FIN
                 PERFORM ATPC085-ATOMICO-LLENAR
                 PERFORM ATPC085-ATOMICO-LLAMAR
                 EVALUATE TRUE
                   WHEN WS-ATPC085-RETORNO-OK
                      
                      PERFORM ATPC085-LLENA-ARREGLO
                            
                      IF MQCOPY-IND-MAS-DATOS = CT-N 
                         SET WS-ATPC085-FIN TO TRUE
                      ELSE
                         IF WS-ATPC085-CARGAR-FECHA 
                            SET WS-ATPC085-FIN TO TRUE
                         ELSE
                            MOVE MP085-CODENT     
                              TO MQCOPY-CLAVE-FIN(14:4)
                            MOVE MP085-CODPROCESO 
                              TO MQCOPY-CLAVE-FIN(19:2)  
                            MOVE MP085-CODGRUPO   
                              TO MQCOPY-CLAVE-FIN(22:2)
                            MOVE MP085-TIPFECHA   
                              TO MQCOPY-CLAVE-FIN(25:1) 
                            MOVE MP085-FECHA(WS-ATPC085-MP085-CONTADOR) 
                              TO MQCOPY-CLAVE-FIN(27:10) 

                            SET  MQCOPY-SIGUIENTE    TO TRUE
                         END-IF
                      END-IF
                    WHEN OTHER
                      SET WS-ATPC085-FIN TO TRUE 
                 END-EVALUATE
              END-PERFORM
          
            END-PERFORM

           DISPLAY 
           "----------------------------------------------------------"
           DISPLAY 
           "-CARGA DE TABLA DE FECHAS FACTURACION EN MEMORIA(ATPC085)-"
           DISPLAY "Cantidad de fechas de facturacion cargadas: [" 
                      WS-ATPC085-TAB-OCCURS "]"
           DISPLAY " "
                         
           END-IF
           .
      

      *----------------------------------------------------------------
      * Proceso: ATPC085-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------
      * Se le debe especificar los datos de entrada e invocar el proceso
      * Ejemplo:
      *     INITIALIZE  WS-ATPC085
      *     MOVE LIB510-CODENT         TO  WS-ATPC085-CODENT
      *     MOVE 1                     TO  WS-ATPC085-CODPROCESO
      *     MOVE ATDATTAS-GRUPOLIQ-SAL TO  WS-ATPC085-CODGRUPO
      *     MOVE 2                     TO  WS-ATPC085-TIPFECHA
      *     PERFORM ATPC085-BUSCAR-EN-ARREGLO  
      *     MOVE WS-ATPC085-FECHA      TO LIB510-FEC-ULT-FACT
      *----------------------------------------------------------------      
       ATPC085-BUSCAR-EN-ARREGLO.
           INITIALIZE WS-ATPC085-RETORNO
           
           SET WS-ATPC085-TAB-INDICE TO 1
           SEARCH ALL WS-ATPC085-TAB
                  AT END 
                     PERFORM ATPC085-BUSCAR-NO-ENCONTRADO
                  WHEN WS-ATPC085-TAB-CLAVE (WS-ATPC085-TAB-INDICE) 
                                           = WS-ATPC085-CLAVE
                       PERFORM ATPC085-MOVER-DATOS-RESPUESTA
           END-SEARCH
           .




      *----------------------------------------------------------------
      * Procesos internos de soporte
      *----------------------------------------------------------------

      *----------------------------------------------------------------
      * Proceso de asignación de condiciones de filtro para la busqueda
      * de Fechas Facturacion
       ATPC085-ATOMICO-LLENAR.
           INITIALIZE WS-MPM0085
           MOVE WS-ATPC085-CODENT             TO MP085-CODENT
           MOVE WS-ATPC085-CODPROCESO         TO MP085-CODPROCESO
           MOVE WS-ATPC085-CONTADOR-COD-GRUPO TO MP085-CODGRUPO
           MOVE WS-ATPC085-TIPFECHA           TO MP085-TIPFECHA
           MOVE WS-ATPC085-AUX-FECHA-ANT      TO MP085-FECHA(1)
           .
           

      *----------------------------------------------------------------
      * Proceso de ejecucion de busqueda de Fecha Facturacion
       ATPC085-ATOMICO-LLAMAR.
           MOVE CT-ATPC085             TO  MQCOPY-PROGRAMA-REAL
           MOVE WS-MPM0085             TO  MQCOPY-MENSAJE
           MOVE "00"                   TO  MQCOPY-RETORNO

           IF SI-LOGGEA-SERVICIO
              MOVE "I"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC085          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF

      *    Llamado a programa ATPC085 que consulta la tabla MPDT085
      *    con las condiciones expresadas en MQCOPY-MENSAJE
           CALL  CT-ATPC085   USING  WS-MQCOPY
           
           IF SI-LOGGEA-SERVICIO
              MOVE "O"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC085          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF

           EVALUATE MQCOPY-RETORNO
              WHEN CT-RETORNO-OK
                   SET WS-ATPC085-RETORNO-OK    TO TRUE
                   MOVE MQCOPY-MENSAJE         TO  WS-MPM0085
              WHEN CT-MQCOPY-INFOR
                   SET WS-ATPC085-RETORNO-INFO  TO TRUE     
              WHEN OTHER
                   SET WS-ATPC085-RETORNO-ERROR TO TRUE
           END-EVALUATE
           .


      *----------------------------------------------------------------
      * Proceso de carga de datos en el arreglo de Fechas Facturacion
       ATPC085-LLENA-ARREGLO.
           INITIALIZE WS-ATPC085-MP085-CONTADOR
           
           PERFORM UNTIL WS-ATPC085-MP085-CONTADOR > 
                             WS-ATPC085-MP085-OCCURS
             
              ADD CT-01         TO WS-ATPC085-CONTADOR
              ADD CT-01         TO WS-ATPC085-MP085-CONTADOR
              
              MOVE WS-ATPC085-CONTADOR-COD-GRUPO 
                TO WS-ATPC085-TAB-OCCURS 

              
              IF MP085-INDPROC(WS-ATPC085-MP085-CONTADOR) = CT-N
                 SET WS-ATPC085-CARGAR-FECHA      TO TRUE
                 PERFORM ATPC085-MOVER-DATOS-X-COD-GRP
                 EXIT PERFORM
              END-IF

      * El caracter @ en el campo MP085-INDCONTINUAR representa que ese
      * es el último dato entregado por la base de datos, por este motivo
      * se utiliza esta "igualdad" para cortar la carga del arreglo
              IF MP085-INDCONTINUAR(WS-ATPC085-MP085-CONTADOR) = '@'
                 EXIT PERFORM
              END-IF

           END-PERFORM
           .
           
           
      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicación           
       ATPC085-MOVER-DATOS-RESPUESTA.
           INITIALIZE WS-ATPC085-RESPUESTA

           MOVE WS-ATPC085-TAB-CODENT(WS-ATPC085-TAB-INDICE) 
             TO    WS-ATPC085-CODENT
           MOVE WS-ATPC085-TAB-CODPROCESO(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-CODPROCESO
           MOVE WS-ATPC085-TAB-TIPFECHA(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-TIPFECHA
           MOVE WS-ATPC085-TAB-CODGRUPO(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-CODGRUPO
           
           MOVE WS-ATPC085-TAB-FECHA-ATR(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-FECHA-ATR
           MOVE WS-ATPC085-TAB-FECHA(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-FECHA
           MOVE WS-ATPC085-TAB-INDPROC-ATR(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-INDPROC-ATR
           MOVE WS-ATPC085-TAB-INDPROC(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-INDPROC
           MOVE WS-ATPC085-TAB-FECHANT-ATR(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-FECHANT-ATR
           MOVE WS-ATPC085-TAB-FECHANT(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-FECHANT
           MOVE WS-ATPC085-TAB-CONTCUR-ATR(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-CONTCUR-ATR
           MOVE WS-ATPC085-TAB-CONTCUR(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-CONTCUR
           MOVE WS-ATPC085-TAB-INDCONTINUAR(WS-ATPC085-TAB-INDICE) 
             TO WS-ATPC085-INDCONTINUAR
           
           SET WS-ATPC085-RETORNO-OK         TO TRUE
           .
 
 
      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicación
       ATPC085-MOVER-DATOS-X-COD-GRP.
           MOVE MP085-CODENT
             TO WS-ATPC085-TAB-CODENT(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-CODPROCESO TO
               WS-ATPC085-TAB-CODPROCESO(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-CODGRUPO
             TO WS-ATPC085-TAB-CODGRUPO(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-TIPFECHA
             TO WS-ATPC085-TAB-TIPFECHA(WS-ATPC085-CONTADOR-COD-GRUPO)
                
           MOVE MP085-FECHA(WS-ATPC085-MP085-CONTADOR)
             TO WS-ATPC085-TAB-FECHA(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-INDPROC(WS-ATPC085-MP085-CONTADOR)
             TO WS-ATPC085-TAB-INDPROC(WS-ATPC085-CONTADOR-COD-GRUPO)
                
           MOVE MP085-FECHA-ATR(WS-ATPC085-MP085-CONTADOR)    
             TO WS-ATPC085-TAB-FECHA-ATR(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-INDPROC-ATR(WS-ATPC085-MP085-CONTADOR) TO 
              WS-ATPC085-TAB-INDPROC-ATR(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-FECHANT-ATR(WS-ATPC085-MP085-CONTADOR) TO
              WS-ATPC085-TAB-FECHANT-ATR(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-FECHANT(WS-ATPC085-MP085-CONTADOR)    
             TO WS-ATPC085-TAB-FECHANT(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-CONTCUR-ATR(WS-ATPC085-MP085-CONTADOR) TO 
              WS-ATPC085-TAB-CONTCUR-ATR(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-CONTCUR(WS-ATPC085-MP085-CONTADOR)    
             TO WS-ATPC085-TAB-CONTCUR(WS-ATPC085-CONTADOR-COD-GRUPO)
           MOVE MP085-INDCONTINUAR(WS-ATPC085-MP085-CONTADOR) TO 
             WS-ATPC085-TAB-INDCONTINUAR(WS-ATPC085-CONTADOR-COD-GRUPO)
           .
           
           
      *----------------------------------------------------------------
      * Proceso ejecutado cuando no se ha encontrado datos de 
      * Fechas Facturacion con los criterios de busquedas recibidos
       ATPC085-BUSCAR-NO-ENCONTRADO.
           SET WS-ATPC085-RETORNO-ERROR      TO TRUE
           STRING "No se encontro el dato buscado en ATPC085." 
                                               DELIMITED BY SIZE
                  " - CODENT:["                DELIMITED BY SIZE
                  WS-ATPC085-CODENT            DELIMITED BY SIZE
                  "] - CODPROCESO:["           DELIMITED BY SIZE
                  WS-ATPC085-CODPROCESO        DELIMITED BY SIZE
                  "] - CODGRUPO:["             DELIMITED BY SIZE
                  WS-ATPC085-CODGRUPO          DELIMITED BY SIZE
                  "]"                          DELIMITED BY SIZE
            INTO WS-ATPC085-RETORNO-DESC
           END-STRING
           
           .
           
           
      *----------------------------------------------------------------
      * Proceso para el calcula de la fecha a un mes antes para 
      * acotar la busqueda de la carga del arreglo
       ATPC085-CALCULAR-FECHA-ANT.
           INITIALIZE WS-ATPC085-AUX-FECHA-ANT
                      WS-ATPC085-AUX-FECHA-ACT
           
           ACCEPT WS-ATPC085-AUX-FECHA-ACT FROM DATE YYYYMMDD
           
           MOVE "-"               TO WS-ATPC085-AUX-FECHA-ANT-G1
                                     WS-ATPC085-AUX-FECHA-ANT-G2
           MOVE 1                 TO WS-ATPC085-AUX-FECHA-ANT-DD
           IF WS-ATPC085-AUX-FECHA-ACT-MM = 1
              MOVE 12             TO WS-ATPC085-AUX-FECHA-ANT-MM
              SUBTRACT 1        FROM WS-ATPC085-AUX-FECHA-ACT-AAAA
                   GIVING WS-ATPC085-AUX-FECHA-ANT-AAAA
           ELSE
              MOVE WS-ATPC085-AUX-FECHA-ACT-AAAA
                TO WS-ATPC085-AUX-FECHA-ANT-AAAA
              SUBTRACT 1        FROM WS-ATPC085-AUX-FECHA-ACT-MM
                   GIVING WS-ATPC085-AUX-FECHA-ANT-MM
           END-IF
           .