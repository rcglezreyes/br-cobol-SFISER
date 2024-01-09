      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * Tabla: TIPOS DE FACTURAS (estructura MPM0044)
      *
      * Datos de entrada:
      *  - WS-ATPC044-CLAVE.
      *     - WS-ATPC044-CODENT         PIC X(04).
      *     - WS-ATPC044-TIPOFAC-ALF    PIC X(04).
      *     - WS-ATPC044-INDNORCOR-ALF  PIC X(01).
      *
      * Datos de salida:
      *  - WS-ATPC044-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0044 son 25 ocurrencias
      *   es decir que en una lectura puede devolver hasta 25 items
      *   [10  MP044-DETALLES   OCCURS 25.]
      *   78  WS-ATPC044-MP044-OCCURS          VALUE 25.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC044
       01  WS-MPM0044.
           COPY "MPM0044". 

      * Nombre del programa
       77  CT-ATPC044                  PIC X(07) VALUE "ATPC044".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0044 (linea 113 -> 10 MP044-DETALLE OCCURS 25.)
       78  WS-ATPC044-MP044-OCCURS            VALUE 25.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM044 
       77  WS-ATPC044-MP044-CONTADOR          PIC 9(04).
      * Contador relacionado al arreglo ATPC044 para busqueda en memoria
       77  WS-ATPC044-CONTADOR                PIC 9(04).

      * Variable boolean para control de carga del arreglo WS-ATPC044-TAB  
       01  FILLER                          PIC 9(01).
           88 WS-ATPC044-FIN               VALUE 1 WHEN FALSE 0.

      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC044-TAB
       77  WS-ATPC044-TAB-OCCURS              PIC 9(04).
       
      * Arreglo o Tabla en memoria 
       01  WS-ATPC044-TABLA.
           05  WS-ATPC044-TAB OCCURS 1 TO 1000
                             DEPENDING ON WS-ATPC044-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC044-TAB-CLAVE
                             INDEXED BY WS-ATPC044-TAB-INDICE.
               10  WS-ATPC044-TAB-CLAVE.
                   15 WS-ATPC044-TAB-CODENT                  PIC X(04).
                   15 WS-ATPC044-TAB-TIPOFAC                 PIC 9(04).
                   15 WS-ATPC044-TAB-TIPOFAC-ALF 
                      REDEFINES WS-ATPC044-TAB-TIPOFAC       PIC X(04).
                   15 WS-ATPC044-TAB-INDNORCOR               PIC 9(01).
                   15 WS-ATPC044-TAB-INDNORCOR-ALF 
                      REDEFINES WS-ATPC044-TAB-INDNORCOR     PIC X(01).

               10 WS-ATPC044-TAB-CODENT-ATR                  PIC X(01).
               10 WS-ATPC044-TAB-TIPOFAC-ATR                 PIC X(01).
               10 WS-ATPC044-TAB-INDNORCOR-ATR               PIC X(01).
               10 WS-ATPC044-TAB-TIPOFACSIST-ATR             PIC X(01).
               10 WS-ATPC044-TAB-TIPOFACSIST                 PIC 9(04).
               10 WS-ATPC044-TAB-TIPOFACSIST-ALF 
                  REDEFINES WS-ATPC044-TAB-TIPOFACSIST       PIC X(04).
               10 WS-ATPC044-TAB-TIPSAL-ATR                  PIC X(01).
               10 WS-ATPC044-TAB-TIPSAL                      PIC X(02).
               10 WS-ATPC044-TAB-DESTIPSAL-ATR               PIC X(01).
               10 WS-ATPC044-TAB-DESTIPSAL                   PIC X(30).
               10 WS-ATPC044-TAB-SIGNO-ATR                   PIC X(01).
               10 WS-ATPC044-TAB-SIGNO                       PIC X(01).
               10 WS-ATPC044-TAB-DESTIPFAC-ATR               PIC X(01).
               10 WS-ATPC044-TAB-DESTIPFAC                   PIC X(30).
               10 WS-ATPC044-TAB-INDAUT-ATR                  PIC X(01).
               10 WS-ATPC044-TAB-INDAUT                      PIC X(01).
               10 WS-ATPC044-TAB-INDFACINF-ATR               PIC X(01).
               10 WS-ATPC044-TAB-INDFACINF                   PIC X(01).
               10 WS-ATPC044-TAB-INDFACFIN-ATR               PIC X(01).
               10 WS-ATPC044-TAB-INDFACFIN                   PIC X(01).
               10 WS-ATPC044-TAB-INDCOMPCUO-ATR              PIC X(01).
               10 WS-ATPC044-TAB-INDCOMPCUO                  PIC X(01).
               10 WS-ATPC044-TAB-INDAPLINT-ATR               PIC X(01).
               10 WS-ATPC044-TAB-INDAPLINT                   PIC X(01).
               10 WS-ATPC044-TAB-TIPFECINIINT-ATR            PIC X(01).
               10 WS-ATPC044-TAB-TIPFECINIINT                PIC X(01).
               10 WS-ATPC044-TAB-TIPFECFININT-ATR            PIC X(01).
               10 WS-ATPC044-TAB-TIPFECFININT                PIC X(01).
               10 WS-ATPC044-TAB-INDMODIF-ATR                PIC X(01).
               10 WS-ATPC044-TAB-INDMODIF                    PIC X(01).
               10 WS-ATPC044-TAB-LINEA-ATR                   PIC X(01).
               10 WS-ATPC044-TAB-LINEA                       PIC X(04).
               10 WS-ATPC044-TAB-DESLINEA-ATR                PIC X(01).
               10 WS-ATPC044-TAB-DESLINEA                    PIC X(30).
               10 WS-ATPC044-TAB-INDENTREM-ATR               PIC X(01).
               10 WS-ATPC044-TAB-INDENTREM                   PIC X(01).
               10 WS-ATPC044-TAB-INDENTEXT-ATR               PIC X(01).
               10 WS-ATPC044-TAB-INDENTEXT                   PIC X(01).
               10 WS-ATPC044-TAB-CODIMPTO-ATR                PIC X(01).
               10 WS-ATPC044-TAB-CODIMPTO                    PIC 9(04).
               10 WS-ATPC044-TAB-CODIMPTO-ALF 
                  REDEFINES WS-ATPC044-TAB-CODIMPTO          PIC X(04).
               10 WS-ATPC044-TAB-DESIMPTO-ATR                PIC X(01).
               10 WS-ATPC044-TAB-DESIMPTO                    PIC X(30).
               10 WS-ATPC044-TAB-FECALTA-ATR                 PIC X(01).
               10 WS-ATPC044-TAB-FECALTA                     PIC X(10).
               10 WS-ATPC044-TAB-FECBAJA-ATR                 PIC X(01).
               10 WS-ATPC044-TAB-FECBAJA                     PIC X(10).
               10 WS-ATPC044-TAB-FECINI-ATR                  PIC X(01).
               10 WS-ATPC044-TAB-FECINI                      PIC X(10).
               10 WS-ATPC044-TAB-FECFIN-ATR                  PIC X(01).
               10 WS-ATPC044-TAB-FECFIN                      PIC X(10).
               10 WS-ATPC044-TAB-CODCONCEP-ATR               PIC X(01).
               10 WS-ATPC044-TAB-CODCONCEP                   PIC X(04).
               10 WS-ATPC044-TAB-CONTCUR-ATR                 PIC X(01).
               10 WS-ATPC044-TAB-CONTCUR                     PIC X(26).
               10 WS-ATPC044-TAB-INDCONTINUAR                PIC X(01).


      * Registro para E/S de datos del proceso 
      * Representacion del registro del MP044 
       01  WS-ATPC044.
           05  WS-ATPC044-CLAVE.
               10 WS-ATPC044-CODENT                      PIC X(04).
               10 WS-ATPC044-TIPOFAC                     PIC 9(04).
               10 WS-ATPC044-TIPOFAC-ALF 
                  REDEFINES WS-ATPC044-TIPOFAC           PIC X(04).
               10 WS-ATPC044-INDNORCOR                   PIC 9(01).
               10 WS-ATPC044-INDNORCOR-ALF 
                  REDEFINES WS-ATPC044-INDNORCOR         PIC X(01).

           05  WS-ATPC044-RESPUESTA.
               10 WS-ATPC044-CODENT-ATR                  PIC X(01).
               10 WS-ATPC044-TIPOFAC-ATR                 PIC X(01).
               10 WS-ATPC044-INDNORCOR-ATR               PIC X(01).
               10 WS-ATPC044-TIPOFACSIST-ATR             PIC X(01).
               10 WS-ATPC044-TIPOFACSIST                 PIC 9(04).
               10 WS-ATPC044-TIPOFACSIST-ALF 
                  REDEFINES WS-ATPC044-TIPOFACSIST       PIC X(04).
               10 WS-ATPC044-TIPSAL-ATR                  PIC X(01).
               10 WS-ATPC044-TIPSAL                      PIC X(02).
               10 WS-ATPC044-DESTIPSAL-ATR               PIC X(01).
               10 WS-ATPC044-DESTIPSAL                   PIC X(30).
               10 WS-ATPC044-SIGNO-ATR                   PIC X(01).
               10 WS-ATPC044-SIGNO                       PIC X(01).
               10 WS-ATPC044-DESTIPFAC-ATR               PIC X(01).
               10 WS-ATPC044-DESTIPFAC                   PIC X(30).
               10 WS-ATPC044-INDAUT-ATR                  PIC X(01).
               10 WS-ATPC044-INDAUT                      PIC X(01).
               10 WS-ATPC044-INDFACINF-ATR               PIC X(01).
               10 WS-ATPC044-INDFACINF                   PIC X(01).
               10 WS-ATPC044-INDFACFIN-ATR               PIC X(01).
               10 WS-ATPC044-INDFACFIN                   PIC X(01).
               10 WS-ATPC044-INDCOMPCUO-ATR              PIC X(01).
               10 WS-ATPC044-INDCOMPCUO                  PIC X(01).
               10 WS-ATPC044-INDAPLINT-ATR               PIC X(01).
               10 WS-ATPC044-INDAPLINT                   PIC X(01).
               10 WS-ATPC044-TIPFECINIINT-ATR            PIC X(01).
               10 WS-ATPC044-TIPFECINIINT                PIC X(01).
               10 WS-ATPC044-TIPFECFININT-ATR            PIC X(01).
               10 WS-ATPC044-TIPFECFININT                PIC X(01).
               10 WS-ATPC044-INDMODIF-ATR                PIC X(01).
               10 WS-ATPC044-INDMODIF                    PIC X(01).
               10 WS-ATPC044-LINEA-ATR                   PIC X(01).
               10 WS-ATPC044-LINEA                       PIC X(04).
               10 WS-ATPC044-DESLINEA-ATR                PIC X(01).
               10 WS-ATPC044-DESLINEA                    PIC X(30).
               10 WS-ATPC044-INDENTREM-ATR               PIC X(01).
               10 WS-ATPC044-INDENTREM                   PIC X(01).
               10 WS-ATPC044-INDENTEXT-ATR               PIC X(01).
               10 WS-ATPC044-INDENTEXT                   PIC X(01).
               10 WS-ATPC044-CODIMPTO-ATR                PIC X(01).
               10 WS-ATPC044-CODIMPTO                    PIC 9(04).
               10 WS-ATPC044-CODIMPTO-ALF 
                  REDEFINES WS-ATPC044-CODIMPTO          PIC X(04).
               10 WS-ATPC044-DESIMPTO-ATR                PIC X(01).
               10 WS-ATPC044-DESIMPTO                    PIC X(30).
               10 WS-ATPC044-FECALTA-ATR                 PIC X(01).
               10 WS-ATPC044-FECALTA                     PIC X(10).
               10 WS-ATPC044-FECBAJA-ATR                 PIC X(01).
               10 WS-ATPC044-FECBAJA                     PIC X(10).
               10 WS-ATPC044-FECINI-ATR                  PIC X(01).
               10 WS-ATPC044-FECINI                      PIC X(10).
               10 WS-ATPC044-FECFIN-ATR                  PIC X(01).
               10 WS-ATPC044-FECFIN                      PIC X(10).
               10 WS-ATPC044-CODCONCEP-ATR               PIC X(01).
               10 WS-ATPC044-CODCONCEP                   PIC X(04).
               10 WS-ATPC044-CONTCUR-ATR                 PIC X(01).
               10 WS-ATPC044-CONTCUR                     PIC X(26).
               10 WS-ATPC044-INDCONTINUAR                PIC X(01).

               
       01  WS-ATPC044-RETORNO.
           05  WS-ATPC044-RETORNO-COD        PIC 9(01).
               88  WS-ATPC044-RETORNO-OK     VALUE 0.
               88  WS-ATPC044-RETORNO-INFO   VALUE 1.
               88  WS-ATPC044-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC044-RETORNO-DESC       PIC X(1000).