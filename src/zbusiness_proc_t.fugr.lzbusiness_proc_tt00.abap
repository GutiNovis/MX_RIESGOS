*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBUSINESS_PROC_T................................*
DATA:  BEGIN OF STATUS_ZBUSINESS_PROC_T              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBUSINESS_PROC_T              .
CONTROLS: TCTRL_ZBUSINESS_PROC_T
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBUSINESS_PROC_T              .
TABLES: ZBUSINESS_PROC_T               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
