FUNCTION z_carga_csv.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(IN_RUTA_ALIAS) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_TRX) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_1251) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_1252) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_ROLAGRPR) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_ROLAGRDE) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_USEGENDA) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_USETOTAL) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_S_TCODE) TYPE  RLGRAP-FILENAME OPTIONAL
*"     REFERENCE(IN_RUTA_AGR_TEXTS) TYPE  RLGRAP-FILENAME OPTIONAL
*"  TABLES
*"      OUT_ALIAS STRUCTURE  ZBC_ALIAS OPTIONAL
*"      OUT_TRX STRUCTURE  ZBC_TRXS OPTIONAL
*"      OUT_1251 STRUCTURE  ZBC_1251 OPTIONAL
*"      OUT_1252 STRUCTURE  ZBC_1252 OPTIONAL
*"      OUT_ROL_AGR_PR STRUCTURE  ZBC_ROL_AGR_PR OPTIONAL
*"      OUT_ROL_AGR_DE STRUCTURE  ZBC_ROL_AGR_DE OPTIONAL
*"      OUT_USE_GEN_DA STRUCTURE  ZBC_ROL_AGR_DA OPTIONAL
*"      OUT_USE_TOTAL STRUCTURE  ZBC_USE_TOTAL OPTIONAL
*"      OUT_ROL_AGR_TEXT STRUCTURE  ZBC_ROL_AGR_PR OPTIONAL
*"----------------------------------------------------------------------

*write: / 'ok'.

  DATA : file_str TYPE string.
  DATA: BEGIN OF itab2 OCCURS 0,
          value(1000) TYPE c,
        END OF itab2.
  DATA : p_flnme LIKE rlgrap-filename. "File Name
  p_flnme = in_ruta_alias.
  file_str = p_flnme.
  DELETE FROM ztb_itab.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_alias-bname out_alias-aliasu.
    APPEND out_alias.
    MODIFY ztb_itab FROM out_alias.
    COMMIT WORK.
    CLEAR out_alias.
  ENDLOOP.
*SEGUNDA CONSULTA: DE TRANSACCIONES
  CLEAR itab2.
  p_flnme = in_ruta_trx.
  file_str = p_flnme.
  DELETE FROM ztb_trxs.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_trx-tcode out_trx-progname out_trx-description.
    APPEND out_trx.
    MODIFY ztb_trxs FROM out_trx.
    COMMIT WORK.
    CLEAR out_trx.
  ENDLOOP.

*TERCERA CONSULTA: AGR_1251
  CLEAR itab2.
  p_flnme = in_ruta_agr_1251.
  file_str = p_flnme.
  DELETE FROM ztb_1251.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_1251-mandt out_1251-agr_name out_1251-counter out_1251-object out_1251-auth out_1251-variant out_1251-field out_1251-low out_1251-high out_1251-modified out_1251-deleted out_1251-copied out_1251-neu out_1251-node .
    APPEND out_1251.
    MODIFY ztb_1251 FROM out_1251.
    COMMIT WORK.
    CLEAR out_1251.
  ENDLOOP.

*CUARTA CONSULTA: AGR_1252
  CLEAR itab2.
  p_flnme = in_ruta_agr_1252.
  file_str = p_flnme.
  DELETE FROM ztb_1252.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_1252-mandt out_1252-agr_name out_1252-counter out_1252-varbl out_1252-low out_1252-high.
    APPEND out_1252.
    MODIFY ztb_1252 FROM out_1252.
    COMMIT WORK.
    CLEAR out_1252.
  ENDLOOP.

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

*QUINTA CONSULTA: ROL_AGR_DE
  CLEAR itab2.
  p_flnme = in_ruta_rolagrde.
  file_str = p_flnme.
  DELETE FROM ztb_rol_agr_de.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.

    SPLIT itab2-value AT ';' INTO out_rol_agr_de-mandt
                                  out_rol_agr_de-agr_name
                                  out_rol_agr_de-parent_agr
                                  out_rol_agr_de-create_usr
                                  out_rol_agr_de-create_dat
                                  out_rol_agr_de-create_tim
                                  out_rol_agr_de-create_tmp
                                  out_rol_agr_de-change_usr
                                  out_rol_agr_de-change_dat
                                  out_rol_agr_de-change_tim
                                  out_rol_agr_de-change_tmp
                                  out_rol_agr_de-attributes
                                  out_rol_agr_de-text.
    APPEND out_rol_agr_de.
    MODIFY ztb_rol_agr_de FROM out_rol_agr_de.
    COMMIT WORK.
    CLEAR out_rol_agr_de.
  ENDLOOP.

*SEXTA CONSULTA: USE_GEN_DA
  CLEAR itab2.
  p_flnme = in_ruta_usegenda.
  file_str = p_flnme.
  DELETE FROM ztb_use_gen_da.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_use_gen_da-mandt
                                  out_use_gen_da-bname
                                  out_use_gen_da-persnum
                                  out_use_gen_da-name_last
                                  out_use_gen_da-name_text
                                  out_use_gen_da-mc_name_first
                                  out_use_gen_da-mc_name_last
                                  out_use_gen_da-gltgv
                                  out_use_gen_da-gltgb
                                  out_use_gen_da-trdat
                                  out_use_gen_da-ltime
                                  out_use_gen_da-uflag.
    APPEND out_use_gen_da.
    MODIFY ztb_use_gen_da FROM out_use_gen_da.
    COMMIT WORK.
    CLEAR out_use_gen_da.
  ENDLOOP.

*OCTAVA CONSULTA: USE_TOTAL
  CLEAR itab2.
  p_flnme = in_ruta_usetotal.
  file_str = p_flnme.
*  DELETE FROM ztb_use_total.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_use_total-tasktype
                                  out_use_total-account
                                  out_use_total-tasktdesc
                                  out_use_total-entry_id
                                  out_use_total-contador
                                  out_use_total-l_entry_id1
                                  out_use_total-l_entry_id2.
    APPEND out_use_total.
*    MODIFY ztb_use_total FROM out_use_total.
*    COMMIT WORK.
    CLEAR out_use_total.
  ENDLOOP.

*NOVENA CONSULTA: S_TCODE
  CLEAR itab2.
  p_flnme = in_ruta_s_tcode.
  file_str = p_flnme.
*  DELETE FROM ztb_use_total.
*UPLOADING FILE INTO INTERNAL TABLE
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
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_use_total-tasktype
                                  out_use_total-account
                                  out_use_total-tasktdesc
                                  out_use_total-entry_id
                                  out_use_total-contador
                                  out_use_total-l_entry_id1
                                  out_use_total-l_entry_id2.
    APPEND out_use_total.
*    MODIFY ztb_use_total FROM out_use_total.
*    COMMIT WORK.
    CLEAR out_use_total.
  ENDLOOP.

* CARGA 10: AGR_TEXTS
  CLEAR itab2.
  p_flnme = in_ruta_agr_texts.
  file_str = p_flnme.

*UPLOADING FILE INTO INTERNAL TABLE
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
  IF itab2 IS NOT INITIAL.
    DELETE FROM zagr_texts.
  ENDIF.
  LOOP AT itab2.
    SPLIT itab2-value AT ';' INTO out_rol_agr_text-mandt out_rol_agr_text-agr_name out_rol_agr_text-langu out_rol_agr_text-profile out_rol_agr_text-ptext.
    APPEND out_rol_agr_text.
    MODIFY ztb_rol_agr_pr FROM out_rol_agr_pr.
    COMMIT WORK.
    CLEAR out_rol_agr_text.
  ENDLOOP.

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
