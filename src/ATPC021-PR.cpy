      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * Tabla: ENTIDADES (estructura MPM0021)
      *
      * Dependencias:
      *  - Debe estar declarada la rutina para manejo de errores 
      *    888888-LOGGEAR-TRANSACCION
      *
      * Procesos de uso Publicos:
      *  - ATPC021-CARGAR-ARREGLO
      *  - ATPC021-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------      


      *----------------------------------------------------------------
      * Proceso: ATPC021-CARGAR-ARREGLO
      *----------------------------------------------------------------
      * Se debe cargar una sola vez al iniciar el servicio
      * Ejemplo:
      *     PERFORM ATPC021-CARGAR-ARREGLO
      *----------------------------------------------------------------      
       ATPC021-CARGAR-ARREGLO.
           IF WS-ATPC021-TAB-CLAVE(1) = SPACES 

              INITIALIZE WS-ATPC021-CONTADOR
                         DATOS-PREVIOS-ENTRADA

              SET WS-ATPC021-FIN    TO FALSE
              
      *       Tipo de Paginacion (IND-PAGINACION)                                       
              SET MQCOPY-UNITARIA   TO TRUE


              PERFORM UNTIL WS-ATPC021-FIN
                 PERFORM ATPC021-ATOMICO-LLENAR
                 PERFORM ATPC021-ATOMICO-LLAMAR
                 EVALUATE TRUE
                   WHEN WS-ATPC021-RETORNO-OK
                      PERFORM ATPC021-LLENA-ARREGLO
                      SET WS-ATPC021-FIN TO TRUE
                    WHEN OTHER
                      SET WS-ATPC021-FIN TO TRUE 
                 END-EVALUATE
              END-PERFORM
              
               DISPLAY 
           "----------------------------------------------------------"
              DISPLAY 
           "- CARGA DE TABLA EN MEMORIA (ATPC021)          -"
              DISPLAY "WS-ATPC021-CODENT....: "
                      "[" WS-ATPC021-CODENT "]"
              DISPLAY "Cantidad de registros cargados: "
                      "[" WS-ATPC021-CONTADOR "]"
              DISPLAY " "             
           END-IF
           .
      

      *----------------------------------------------------------------
      * Proceso: ATPC021-BUSCAR-EN-ARREGLO
      *----------------------------------------------------------------
      * Se le debe especificar los datos de entrada e invocar el proceso
      * Ejemplo:
      *     INITIALIZE  WS-ATPC021
      *     INITIALIZE WS-MPM0021
      *     MOVE MP021-CODENT     TO WS-ATPC021-CODENT
      *     PERFORM ATPC021-BUSCAR-EN-ARREGLO  
      *----------------------------------------------------------------      
       ATPC021-BUSCAR-EN-ARREGLO.
           INITIALIZE WS-ATPC021-RETORNO
                      WS-ATPC021-RESPUESTA
           SET WS-ATPC021-TAB-INDICE TO 1
           SEARCH ALL WS-ATPC021-TAB
                  AT END 
                     PERFORM ATPC021-BUSCAR-NO-ENCONTRADO
                  WHEN WS-ATPC021-TAB-CLAVE (WS-ATPC021-TAB-INDICE) 
                                           = WS-ATPC021-CLAVE
                     PERFORM ATPC021-MOVER-DATOS-RESPUESTA
           END-SEARCH
           .




      *----------------------------------------------------------------
      * Procesos internos de soporte
      *----------------------------------------------------------------

      * Proceso de asignaci�n de condiciones de filtro para la busqueda
       ATPC021-ATOMICO-LLENAR.
           INITIALIZE WS-MPM0021
           MOVE WS-ATPC021-CODENT   TO MP021-CODENT
           .


      *----------------------------------------------------------------
      * Proceso de ejecucion de busqueda
       ATPC021-ATOMICO-LLAMAR.
           MOVE CT-ATPC021             TO  MQCOPY-PROGRAMA-REAL
           MOVE CT-ATPC021             TO  MQCOPY-PROGRAMA
           MOVE "MPDT021"              TO  MQCOPY-NOMBRE-TABLA
           
           MOVE MPM0021                TO  MQCOPY-MENSAJE
           MOVE ZEROES                 TO  MQCOPY-RETORNO

           IF SI-LOGGEA-SERVICIO
              MOVE "I"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC021          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
      *    Llamado a programa ATPC021 que consulta la tabla MPDT021
      *    con las condiciones expresadas en MQCOPY-MENSAJE
           CALL  CT-ATPC021   USING  WS-MQCOPY
           
           IF SI-LOGGEA-SERVICIO
              MOVE "O"                 TO  INDICADOR_I-O OF MPMLOG
              MOVE CT-ATPC021          TO  CODIGO_RUTINA OF MPMLOG
              MOVE MQCOPY              TO  MENSAJE_COPY  OF MPMLOG
              PERFORM 888888-LOGGEAR-TRANSACCION
           END-IF
           
           EVALUATE MQCOPY-RETORNO
              WHEN CT-RETORNO-OK
                   SET WS-ATPC021-RETORNO-OK    TO TRUE
                   MOVE MQCOPY-MENSAJE         TO  WS-MPM0021
              WHEN CT-MQCOPY-INFOR
                   SET WS-ATPC021-RETORNO-INFO  TO TRUE     
              WHEN OTHER
                   SET WS-ATPC021-RETORNO-ERROR TO TRUE
                   
                   DISPLAY "ATPC052 - MQCOPY-COD-ERROR:"
                           "[" MQCOPY-COD-ERROR "]"
                   DISPLAY "ATPC052 - MQCOPY-RETORNO:"
                           "[" MQCOPY-RETORNO "]"
           END-EVALUATE
           .


      *----------------------------------------------------------------
      * Proceso de carga de datos en el arreglo
       ATPC021-LLENA-ARREGLO.
      
           INITIALIZE WS-ATPC021-MP021-CONTADOR
           PERFORM UNTIL WS-ATPC021-MP021-CONTADOR > 
                             WS-ATPC021-MP021-OCCURS
                             
              ADD CT-01         TO WS-ATPC021-CONTADOR
              ADD CT-01         TO WS-ATPC021-MP021-CONTADOR
              
              MOVE WS-ATPC021-CONTADOR TO WS-ATPC021-TAB-OCCURS
              
              MOVE MP021-CODENT-ATR
                TO WS-ATPC021-TAB-CODENT-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CODENT
                TO WS-ATPC021-TAB-CODENT(WS-ATPC021-CONTADOR)
              MOVE MP021-CODENTDES-ATR
                TO WS-ATPC021-TAB-CODENTDES-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CODENTDES
                TO WS-ATPC021-TAB-CODENTDES(WS-ATPC021-CONTADOR)
              MOVE MP021-CODCSBENT-ATR
                TO WS-ATPC021-TAB-CODCSBENT-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CODCSBENT
                TO WS-ATPC021-TAB-CODCSBENT(WS-ATPC021-CONTADOR)
              MOVE MP021-CODENTCOM-ATR
                TO WS-ATPC021-TAB-CODENTCOM-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CODENTCOM
                TO WS-ATPC021-TAB-CODENTCOM(WS-ATPC021-CONTADOR)
              MOVE MP021-PORDESREM-ATR
                TO WS-ATPC021-TAB-PORDESREM-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-PORDESREM
                TO WS-ATPC021-TAB-PORDESREM(WS-ATPC021-CONTADOR)
              MOVE MP021-PORAUTFACN-ATR
                TO WS-ATPC021-TAB-PORAUTFACN-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-PORAUTFACN
                TO WS-ATPC021-TAB-PORAUTFACN(WS-ATPC021-CONTADOR)
              MOVE MP021-PORAUTFACE-ATR
                TO WS-ATPC021-TAB-PORAUTFACE-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-PORAUTFACE
                TO WS-ATPC021-TAB-PORAUTFACE(WS-ATPC021-CONTADOR)
              MOVE MP021-PORLIMAUTCRE-ATR
                TO WS-ATPC021-TAB-PORLIMAUTCRE-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-PORLIMAUTCRE
                TO WS-ATPC021-TAB-PORLIMAUTCRE(WS-ATPC021-CONTADOR)
              MOVE MP021-PORLIMAUTCREE-ATR
                TO WS-ATPC021-TAB-PORLIMAUTCREE-AT(WS-ATPC021-CONTADOR)
              MOVE MP021-PORLIMAUTCREE
                TO WS-ATPC021-TAB-PORLIMAUTCREE(WS-ATPC021-CONTADOR)
              MOVE MP021-INDUF-ATR
                TO WS-ATPC021-TAB-INDUF-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDUF
                TO WS-ATPC021-TAB-INDUF(WS-ATPC021-CONTADOR)
              MOVE MP021-CLAMONUF-ATR
                TO WS-ATPC021-TAB-CLAMONUF-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CLAMONUF
                TO WS-ATPC021-TAB-CLAMONUF(WS-ATPC021-CONTADOR)
              MOVE MP021-CODPAIS-ATR
                TO WS-ATPC021-TAB-CODPAIS-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CODPAIS
                TO WS-ATPC021-TAB-CODPAIS(WS-ATPC021-CONTADOR)
              MOVE MP021-NOMPAIS-ATR
                TO WS-ATPC021-TAB-NOMPAIS-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NOMPAIS
                TO WS-ATPC021-TAB-NOMPAIS(WS-ATPC021-CONTADOR)
              MOVE MP021-OFIMPAGO-ATR
                TO WS-ATPC021-TAB-OFIMPAGO-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-OFIMPAGO
                TO WS-ATPC021-TAB-OFIMPAGO(WS-ATPC021-CONTADOR)
              MOVE MP021-RESMPAGO-ATR
                TO WS-ATPC021-TAB-RESMPAGO-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-RESMPAGO
                TO WS-ATPC021-TAB-RESMPAGO(WS-ATPC021-CONTADOR)
              MOVE MP021-MESNOREN-ATR
                TO WS-ATPC021-TAB-MESNOREN-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-MESNOREN
                TO WS-ATPC021-TAB-MESNOREN(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMESRENOV-ATR
                TO WS-ATPC021-TAB-NUMMESRENOV-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMESRENOV
                TO WS-ATPC021-TAB-NUMMESRENOV(WS-ATPC021-CONTADOR)
              MOVE MP021-INDEXTMON-ATR
                TO WS-ATPC021-TAB-INDEXTMON-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDEXTMON
                TO WS-ATPC021-TAB-INDEXTMON(WS-ATPC021-CONTADOR)
              MOVE MP021-INDREPDISP-ATR
                TO WS-ATPC021-TAB-INDREPDISP-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDREPDISP
                TO WS-ATPC021-TAB-INDREPDISP(WS-ATPC021-CONTADOR)
              MOVE MP021-MAXFACTNES-ATR
                TO WS-ATPC021-TAB-MAXFACTNES-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-MAXFACTNES
                TO WS-ATPC021-TAB-MAXFACTNES(WS-ATPC021-CONTADOR)
              MOVE MP021-INDCTADOM-ATR
                TO WS-ATPC021-TAB-INDCTADOM-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDCTADOM
                TO WS-ATPC021-TAB-INDCTADOM(WS-ATPC021-CONTADOR)
              MOVE MP021-INDRELCON-ATR
                TO WS-ATPC021-TAB-INDRELCON-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDRELCON
                TO WS-ATPC021-TAB-INDRELCON(WS-ATPC021-CONTADOR)
              MOVE MP021-INDCALDIS-ATR
                TO WS-ATPC021-TAB-INDCALDIS-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDCALDIS
                TO WS-ATPC021-TAB-INDCALDIS(WS-ATPC021-CONTADOR)
              MOVE MP021-CODIDIOMA-ATR
                TO WS-ATPC021-TAB-CODIDIOMA-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CODIDIOMA
                TO WS-ATPC021-TAB-CODIDIOMA(WS-ATPC021-CONTADOR)
              MOVE MP021-TACOMINTAD-ATR
                TO WS-ATPC021-TAB-TACOMINTAD-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-TACOMINTAD
                TO WS-ATPC021-TAB-TACOMINTAD(WS-ATPC021-CONTADOR)
              MOVE MP021-INDVISAPHONE-ATR
                TO WS-ATPC021-TAB-INDVISAPHONE-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDVISAPHONE
                TO WS-ATPC021-TAB-INDVISAPHONE(WS-ATPC021-CONTADOR)
              MOVE MP021-INDABOREAL-ATR
                TO WS-ATPC021-TAB-INDABOREAL-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDABOREAL
                TO WS-ATPC021-TAB-INDABOREAL(WS-ATPC021-CONTADOR)
              MOVE MP021-FORCALINT-ATR
                TO WS-ATPC021-TAB-FORCALINT-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-FORCALINT
                TO WS-ATPC021-TAB-FORCALINT(WS-ATPC021-CONTADOR)
              MOVE MP021-INDPAGMIN-ATR
                TO WS-ATPC021-TAB-INDPAGMIN-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDPAGMIN
                TO WS-ATPC021-TAB-INDPAGMIN(WS-ATPC021-CONTADOR)
              MOVE MP021-FECALTA-ATR
                TO WS-ATPC021-TAB-FECALTA-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-FECALTA
                TO WS-ATPC021-TAB-FECALTA(WS-ATPC021-CONTADOR)
              MOVE MP021-FECINI-ATR
                TO WS-ATPC021-TAB-FECINI-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-FECINI
                TO WS-ATPC021-TAB-FECINI(WS-ATPC021-CONTADOR)
              MOVE MP021-FECFIN-ATR
                TO WS-ATPC021-TAB-FECFIN-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-FECFIN
                TO WS-ATPC021-TAB-FECFIN(WS-ATPC021-CONTADOR)
              MOVE MP021-CRIREC-ATR
                TO WS-ATPC021-TAB-CRIREC-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CRIREC
                TO WS-ATPC021-TAB-CRIREC(WS-ATPC021-CONTADOR)
              MOVE MP021-INDADMSALDO-ATR
                TO WS-ATPC021-TAB-INDADMSALDO-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDADMSALDO
                TO WS-ATPC021-TAB-INDADMSALDO(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMORDSALCOM-ATR
                TO WS-ATPC021-TAB-NUMORDSALCOM-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMORDSALCOM
                TO WS-ATPC021-TAB-NUMORDSALCOM(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMORDSALDIS-ATR
                TO WS-ATPC021-TAB-NUMORDSALDIS-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMORDSALDIS
                TO WS-ATPC021-TAB-NUMORDSALDIS(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMAXMONCTA-ATR
                TO WS-ATPC021-TAB-NUMMAXMONCTA-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMAXMONCTA
                TO WS-ATPC021-TAB-NUMMAXMONCTA(WS-ATPC021-CONTADOR)
              MOVE MP021-INDTRACON-ATR
                TO WS-ATPC021-TAB-INDTRACON-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDTRACON
                TO WS-ATPC021-TAB-INDTRACON(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMDIASRET-ATR
                TO WS-ATPC021-TAB-NUMDIASRET-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMDIASRET
                TO WS-ATPC021-TAB-NUMDIASRET(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMAXINCSOL-ATR
                TO WS-ATPC021-TAB-NUMMAXINCSOL-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMAXINCSOL
                TO WS-ATPC021-TAB-NUMMAXINCSOL(WS-ATPC021-CONTADOR)
              MOVE MP021-ORDPREPAG-ATR
                TO WS-ATPC021-TAB-ORDPREPAG-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-ORDPREPAG
                TO WS-ATPC021-TAB-ORDPREPAG(WS-ATPC021-CONTADOR)
              MOVE MP021-PORPERPREPAG-ATR
                TO WS-ATPC021-TAB-PORPERPREPAG-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-PORPERPREPAG
                TO WS-ATPC021-TAB-PORPERPREPAG(WS-ATPC021-CONTADOR)
              MOVE MP021-DIASCOMPREPAG-ATR
                TO WS-ATPC021-TAB-DIASCOMPREPAG-AT(WS-ATPC021-CONTADOR)
              MOVE MP021-DIASCOMPREPAG
                TO WS-ATPC021-TAB-DIASCOMPREPAG(WS-ATPC021-CONTADOR)
              MOVE MP021-DIAPAGCANAL-ATR
                TO WS-ATPC021-TAB-DIAPAGCANAL-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-DIAPAGCANAL
                TO WS-ATPC021-TAB-DIAPAGCANAL(WS-ATPC021-CONTADOR)
              MOVE MP021-METCALLIQ-ATR
                TO WS-ATPC021-TAB-METCALLIQ-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-METCALLIQ
                TO WS-ATPC021-TAB-METCALLIQ(WS-ATPC021-CONTADOR)
              MOVE MP021-RPTVALPAGO-ATR
                TO WS-ATPC021-TAB-RPTVALPAGO-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-RPTVALPAGO
                TO WS-ATPC021-TAB-RPTVALPAGO(WS-ATPC021-CONTADOR)
              MOVE MP021-INDRETPAGO-ATR
                TO WS-ATPC021-TAB-INDRETPAGO-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDRETPAGO
                TO WS-ATPC021-TAB-INDRETPAGO(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMESCOMPL-ATR
                TO WS-ATPC021-TAB-NUMMESCOMPL-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-NUMMESCOMPL
                TO WS-ATPC021-TAB-NUMMESCOMPL(WS-ATPC021-CONTADOR)
              MOVE MP021-INDMECDEV-ATR
                TO WS-ATPC021-TAB-INDMECDEV-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDMECDEV
                TO WS-ATPC021-TAB-INDMECDEV(WS-ATPC021-CONTADOR)
              MOVE MP021-INDCAPIMP-ATR
                TO WS-ATPC021-TAB-INDCAPIMP-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-INDCAPIMP
                TO WS-ATPC021-TAB-INDCAPIMP(WS-ATPC021-CONTADOR)
              MOVE MP021-CONTCUR-ATR
                TO WS-ATPC021-TAB-CONTCUR-ATR(WS-ATPC021-CONTADOR)
              MOVE MP021-CONTCUR
                TO WS-ATPC021-TAB-CONTCUR(WS-ATPC021-CONTADOR)
              EXIT PERFORM
           END-PERFORM
           .


      *----------------------------------------------------------------
      * Proceso que carga los datos de respuesta en la interfaz de
      * comunicaci�n
       ATPC021-MOVER-DATOS-RESPUESTA.
           INITIALIZE WS-ATPC021-RESPUESTA

           MOVE WS-ATPC021-TAB-CODENT-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODENT-ATR
           MOVE WS-ATPC021-TAB-CODENT(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODENT
           MOVE WS-ATPC021-TAB-CODENTDES-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODENTDES-ATR
           MOVE WS-ATPC021-TAB-CODENTDES(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODENTDES
           MOVE WS-ATPC021-TAB-CODCSBENT-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODCSBENT-ATR
           MOVE WS-ATPC021-TAB-CODCSBENT(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODCSBENT
           MOVE WS-ATPC021-TAB-CODENTCOM-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODENTCOM-ATR
           MOVE WS-ATPC021-TAB-CODENTCOM(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODENTCOM
           MOVE WS-ATPC021-TAB-PORDESREM-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORDESREM-ATR
           MOVE WS-ATPC021-TAB-PORDESREM(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORDESREM
           MOVE WS-ATPC021-TAB-PORAUTFACN-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORAUTFACN-ATR
           MOVE WS-ATPC021-TAB-PORAUTFACN(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORAUTFACN
           MOVE WS-ATPC021-TAB-PORAUTFACE-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORAUTFACE-ATR
           MOVE WS-ATPC021-TAB-PORAUTFACE(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORAUTFACE
           MOVE WS-ATPC021-TAB-PORLIMAUTCRE-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORLIMAUTCRE-ATR
           MOVE WS-ATPC021-TAB-PORLIMAUTCRE(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORLIMAUTCRE
           MOVE WS-ATPC021-TAB-PORLIMAUTCREE-AT(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORLIMAUTCREE-ATR
           MOVE WS-ATPC021-TAB-PORLIMAUTCREE(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORLIMAUTCREE
           MOVE WS-ATPC021-TAB-INDUF-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDUF-ATR
           MOVE WS-ATPC021-TAB-INDUF(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDUF
           MOVE WS-ATPC021-TAB-CLAMONUF-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CLAMONUF-ATR
           MOVE WS-ATPC021-TAB-CLAMONUF(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CLAMONUF
           MOVE WS-ATPC021-TAB-CODPAIS-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODPAIS-ATR
           MOVE WS-ATPC021-TAB-CODPAIS(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODPAIS
           MOVE WS-ATPC021-TAB-NOMPAIS-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NOMPAIS-ATR
           MOVE WS-ATPC021-TAB-NOMPAIS(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NOMPAIS
           MOVE WS-ATPC021-TAB-OFIMPAGO-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-OFIMPAGO-ATR
           MOVE WS-ATPC021-TAB-OFIMPAGO(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-OFIMPAGO
           MOVE WS-ATPC021-TAB-RESMPAGO-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-RESMPAGO-ATR
           MOVE WS-ATPC021-TAB-RESMPAGO(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-RESMPAGO
           MOVE WS-ATPC021-TAB-MESNOREN-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-MESNOREN-ATR
           MOVE WS-ATPC021-TAB-MESNOREN(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-MESNOREN
           MOVE WS-ATPC021-TAB-NUMMESRENOV-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMESRENOV-ATR
           MOVE WS-ATPC021-TAB-NUMMESRENOV(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMESRENOV
           MOVE WS-ATPC021-TAB-INDEXTMON-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDEXTMON-ATR
           MOVE WS-ATPC021-TAB-INDEXTMON(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDEXTMON
           MOVE WS-ATPC021-TAB-INDREPDISP-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDREPDISP-ATR
           MOVE WS-ATPC021-TAB-INDREPDISP(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDREPDISP
           MOVE WS-ATPC021-TAB-MAXFACTNES-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-MAXFACTNES-ATR
           MOVE WS-ATPC021-TAB-MAXFACTNES(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-MAXFACTNES
           MOVE WS-ATPC021-TAB-INDCTADOM-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDCTADOM-ATR
           MOVE WS-ATPC021-TAB-INDCTADOM(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDCTADOM
           MOVE WS-ATPC021-TAB-INDRELCON-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDRELCON-ATR
           MOVE WS-ATPC021-TAB-INDRELCON(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDRELCON
           MOVE WS-ATPC021-TAB-INDCALDIS-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDCALDIS-ATR
           MOVE WS-ATPC021-TAB-INDCALDIS(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDCALDIS
           MOVE WS-ATPC021-TAB-CODIDIOMA-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODIDIOMA-ATR
           MOVE WS-ATPC021-TAB-CODIDIOMA(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CODIDIOMA
           MOVE WS-ATPC021-TAB-TACOMINTAD-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-TACOMINTAD-ATR
           MOVE WS-ATPC021-TAB-TACOMINTAD(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-TACOMINTAD
           MOVE WS-ATPC021-TAB-INDVISAPHONE-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDVISAPHONE-ATR
           MOVE WS-ATPC021-TAB-INDVISAPHONE(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDVISAPHONE
           MOVE WS-ATPC021-TAB-INDABOREAL-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDABOREAL-ATR
           MOVE WS-ATPC021-TAB-INDABOREAL(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDABOREAL
           MOVE WS-ATPC021-TAB-FORCALINT-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FORCALINT-ATR
           MOVE WS-ATPC021-TAB-FORCALINT(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FORCALINT
           MOVE WS-ATPC021-TAB-INDPAGMIN-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDPAGMIN-ATR
           MOVE WS-ATPC021-TAB-INDPAGMIN(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDPAGMIN
           MOVE WS-ATPC021-TAB-FECALTA-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FECALTA-ATR
           MOVE WS-ATPC021-TAB-FECALTA(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FECALTA
           MOVE WS-ATPC021-TAB-FECINI-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FECINI-ATR
           MOVE WS-ATPC021-TAB-FECINI(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FECINI
           MOVE WS-ATPC021-TAB-FECFIN-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FECFIN-ATR
           MOVE WS-ATPC021-TAB-FECFIN(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-FECFIN
           MOVE WS-ATPC021-TAB-CRIREC-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CRIREC-ATR
           MOVE WS-ATPC021-TAB-CRIREC(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CRIREC
           MOVE WS-ATPC021-TAB-INDADMSALDO-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDADMSALDO-ATR
           MOVE WS-ATPC021-TAB-INDADMSALDO(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDADMSALDO
           MOVE WS-ATPC021-TAB-NUMORDSALCOM-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMORDSALCOM-ATR
           MOVE WS-ATPC021-TAB-NUMORDSALCOM(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMORDSALCOM
           MOVE WS-ATPC021-TAB-NUMORDSALDIS-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMORDSALDIS-ATR
           MOVE WS-ATPC021-TAB-NUMORDSALDIS(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMORDSALDIS
           MOVE WS-ATPC021-TAB-NUMMAXMONCTA-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMAXMONCTA-ATR
           MOVE WS-ATPC021-TAB-NUMMAXMONCTA(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMAXMONCTA
           MOVE WS-ATPC021-TAB-INDTRACON-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDTRACON-ATR
           MOVE WS-ATPC021-TAB-INDTRACON(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDTRACON
           MOVE WS-ATPC021-TAB-NUMDIASRET-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMDIASRET-ATR
           MOVE WS-ATPC021-TAB-NUMDIASRET(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMDIASRET
           MOVE WS-ATPC021-TAB-NUMMAXINCSOL-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMAXINCSOL-ATR
           MOVE WS-ATPC021-TAB-NUMMAXINCSOL(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMAXINCSOL
           MOVE WS-ATPC021-TAB-ORDPREPAG-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-ORDPREPAG-ATR
           MOVE WS-ATPC021-TAB-ORDPREPAG(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-ORDPREPAG
           MOVE WS-ATPC021-TAB-PORPERPREPAG-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORPERPREPAG-ATR
           MOVE WS-ATPC021-TAB-PORPERPREPAG(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-PORPERPREPAG
           MOVE WS-ATPC021-TAB-DIASCOMPREPAG-AT(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-DIASCOMPREPAG-ATR
           MOVE WS-ATPC021-TAB-DIASCOMPREPAG(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-DIASCOMPREPAG
           MOVE WS-ATPC021-TAB-DIAPAGCANAL-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-DIAPAGCANAL-ATR
           MOVE WS-ATPC021-TAB-DIAPAGCANAL(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-DIAPAGCANAL
           MOVE WS-ATPC021-TAB-METCALLIQ-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-METCALLIQ-ATR
           MOVE WS-ATPC021-TAB-METCALLIQ(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-METCALLIQ
           MOVE WS-ATPC021-TAB-RPTVALPAGO-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-RPTVALPAGO-ATR
           MOVE WS-ATPC021-TAB-RPTVALPAGO(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-RPTVALPAGO
           MOVE WS-ATPC021-TAB-INDRETPAGO-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDRETPAGO-ATR
           MOVE WS-ATPC021-TAB-INDRETPAGO(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDRETPAGO
           MOVE WS-ATPC021-TAB-NUMMESCOMPL-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMESCOMPL-ATR
           MOVE WS-ATPC021-TAB-NUMMESCOMPL(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-NUMMESCOMPL
           MOVE WS-ATPC021-TAB-INDMECDEV-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDMECDEV-ATR
           MOVE WS-ATPC021-TAB-INDMECDEV(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDMECDEV
           MOVE WS-ATPC021-TAB-INDCAPIMP-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDCAPIMP-ATR
           MOVE WS-ATPC021-TAB-INDCAPIMP(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-INDCAPIMP
           MOVE WS-ATPC021-TAB-CONTCUR-ATR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CONTCUR-ATR
           MOVE WS-ATPC021-TAB-CONTCUR(WS-ATPC021-TAB-INDICE)
             TO WS-ATPC021-CONTCUR
  
           SET WS-ATPC021-RETORNO-OK         TO TRUE
           .

 
      *----------------------------------------------------------------
      * Proceso ejecutado cuando no se ha encontrado datos de 
      * Tipos de Tarjetas con los criterios de busquedas recibidos          
       ATPC021-BUSCAR-NO-ENCONTRADO.
           SET WS-ATPC021-RETORNO-ERROR      TO TRUE
           STRING "No se encontro el dato buscado en ATPC021." 
                                                    DELIMITED BY SIZE
                  " - CODENT:"                      DELIMITED BY SIZE
                  "[" WS-ATPC021-CODENT "]"         DELIMITED BY SIZE
             INTO WS-ATPC021-RETORNO-DESC
           END-STRING
           .