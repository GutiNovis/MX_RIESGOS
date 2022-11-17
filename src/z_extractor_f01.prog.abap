*&---------------------------------------------------------------------*
*&  Include           Z_EXTRACTOR_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data .
*------------------------------------------------------------------------&USE
  IF p_use IS NOT INITIAL.
    CALL FUNCTION 'SWNC_COLLECTOR_GET_AGGREGATES'
      EXPORTING
        component     = p_comp
*       ASSIGNDSYS    = SY-SYSID
        periodtype    = p_periot
        periodstrt    = p_perios
        summary_only  = p_summar
*       STORAGE_TYPE  = ' '
*       FACTOR        = 1000
      TABLES
*       TASKTYPE      =
*       TASKTIMES     =
*       TIMES         =
*       DBPROCS       =
*       EXTSYSTEM     =
*       TCDET         =
*       FRONTEND      =
*       MEMORY        =
*       SPOOLACT      =
*       TABLEREC      =
        usertcode     = lt_ucode
*       USERWORKLOAD  =
*       RFCCLNT       =
*       RFCCLNTDEST   =
*       RFCSRVR       =
*       RFCSRVRDEST   =
*       SPOOL         =
*       HITLIST_DATABASE       =
*       HITLIST_RESPTIME       =
*       ASTAT         =
*       ASHITL_DATABASE        =
*       ASHITL_RESPTIME        =
*       COMP_HIERARCHY         =
*       ORG_UNITS     =
*       DBCON         =
*       VMC           =
*       WEBSD         =
*       WEBCD         =
*       WEBS          =
*       WEBC          =
*       TREX          =
*       FE            =
      EXCEPTIONS
        no_data_found = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE 'No data selected'(001) TYPE 'E'.
    ENDIF.

    DATA: l_entry_id1(40),
          l_entry_id2(32),
          l_entry_id3(1).

    IF lt_ucode IS INITIAL.
      WRITE: / 'File' ,p_file_u ,  ' has not been generated' COLOR COL_NEGATIVE .
    ELSE.
      LOOP AT lt_ucode INTO lw_ucode.
        lw_extract01-tasktype = lw_ucode-tasktype.
        lw_extract01-account  = lw_ucode-account.
        lw_extract01-entry_id = lw_ucode-entry_id.
        lw_extract01-count    = lw_ucode-count.

        CALL METHOD cl_swnc_collector_info=>translate_tasktype
          EXPORTING
            tasktyperaw = lw_ucode-tasktype
          RECEIVING
            tasktype    = lw_extract01-tasktdesc.
        APPEND lw_extract01 TO lt_extract01.
      ENDLOOP.

      OPEN DATASET p_file_u FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      "SKIPPING BYTE-ORDER MARK.
      LOOP AT lt_extract01 INTO lw_extract01.
        lw_extract02-tasktype   = lw_extract01-tasktype.
        lw_extract02-account    = lw_extract01-account.
        lw_extract02-tasktdesc  = lw_extract01-tasktdesc.
*     lw_extract02-entry_id   = lw_extract01-entry_id.
        l_entry_id1 = lw_extract01-entry_id(40).
        l_entry_id2 = lw_extract01-entry_id+40(32).
        l_entry_id3 = lw_extract01-entry_id+72(1).
        lw_extract02-count      = lw_extract01-count.
        CONDENSE lw_extract02-count.

        IF l_entry_id2 IS INITIAL.
          l_entry_id2 = '_B_'.
        ENDIF.

        IF p_ushake = 'X'.
          CALL METHOD lc_ushaker->get_alias EXPORTING bname = lw_extract02-account IMPORTING alias = lw_extract02-account.
        ENDIF.

        CONCATENATE lw_extract02-tasktype   ';'  lw_extract02-account ';'  lw_extract02-tasktdesc ';'
                    l_entry_id1  ';'  l_entry_id2  ';' l_entry_id3  ';'  lw_extract02-count
                    INTO line_file01 IN CHARACTER MODE.
        TRANSFER line_file01 TO p_file_u.
        CLEAR: line_file01 ,lw_extract02, l_entry_id1, l_entry_id2, l_entry_id3.
      ENDLOOP.

      CLOSE DATASET p_file_u.
      WRITE: / 'File' ,p_file_u ,  ' has been generated'.
    ENDIF.
  ENDIF.

*------------------------------------------------------------------------&ROLES&USERS
  IF p_role IS NOT INITIAL.
* -TABLE AGR_USERS---------------------------------------------------
    SELECT * FROM agr_users INTO TABLE lt_agr_user.
    OPEN DATASET p_filer1 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

    LOOP AT lt_agr_user INTO lw_agr_user.
      IF p_ushake = 'X'.
        CALL METHOD lc_ushaker->get_alias EXPORTING bname = lw_agr_user-uname IMPORTING alias = lw_agr_user-uname.
      ENDIF.
      s_st_aux = lw_agr_user-change_tst.
      CONDENSE s_st_aux.
      CONCATENATE:  lw_agr_user-mandt      ';' lw_agr_user-agr_name   ';' lw_agr_user-uname      ';'
                    lw_agr_user-from_dat   ';' lw_agr_user-to_dat     ';' lw_agr_user-exclude    ';'
                    lw_agr_user-change_dat ';' lw_agr_user-change_tim ';' " s_st_aux               ';'
                    lw_agr_user-org_flag   ';' lw_agr_user-col_flag      INTO lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      TRANSFER line_file01 TO p_filer1.
      CLEAR: line_file01, lw_line,s_st_aux, lw_agr_texts.
    ENDLOOP.
    CONCATENATE 'Generando Documento' p_filer1 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 10
        text       = lv_text_p01.

    CLOSE DATASET p_filer1.
    CLEAR: lt_agr_user[], lt_agr_texts[].
    WRITE: / 'File' ,p_filer1 ,  ' has been generated'.

* -TABLE AGR_DEFINE------------------------------------------------
    SELECT * FROM agr_define INTO TABLE lt_agr_define.

    OPEN DATASET p_filer2 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_agr_define INTO lw_agr_define.
      s_st_aux  = lw_agr_define-create_tmp.
      s_st_aux2 = lw_agr_define-change_tmp.
      CONDENSE:s_st_aux,s_st_aux2.
      CONCATENATE:  lw_agr_define-mandt      ';' lw_agr_define-agr_name   ';' lw_agr_define-parent_agr ';'
                    lw_agr_define-create_usr ';' lw_agr_define-create_dat ';' lw_agr_define-create_tim ';'
                    s_st_aux                 ';' lw_agr_define-change_usr ';' lw_agr_define-change_dat ';'
                    lw_agr_define-change_tim ';' s_st_aux2                ';' lw_agr_define-attributes INTO lw_line.
      CONDENSE lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer2.

      CLEAR: line_file01, lw_line, s_st_aux, s_st_aux2.
    ENDLOOP.
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer2 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 20
        text       = lv_text_p01.

    CLOSE DATASET p_filer2.
    CLEAR lt_agr_define[].
    WRITE: / 'File' ,p_filer2 ,  ' has been generated'.

* -TABLE AGR_1251---------------------------------------------------
    SELECT * FROM agr_1251 INTO TABLE lt_agr_1251.
*    SELECT * FROM tobj INTO TABLE lt_tobj.

    OPEN DATASET p_filer3 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_agr_1251 INTO lw_agr_1251.

*      READ TABLE lt_tstct INTO lw_tstct WITH KEY tcode = lw_agr_1251-low.

      CONCATENATE:  lw_agr_1251-mandt    ';' lw_agr_1251-agr_name ';' lw_agr_1251-counter  ';'
                    lw_agr_1251-object   ';' lw_agr_1251-auth     ';' lw_agr_1251-variant  ';'
                    lw_agr_1251-field    ';' lw_agr_1251-low      ';' lw_agr_1251-high     ';'
                    lw_agr_1251-modified ';' lw_agr_1251-deleted  ';' lw_agr_1251-copied   ';'
                    lw_agr_1251-neu      ';' lw_agr_1251-node     INTO lw_line.
      CONDENSE lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer3.
      CLEAR line_file01.
    ENDLOOP.
    lt_1251_aux[] = lt_agr_1251[].
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer3 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 30
        text       = lv_text_p01.

    CLOSE DATASET p_filer3.
    WRITE: / 'File' ,p_filer3 ,  ' has been generated'.

* -TABLE AGR_TEXTS---------------------------------------------------

    SELECT * FROM agr_texts INTO TABLE lt_agr_texts WHERE ( spras = 'S' OR spras = 'E' ).
    OPEN DATASET p_filer4 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

    LOOP AT lt_agr_texts INTO lw_agr_texts.
      CONCATENATE:  lw_agr_texts-mandt    ';' lw_agr_texts-agr_name ';' lw_agr_texts-spras  ';'
                    lw_agr_texts-line  ';' lw_agr_texts-text  INTO lw_line.
      CONDENSE lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer4.
      CLEAR: line_file01, lw_line.
    ENDLOOP.
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer4 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 40
        text       = lv_text_p01.

    CLOSE DATASET p_filer4.
    WRITE: / 'File' ,p_filer4 ,  ' has been generated'.

* -USERS GENERAL DATA------------------------------------------------------
    SELECT * FROM v_username
      INTO TABLE lt_username.

    SELECT bname gltgv gltgb ustyp
           class uflag trdat ltime
      FROM usr02
      INTO CORRESPONDING FIELDS OF TABLE lt_ulock.

    SELECT bname name_textc
      FROM user_addr
      INTO CORRESPONDING FIELDS OF TABLE lt_user_addr.
*    IF p_ushake  = 'X'.
*      CREATE OBJECT lc_ushaker.
*    ENDIF.

    LOOP AT lt_ulock INTO lw_ulock.

      READ TABLE lt_user_addr INTO lw_user_addr WITH KEY bname = lw_ulock-bname.
      READ TABLE lt_username INTO lw_username WITH KEY bname = lw_ulock-bname.
      IF sy-subrc <> 0.
        "      IF sy-subrc <> 0 OR p_ushake = 'X'.
        lw_username-persnumber = '9999999999'.
        lw_username-name_last = lw_username-name_text =
        lw_username-mc_namefir = lw_username-mc_namelas = '_B_'.
      ENDIF.

      lw_user-mandt          = sy-mandt.
      lw_user-bname          = lw_ulock-bname.
      lw_user-persnum        = lw_username-persnumber.
      lw_user-name_last      = lw_username-name_last.
      lw_user-name_text      = lw_username-name_text.
      lw_user-mc_name_first  = lw_username-mc_namefir.
      lw_user-mc_name_last   = lw_username-mc_namelas.
      lw_user-gltgv          = lw_ulock-gltgv.
      lw_user-gltgb          = lw_ulock-gltgb.
      lw_user-ustyp          = lw_ulock-ustyp.
      lw_user-class          = lw_ulock-class.
      lw_user-trdat          = lw_ulock-trdat.
      lw_user-ltime          = lw_ulock-ltime.
      lw_user-uflag          = lw_ulock-uflag.
      lw_user-name_textc     = lw_user_addr-name_textc.

      IF p_ushake = 'X'.
*        lw_ushake-bname = lw_user-bname.
**       lw_user-bname   = lc_ushaker->shake( ).
        CALL METHOD lc_ushaker->get_alias EXPORTING bname = lw_user-bname IMPORTING alias = lw_user-bname.
*        lw_ushake-alias = lw_user-bname.
*        APPEND lw_ushake TO lt_ushake.
*        CLEAR lw_ushake.
      ENDIF.

      APPEND lw_user TO lt_user.
      CONCATENATE: lw_user-mandt        ';' lw_user-bname     ';' lw_user-persnum       ';'
                   lw_user-name_last    ';' lw_user-name_text ';' lw_user-mc_name_first ';'
                   lw_user-mc_name_last ';' lw_user-gltgv     ';' lw_user-gltgb         ';'
                   lw_user-ustyp        ';'
                   lw_user-class        ';' lw_user-trdat     ';' lw_user-ltime         ';'
                   lw_user-uflag        ';' lw_user-name_textc
                   INTO lw_line.
      APPEND lw_line TO lt_line.
      CLEAR: lw_username, lw_ulock.
    ENDLOOP.

    CLEAR: lt_username[], lt_ulock[].
    OPEN DATASET p_filer5 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_line INTO lw_line.
      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer5.
      CLEAR line_file01.
    ENDLOOP.
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer5 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 50
        text       = lv_text_p01.

    CLOSE DATASET p_filer5.
    WRITE: / 'File' ,p_filer5 ,  ' has been generated'.
    CLEAR: lt_line[], lw_line.

* -TABLE AGR_1252---------------------------------------------------
    SELECT * FROM agr_1252 INTO TABLE lt_agr_1252.

    OPEN DATASET p_filer6 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_agr_1252 INTO lw_agr_1252.
      CONCATENATE:  lw_agr_1252-mandt    ';' lw_agr_1252-agr_name ';' lw_agr_1252-counter  ';'
                    lw_agr_1252-varbl   ';' lw_agr_1252-low      ';' lw_agr_1252-high INTO lw_line.
      CONDENSE lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer6.
      CLEAR line_file01.
    ENDLOOP.
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer6 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 60
        text       = lv_text_p01.

    CLOSE DATASET p_filer6.
    WRITE: / 'File' ,p_filer6 ,  ' has been generated'.

* -TABLE AGR_TEXTS Estructura de archivo para menú jerárquico: Cliente  --------

* -TABLE AGR_PROF---------------------------------------------------
****    SELECT * FROM agr_prof INTO TABLE lt_agr_prof.
****    OPEN DATASET p_filer4 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
****
****    LOOP AT lt_agr_prof INTO lw_agr_prof.
****      CONCATENATE:  lw_agr_prof-mandt    ';' lw_agr_prof-agr_name ';' lw_agr_prof-langu  ';'
****                    lw_agr_prof-profile  ';' lw_agr_prof-ptext  INTO lw_line.
****      CONDENSE lw_line.
****
****      CALL METHOD cl_abap_container_utilities=>fill_container_c
****        EXPORTING
****          im_value               = lw_line
****        IMPORTING
****          ex_container           = line_file01
****        EXCEPTIONS
****          illegal_parameter_type = 1
****          OTHERS                 = 2.
****      IF sy-subrc <> 0.
****        CONTINUE.
****      ENDIF.
****      TRANSFER line_file01 TO p_filer4.
****      CLEAR: line_file01, lw_line.
****    ENDLOOP.
****
****    CLOSE DATASET p_filer4.
****    WRITE: / 'File' ,p_filer4 ,  ' has been generated'.

* -TABLE TSTCT Textos cod. transacción------------------------------
    IF lt_1251_aux[] IS NOT INITIAL.

      DELETE lt_1251_aux WHERE object NE 'S_TCODE'
                            OR low EQ ''.
      SORT lt_1251_aux BY low.
      DELETE ADJACENT DUPLICATES FROM lt_1251_aux[] COMPARING low.
      LOOP AT lt_1251_aux INTO DATA(wa_1251_aux).
        APPEND INITIAL LINE TO lt_tcode ASSIGNING FIELD-SYMBOL(<fs_tcode>).
*        <fs_tcode>-spras = wa_1251_aux-spras.
        <fs_tcode>-tcode = wa_1251_aux-low.
      ENDLOOP.

      SELECT *
      FROM tstct
      INTO TABLE lt_tstct
        FOR ALL ENTRIES IN lt_tcode
      WHERE ( sprsl = 'S' OR sprsl = 'E' )
        AND tcode = lt_tcode-tcode.

      OPEN DATASET p_filer7 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

      LOOP AT lt_tstct INTO lw_tstct.
        CONCATENATE: lw_tstct-sprsl ';' lw_tstct-tcode ';' lw_tstct-ttext   INTO lw_line.
        CONDENSE lw_line.

        CALL METHOD cl_abap_container_utilities=>fill_container_c
          EXPORTING
            im_value               = lw_line
          IMPORTING
            ex_container           = line_file01
          EXCEPTIONS
            illegal_parameter_type = 1
            OTHERS                 = 2.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        TRANSFER line_file01 TO p_filer7.
        CLEAR: line_file01, lw_line.
      ENDLOOP.
      CLEAR lv_text_p01.
      CONCATENATE 'Generando Documento' p_filer7 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = 70
          text       = lv_text_p01.

      CLOSE DATASET p_filer7.
      WRITE: / 'File' ,p_filer7 ,  ' has been generated'.
    ENDIF.
* -TABLE AGR_AGRS------------------------------------------------
    SELECT * FROM agr_agrs INTO TABLE lt_agr_agrs.

    OPEN DATASET p_filer8 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_agr_agrs INTO lw_agr_agrs.
      CONCATENATE:  lw_agr_agrs-mandt      ';' lw_agr_agrs-agr_name   ';'
                    lw_agr_agrs-child_agr  ';' lw_agr_agrs-attributes INTO lw_line.
      CONDENSE lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer8.

      CLEAR: line_file01, lw_line, s_st_aux, s_st_aux2.
    ENDLOOP.
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer8 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 80
        text       = lv_text_p01.

    CLOSE DATASET p_filer8.
    CLEAR lt_agr_agrs[].
    WRITE: / 'File' ,p_filer8 ,  ' has been generated'.

* -TABLE TOBJ------------------------------------------------
    SELECT * FROM tobj INTO TABLE lt_tobj.

    OPEN DATASET p_filer9 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_tobj INTO lw_tobj.
      CONCATENATE:  lw_tobj-objct     ','
                    lw_tobj-fiel1     ','
                    lw_tobj-fiel2     ','
                    lw_tobj-fiel3     ','
                    lw_tobj-fiel4     ','
                    lw_tobj-fiel5     ','
                    lw_tobj-fiel6     ','
                    lw_tobj-fiel7     ','
                    lw_tobj-fiel8     ','
                    lw_tobj-fiel9     ','
                    lw_tobj-fiel0     ','
                    lw_tobj-oclss     ','
                    lw_tobj-bname     ','
                    lw_tobj-fblock    ','
                    lw_tobj-conversion INTO lw_line.
      CONDENSE lw_line.

      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_filer9.

      CLEAR: line_file01, lw_line, s_st_aux, s_st_aux2.
    ENDLOOP.
    CLEAR lv_text_p01.
    CONCATENATE 'Generando Documento' p_filer9 INTO lv_text_p01 SEPARATED BY ''.
*Muestra el indicador en la barra de status
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 90
        text       = lv_text_p01.

    CLOSE DATASET p_filer9.
    CLEAR lt_tobj[].
    WRITE: / 'File' ,p_filer9 ,  ' has been generated'.

  ENDIF.

  IF p_licens IS NOT INITIAL.
* -License Data ---------------------------------------------------
    SELECT * FROM usr06 INTO TABLE lt_usr06.
    IF sy-subrc <> 0.
      WRITE: / 'File' ,p_file_l ,  ' has not been generated' COLOR COL_NEGATIVE .
    ELSE.
      OPEN DATASET p_file_l FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

      SELECT * FROM tutypa INTO TABLE lt_tutypa.
      SELECT * FROM tutypnow INTO TABLE lt_tutypnow.

      LOOP AT lt_usr06 INTO lw_usr06.
        CLEAR: lw_tutypa, lw_tutypnow, lw_userlic.
        READ TABLE lt_tutypa INTO lw_tutypa WITH KEY usertyp = lw_usr06-lic_type.
        READ TABLE lt_tutypnow INTO lw_tutypnow WITH KEY langu = p_spra1 usertyp = lw_usr06-lic_type.
        lw_userlic-usr06-mandt     = lw_usr06-mandt.
        lw_userlic-usr06-bname     = lw_usr06-bname.
        lw_userlic-usr06-lic_type  = lw_usr06-lic_type.
        lw_userlic-usr06-vondat    = lw_usr06-vondat.
        lw_userlic-usr06-bisdat    = lw_usr06-bisdat.
        lw_userlic-usr06-mandt2    = lw_usr06-mandt2.
        lw_userlic-usr06-sysid     = lw_usr06-sysid.
        lw_userlic-usr06-aname     = lw_usr06-aname.
        lw_userlic-usr06-easlpfl   = lw_usr06-easlpfl.
        lw_userlic-usr06-spras     = lw_usr06-spras.
        s_ts = lw_userlic-usr06-surcharge = lw_usr06-surcharge.
        lw_userlic-sscr_allow      = lw_tutypa-sscr_allow.
        lw_userlic-active          = lw_tutypa-active.
        lw_userlic-sondervers      = lw_tutypa-sondervers.
        lw_userlic-country         = lw_tutypa-country.
        lw_userlic-charge_info     = lw_tutypa-charge_info.
        lw_userlic-utyptext        = lw_tutypnow-utyptext.
        lw_userlic-sort            = lw_tutypnow-sort.

        IF p_ushake = 'X'.
          CALL METHOD lc_ushaker->get_alias
            EXPORTING
              bname = lw_userlic-usr06-bname
            IMPORTING
              alias = lw_userlic-usr06-bname.
        ENDIF.

        CONCATENATE: lw_userlic-usr06-mandt  ';' lw_userlic-usr06-bname   ';' lw_userlic-usr06-lic_type ';'
                     lw_userlic-usr06-vondat ';' lw_userlic-usr06-bisdat  ';' lw_userlic-usr06-mandt2 ';'
                     lw_userlic-usr06-sysid  ';' lw_userlic-usr06-aname   ';' lw_userlic-usr06-easlpfl ';'
                     lw_userlic-usr06-spras  ';' s_ts                     ';' lw_userlic-sscr_allow ';'
                     lw_userlic-active       ';' lw_userlic-sondervers    ';' lw_userlic-country ';'
                     lw_userlic-charge_info  ';' lw_userlic-utyptext      ';' lw_userlic-sort ';'
                     INTO lw_line.
        APPEND lw_line TO lt_line.
      ENDLOOP.

      LOOP AT lt_line INTO lw_line.
        CALL METHOD cl_abap_container_utilities=>fill_container_c
          EXPORTING
            im_value               = lw_line
          IMPORTING
            ex_container           = line_file01
          EXCEPTIONS
            illegal_parameter_type = 1
            OTHERS                 = 2.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        TRANSFER line_file01 TO p_file_l.
        CLEAR: line_file01, lw_line.
      ENDLOOP.

      CLOSE DATASET p_file_l.
      CLEAR: lt_line[], lw_line.
      WRITE: / 'File' ,p_file_l ,  ' has been generated'.
    ENDIF.
  ENDIF.

  IF p_gene IS NOT INITIAL.
* -TABLE TSTCV - CSV---------------------------------------------------
    SELECT * FROM tstc  INTO TABLE lt_tstc.
    SELECT * FROM tstcv INTO TABLE lt_tstcv WHERE sprsl = p_spras.

    OPEN DATASET p_file_g FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    LOOP AT lt_tstc INTO lw_tstc.
      CLEAR: lw_trxs, lw_tstcv.
      READ TABLE lt_tstcv INTO lw_tstcv WITH KEY tcode = lw_tstc-tcode.
      IF sy-subrc = 0.
        lw_trxs-description = lw_tstcv-ttext.
      ELSE.
        lw_trxs-description = '_B_'.
      ENDIF.
      lw_trxs-tcode        = lw_tstc-tcode.
      lw_trxs-progname     = lw_tstc-pgmna.
      APPEND lw_trxs TO lt_trxs.

      CONCATENATE: lw_trxs-tcode ';' lw_trxs-progname ';' lw_trxs-description INTO lw_line.
      APPEND lw_line TO lt_line.
    ENDLOOP.

    LOOP AT lt_line INTO lw_line.
      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_file_g.
      CLEAR: line_file01, lw_line.
    ENDLOOP.

    CLOSE DATASET p_file_g.
    CLEAR lt_tstc[].
    WRITE: / 'File' ,p_file_g ,  ' has been generated'.
  ENDIF.
  IF p_ushake  = 'X'.
    CREATE OBJECT lc_ushaker.
  ENDIF.

  IF p_ushake = 'X'.
    OPEN DATASET p_fileu1 FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    CALL METHOD lc_ushaker->get_alias_table IMPORTING lt_ushake = lt_ushake.
    LOOP AT lt_ushake INTO lw_ushake.
      CONCATENATE lw_ushake-bname ';' lw_ushake-alias INTO lw_line.
      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value               = lw_line
        IMPORTING
          ex_container           = line_file01
        EXCEPTIONS
          illegal_parameter_type = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      TRANSFER line_file01 TO p_fileu1.
      CLEAR: line_file01,lw_line.
    ENDLOOP.

    CLOSE DATASET p_fileu1.
    WRITE: / 'File' ,p_fileu1 ,  ' has been generated'.
    CLEAR lt_ushake[].
  ENDIF.
ENDFORM.
