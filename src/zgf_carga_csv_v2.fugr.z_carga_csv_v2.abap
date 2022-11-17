FUNCTION z_carga_csv_v2.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(IN_RUTA_USETOTAL) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_USER) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_DEFINE) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_1251) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_TEXTS) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_USEGENDA) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_1252) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_S_TCODE) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_AGRS) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_TOBJ) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_GENTRXS) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_ALIAS) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_ROLAGRPR) TYPE  RLGRAP-FILENAME OPTIONAL
*"----------------------------------------------------------------------

*write: / 'ok'.

  DATA: file_str TYPE string,
        w_string TYPE string.
  DATA: BEGIN OF itab2 OCCURS 0,
          value(1000) TYPE c,
        END OF itab2.
  DATA : p_flnme LIKE rlgrap-filename. "File Name

* ===================================== CONSULTA 1: IN_RUTA_USETOTAL =====================================
  " Sin implementar

* ===================================== CONSULTA 2: IN_RUTA_AGR_USER =====================================
  p_flnme = in_ruta_agr_user.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO w_string.
    WRITE: / w_string.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_users.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_agr_users-mandt
                                  wa_agr_users-agr_name
                                  wa_agr_users-uname
                                  wa_agr_users-from_dat
                                  wa_agr_users-to_dat
                                  wa_agr_users-exclude
                                  wa_agr_users-change_dat
                                  wa_agr_users-change_tim
                                  wa_agr_users-org_flag
                                  wa_agr_users-col_flag.
    APPEND wa_agr_users TO ti_agr_users.
    CLEAR wa_agr_users.
  ENDLOOP.
  IF ti_agr_users[] IS NOT INITIAL.
    MODIFY zagr_users FROM TABLE ti_agr_users.
    COMMIT WORK.
    WRITE: / 'Tabla ZAGR_USERS cargada correctamente'.
  ELSE.
    WRITE: / 'No se han cargado datos nuevos a tabla ZAGR_USERS'.
  ENDIF.

* ===================================== CONSULTA 3: IN_RUTA_AGR_DEFINE =====================================
  CLEAR itab2.
  p_flnme = in_ruta_agr_define.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO w_string.
    WRITE: / w_string.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_define.
  ENDIF.
  LOOP AT itab2.

    SPLIT itab2-value AT ';' INTO wa_agr_define-mandt
                                  wa_agr_define-agr_name
                                  wa_agr_define-parent_agr
                                  wa_agr_define-create_usr
                                  wa_agr_define-create_dat
                                  wa_agr_define-create_tim
                                  wa_agr_define-create_tmp
                                  wa_agr_define-change_usr
                                  wa_agr_define-change_dat
                                  wa_agr_define-change_tim
                                  wa_agr_define-change_tmp
                                  wa_agr_define-attributes.
    APPEND wa_agr_define TO ti_agr_define.
    CLEAR wa_agr_define.
  ENDLOOP.
  IF ti_agr_define[] IS NOT INITIAL.
    MODIFY zagr_define FROM TABLE ti_agr_define.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 4: IN_RUTA_AGR_1251 =====================================
  CLEAR itab2.
  p_flnme = in_ruta_agr_1251.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO w_string.
    WRITE: / w_string.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_1251.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_agr_1251-mandt
                                  wa_agr_1251-agr_name
                                  wa_agr_1251-counter
                                  wa_agr_1251-object
                                  wa_agr_1251-auth
                                  wa_agr_1251-variant
                                  wa_agr_1251-field
                                  wa_agr_1251-low
                                  wa_agr_1251-high
                                  wa_agr_1251-modified
                                  wa_agr_1251-deleted
                                  wa_agr_1251-copied
                                  wa_agr_1251-neu
                                  wa_agr_1251-node.

    APPEND wa_agr_1251 TO ti_agr_1251.
    CLEAR wa_agr_1251.
  ENDLOOP.
  IF ti_agr_1251[] IS NOT INITIAL.
    MODIFY zagr_1251 FROM TABLE ti_agr_1251.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 5: IN_RUTA_AGR_TEXTS =====================================
  CLEAR itab2.
  p_flnme = in_ruta_agr_texts.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_texts.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_agr_texts-mandt
                                  wa_agr_texts-agr_name
                                  wa_agr_texts-spras
                                  wa_agr_texts-line
                                  wa_agr_texts-text.

    APPEND wa_agr_texts TO ti_agr_texts.
    CLEAR wa_agr_texts.
  ENDLOOP.
  IF ti_agr_texts[] IS NOT INITIAL.
    MODIFY zagr_texts FROM TABLE ti_agr_texts.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 6: IN_RUTA_USEGENDA =====================================
  CLEAR itab2.
  p_flnme = in_ruta_usegenda.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_texts.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_use_gen_da-mandt
                                  wa_use_gen_da-bname
                                  wa_use_gen_da-persnum
                                  wa_use_gen_da-name_last
                                  wa_use_gen_da-name_text
                                  wa_use_gen_da-mc_name_first
                                  wa_use_gen_da-mc_name_last
                                  wa_use_gen_da-gltgv
                                  wa_use_gen_da-gltgb
                                  wa_use_gen_da-ustyp
                                  wa_use_gen_da-class
                                  wa_use_gen_da-trdat
                                  wa_use_gen_da-ltime
                                  wa_use_gen_da-uflag
                                  wa_use_gen_da-name_textc.
    APPEND wa_use_gen_da TO ti_use_gen_da.
    CLEAR wa_use_gen_da.
  ENDLOOP.
  IF ti_use_gen_da[] IS NOT INITIAL.
    MODIFY zuse_gen_da FROM TABLE ti_use_gen_da.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 7: IN_RUTA_AGR_1252 =====================================
  CLEAR itab2.
  p_flnme = in_ruta_agr_1252.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_1252.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_agr_1252-mandt
                                  wa_agr_1252-agr_name
                                  wa_agr_1252-counter
                                  wa_agr_1252-varbl
                                  wa_agr_1252-low
                                  wa_agr_1252-high.

    APPEND wa_agr_1252 TO ti_agr_1252.
    CLEAR wa_agr_1252.
  ENDLOOP.
  IF ti_agr_1252[] IS NOT INITIAL.
    MODIFY zagr_1252 FROM TABLE ti_agr_1252.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 8: IN_RUTA_S_TCODE =====================================
  CLEAR itab2.
  p_flnme = in_ruta_s_tcode.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM ztstct.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_tstct-sprsl
                                  wa_tstct-tcode
                                  wa_tstct-ttext.

    APPEND wa_tstct TO ti_tstct.
    CLEAR wa_tstct.
  ENDLOOP.
  IF ti_tstct[] IS NOT INITIAL.
    MODIFY ztstct FROM TABLE ti_tstct.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 9: IN_RUTA_AGR_AGRS =====================================
  CLEAR itab2.
  p_flnme = in_ruta_agr_agrs.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM zagr_agrs.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_agr_agrs-mandt
                                  wa_agr_agrs-agr_name
                                  wa_agr_agrs-child_agr
                                  wa_agr_agrs-attributes.

    APPEND wa_agr_agrs TO ti_agr_agrs.
    CLEAR wa_agr_agrs.
  ENDLOOP.
  IF ti_agr_agrs[] IS NOT INITIAL.
    MODIFY zagr_agrs FROM TABLE ti_agr_agrs.
    COMMIT WORK.
  ENDIF.

* ===================================== CONSULTA 10: IN_RUTA_TOBJ =====================================
  CLEAR itab2.
  p_flnme = in_ruta_tobj.
  file_str = p_flnme.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = file_str
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = itab2
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF itab2[] IS NOT INITIAL.
    DELETE FROM ztobj.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO wa_tobj-mandt
                                  wa_tobj-objct
                                  wa_tobj-fiel1
                                  wa_tobj-fiel2
                                  wa_tobj-fiel3
                                  wa_tobj-fiel4
                                  wa_tobj-fiel5
                                  wa_tobj-fiel6
                                  wa_tobj-fiel7
                                  wa_tobj-fiel8
                                  wa_tobj-fiel9
                                  wa_tobj-fiel0
                                  wa_tobj-oclss
                                  wa_tobj-bname
                                  wa_tobj-fblock
                                  wa_tobj-conversion.

    APPEND wa_tobj TO ti_tobj.
    CLEAR wa_tobj.
  ENDLOOP.
  IF ti_tobj[] IS NOT INITIAL.
    MODIFY ztobj FROM TABLE ti_tobj.
    COMMIT WORK.
  ENDIF.

*  CONSULTA 1: ALIAS
****  p_flnme = in_ruta_alias.
****  file_str = p_flnme.
****  DELETE FROM ztb_itab.
****UPLOADING FILE INTO INTERNAL TABLE
****  CALL FUNCTION 'GUI_UPLOAD'
****    EXPORTING
****      filename                = file_str
****      filetype                = 'ASC'
****      has_field_separator     = 'X'
****    TABLES
****      data_tab                = itab2
****    EXCEPTIONS
****      file_open_error         = 1
****      file_read_error         = 2
****      no_batch                = 3
****      gui_refuse_filetransfer = 4
****      invalid_type            = 5
****      no_authority            = 6
****      unknown_error           = 7
****      bad_data_format         = 8
****      header_not_allowed      = 9
****      separator_not_allowed   = 10
****      header_too_long         = 11
****      unknown_dp_error        = 12
****      access_denied           = 13
****      dp_out_of_memory        = 14
****      disk_full               = 15
****      dp_timeout              = 16
****      OTHERS                  = 17.
****
****  IF sy-subrc <> 0.
****    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
****    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
****  ENDIF.
****  LOOP AT itab2.
****    SPLIT itab2-value AT ';' INTO out_alias-bname out_alias-aliasu.
****    APPEND out_alias.
****    MODIFY ztb_itab FROM out_alias.
****    COMMIT WORK.
****    CLEAR out_alias.
****  ENDLOOP.
* CONSULTA 2: DE TRANSACCIONES
****  CLEAR itab2.
****  p_flnme = in_ruta_gentrxs.
****  file_str = p_flnme.
****  DELETE FROM ztb_trxs.
****UPLOADING FILE INTO INTERNAL TABLE
****  CALL FUNCTION 'GUI_UPLOAD'
****    EXPORTING
****      filename                = file_str
****      filetype                = 'ASC'
****      has_field_separator     = 'X'
****    TABLES
****      data_tab                = itab2
****    EXCEPTIONS
****      file_open_error         = 1
****      file_read_error         = 2
****      no_batch                = 3
****      gui_refuse_filetransfer = 4
****      invalid_type            = 5
****      no_authority            = 6
****      unknown_error           = 7
****      bad_data_format         = 8
****      header_not_allowed      = 9
****      separator_not_allowed   = 10
****      header_too_long         = 11
****      unknown_dp_error        = 12
****      access_denied           = 13
****      dp_out_of_memory        = 14
****      disk_full               = 15
****      dp_timeout              = 16
****      OTHERS                  = 17.
****
****  IF sy-subrc <> 0.
****    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
****    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
****  ENDIF.
****  LOOP AT itab2.
****    SPLIT itab2-value AT ';' INTO out_trx-tcode out_trx-progname out_trx-description.
****    APPEND out_trx.
****    MODIFY ztb_trxs FROM out_trx.
****    COMMIT WORK.
****    CLEAR out_trx.
****  ENDLOOP.

*QUINTA CONSULTA: ROL_AGR_PR
****  CLEAR itab2.
****  p_flnme = in_ruta_rolagrpr.
****  file_str = p_flnme.
****  DELETE FROM ztb_rol_agr_pr.
*****UPLOADING FILE INTO INTERNAL TABLE
****  CALL FUNCTION 'GUI_UPLOAD'
****    EXPORTING
****      filename                = file_str
****      filetype                = 'ASC'
****      has_field_separator     = 'X'
****    TABLES
****      data_tab                = itab2
****    EXCEPTIONS
****      file_open_error         = 1
****      file_read_error         = 2
****      no_batch                = 3
****      gui_refuse_filetransfer = 4
****      invalid_type            = 5
****      no_authority            = 6
****      unknown_error           = 7
****      bad_data_format         = 8
****      header_not_allowed      = 9
****      separator_not_allowed   = 10
****      header_too_long         = 11
****      unknown_dp_error        = 12
****      access_denied           = 13
****      dp_out_of_memory        = 14
****      disk_full               = 15
****      dp_timeout              = 16
****      OTHERS                  = 17.
****
****  IF sy-subrc <> 0.
****    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
****    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
****  ENDIF.
****  LOOP AT itab2.
****    SPLIT itab2-value AT ';' INTO out_rol_agr_pr-mandt out_rol_agr_pr-agr_name out_rol_agr_pr-langu out_rol_agr_pr-profile out_rol_agr_pr-ptext.
****    APPEND out_rol_agr_pr.
****    MODIFY ztb_rol_agr_pr FROM out_rol_agr_pr.
****    COMMIT WORK.
****    CLEAR out_rol_agr_pr.
****  ENDLOOP.





*OCTAVA CONSULTA: USE_TOTAL
***  CLEAR itab2.
***  p_flnme = in_ruta_usetotal.
***  file_str = p_flnme.
****  DELETE FROM ztb_use_total.
****UPLOADING FILE INTO INTERNAL TABLE
***  CALL FUNCTION 'GUI_UPLOAD'
***    EXPORTING
***      filename                = file_str
***      filetype                = 'ASC'
***      has_field_separator     = 'X'
***    TABLES
***      data_tab                = itab2
***    EXCEPTIONS
***      file_open_error         = 1
***      file_read_error         = 2
***      no_batch                = 3
***      gui_refuse_filetransfer = 4
***      invalid_type            = 5
***      no_authority            = 6
***      unknown_error           = 7
***      bad_data_format         = 8
***      header_not_allowed      = 9
***      separator_not_allowed   = 10
***      header_too_long         = 11
***      unknown_dp_error        = 12
***      access_denied           = 13
***      dp_out_of_memory        = 14
***      disk_full               = 15
***      dp_timeout              = 16
***      OTHERS                  = 17.
***
***  IF sy-subrc <> 0.
***    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
***    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
***  ENDIF.
***  LOOP AT itab2.
***    SPLIT itab2-value AT ';' INTO out_use_total-tasktype
***                                  out_use_total-account
***                                  out_use_total-tasktdesc
***                                  out_use_total-entry_id
***                                  out_use_total-contador
***                                  out_use_total-l_entry_id1
***                                  out_use_total-l_entry_id2.
***    APPEND out_use_total.
****    MODIFY ztb_use_total FROM out_use_total.
****    COMMIT WORK.
***    CLEAR out_use_total.
***  ENDLOOP.

*CALL FUNCTION ‘TH_POPUP’
*  EXPORTING
*  client = sy-mandt
*  user = sy-uname
*  message = 'Carga de datos OK'
**   MESSAGE_LEN = 0
**   CUT_BLANKS = ‘ ‘
*  EXCEPTIONS
*  USER_NOT_FOUND = 1
*  OTHERS = 2.
ENDFUNCTION.
