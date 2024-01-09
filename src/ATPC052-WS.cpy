      *    ----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * Tabla: CONCEPTOS ECONOMICOS (estructura MPM0052)
      *
      * Datos de entrada:
      *  - WS-ATPC052-CLAVE.
      *     - WS-ATPC052-CODENT    PIC X(4).
      *     - WS-ATPC052-INDVERT   PIC X(1).
      *     - WS-ATPC052-INDNIVAPL PIC X(2).
      *
      * Datos de salida:
      *  - WS-ATPC052-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0052 son 10 ocurrencias
      *   es decir que en una lectura puede devolver hasta 10 items
      *   [10 MP052-DETALLE OCCURS 10.]
      *   78  WS-ATPC052-MP052-OCCURS          VALUE 10.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC052
       01  WS-MPM0052.
           COPY "MPM0052". 

      * Nombre del programa
       77  CT-ATPC052                  PIC X(07) VALUE "ATPC052".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0052 (linea 19 -> 10 MP052-DETALLE OCCURS 10.)
       78  WS-ATPC052-MP052-OCCURS            VALUE 10.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM052 
       77  WS-ATPC052-MP052-CONTADOR          PIC 9(04).
      * Contador relacionado al arreglo ATPC052 para busqueda en memoria
       77  WS-ATPC052-CONTADOR                PIC 9(04).

      * Variable boolean para control de carga del arreglo WS-ATPC052-TAB  
       01  FILLER                          PIC 9(01).
           88 WS-ATPC052-FIN               VALUE 1 WHEN FALSE 0.

      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC052-TAB
       77  WS-ATPC052-TAB-OCCURS              PIC 9(04).
       
      * Arreglo o Tabla en memoria 
       01  WS-ATPC052-TABLA.
           05 WS-ATPC052-TAB OCCURS 1 TO 1000
                             DEPENDING ON WS-ATPC052-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC052-TAB-CLAVE
                             INDEXED BY WS-ATPC052-TAB-INDICE.
              10  WS-ATPC052-TAB-CLAVE.
                  15 WS-ATPC052-TAB-CODENT               PIC X(04).
                  15 WS-ATPC052-TAB-INDVERT              PIC X(1).
                  15 WS-ATPC052-TAB-INDNIVAPL            PIC X(2).
                  15 WS-ATPC052-TAB-CODCONECO            PIC 9(4).
                  15 WS-ATPC052-TAB-CODCONECO-ALF
                     REDEFINES WS-ATPC052-TAB-CODCONECO  PIC X(4).

              10 WS-ATPC052-TAB-CODENT-ATR               PIC X(1).
              10 WS-ATPC052-TAB-INDVERT-ATR              PIC X(1).
              10 WS-ATPC052-TAB-INDNIVAPL-ATR            PIC X(1).
              10 WS-ATPC052-TAB-CODCONECO-ATR            PIC X(1).
              10 WS-ATPC052-TAB-INDBONOPE-ATR            PIC X(1).
              10 WS-ATPC052-TAB-INDBONOPE                PIC X(1).
              10 WS-ATPC052-TAB-DESCONECO-ATR            PIC X(1).
              10 WS-ATPC052-TAB-DESCONECO                PIC X(30).
              10 WS-ATPC052-TAB-DESCONECORED-ATR         PIC X(1).
              10 WS-ATPC052-TAB-DESCONECORED             PIC X(10).
              10 WS-ATPC052-TAB-INDAPLICA-ATR            PIC X(1).
              10 WS-ATPC052-TAB-INDAPLICA                PIC X(1).
              10 WS-ATPC052-TAB-CODIMPTO-ATR             PIC X(1).
              10 WS-ATPC052-TAB-CODIMPTO                 PIC 9(4).
              10 WS-ATPC052-TAB-CODIMPTO-ALF              
                 REDEFINES WS-ATPC052-TAB-CODIMPTO       PIC X(4).
              10 WS-ATPC052-TAB-VERTIENTE-ATR            PIC X(1).
              10 WS-ATPC052-TAB-VERTIENTE                PIC X(1).
              10 WS-ATPC052-TAB-NIVAPLICA-ATR            PIC X(1).
              10 WS-ATPC052-TAB-NIVAPLICA                PIC X(2).
              10 WS-ATPC052-TAB-SIGNO-ATR                PIC X(1).
              10 WS-ATPC052-TAB-SIGNO                    PIC X(1).
              10 WS-ATPC052-TAB-PROCESO-ATR              PIC X(1).
              10 WS-ATPC052-TAB-PROCESO                  PIC X(10).
              10 WS-ATPC052-TAB-IDEIMPAPL-ATR            PIC X(1).
              10 WS-ATPC052-TAB-IDEIMPAPL                PIC X(10).
              10 WS-ATPC052-TAB-INDPORTRAMO-ATR          PIC X(1).
              10 WS-ATPC052-TAB-INDPORTRAMO              PIC X(1).
              10 WS-ATPC052-TAB-PORREF-ATR               PIC X(1).
              10 WS-ATPC052-TAB-PORREF                   PIC 9(3)V9999.
              10 WS-ATPC052-TAB-PORREF-ALF
                 REDEFINES WS-ATPC052-TAB-PORREF         PIC X(07).
              10 WS-ATPC052-TAB-FECALTA-ATR              PIC X(1).
              10 WS-ATPC052-TAB-FECALTA                  PIC X(10).
              10 WS-ATPC052-TAB-FECINI-ATR               PIC X(1).
              10 WS-ATPC052-TAB-FECINI                   PIC X(10).
              10 WS-ATPC052-TAB-FECFIN-ATR               PIC X(1).
              10 WS-ATPC052-TAB-FECFIN                   PIC X(10).
              10 WS-ATPC052-TAB-INDCONFIN-ATR            PIC X(1).
              10 WS-ATPC052-TAB-INDCONFIN                PIC X(1).
              10 WS-ATPC052-TAB-INDAPLACR-ATR            PIC X(1).
              10 WS-ATPC052-TAB-INDAPLACR                PIC X(1).
              10 WS-ATPC052-TAB-TIPCONECO-ATR            PIC X(1).
              10 WS-ATPC052-TAB-TIPCONECO                PIC X(1).
              10 WS-ATPC052-TAB-CODCONCEP-ATR            PIC X(1).
              10 WS-ATPC052-TAB-CODCONCEP                PIC X(4).
              10 WS-ATPC052-TAB-INDTOPE-ATR              PIC X(1).
              10 WS-ATPC052-TAB-INDTOPE                  PIC X(1).
              10 WS-ATPC052-TAB-PORCOMTOP-ATR            PIC X(1).
              10 WS-ATPC052-TAB-PORCOMTOP                PIC 9(3)V9999.
              10 WS-ATPC052-TAB-PORCOMTOP-ALF
                 REDEFINES WS-ATPC052-TAB-PORCOMTOP      PIC X(7).
              10 WS-ATPC052-TAB-CONTCUR-ATR              PIC X(1).
              10 WS-ATPC052-TAB-CONTCUR                  PIC X(26).
              10 WS-ATPC052-TAB-DESVERTIENTE-ATR         PIC X(1).
              10 WS-ATPC052-TAB-DESVERTIENTE             PIC X(30).
              10 WS-ATPC052-TAB-DESNIVAPLICA-ATR         PIC X(1).
              10 WS-ATPC052-TAB-DESNIVAPLICA             PIC X(30).
              10 WS-ATPC052-TAB-DESINDAPLICA-ATR         PIC X(1).
              10 WS-ATPC052-TAB-DESINDAPLICA             PIC X(30).
              10 WS-ATPC052-TAB-DESTIPCONECO-ATR         PIC X(1).
              10 WS-ATPC052-TAB-DESTIPCONECO             PIC X(30).
              10 WS-ATPC052-TAB-DESINDPORTRAMO-A         PIC X(1).
              10 WS-ATPC052-TAB-DESINDPORTRAMO           PIC X(30).
              10 WS-ATPC052-TAB-DESCODIMPTO-ATR          PIC X(1).
              10 WS-ATPC052-TAB-DESCODIMPTO              PIC X(30).
              10 WS-ATPC052-TAB-INDCONTINUAR             PIC X(1).



      * Registro para E/S de datos del proceso 
      * Representacion del registro del MP052 
       01  WS-ATPC052.
           05  WS-ATPC052-CLAVE.
              10 WS-ATPC052-CODENT                    PIC X(4).
              10 WS-ATPC052-INDVERT                   PIC X(1).
              10 WS-ATPC052-INDNIVAPL                 PIC X(2).
              10 WS-ATPC052-CODCONECO                 PIC 9(4).
              10 WS-ATPC052-CODCONECO-ALF
                 REDEFINES WS-ATPC052-CODCONECO       PIC X(4).

           05  WS-ATPC052-RESPUESTA.
              10 WS-ATPC052-CODENT-ATR                PIC X(1).
              10 WS-ATPC052-INDVERT-ATR               PIC X(1).
              10 WS-ATPC052-INDNIVAPL-ATR             PIC X(1).
              10 WS-ATPC052-CODCONECO-ATR             PIC X(1).
              10 WS-ATPC052-INDBONOPE-ATR             PIC X(1).
              10 WS-ATPC052-INDBONOPE                 PIC X(1).
              10 WS-ATPC052-DESCONECO-ATR             PIC X(1).
              10 WS-ATPC052-DESCONECO                 PIC X(30).
              10 WS-ATPC052-DESCONECORED-ATR          PIC X(1).
              10 WS-ATPC052-DESCONECORED              PIC X(10).
              10 WS-ATPC052-INDAPLICA-ATR             PIC X(1).
              10 WS-ATPC052-INDAPLICA                 PIC X(1).
              10 WS-ATPC052-CODIMPTO-ATR              PIC X(1).
              10 WS-ATPC052-CODIMPTO                  PIC 9(4).
              10 WS-ATPC052-CODIMPTO-ALF              
                 REDEFINES WS-ATPC052-CODIMPTO        PIC X(4).
              10 WS-ATPC052-VERTIENTE-ATR             PIC X(1).
              10 WS-ATPC052-VERTIENTE                 PIC X(1).
              10 WS-ATPC052-NIVAPLICA-ATR             PIC X(1).
              10 WS-ATPC052-NIVAPLICA                 PIC X(2).
              10 WS-ATPC052-SIGNO-ATR                 PIC X(1).
              10 WS-ATPC052-SIGNO                     PIC X(1).
              10 WS-ATPC052-PROCESO-ATR               PIC X(1).
              10 WS-ATPC052-PROCESO                   PIC X(10).
              10 WS-ATPC052-IDEIMPAPL-ATR             PIC X(1).
              10 WS-ATPC052-IDEIMPAPL                 PIC X(10).
              10 WS-ATPC052-INDPORTRAMO-ATR           PIC X(1).
              10 WS-ATPC052-INDPORTRAMO               PIC X(1).
              10 WS-ATPC052-PORREF-ATR                PIC X(1).
              10 WS-ATPC052-PORREF                    PIC 9(3)V9999.
              10 WS-ATPC052-PORREF-ALF         
                 REDEFINES WS-ATPC052-PORREF          PIC X(07).
              10 WS-ATPC052-FECALTA-ATR               PIC X(1).
              10 WS-ATPC052-FECALTA                   PIC X(10).
              10 WS-ATPC052-FECINI-ATR                PIC X(1).
              10 WS-ATPC052-FECINI                    PIC X(10).
              10 WS-ATPC052-FECFIN-ATR                PIC X(1).
              10 WS-ATPC052-FECFIN                    PIC X(10).
              10 WS-ATPC052-INDCONFIN-ATR             PIC X(1).
              10 WS-ATPC052-INDCONFIN                 PIC X(1).
              10 WS-ATPC052-INDAPLACR-ATR             PIC X(1).
              10 WS-ATPC052-INDAPLACR                 PIC X(1).
              10 WS-ATPC052-TIPCONECO-ATR             PIC X(1).
              10 WS-ATPC052-TIPCONECO                 PIC X(1).
              10 WS-ATPC052-CODCONCEP-ATR             PIC X(1).
              10 WS-ATPC052-CODCONCEP                 PIC X(4).
              10 WS-ATPC052-INDTOPE-ATR               PIC X(1).
              10 WS-ATPC052-INDTOPE                   PIC X(1).
              10 WS-ATPC052-PORCOMTOP-ATR             PIC X(1).
              10 WS-ATPC052-PORCOMTOP                 PIC 9(3)V9999.
              10 WS-ATPC052-PORCOMTOP-ALF      
                 REDEFINES WS-ATPC052-PORCOMTOP       PIC X(7).
              10 WS-ATPC052-CONTCUR-ATR               PIC X(1).
              10 WS-ATPC052-CONTCUR                   PIC X(26).
              10 WS-ATPC052-DESVERTIENTE-ATR          PIC X(1).
              10 WS-ATPC052-DESVERTIENTE              PIC X(30).
              10 WS-ATPC052-DESNIVAPLICA-ATR          PIC X(1).
              10 WS-ATPC052-DESNIVAPLICA              PIC X(30).
              10 WS-ATPC052-DESINDAPLICA-ATR          PIC X(1).
              10 WS-ATPC052-DESINDAPLICA              PIC X(30).
              10 WS-ATPC052-DESTIPCONECO-ATR          PIC X(1).
              10 WS-ATPC052-DESTIPCONECO              PIC X(30).
              10 WS-ATPC052-DESINDPORTRAMO-ATR        PIC X(1).
              10 WS-ATPC052-DESINDPORTRAMO            PIC X(30).
              10 WS-ATPC052-DESCODIMPTO-ATR           PIC X(1).
              10 WS-ATPC052-DESCODIMPTO               PIC X(30).
              10 WS-ATPC052-INDCONTINUAR              PIC X(1).


               
       01  WS-ATPC052-RETORNO.
           05  WS-ATPC052-RETORNO-COD        PIC 9(01).
               88  WS-ATPC052-RETORNO-OK     VALUE 0.
               88  WS-ATPC052-RETORNO-INFO   VALUE 1.
               88  WS-ATPC052-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC052-RETORNO-DESC       PIC X(1000).