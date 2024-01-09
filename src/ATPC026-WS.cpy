      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla TIPO DE TARJETA (estructura MPM0026)
      *
      * Datos de entrada:
      *  - WS-ATPC026-CLAVE.
      *     - WS-ATPC026-CODENT   PIC 9(04).
      *     - WS-ATPC026-CODMAR   PIC 9(02).
      *     - WS-ATPC026-INDTIPT  PIC 9(02).
      * Datos de salida:
      *  - WS-ATPC026-RESPUESTA.
      *
      * Nota: 
      *   Segun la definicion en el archivo MPM0026 son 56 ocurrencias 
      *   es decir que en una lectura puede devolver hasta 56 items
      *   [10 MP026-DETALLE  OCCURS 56.]
      *   78  WS-ATPC026-MP026-OCCURS          VALUE 56.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC026
       01  WS-MPM0026.
           COPY "MPM0026".

      * Nombre del programa que devuelve los Tipo de Tarjeras
       77  CT-ATPC026                  PIC X(07) VALUE "ATPC026".
       
      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0026 (linea 22 -> 10 MP026-DETALLE  OCCURS 56.)
       78  WS-ATPC026-MP026-OCCURS               VALUE 56.
       
      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM026 
       77  WS-ATPC026-MP026-CONTADOR          PIC 9(02).
      * Contador relacionado al arreglo ATPC026 para busqueda en memoria
       77  WS-ATPC026-CONTADOR                PIC 9(03).       
      
      * Variable boolean para control de carga del arreglo WS-ATPC026-TAB  
       01  FILLER                             PIC 9(01).
           88 WS-ATPC026-FIN                  VALUE 1 WHEN FALSE 0.
           
      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC026-TAB
       77  WS-ATPC026-TAB-OCCURS       PIC 9(03).
       
      * Arreglo o Tabla en memoria con datos de Tipos de Tarjetas
       01  WS-ATPC026-TABLA.
           05 WS-ATPC026-TAB OCCURS 1 TO 100
                             DEPENDING ON WS-ATPC026-TAB-OCCURS
                             ASCENDING KEY IS WS-ATPC026-TAB-CLAVE
                             INDEXED BY WS-ATPC026-TAB-INDICE.
              10  WS-ATPC026-TAB-CLAVE.
                  15  WS-ATPC026-TAB-CODENT     PIC 9(04).
      *            15  WS-ATPC026-TAB-CODENT-ALF REDEFINES
      *                WS-ATPC026-TAB-CODENT     PIC X(04).
                  15  WS-ATPC026-TAB-CODMAR     PIC 9(02).
                  15  WS-ATPC026-TAB-INDTIPT    PIC 9(02).
      *            15  WS-ATPC026-TAB-INDTIPT-ALF REDEFINES
      *                WS-ATPC026-TAB-INDTIPT         PIC X(02).

              10  WS-ATPC026-TAB-CODENT-ATR      PIC X(01).
              10  WS-ATPC026-TAB-CODMAR-ATR      PIC X(01).
              10  WS-ATPC026-TAB-DESMAR-ATR      PIC X(01).
              10  WS-ATPC026-TAB-DESMAR          PIC X(30).         
              10  WS-ATPC026-TAB-INDTIPT-ATR     PIC X(01).         
              10  WS-ATPC026-TAB-CLASE-ATR       PIC X(01).         
              10  WS-ATPC026-TAB-CLASE           PIC X(04).         
              10  WS-ATPC026-TAB-DESTIPT-ATR     PIC X(01).         
              10  WS-ATPC026-TAB-DESTIPT         PIC X(30).         
              10  WS-ATPC026-TAB-DESTIPTRED-ATR  PIC X(01).         
              10  WS-ATPC026-TAB-DESTIPTRED      PIC X(10).         
              10  WS-ATPC026-TAB-CONTCUR-ATR     PIC X(01).         
              10  WS-ATPC026-TAB-CONTCUR         PIC X(26).         
              10  WS-ATPC026-TAB-INDCONTINUAR    PIC X(01).
 
       
      * Registro para E/S de datos del proceso
      * Representacion del registro del MP0026 
       01  WS-ATPC026.
           05  WS-ATPC026-CLAVE.
               10  WS-ATPC026-CODENT          PIC 9(04).
      *         10  WS-ATPC026-CODENT-ALF      REDEFINES
      *             WS-ATPC026-CODENT          PIC X(04).
               10  WS-ATPC026-CODMAR          PIC 9(02).
               10  WS-ATPC026-INDTIPT         PIC 9(02).
      *         10  WS-ATPC026-INDTIPT-ALF REDEFINES
      *             WS-ATPC026-INDTIPT         PIC X(02).         

           05  WS-ATPC026-RESPUESTA.
               10  WS-ATPC026-CODENT-ATR      PIC X(01).
               10  WS-ATPC026-CODMAR-ATR      PIC X(01).
               10  WS-ATPC026-DESMAR-ATR      PIC X(01).
               10  WS-ATPC026-DESMAR          PIC X(30).         
               10  WS-ATPC026-INDTIPT-ATR     PIC X(01).         
               10  WS-ATPC026-CLASE-ATR       PIC X(01).         
               10  WS-ATPC026-CLASE           PIC X(04).         
               10  WS-ATPC026-DESTIPT-ATR     PIC X(01).         
               10  WS-ATPC026-DESTIPT         PIC X(30).         
               10  WS-ATPC026-DESTIPTRED-ATR  PIC X(01).         
               10  WS-ATPC026-DESTIPTRED      PIC X(10).         
               10  WS-ATPC026-CONTCUR-ATR     PIC X(01).         
               10  WS-ATPC026-CONTCUR         PIC X(26).         
               10  WS-ATPC026-INDCONTINUAR    PIC X(01).
               
       01  WS-ATPC026-RETORNO.
           05  WS-ATPC026-RETORNO-COD        PIC 9(01).
               88  WS-ATPC026-RETORNO-OK     VALUE 0.
               88  WS-ATPC026-RETORNO-INFO   VALUE 1.
               88  WS-ATPC026-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC026-RETORNO-DESC       PIC X(1000).