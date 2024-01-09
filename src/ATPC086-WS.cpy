      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla FECHAS DE LIQUIDACIONES (estructura MPM0086)
      *
      * Datos de entrada:
      *  - WS-ATPC086-CLAVE.
      *     - WS-ATPC086-CODENT   PIC 9(04).
      *
      *
      * Datos de salida:
      *  - WS-ATPC086-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0086 son 58 ocurrencias
      *   es decir que en una lectura puede devolver hasta 58 items
      *   [10 DETALLE OCCURS 58.]
      *   78  WS-ATPC086-MP086-OCCURS          VALUE 58.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC086
       01  WS-MPM0086.
           COPY "MPM0086".

      * Nombre del programa que devuelve las Fechas
       77  CT-ATPC086                  PIC X(07) VALUE "ATPC086".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0086 (linea 21 -> 10 DETALLE OCCURS 58.)
       78  WS-ATPC086-MP086-OCCURS            VALUE 58.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM086 
       77  WS-ATPC086-MP086-CONTADOR          PIC 9(02).
      * Contador relacionado al arreglo ATPC086 para busqueda en memoria
       77  WS-ATPC086-CONTADOR                PIC 9(03).

      * Variable boolean para control de carga del arreglo WS-ATPC086-TAB  
       01  FILLER                          PIC 9(01).
           88 WS-ATPC086-FIN               VALUE 1 WHEN FALSE 0.

      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC086-TAB
       77  WS-ATPC086-TAB-OCCURS              PIC 9(04).
       
      * Arreglo o Tabla en memoria con datos de Fechas
       01  WS-ATPC086-TABLA.
           05  WS-ATPC086-TAB OCCURS 1 TO 100
                             DEPENDING ON WS-ATPC086-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC086-TAB-CLAVE
                             INDEXED BY WS-ATPC086-TAB-INDICE.
               10  WS-ATPC086-TAB-CLAVE.
                   15  WS-ATPC086-TAB-CODENT           PIC X(04).
      *             15 WS-ATPC086-TAB-CODENT-ALF REDEFINES
      *                WS-ATPC086-TAB-CODENT            PIC 9(04).
                   15  WS-ATPC086-TAB-CODPROCESO       PIC 9(02).
      *             15  WS-ATPC086-TAB-CODPROCESO-ALF REDEFINES 
      *                 WS-ATPC086-TAB-CODPROCESO       PIC X(02).
                   15  WS-ATPC086-TAB-CODGRUPO         PIC 9(02).
      *             15  WS-ATPC086-TAB-CODGRUPO-ALF REDEFINES 
      *                 WS-ATPC086-TAB-CODGRUPO         PIC X(02).
      
               10  WS-ATPC086-TAB-CODENT-ATR       PIC X(01).
               10  WS-ATPC086-TAB-CODPROCESO-ATR   PIC X(01).
      *         10  WS-ATPC086-TAB-CODPROCESO       PIC 9(02).
      *         10  WS-ATPC086-TAB-CODPROCESO-ALF REDEFINES 
      *             WS-ATPC086-TAB-CODPROCESO       PIC X(02).
               10  WS-ATPC086-TAB-DESPROCESO-ATR   PIC X(01).
               10  WS-ATPC086-TAB-DESPROCESO       PIC X(30).
               10  WS-ATPC086-TAB-CODGRUPO-ATR     PIC X(01).
      *         10  WS-ATPC086-TAB-CODGRUPO         PIC 9(02).
      *         10  WS-ATPC086-TAB-CODGRUPO-ALF REDEFINES 
      *             WS-ATPC086-TAB-CODGRUPO         PIC X(02).
               10  WS-ATPC086-TAB-DESCRIPCION-ATR  PIC X(01).
               10  WS-ATPC086-TAB-DESCRIPCION      PIC X(30).
               10  WS-ATPC086-TAB-DESCRED-ATR      PIC X(01).
               10  WS-ATPC086-TAB-DESCRED          PIC X(10).
               10  WS-ATPC086-TAB-CONTCUR-ATR      PIC X(01).
               10  WS-ATPC086-TAB-CONTCUR          PIC X(26).
               10  WS-ATPC086-TAB-INDCONTINUAR     PIC X(01).


      * Registro para E/S de datos del proceso 
      * Representacion del registro del MP0086 
       01  WS-ATPC086.
           05  WS-ATPC086-CLAVE.
               10  WS-ATPC086-CODENT         PIC 9(04).
      *         10  WS-ATPC086-CODENT-ALF REDEFINES
      *             WS-ATPC086-CODENT        PIC X(04).
               10  WS-ATPC086-CODPROCESO        PIC 9(02).
      *         10  WS-ATPC086-CODPROCESO-ALF REDEFINES 
      *             WS-ATPC086-CODPROCESO        PIC X(02).
               10  WS-ATPC086-CODGRUPO       PIC 9(02).

           05  WS-ATPC086-RESPUESTA.
               10  WS-ATPC086-CODENT-ATR        PIC X(01).
               10  WS-ATPC086-CODPROCESO-ATR    PIC X(01).

               10  WS-ATPC086-DESPROCESO-ATR    PIC X(01).
               10  WS-ATPC086-DESPROCESO        PIC X(30).
               10  WS-ATPC086-CODGRUPO-ATR      PIC X(01).

      *         10  WS-ATPC086-CODGRUPO-ALF REDEFINES 
      *             WS-ATPC086-CODGRUPO          PIC X(02).
               10  WS-ATPC086-DESCRIPCION-ATR   PIC X(01).
               10  WS-ATPC086-DESCRIPCION       PIC X(30).
               10  WS-ATPC086-DESCRED-ATR       PIC X(01).
               10  WS-ATPC086-DESCRED           PIC X(10).
               10  WS-ATPC086-CONTCUR-ATR       PIC X(01).
               10  WS-ATPC086-CONTCUR           PIC X(26).
               10  WS-ATPC086-INDCONTINUAR      PIC X(01).
               
       01  WS-ATPC086-RETORNO.
           05  WS-ATPC086-RETORNO-COD        PIC 9(01).
               88  WS-ATPC086-RETORNO-OK     VALUE 0.
               88  WS-ATPC086-RETORNO-INFO   VALUE 1.
               88  WS-ATPC086-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC086-RETORNO-DESC       PIC X(1000).