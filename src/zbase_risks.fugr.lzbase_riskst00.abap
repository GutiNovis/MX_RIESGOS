*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBASE_RISKS.....................................*
DATA:  BEGIN OF STATUS_ZBASE_RISKS                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBASE_RISKS                   .
CONTROLS: TCTRL_ZBASE_RISKS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBASE_RISKS                   .
TABLES: ZBASE_RISKS                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
