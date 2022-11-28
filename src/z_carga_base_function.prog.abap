*&---------------------------------------------------------------------*
*& Report Z_CARGA_BASE_FUNCTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_carga_base_function MESSAGE-ID zi LINE-SIZE 550 NO STANDARD PAGE HEADING.
*TABLES: zestruc.
*data: begin of it_paso occurs 0,
*      line(800),
*      end of it_paso.
TYPES: BEGIN OF ty_struc,
         process_grc_ac01 TYPE zed_funcion_grc,
         tcode            TYPE tcode,
         estado           TYPE zed_status,
       END OF ty_struc.
DATA: it_estruc TYPE TABLE OF zbase_function,
      wa_estruc TYPE zbase_function.


*DATA: BEGIN OF it_estruc OCCURS 0.
*    INCLUDE STRUCTURE zestruc.
*DATA: END OF it_estruc.
DATA: BEGIN OF it_excel_data OCCURS 0.
    INCLUDE STRUCTURE  zalsmex_tabline.
DATA: END OF it_excel_data.
DATA: acum    TYPE p,
      acumins TYPE p.
DATA: renglon LIKE it_excel_data-row VALUE '0000'.
PARAMETERS: origen LIKE rlgrap-filename OBLIGATORY.
************************************************************************
INITIALIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR origen.
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    EXPORTING
      field_name    = origen
    CHANGING
      file_name     = origen
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.
************************************************************************
START-OF-SELECTION.
  PERFORM inicia_proceso.
*  MESSAGE i398(00) WITH ' Registros Procesados ' acum.
**                        ' Registros Actualizados ' acumins.
*&---------------------------------------------------------------------*
*&      Form  INICIA_PROCESO
*&---------------------------------------------------------------------*
FORM inicia_proceso.
  REFRESH it_excel_data.
  CALL FUNCTION 'ZALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = origen
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 40     " 100
      i_end_row               = 999999
    TABLES
      intern                  = it_excel_data
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  PERFORM procesa.
ENDFORM.                    " INICIA_PROCESO
*&---------------------------------------------------------------------*
*&      Form  PROCESA
*&---------------------------------------------------------------------*
*
FORM procesa.
  CLEAR: renglon, it_estruc, wa_estruc.
  LOOP AT it_excel_data.
    IF sy-tabix NE 1 AND sy-tabix NE 2 AND sy-tabix NE 3.
      IF renglon <> it_excel_data-row.
        IF renglon = '0000'.
          renglon = it_excel_data-row.
        ELSE.
          APPEND wa_estruc TO it_estruc.
          acum = acum + 1.
          CLEAR wa_estruc.
          renglon = it_excel_data-row.
        ENDIF.
      ENDIF.
      CASE it_excel_data-col.
        WHEN '01'.
          wa_estruc-process_grc_ac01 = it_excel_data-value.
        WHEN '02'.
          wa_estruc-tcode = it_excel_data-value.
        WHEN '03'.
          wa_estruc-estado = it_excel_data-value.
      ENDCASE.
    ENDIF.
  ENDLOOP.
***   Graba ultimo registtro
  APPEND wa_estruc TO it_estruc.
  acum = acum + 1.
***
*  LOOP AT it_estruc into wa_.
*    zestruc-process_grc_ac01  = it_estruc-sec1.
*    zestruc-tcode  = it_estruc-sec2.
*    zestruc-estado  = it_estruc-sec3.
*
*  ENDLOOP.
  IF it_estruc[] IS NOT INITIAL.
    DELETE FROM zbase_function.
    MODIFY zbase_function FROM TABLE it_estruc.
    COMMIT WORK.
    MESSAGE i398(00) WITH 'Registros Procesados ' acum
                          'Tabla ZBASE_FUNCTION cargada correctamente'.
*                        ' Registros Actualizados ' acumins.
*    WRITE: / 'Tabla ZBASE_FUNCTION cargada correctamente'.
  ELSE.
    MESSAGE i398(00) WITH 'No se han cargado datos nuevos a tabla:'
                          'ZBASE_FUNCTION'.
*                        ' Registros Actualizados ' acumins.
*    WRITE: / 'No se han cargado datos nuevos a tabla ZBASE_FUNCTION'.
  ENDIF.
ENDFORM.                    " PROCESA
