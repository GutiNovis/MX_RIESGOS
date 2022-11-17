*&---------------------------------------------------------------------*
*&  Include           Z_EXTRACTOR_SEL
*&---------------------------------------------------------------------*
*-$-SELECTION SCREEN
*SELECTION-SCREEN BEGIN OF BLOCK cliente WITH FRAME TITLE title_1. " Cliente
*PARAMETERS: p_custo TYPE text12 OBLIGATORY.
*SELECTION-SCREEN END OF BLOCK cliente.

SELECTION-SCREEN BEGIN OF BLOCK use WITH FRAME TITLE title_2. " Use
PARAMETERS: p_use    AS CHECKBOX DEFAULT 'X',
            p_comp   TYPE swnchostname DEFAULT 'TOTAL' NO-DISPLAY,
            p_periot TYPE swncperitype DEFAULT 'M',
            p_perios TYPE swncdatum DEFAULT sy-datum,
            p_summar TYPE swnc_cflag DEFAULT '' NO-DISPLAY,
            p_file_u TYPE rlgrap-filename. " DEFAULT '/tmp/test01.txt'.
SELECTION-SCREEN END OF BLOCK use.

SELECTION-SCREEN BEGIN OF BLOCK rol WITH FRAME TITLE title_3. " Usuario y Rol
PARAMETERS: p_role   AS   CHECKBOX DEFAULT 'X',
            p_spra1  TYPE spras DEFAULT sy-langu NO-DISPLAY,
            p_filer1 TYPE rlgrap-filename, " AGR_USERS            OK
            p_filer2 TYPE rlgrap-filename, " AGR_DEFINE           OK
            p_filer3 TYPE rlgrap-filename, " AGR 1251             OK
            p_filer4 TYPE rlgrap-filename, " AGR_TEXTS            OK
            p_filer5 TYPE rlgrap-filename, " USER_ADDR, USR02
            p_filer6 TYPE rlgrap-filename, " AGR 1252             OK
            p_filer7 TYPE rlgrap-filename, " TSTCT                OK
            p_filer8 TYPE rlgrap-filename, " AGR_AGRS
            p_filer9 TYPE rlgrap-filename. " TOBJ
*            p_spras2 TYPE spras DEFAULT 'E' OBLIGATORY,
*              p_ushake TYPE flag DEFAULT '',
SELECTION-SCREEN END OF BLOCK rol.

SELECTION-SCREEN BEGIN OF BLOCK lic WITH FRAME TITLE title_4. " Licencia
PARAMETERS: p_licens TYPE flag DEFAULT '',
            p_file_l TYPE rlgrap-filename. " DEFAULT '/tmp/license.txt'.
SELECTION-SCREEN END OF BLOCK lic.

SELECTION-SCREEN BEGIN OF BLOCK gen WITH FRAME TITLE title_5. " General
PARAMETERS: p_gene   AS CHECKBOX DEFAULT '',
            p_spras  TYPE spras DEFAULT 'E' NO-DISPLAY,
            p_file_g TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK gen.

SELECTION-SCREEN BEGIN OF BLOCK uan WITH FRAME TITLE title_6. " Alias
PARAMETERS: p_ushake TYPE flag DEFAULT '',
            p_fileu1 TYPE rlgrap-filename. "  DEFAULT '/tmp/alias.txt'.
SELECTION-SCREEN END OF BLOCK uan.

*SELECTION-SCREEN ULINE /1(50).
SELECTION-SCREEN COMMENT /1(30) l_instr.
*SELECTION-SCREEN ULINE /1(50).
