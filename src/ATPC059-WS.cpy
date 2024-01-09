      *    ----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * Tabla: FACTURA / CONCEPTOS ECONOMICOS (estructura MPM0059)
      *
      * Datos de entrada:
      *  - WS-ATPC059-CLAVE.
      *     - WS-ATPC059-CODENT    PIC X(4).
      *     - WS-ATPC059-CODCONECO PIC 9(4).
      *
      * Datos de salida:
      *  - WS-ATPC059-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0059 son 70 ocurrencias
      *   es decir que en una lectura puede devolver hasta 70 items
      *   [10      MP059-DETALLE OCCURS 70.]
      *   78  WS-ATPC059-MP059-OCCURS          VALUE 70.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC059
       01  WS-MPM0059.
           COPY "MPM0059". 

      * Nombre del programa
       77  CT-ATPC059                  PIC X(07) VALUE "ATPC059".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0059 (linea 15 -> 10 MP059-DETALLE OCCURS 70.)
       78  WS-ATPC059-MP059-OCCURS            VALUE 70.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM059 
       77  WS-ATPC059-MP059-CONTADOR          PIC 9(04).
      * Contador relacionado al arreglo ATPC059 para busqueda en memoria
       77  WS-ATPC059-CONTADOR                PIC 9(04).

      * Variable boolean para control de carga del arreglo WS-ATPC059-TAB  
       01  FILLER                          PIC 9(01).
           88 WS-ATPC059-FIN               VALUE 1 WHEN FALSE 0.

      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC059-TAB
       77  WS-ATPC059-TAB-OCCURS              PIC 9(04).
       
      * Arreglo o Tabla en memoria 
       01  WS-ATPC059-TABLA.
           05 WS-ATPC059-TAB OCCURS 1 TO 1000
                             DEPENDING ON WS-ATPC059-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC059-TAB-CLAVE
                             INDEXED BY WS-ATPC059-TAB-INDICE.
              10  WS-ATPC059-TAB-CLAVE.
                  15  WS-ATPC059-TAB-CODENT               PIC X(4).
                  15  WS-ATPC059-TAB-INDNORCOR            PIC 9(1).
                  15  WS-ATPC059-TAB-TIPOFAC              PIC 9(4).
                  15  WS-ATPC059-TAB-INDAPLCON            PIC X(1).
                  15  WS-ATPC059-TAB-INDAPLDEBCRE         PIC 9(1).
              
              10  WS-ATPC059-TAB-CODENT-ATR               PIC X(1).
              10  WS-ATPC059-TAB-INDNORCOR-ATR            PIC X(1).
      *        10  WS-ATPC059-TAB-INDNORCOR-ALF      
      *            REDEFINES WS-ATPC059-TAB-INDNORCOR      PIC X(1).
              10  WS-ATPC059-TAB-TIPOFAC-ATR              PIC X(1).

      *        10  WS-ATPC059-TAB-TIPOFAC-ALF 
      *            REDEFINES WS-ATPC059-TAB-TIPOFAC        PIC X(4).
              10  WS-ATPC059-TAB-DESTIPFAC-ATR            PIC X(1).
              10  WS-ATPC059-TAB-DESTIPFAC                PIC X(30).
              10  WS-ATPC059-TAB-CODCONECO-ATR            PIC X(1).
              10  WS-ATPC059-TAB-CODCONECO                PIC 9(4).
              10  WS-ATPC059-TAB-CODCONECO-ALF 
                  REDEFINES WS-ATPC059-TAB-CODCONECO      PIC X(4).
              10  WS-ATPC059-TAB-DESCONECO-ATR            PIC X(1).
              10  WS-ATPC059-TAB-DESCONECO                PIC X(30).
              10  WS-ATPC059-TAB-INDAPLCON-ATR            PIC X(1).

              10  WS-ATPC059-TAB-INDAPLDEBCRE-ATR         PIC X(1).

      *        10  WS-ATPC059-TAB-INDAPLDEBCRE-ALF 
      *            REDEFINES WS-ATPC059-TAB-INDAPLDEBCRE   PIC X(01).
              10  WS-ATPC059-TAB-FECALTA-ATR              PIC X(1).
              10  WS-ATPC059-TAB-FECALTA                  PIC X(10).
              10  WS-ATPC059-TAB-CONTCUR-ATR              PIC X(1).
              10  WS-ATPC059-TAB-CONTCUR                  PIC X(26).
              10  WS-ATPC059-TAB-INDCONTINUAR             PIC X(1).



      * Registro para E/S de datos del proceso 
      * Representacion del registro del MP059 
       01  WS-ATPC059.
           05  WS-ATPC059-CLAVE.
              10 WS-ATPC059-CODENT                    PIC X(4).
              10  WS-ATPC059-INDNORCOR                PIC 9(1).
              10  WS-ATPC059-TIPOFAC                  PIC 9(4).
              10  WS-ATPC059-INDAPLCON                PIC X(1).
              10  WS-ATPC059-INDAPLDEBCRE             PIC 9(1).
              
           05  WS-ATPC059-RESPUESTA.
              10  WS-ATPC059-CODENT-ATR               PIC X(1).
              10  WS-ATPC059-INDNORCOR-ATR            PIC X(1).
      *        10  WS-ATPC059-INDNORCOR-ALF      
      *            REDEFINES WS-ATPC059-INDNORCOR      PIC X(1).
              10  WS-ATPC059-TIPOFAC-ATR              PIC X(1).
      *        10  WS-ATPC059-TIPOFAC-ALF 
      *            REDEFINES WS-ATPC059-TIPOFAC        PIC X(4).
              10  WS-ATPC059-DESTIPFAC-ATR            PIC X(1).
              10  WS-ATPC059-DESTIPFAC                PIC X(30).
              10  WS-ATPC059-CODCONECO-ATR            PIC X(1).
              10  WS-ATPC059-CODCONECO                PIC 9(4).
              10  WS-ATPC059-CODCONECO-ALF 
                  REDEFINES WS-ATPC059-CODCONECO      PIC X(4).
              10  WS-ATPC059-DESCONECO-ATR            PIC X(1).
              10  WS-ATPC059-DESCONECO                PIC X(30).
              10  WS-ATPC059-INDAPLCON-ATR            PIC X(1).
              10  WS-ATPC059-INDAPLDEBCRE-ATR         PIC X(1).
      *        10  WS-ATPC059-INDAPLDEBCRE-ALF 
      *            REDEFINES WS-ATPC059-INDAPLDEBCRE   PIC X(01).
              10  WS-ATPC059-FECALTA-ATR              PIC X(1).
              10  WS-ATPC059-FECALTA                  PIC X(10).
              10  WS-ATPC059-CONTCUR-ATR              PIC X(1).
              10  WS-ATPC059-CONTCUR                  PIC X(26).
              10  WS-ATPC059-INDCONTINUAR             PIC X(1).

               
       01  WS-ATPC059-RETORNO.
           05  WS-ATPC059-RETORNO-COD        PIC 9(01).
               88  WS-ATPC059-RETORNO-OK     VALUE 0.
               88  WS-ATPC059-RETORNO-INFO   VALUE 1.
               88  WS-ATPC059-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC059-RETORNO-DESC       PIC X(1000).