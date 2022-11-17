*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZRISKS_T........................................*
DATA:  BEGIN OF STATUS_ZRISKS_T                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZRISKS_T                      .
CONTROLS: TCTRL_ZRISKS_T
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZRISKS_T                      .
TABLES: ZRISKS_T                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
