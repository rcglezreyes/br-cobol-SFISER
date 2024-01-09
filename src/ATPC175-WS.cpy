      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla de DESCRIPC. ESTADO CUENTA O REPACTACION (estructura MPM0175)
      *
      * Datos de entrada:
      *  - WS-ATPC175-CLAVE.
      *     - WS-ATPC175-CODENT    PIC X(04).
      *     - WS-ATPC175-CODESTCTA PIC 9(02).
      *
      * Datos de salida:
      *  - WS-ATPC175-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0175 son 51 ocurrencias
      *   es decir que en una lectura puede devolver hasta 51 items
      *   [10  MP175-DETALLES   OCCURS 51.]
      *   78  WS-ATPC175-MP175-OCCURS          VALUE 51.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC175
       01  WS-MPM0175.
           COPY "MPM0175".

      * Nombre del programa que devuelve las Fechas
       77  CT-ATPC175                  PIC X(07) VALUE "ATPC175".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0175 (linea 49 -> 10  MP175-DETALLES   OCCURS 51.)
       78  WS-ATPC175-MP175-OCCURS            VALUE 51.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM175 
       77  WS-ATPC175-MP175-CONTADOR          PIC 9(02).
      * Contador relacionado al arreglo ATPC175 para busqueda en memoria
       77  WS-ATPC175-CONTADOR                PIC 9(03).

      * Variable boolean para control de carga del arreglo WS-ATPC175-TAB  
       01  FILLER                          PIC 9(01).
           88 WS-ATPC175-FIN               VALUE 1 WHEN FALSE 0.

      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC175-TAB
       77  WS-ATPC175-TAB-OCCURS              PIC 9(04).
       
      * Arreglo o Tabla en memoria con datos de Fechas
       01  WS-ATPC175-TABLA.
           05  WS-ATPC175-TAB OCCURS 1 TO 100
                             DEPENDING ON WS-ATPC175-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC175-TAB-CLAVE
                             INDEXED BY WS-ATPC175-TAB-INDICE.
               10  WS-ATPC175-TAB-CLAVE.
                   15  WS-ATPC175-TAB-CODENT           PIC X(04).
                   15  WS-ATPC175-TAB-CODESTCTA        PIC 9(02).

               10  WS-ATPC175-TAB-CODENT-ATR        PIC X(01).      
               10  WS-ATPC175-TAB-CODESTCTA-ATR     PIC X(01).

      *         10  WS-ATPC175-TAB-CODESTCTA         PIC 9(02).
      *         10  WS-ATPC175-TAB-CODESTCTA-ALF
      *                 REDEFINES MP175-CODESTCTA PIC X(02).
               10  WS-ATPC175-TAB-LINEA-ATR         PIC X(01).
               10  WS-ATPC175-TAB-LINEA             PIC X(04).
               10  WS-ATPC175-TAB-TIPESTCTA-ATR     PIC X(01).
               10  WS-ATPC175-TAB-TIPESTCTA         PIC X(01).
               10  WS-ATPC175-TAB-DESESTCTA-ATR     PIC X(01).
               10  WS-ATPC175-TAB-DESESTCTA         PIC X(30).
               10  WS-ATPC175-TAB-DESESTCTARED-ATR  PIC X(01).
               10  WS-ATPC175-TAB-DESESTCTARED      PIC X(10).
               10  WS-ATPC175-TAB-NUMDIASACT-ATR    PIC X(01).
               10  WS-ATPC175-TAB-NUMDIASACT        PIC 9(03).
      *         10  WS-ATPC175-TAB-NUMDIASACT-ALF
      *                 REDEFINES MP175-NUMDIASACT PIC X(03).
               10  WS-ATPC175-TAB-CLASIFCONT-ATR    PIC X(01).
               10  WS-ATPC175-TAB-CLASIFCONT        PIC X(01).
               10  WS-ATPC175-TAB-CODBLQ-ATR        PIC X(01).
               10  WS-ATPC175-TAB-CODBLQ            PIC 9(02).
      *         10  WS-ATPC175-TAB-CODBLQ-ALF
      *                 REDEFINES MP175-CODBLQ  PIC X(02).
               10  WS-ATPC175-TAB-DESBLQ-ATR        PIC X(01).
               10  WS-ATPC175-TAB-DESBLQ            PIC X(30).
               10  WS-ATPC175-TAB-INDACEDEU-ATR     PIC X(01).
               10  WS-ATPC175-TAB-INDACEDEU         PIC X(01).
               10  WS-ATPC175-TAB-CONTCUR-ATR       PIC X(01).
               10  WS-ATPC175-TAB-CONTCUR           PIC X(26).
               10  WS-ATPC175-TAB-INDCONTINUAR      PIC X(01).


      * Registro para E/S de datos del proceso 
      * Representacion del registro del MP0175 
       01  WS-ATPC175.
           05  WS-ATPC175-CLAVE.
               10  WS-ATPC175-CODENT            PIC X(04).
               10  WS-ATPC175-CODESTCTA         PIC 9(02).

           05  WS-ATPC175-RESPUESTA.
               10  WS-ATPC175-CODENT-ATR        PIC X(01).
               10  WS-ATPC175-CODESTCTA-ATR     PIC X(01).
      *         10  WS-ATPC175-CODESTCTA         PIC 9(02).
      *         10  WS-ATPC175-CODESTCTA-ALF
      *                 REDEFINES MP175-CODESTCTA PIC X(02).
               10  WS-ATPC175-LINEA-ATR         PIC X(01).
               10  WS-ATPC175-LINEA             PIC X(04).
               10  WS-ATPC175-TIPESTCTA-ATR     PIC X(01).
               10  WS-ATPC175-TIPESTCTA         PIC X(01).
               10  WS-ATPC175-DESESTCTA-ATR     PIC X(01).
               10  WS-ATPC175-DESESTCTA         PIC X(30).
               10  WS-ATPC175-DESESTCTARED-ATR  PIC X(01).
               10  WS-ATPC175-DESESTCTARED      PIC X(10).
               10  WS-ATPC175-NUMDIASACT-ATR    PIC X(01).
               10  WS-ATPC175-NUMDIASACT        PIC 9(03).
      *         10  WS-ATPC175-NUMDIASACT-ALF
      *                 REDEFINES MP175-NUMDIASACT PIC X(03).
               10  WS-ATPC175-CLASIFCONT-ATR    PIC X(01).
               10  WS-ATPC175-CLASIFCONT        PIC X(01).
               10  WS-ATPC175-CODBLQ-ATR        PIC X(01).
               10  WS-ATPC175-CODBLQ            PIC 9(02).
      *         10  WS-ATPC175-CODBLQ-ALF
      *                 REDEFINES MP175-CODBLQ  PIC X(02).
               10  WS-ATPC175-DESBLQ-ATR        PIC X(01).
               10  WS-ATPC175-DESBLQ            PIC X(30).
               10  WS-ATPC175-INDACEDEU-ATR     PIC X(01).
               10  WS-ATPC175-INDACEDEU         PIC X(01).
               10  WS-ATPC175-CONTCUR-ATR       PIC X(01).
               10  WS-ATPC175-CONTCUR           PIC X(26).
               10  WS-ATPC175-INDCONTINUAR      PIC X(01).

               
       01  WS-ATPC175-RETORNO.
           05  WS-ATPC175-RETORNO-COD        PIC 9(01).
               88  WS-ATPC175-RETORNO-OK     VALUE 0.
               88  WS-ATPC175-RETORNO-INFO   VALUE 1.
               88  WS-ATPC175-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC175-RETORNO-DESC       PIC X(1000).