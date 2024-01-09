      *    ----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * Tabla: ENTIDADES (estructura MPM0021)
      *
      * Datos de entrada:
      *  - WS-ATPC021-CLAVE.
      *     - WS-ATPC021-CODENT    PIC X(04).
      *
      * Datos de salida:
      *  - WS-ATPC021-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0021 son 01 ocurrencias
      *   es decir que en una lectura puede devolver hasta 01 items
      *   78  WS-ATPC021-MP021-OCCURS          VALUE 01.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC021
       01  WS-MPM0021.
           COPY "MPM0021". 

      * Nombre del programa
       77  CT-ATPC021                      PIC X(07) VALUE "ATPC021".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0021 (sólo devuelve una instancia)
       78  WS-ATPC021-MP021-OCCURS         VALUE 01.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM021 
       77  WS-ATPC021-MP021-CONTADOR       PIC 9(01).
      * Contador relacionado al arreglo ATPC021 para busqueda en memoria
       77  WS-ATPC021-CONTADOR             PIC 9(01).

      * Variable boolean para control de carga del arreglo WS-ATPC021-TAB  
       01  FILLER                          PIC 9(01).
           88 WS-ATPC021-FIN               VALUE 1 WHEN FALSE 0.

      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC021-TAB
       77  WS-ATPC021-TAB-OCCURS           PIC 9(01).
       
      * Arreglo o Tabla en memoria 
       01  WS-ATPC021-TABLA.
           05 WS-ATPC021-TAB OCCURS 1 TO 10
                             DEPENDING ON WS-ATPC021-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC021-TAB-CLAVE
                             INDEXED BY WS-ATPC021-TAB-INDICE.
              10  WS-ATPC021-TAB-CLAVE.
                  15  WS-ATPC021-TAB-CODENT              PIC X(4).
              
              10  WS-ATPC021-TAB-CODENT-ATR              PIC X(1).
              10  WS-ATPC021-TAB-CODENTDES-ATR           PIC X(1).
              10  WS-ATPC021-TAB-CODENTDES               PIC X(30).
              10  WS-ATPC021-TAB-CODCSBENT-ATR           PIC X(1).
              10  WS-ATPC021-TAB-CODCSBENT               PIC 9(10).
              10  WS-ATPC021-TAB-CODCSBENT-ALF 
                  REDEFINES WS-ATPC021-TAB-CODCSBENT     PIC X(10).
              10  WS-ATPC021-TAB-CODENTCOM-ATR           PIC X(1).
              10  WS-ATPC021-TAB-CODENTCOM               PIC 9(10).
              10  WS-ATPC021-TAB-CODENTCOM-ALF 
                  REDEFINES WS-ATPC021-TAB-CODENTCOM     PIC X(10).
              10  WS-ATPC021-TAB-PORDESREM-ATR           PIC X(1).
              10  WS-ATPC021-TAB-PORDESREM               PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-PORDESREM-ALF 
                  REDEFINES WS-ATPC021-TAB-PORDESREM     PIC X(07).
              10  WS-ATPC021-TAB-PORAUTFACN-ATR          PIC X(1).
              10  WS-ATPC021-TAB-PORAUTFACN              PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-PORAUTFACN-ALF 
                  REDEFINES WS-ATPC021-TAB-PORAUTFACN    PIC X(07).
              10  WS-ATPC021-TAB-PORAUTFACE-ATR          PIC X(1).
              10  WS-ATPC021-TAB-PORAUTFACE              PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-PORAUTFACE-ALF 
                  REDEFINES WS-ATPC021-TAB-PORAUTFACE    PIC X(07).
              10  WS-ATPC021-TAB-PORLIMAUTCRE-ATR        PIC X(1).
              10  WS-ATPC021-TAB-PORLIMAUTCRE            PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-PORLIMAUTCRE-ALF 
                  REDEFINES WS-ATPC021-TAB-PORLIMAUTCRE  PIC X(07).
              10  WS-ATPC021-TAB-PORLIMAUTCREE-AT        PIC X(1).
              10  WS-ATPC021-TAB-PORLIMAUTCREE           PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-PORLIMAUTCREE-AL 
                  REDEFINES WS-ATPC021-TAB-PORLIMAUTCREE PIC X(07).
              10  WS-ATPC021-TAB-INDUF-ATR               PIC X(1).
              10  WS-ATPC021-TAB-INDUF                   PIC X(01).
              10  WS-ATPC021-TAB-CLAMONUF-ATR            PIC X(1).
              10  WS-ATPC021-TAB-CLAMONUF                PIC 9(3).
              10  WS-ATPC021-TAB-CLAMONUF-ALF 
                  REDEFINES WS-ATPC021-TAB-CLAMONUF      PIC X(03).
              10  WS-ATPC021-TAB-CODPAIS-ATR             PIC X(1).
              10  WS-ATPC021-TAB-CODPAIS                 PIC 9(3).
              10  WS-ATPC021-TAB-CODPAIS-ALF 
                  REDEFINES WS-ATPC021-TAB-CODPAIS       PIC X(03).
              10  WS-ATPC021-TAB-NOMPAIS-ATR             PIC X(1).
              10  WS-ATPC021-TAB-NOMPAIS                 PIC X(30).
              10  WS-ATPC021-TAB-OFIMPAGO-ATR            PIC X(1).
              10  WS-ATPC021-TAB-OFIMPAGO                PIC X(4).
              10  WS-ATPC021-TAB-RESMPAGO-ATR            PIC X(1).
              10  WS-ATPC021-TAB-RESMPAGO                PIC X(22).
              10  WS-ATPC021-TAB-MESNOREN-ATR            PIC X(1).
              10  WS-ATPC021-TAB-MESNOREN                PIC X(12).
              10  WS-ATPC021-TAB-NUMMESRENOV-ATR         PIC X(1).
              10  WS-ATPC021-TAB-NUMMESRENOV             PIC 9(2).
              10  WS-ATPC021-TAB-NUMMESRENOV-ALF 
                  REDEFINES WS-ATPC021-TAB-NUMMESRENOV   PIC X(02).
              10  WS-ATPC021-TAB-INDEXTMON-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDEXTMON               PIC X(1).
              10  WS-ATPC021-TAB-INDREPDISP-ATR          PIC X(1).
              10  WS-ATPC021-TAB-INDREPDISP              PIC X(1).
              10  WS-ATPC021-TAB-MAXFACTNES-ATR          PIC X(1).
              10  WS-ATPC021-TAB-MAXFACTNES              PIC 9(2).
              10  WS-ATPC021-TAB-MAXFACTNES-ALF 
                  REDEFINES WS-ATPC021-TAB-MAXFACTNES    PIC X(02).
              10  WS-ATPC021-TAB-INDCTADOM-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDCTADOM               PIC X(1).
              10  WS-ATPC021-TAB-INDRELCON-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDRELCON               PIC X(1).
              10  WS-ATPC021-TAB-INDCALDIS-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDCALDIS               PIC X(1).
              10  WS-ATPC021-TAB-CODIDIOMA-ATR           PIC X(1).
              10  WS-ATPC021-TAB-CODIDIOMA               PIC X(1).
              10  WS-ATPC021-TAB-TACOMINTAD-ATR          PIC X(1).
              10  WS-ATPC021-TAB-TACOMINTAD              PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-TACOMINTAD-ALF 
                  REDEFINES WS-ATPC021-TAB-TACOMINTAD    PIC X(07).
              10  WS-ATPC021-TAB-INDVISAPHONE-ATR        PIC X(1).
              10  WS-ATPC021-TAB-INDVISAPHONE            PIC 9(1).
              10  WS-ATPC021-TAB-INDVISAPHONE-ALF 
                  REDEFINES WS-ATPC021-TAB-INDVISAPHONE  PIC X(01).
              10  WS-ATPC021-TAB-INDABOREAL-ATR          PIC X(1).
              10  WS-ATPC021-TAB-INDABOREAL              PIC X(1).
              10  WS-ATPC021-TAB-FORCALINT-ATR           PIC X(1).
              10  WS-ATPC021-TAB-FORCALINT               PIC X(1).
              10  WS-ATPC021-TAB-INDPAGMIN-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDPAGMIN               PIC X(1).
              10  WS-ATPC021-TAB-FECALTA-ATR             PIC X(1).
              10  WS-ATPC021-TAB-FECALTA                 PIC X(10).
              10  WS-ATPC021-TAB-FECINI-ATR              PIC X(1).
              10  WS-ATPC021-TAB-FECINI                  PIC X(10).
              10  WS-ATPC021-TAB-FECFIN-ATR              PIC X(1).
              10  WS-ATPC021-TAB-FECFIN                  PIC X(10).
              10  WS-ATPC021-TAB-CRIREC-ATR              PIC X(1).
              10  WS-ATPC021-TAB-CRIREC                  PIC X(1).
              10  WS-ATPC021-TAB-INDADMSALDO-ATR         PIC X(1).
              10  WS-ATPC021-TAB-INDADMSALDO             PIC X(1).
              10  WS-ATPC021-TAB-NUMORDSALCOM-ATR        PIC X(1).
              10  WS-ATPC021-TAB-NUMORDSALCOM            PIC 9(1).
              10  WS-ATPC021-TAB-NUMORDSALCOM-ALF 
                  REDEFINES WS-ATPC021-TAB-NUMORDSALCOM  PIC X(01).
              10  WS-ATPC021-TAB-NUMORDSALDIS-ATR        PIC X(1).
              10  WS-ATPC021-TAB-NUMORDSALDIS            PIC 9(1).
              10  WS-ATPC021-TAB-NUMORDSALDIS-ALF 
                  REDEFINES WS-ATPC021-TAB-NUMORDSALDIS  PIC X(01).
              10  WS-ATPC021-TAB-NUMMAXMONCTA-ATR        PIC X(1).
              10  WS-ATPC021-TAB-NUMMAXMONCTA            PIC 9(1).
              10  WS-ATPC021-TAB-NUMMAXMONCTA-ALF 
                  REDEFINES WS-ATPC021-TAB-NUMMAXMONCTA  PIC X(01).
              10  WS-ATPC021-TAB-INDTRACON-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDTRACON               PIC X(1).
              10  WS-ATPC021-TAB-NUMDIASRET-ATR          PIC X(1).
              10  WS-ATPC021-TAB-NUMDIASRET              PIC 9(2).
              10  WS-ATPC021-TAB-NUMDIASRET-ALF 
                  REDEFINES WS-ATPC021-TAB-NUMDIASRET    PIC X(02).
              10  WS-ATPC021-TAB-NUMMAXINCSOL-ATR        PIC X(1).
              10  WS-ATPC021-TAB-NUMMAXINCSOL            PIC 9(3).
              10  WS-ATPC021-TAB-NUMMAXINCSOL-ALF 
                  REDEFINES WS-ATPC021-TAB-NUMMAXINCSOL  PIC X(03).
              10  WS-ATPC021-TAB-ORDPREPAG-ATR           PIC X(1).
              10  WS-ATPC021-TAB-ORDPREPAG               PIC X(1).
              10  WS-ATPC021-TAB-PORPERPREPAG-ATR        PIC X(1).
              10  WS-ATPC021-TAB-PORPERPREPAG            PIC 9(3)V9(4).
              10  WS-ATPC021-TAB-PORPERPREPAG-ALF 
                  REDEFINES WS-ATPC021-TAB-PORPERPREPAG  PIC X(07).
              10  WS-ATPC021-TAB-DIASCOMPREPAG-AT        PIC X(1).
              10  WS-ATPC021-TAB-DIASCOMPREPAG           PIC 9(2).     
              10  WS-ATPC021-TAB-DIASCOMPREPAG-AL 
                  REDEFINES WS-ATPC021-TAB-DIASCOMPREPAG PIC X(02).
              10  WS-ATPC021-TAB-DIAPAGCANAL-ATR         PIC X(1).
              10  WS-ATPC021-TAB-DIAPAGCANAL             PIC 9(2).     
              10  WS-ATPC021-TAB-DIAPAGCANAL-ALF 
                  REDEFINES WS-ATPC021-TAB-DIAPAGCANAL   PIC X(02).
              10  WS-ATPC021-TAB-METCALLIQ-ATR           PIC X(1).
              10  WS-ATPC021-TAB-METCALLIQ               PIC X(1).
              10  WS-ATPC021-TAB-RPTVALPAGO-ATR          PIC X(1).
              10  WS-ATPC021-TAB-RPTVALPAGO              PIC X(1).
              10  WS-ATPC021-TAB-INDRETPAGO-ATR          PIC X(1).
              10  WS-ATPC021-TAB-INDRETPAGO              PIC X(1).
              10  WS-ATPC021-TAB-NUMMESCOMPL-ATR         PIC X(1).
              10  WS-ATPC021-TAB-NUMMESCOMPL             PIC 9(2).
              10  WS-ATPC021-TAB-NUMMESCOMPL-ALF                      
                  REDEFINES WS-ATPC021-TAB-NUMMESCOMPL   PIC X(2).
              10  WS-ATPC021-TAB-INDMECDEV-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDMECDEV               PIC X(1).
              10  WS-ATPC021-TAB-INDCAPIMP-ATR           PIC X(1).
              10  WS-ATPC021-TAB-INDCAPIMP               PIC X(1).
              10  WS-ATPC021-TAB-CONTCUR-ATR             PIC X(1).
              10  WS-ATPC021-TAB-CONTCUR                 PIC X(26).




      * Registro para E/S de datos del proceso 
      * Representacion del registro del MP021 
       01  WS-ATPC021.
           05  WS-ATPC021-CLAVE.
              10  WS-ATPC021-CODENT                  PIC X(4).
                            
           05  WS-ATPC021-RESPUESTA.
              10  WS-ATPC021-CODENT-ATR              PIC X(1).
              10  WS-ATPC021-CODENTDES-ATR           PIC X(1).
              10  WS-ATPC021-CODENTDES               PIC X(30).
              10  WS-ATPC021-CODCSBENT-ATR           PIC X(1).
              10  WS-ATPC021-CODCSBENT               PIC 9(10).
              10  WS-ATPC021-CODCSBENT-ALF 
                  REDEFINES WS-ATPC021-CODCSBENT     PIC X(10).
              10  WS-ATPC021-CODENTCOM-ATR           PIC X(1).
              10  WS-ATPC021-CODENTCOM               PIC 9(10).
              10  WS-ATPC021-CODENTCOM-ALF 
                  REDEFINES WS-ATPC021-CODENTCOM     PIC X(10).
              10  WS-ATPC021-PORDESREM-ATR           PIC X(1).
              10  WS-ATPC021-PORDESREM               PIC 9(3)V9(4).
              10  WS-ATPC021-PORDESREM-ALF 
                  REDEFINES WS-ATPC021-PORDESREM     PIC X(07).
              10  WS-ATPC021-PORAUTFACN-ATR          PIC X(1).
              10  WS-ATPC021-PORAUTFACN              PIC 9(3)V9(4).
              10  WS-ATPC021-PORAUTFACN-ALF 
                  REDEFINES WS-ATPC021-PORAUTFACN    PIC X(07).
              10  WS-ATPC021-PORAUTFACE-ATR          PIC X(1).
              10  WS-ATPC021-PORAUTFACE              PIC 9(3)V9(4).
              10  WS-ATPC021-PORAUTFACE-ALF 
                  REDEFINES WS-ATPC021-PORAUTFACE    PIC X(07).
              10  WS-ATPC021-PORLIMAUTCRE-ATR        PIC X(1).
              10  WS-ATPC021-PORLIMAUTCRE            PIC 9(3)V9(4).
              10  WS-ATPC021-PORLIMAUTCRE-ALF 
                  REDEFINES WS-ATPC021-PORLIMAUTCRE  PIC X(07).
              10  WS-ATPC021-PORLIMAUTCREE-ATR       PIC X(1).
              10  WS-ATPC021-PORLIMAUTCREE           PIC 9(3)V9(4).
              10  WS-ATPC021-PORLIMAUTCREE-ALF 
                  REDEFINES WS-ATPC021-PORLIMAUTCREE PIC X(07).
              10  WS-ATPC021-INDUF-ATR               PIC X(1).
              10  WS-ATPC021-INDUF                   PIC X(01).
              10  WS-ATPC021-CLAMONUF-ATR            PIC X(1).
              10  WS-ATPC021-CLAMONUF                PIC 9(3).
              10  WS-ATPC021-CLAMONUF-ALF 
                  REDEFINES WS-ATPC021-CLAMONUF      PIC X(03).
              10  WS-ATPC021-CODPAIS-ATR             PIC X(1).
              10  WS-ATPC021-CODPAIS                 PIC 9(3).
              10  WS-ATPC021-CODPAIS-ALF 
                  REDEFINES WS-ATPC021-CODPAIS       PIC X(03).
              10  WS-ATPC021-NOMPAIS-ATR             PIC X(1).
              10  WS-ATPC021-NOMPAIS                 PIC X(30).
              10  WS-ATPC021-OFIMPAGO-ATR            PIC X(1).
              10  WS-ATPC021-OFIMPAGO                PIC X(4).
              10  WS-ATPC021-RESMPAGO-ATR            PIC X(1).
              10  WS-ATPC021-RESMPAGO                PIC X(22).
              10  WS-ATPC021-MESNOREN-ATR            PIC X(1).
              10  WS-ATPC021-MESNOREN                PIC X(12).
              10  WS-ATPC021-NUMMESRENOV-ATR         PIC X(1).
              10  WS-ATPC021-NUMMESRENOV             PIC 9(2).
              10  WS-ATPC021-NUMMESRENOV-ALF 
                  REDEFINES WS-ATPC021-NUMMESRENOV   PIC X(02).
              10  WS-ATPC021-INDEXTMON-ATR           PIC X(1).
              10  WS-ATPC021-INDEXTMON               PIC X(1).
              10  WS-ATPC021-INDREPDISP-ATR          PIC X(1).
              10  WS-ATPC021-INDREPDISP              PIC X(1).
              10  WS-ATPC021-MAXFACTNES-ATR          PIC X(1).
              10  WS-ATPC021-MAXFACTNES              PIC 9(2).
              10  WS-ATPC021-MAXFACTNES-ALF 
                  REDEFINES WS-ATPC021-MAXFACTNES    PIC X(02).
              10  WS-ATPC021-INDCTADOM-ATR           PIC X(1).
              10  WS-ATPC021-INDCTADOM               PIC X(1).
              10  WS-ATPC021-INDRELCON-ATR           PIC X(1).
              10  WS-ATPC021-INDRELCON               PIC X(1).
              10  WS-ATPC021-INDCALDIS-ATR           PIC X(1).
              10  WS-ATPC021-INDCALDIS               PIC X(1).
              10  WS-ATPC021-CODIDIOMA-ATR           PIC X(1).
              10  WS-ATPC021-CODIDIOMA               PIC X(1).
              10  WS-ATPC021-TACOMINTAD-ATR          PIC X(1).
              10  WS-ATPC021-TACOMINTAD              PIC 9(3)V9(4).
              10  WS-ATPC021-TACOMINTAD-ALF 
                  REDEFINES WS-ATPC021-TACOMINTAD    PIC X(07).
              10  WS-ATPC021-INDVISAPHONE-ATR        PIC X(1).
              10  WS-ATPC021-INDVISAPHONE            PIC 9(1).
              10  WS-ATPC021-INDVISAPHONE-ALF 
                  REDEFINES WS-ATPC021-INDVISAPHONE  PIC X(01).
              10  WS-ATPC021-INDABOREAL-ATR          PIC X(1).
              10  WS-ATPC021-INDABOREAL              PIC X(1).
              10  WS-ATPC021-FORCALINT-ATR           PIC X(1).
              10  WS-ATPC021-FORCALINT               PIC X(1).
              10  WS-ATPC021-INDPAGMIN-ATR           PIC X(1).
              10  WS-ATPC021-INDPAGMIN               PIC X(1).
              10  WS-ATPC021-FECALTA-ATR             PIC X(1).
              10  WS-ATPC021-FECALTA                 PIC X(10).
              10  WS-ATPC021-FECINI-ATR              PIC X(1).
              10  WS-ATPC021-FECINI                  PIC X(10).
              10  WS-ATPC021-FECFIN-ATR              PIC X(1).
              10  WS-ATPC021-FECFIN                  PIC X(10).
              10  WS-ATPC021-CRIREC-ATR              PIC X(1).
              10  WS-ATPC021-CRIREC                  PIC X(1).
              10  WS-ATPC021-INDADMSALDO-ATR         PIC X(1).
              10  WS-ATPC021-INDADMSALDO             PIC X(1).
              10  WS-ATPC021-NUMORDSALCOM-ATR        PIC X(1).
              10  WS-ATPC021-NUMORDSALCOM            PIC 9(1).
              10  WS-ATPC021-NUMORDSALCOM-ALF 
                  REDEFINES WS-ATPC021-NUMORDSALCOM  PIC X(01).
              10  WS-ATPC021-NUMORDSALDIS-ATR        PIC X(1).
              10  WS-ATPC021-NUMORDSALDIS            PIC 9(1).
              10  WS-ATPC021-NUMORDSALDIS-ALF 
                  REDEFINES WS-ATPC021-NUMORDSALDIS  PIC X(01).
              10  WS-ATPC021-NUMMAXMONCTA-ATR        PIC X(1).
              10  WS-ATPC021-NUMMAXMONCTA            PIC 9(1).
              10  WS-ATPC021-NUMMAXMONCTA-ALF 
                  REDEFINES WS-ATPC021-NUMMAXMONCTA  PIC X(01).
              10  WS-ATPC021-INDTRACON-ATR           PIC X(1).
              10  WS-ATPC021-INDTRACON               PIC X(1).
              10  WS-ATPC021-NUMDIASRET-ATR          PIC X(1).
              10  WS-ATPC021-NUMDIASRET              PIC 9(2).
              10  WS-ATPC021-NUMDIASRET-ALF 
                  REDEFINES WS-ATPC021-NUMDIASRET    PIC X(02).
              10  WS-ATPC021-NUMMAXINCSOL-ATR        PIC X(1).
              10  WS-ATPC021-NUMMAXINCSOL            PIC 9(3).
              10  WS-ATPC021-NUMMAXINCSOL-ALF 
                  REDEFINES WS-ATPC021-NUMMAXINCSOL  PIC X(03).
              10  WS-ATPC021-ORDPREPAG-ATR           PIC X(1).
              10  WS-ATPC021-ORDPREPAG               PIC X(1).
              10  WS-ATPC021-PORPERPREPAG-ATR        PIC X(1).
              10  WS-ATPC021-PORPERPREPAG            PIC 9(3)V9(4).
              10  WS-ATPC021-PORPERPREPAG-ALF 
                  REDEFINES WS-ATPC021-PORPERPREPAG  PIC X(07).
              10  WS-ATPC021-DIASCOMPREPAG-ATR       PIC X(1).
              10  WS-ATPC021-DIASCOMPREPAG           PIC 9(2).     
              10  WS-ATPC021-DIASCOMPREPAG-ALF 
                  REDEFINES WS-ATPC021-DIASCOMPREPAG PIC X(02).
              10  WS-ATPC021-DIAPAGCANAL-ATR         PIC X(1).
              10  WS-ATPC021-DIAPAGCANAL             PIC 9(2).     
              10  WS-ATPC021-DIAPAGCANAL-ALF 
                  REDEFINES WS-ATPC021-DIAPAGCANAL   PIC X(02).
              10  WS-ATPC021-METCALLIQ-ATR           PIC X(1).
              10  WS-ATPC021-METCALLIQ               PIC X(1).
              10  WS-ATPC021-RPTVALPAGO-ATR          PIC X(1).
              10  WS-ATPC021-RPTVALPAGO              PIC X(1).
              10  WS-ATPC021-INDRETPAGO-ATR          PIC X(1).
              10  WS-ATPC021-INDRETPAGO              PIC X(1).
              10  WS-ATPC021-NUMMESCOMPL-ATR         PIC X(1).
              10  WS-ATPC021-NUMMESCOMPL             PIC 9(2).
              10  WS-ATPC021-NUMMESCOMPL-ALF                      
                  REDEFINES WS-ATPC021-NUMMESCOMPL   PIC X(2).
              10  WS-ATPC021-INDMECDEV-ATR           PIC X(1).
              10  WS-ATPC021-INDMECDEV               PIC X(1).
              10  WS-ATPC021-INDCAPIMP-ATR           PIC X(1).
              10  WS-ATPC021-INDCAPIMP               PIC X(1).
              10  WS-ATPC021-CONTCUR-ATR             PIC X(1).
              10  WS-ATPC021-CONTCUR                 PIC X(26).

               
       01  WS-ATPC021-RETORNO.
           05  WS-ATPC021-RETORNO-COD        PIC 9(01).
               88  WS-ATPC021-RETORNO-OK     VALUE 0.
               88  WS-ATPC021-RETORNO-INFO   VALUE 1.
               88  WS-ATPC021-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC021-RETORNO-DESC       PIC X(1000).