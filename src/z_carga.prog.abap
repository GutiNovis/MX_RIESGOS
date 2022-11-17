*&---------------------------------------------------------------------*
*& Report ZBC_AUDITOR_RUTA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_carga.
TABLES: sscrfields.
DATA: lv_raiz   TYPE rlgrap-filename,
      lv_ruta1  TYPE rlgrap-filename,
      lv_ruta2  TYPE rlgrap-filename,
      lv_ruta3  TYPE rlgrap-filename,
      lv_ruta4  TYPE rlgrap-filename,
      lv_ruta5  TYPE rlgrap-filename,
      lv_ruta6  TYPE rlgrap-filename,
      lv_ruta7  TYPE rlgrap-filename,
      lv_ruta8  TYPE rlgrap-filename,
      lv_ruta9  TYPE rlgrap-filename,
      lv_ruta10 TYPE rlgrap-filename,
      lv_ruta11 TYPE rlgrap-filename,
      lv_ruta12 TYPE rlgrap-filename.

SELECTION-SCREEN BEGIN OF BLOCK blk6  WITH FRAME TITLE title. "
PARAMETERS: p_file TYPE string.

SELECTION-SCREEN END OF BLOCK blk6.
SELECTION-SCREEN:
PUSHBUTTON 1(30) but1 USER-COMMAND b01  VISIBLE LENGTH 30, "'Botón carga'.
PUSHBUTTON 35(30) but2 USER-COMMAND b02  VISIBLE LENGTH 30. "'Botón ir a analisis'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      initial_folder  = 'C:'
    CHANGING
      selected_folder = p_file.


INITIALIZATION.
  title  = 'Ruta de archivos para analizar'.

  but1 = 'Cargar archivos'.
  but2 = 'Ir a analisis'.


AT SELECTION-SCREEN.

  IF p_file IS NOT INITIAL.
    CASE sscrfields.
      WHEN 'B01'.
        PERFORM cargar_datos.
      WHEN 'B02'.
        SUBMIT z_reporte VIA SELECTION-SCREEN AND RETURN.
    ENDCASE.
  ENDIF.


FORM cargar_datos.
  lv_raiz = p_file.

  CONCATENATE lv_raiz '\_USE_TOTAL_M.csv'    INTO lv_ruta1. " OK p_file_u
  CONCATENATE lv_raiz '\_ROL_AGR_USER.csv'   INTO lv_ruta2. " OK p_filer1
  CONCATENATE lv_raiz '\_ROL_AGR_DEFINE.csv' INTO lv_ruta3. " OK p_filer2
  CONCATENATE lv_raiz '\_ROL_AGR_1251.csv'   INTO lv_ruta4. " OK p_filer3
  CONCATENATE lv_raiz '\_ROL_AGR_TEXTS.csv'  INTO lv_ruta5. " OK p_filer4
  CONCATENATE lv_raiz '\_USE_GEN_DA.csv'     INTO lv_ruta6. " OK p_filer5
  CONCATENATE lv_raiz '\_ROL_AGR_1252.csv'   INTO lv_ruta7. " OK p_filer6
  CONCATENATE lv_raiz '\_S_TCODE.csv'        INTO lv_ruta8. " OK p_filer7
  CONCATENATE lv_raiz '\_ROL_AGR_AGRS.csv'   INTO lv_ruta9. " OK p_filer8
  CONCATENATE lv_raiz '\_TOBJ.csv'           INTO lv_ruta10. " OK p_filer9
  CONCATENATE lv_raiz '\_GEN_TRXS.csv'       INTO lv_ruta11. " OK p_file_g
  CONCATENATE lv_raiz '\_ALIAS.csv'          INTO lv_ruta12. " OK p_fileu1

*    PERFORM leer_alias USING lv_ruta1.

  CALL FUNCTION 'Z_CARGA_CSV_V2'
    EXPORTING
*     in_ruta_usetotal   = lv_ruta1  " No se esta cargando esta tabla
      in_ruta_agr_user   = lv_ruta2  " OK
      in_ruta_agr_define = lv_ruta3  " OK
      in_ruta_agr_1251   = lv_ruta4  " OK
      in_ruta_agr_texts  = lv_ruta5  " OK
      in_ruta_usegenda   = lv_ruta6  " OK
      in_ruta_agr_1252   = lv_ruta7  " OK
      in_ruta_s_tcode    = lv_ruta8  " OK
      in_ruta_agr_agrs   = lv_ruta9  " OK
      in_ruta_tobj       = lv_ruta10 " OK
      in_ruta_gentrxs    = lv_ruta11 " No se esta cargando esta tabla
      in_ruta_alias      = lv_ruta12. " No se esta cargando esta tabla

ENDFORM.
