      *----------------------------------------------------------------
      * Libreria para el manejo en memoria de los datos relacionados a
      * la tabla FECHAS DE FACTURACION (estructura MPM0085)
      *
      * Datos de entrada:
      *
      * Datos de salida:
      *
      * Nota: 
      *   Segun la definicion del archivo de interfaz MPM0085, el campo 
      *   de "detalle" tiene 115 ocurrencias 
      *   [10 MP085-DETALLE OCCURS 115.], 
      *   es decir que puede devolver hasta 115 items por lectura 
      *   78  WS-ATPC085-MP085-OCCURS          VALUE 115.
      *----------------------------------------------------------------

      * Interfaz para uso del servicio ATPC085
       01  WS-MPM0085.
           COPY "MPM0085".

      * Nombre del programa que devuelve las Fechas
       77  CT-ATPC085               PIC X(07) VALUE "ATPC085".

      * Cantidad de elementos devuelto por el cursor de la base de datos
      * y manejado por la interfaz MPM0085 (linea 53 -> 10 MP085-DETALLE OCCURS 115.)
       78  WS-ATPC085-MP085-OCCURS            VALUE 115.

      * - Contadores auxiliares -
      * Contador relacionado al arreglo pertinente a la intefaz MPM085
       77  WS-ATPC085-MP085-CONTADOR          PIC 9(03).
      * Contador relacionado al arreglo ATPC085 para busqueda en memoria
       77  WS-ATPC085-CONTADOR                PIC 9(04).

      * Contador relacionado al codigo de grupo como soporte para la carga del arreglo
       77  WS-ATPC085-CONTADOR-COD-GRUPO      PIC 9(02).
       78  WS-ATPC085-TOTAL-COD-GRUPO         VALUE 7.
      * Variable de soporte para calculo de fecha para soporte para la carga del arreglo
       01  WS-ATPC085-AUX-FECHA-ACT.
           05 WS-ATPC085-AUX-FECHA-ACT-AAAA   PIC 9(04).
           05 WS-ATPC085-AUX-FECHA-ACT-MM     PIC 9(02).
           05 WS-ATPC085-AUX-FECHA-ACT-DD     PIC 9(02).
       01  WS-ATPC085-AUX-FECHA-ANT.
           05 WS-ATPC085-AUX-FECHA-ANT-AAAA   PIC 9(04).
           05 WS-ATPC085-AUX-FECHA-ANT-G1     PIC X(01) VALUE "-".
           05 WS-ATPC085-AUX-FECHA-ANT-MM     PIC 9(02).
           05 WS-ATPC085-AUX-FECHA-ANT-G2     PIC X(01) VALUE "-".
           05 WS-ATPC085-AUX-FECHA-ANT-DD     PIC 9(02).

       
      * Variable boolean para control de carga del arreglo WS-ATPC085-TAB  
       01  FILLER                            PIC 9(01).
           88 WS-ATPC085-FIN                 VALUE 1 WHEN FALSE 0.
           
      * Variable para identificacion de fecha a cargar
       01  FILLER                            PIC IS  9(01).
           88 WS-ATPC085-CARGAR-FECHA        VALUE 1 WHEN FALSE 0.
       
      * Manejo dinamico de la cantidad total de ocurrencias del arreglo WS-ATPC085-TAB
       77  WS-ATPC085-TAB-OCCURS              PIC 9(04).
       
      * Arreglo o Tabla en memoria con datos de Fechas
       01  WS-ATPC085-TABLA.
           05 WS-ATPC085-TAB OCCURS 1 TO 10 
                             DEPENDING ON WS-ATPC085-TAB-OCCURS
                             ASCENDING KEY WS-ATPC085-TAB-CLAVE
                             INDEXED BY WS-ATPC085-TAB-INDICE.
              10  WS-ATPC085-TAB-CLAVE.
                  15         WS-ATPC085-TAB-CODENT         PIC 9(04).
      *            15 WS-ATPC085-TAB-CODENT-ALF     REDEFINES
      *               WS-ATPC085-TAB-CODENT         PIC X(04).
                  15 WS-ATPC085-TAB-CODPROCESO     PIC 9(02).
      *            15 WS-ATPC085-TAB-CODPROCESO-ALF REDEFINES
      *               WS-ATPC085-TAB-CODPROCESO     PIC X(02).
                  15 WS-ATPC085-TAB-TIPFECHA       PIC 9(01).
      *            15 WS-ATPC085-TAB-TIPFECHA-ALF   REDEFINES
      *               WS-ATPC085-TAB-TIPFECHA       PIC X(01).
                  15 WS-ATPC085-TAB-CODGRUPO       PIC 9(02).
      *            15 WS-ATPC085-TAB-CODGRUPO-ALF   REDEFINES
      *               WS-ATPC085-TAB-CODGRUPO       PIC X(02).
      *        10  WS-ATPC085-TAB-DETALLE OCCURS 115.
              10 WS-ATPC085-TAB-FECHA-ATR      PIC X(01).
              10 WS-ATPC085-TAB-FECHA          PIC X(10).
              10 WS-ATPC085-TAB-INDPROC-ATR    PIC X(01).
              10 WS-ATPC085-TAB-INDPROC        PIC X(01).
              10 WS-ATPC085-TAB-FECHANT-ATR    PIC X(01).
              10 WS-ATPC085-TAB-FECHANT        PIC X(10).
              10 WS-ATPC085-TAB-CONTCUR-ATR    PIC X(01).
              10 WS-ATPC085-TAB-CONTCUR        PIC X(26).
              10 WS-ATPC085-TAB-INDCONTINUAR   PIC X(01).

       
      * Representacion del registro del MP0085 
       01  WS-ATPC085.
           05  WS-ATPC085-CLAVE.
               10 WS-ATPC085-CODENT           PIC X(04).
      *         10 WS-ATPC085-CODENT-ALF REDEFINES
      *            WS-ATPC085-CODENT           PIC X(04).
               10 WS-ATPC085-CODPROCESO       PIC 9(02).
               10 WS-ATPC085-TIPFECHA         PIC 9(01).
               10 WS-ATPC085-CODGRUPO         PIC 9(02).
               
           05 WS-ATPC085-RESPUESTA.
              10 WS-ATPC085-FECHA-ATR            PIC X(01).
              10 WS-ATPC085-FECHA                PIC X(10).
              10 WS-ATPC085-INDPROC-ATR          PIC X(01).
              10 WS-ATPC085-INDPROC              PIC X(1).
              10 WS-ATPC085-FECHANT-ATR          PIC X(1).
              10 WS-ATPC085-FECHANT              PIC X(10).
              10 WS-ATPC085-CONTCUR-ATR          PIC X(1).
              10 WS-ATPC085-CONTCUR              PIC X(26).
              10 WS-ATPC085-INDCONTINUAR         PIC X(01).
           
       01  WS-ATPC085-RETORNO.
           05  WS-ATPC085-RETORNO-COD        PIC 9(01).
               88  WS-ATPC085-RETORNO-OK     VALUE 0.
               88  WS-ATPC085-RETORNO-INFO   VALUE 1.
               88  WS-ATPC085-RETORNO-ERROR  VALUE 9.
           05  WS-ATPC085-RETORNO-DESC       PIC X(1000).