*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBASE_RISKS_Z...................................*
DATA:  BEGIN OF STATUS_ZBASE_RISKS_Z                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBASE_RISKS_Z                 .
CONTROLS: TCTRL_ZBASE_RISKS_Z
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBASE_RISKS_Z                 .
TABLES: ZBASE_RISKS_Z                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
