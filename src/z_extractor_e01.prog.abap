*&---------------------------------------------------------------------*
*&  Include           Z_EXTRACTOR_E01
*&---------------------------------------------------------------------*
" Pantalla posterior a ingreso cliente.

AT SELECTION-SCREEN.

  CLEAR l_fileprefix.

*  CONCATENATE p_custo '_' sy-sysid '_' sy-mandt INTO l_fileprefix.

  CONCATENATE   '.\_USE_' p_comp '_' p_periot '.csv' INTO p_file_u.
*  CONCATENATE   '.\' l_fileprefix '_USE_' p_comp '_' p_periot '_' p_perios'.csv' INTO p_file_u.
  lw_file-file = p_file_u. APPEND lw_file TO lt_files.

  p_filer1 = '.\_ROL_AGR_USER.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_USER_' s_ts '.csv' INTO p_filer1.
  lw_file-file = p_filer1. APPEND lw_file TO lt_files.

  p_filer2 = '.\_ROL_AGR_DEFINE.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_DEFINE_' s_ts '.csv' INTO p_filer2.
  lw_file-file = p_filer2. APPEND lw_file TO lt_files.

  p_filer3 = '.\_ROL_AGR_1251.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_1251_' s_ts '.csv' INTO p_filer3.
  lw_file-file = p_filer3. APPEND lw_file TO lt_files.

  p_filer4 = '.\_ROL_AGR_TEXTS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_TEXTS_' s_ts '.csv' INTO p_filer4.
  lw_file-file = p_filer4. APPEND lw_file TO lt_files.

  p_filer5 = '.\_USE_GEN_DA.csv'.
*  CONCATENATE   '.\' l_fileprefix '_USE_GEN_DA_'  s_ts '.csv' INTO p_filer5.
  lw_file-file = p_filer5. APPEND lw_file TO lt_files.

  p_filer6 = '.\_ROL_AGR_1252.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_1252_' s_ts '.csv' INTO p_filer6.
  lw_file-file = p_filer6. APPEND lw_file TO lt_files.

  p_filer7 = '.\_S_TCODE.csv'.
*  CONCATENATE   '.\' l_fileprefix '_S_TCODE_' s_ts '.csv'  INTO p_filer7.
  lw_file-file = p_filer7. APPEND lw_file TO lt_files.

  p_filer8 = '.\_ROL_AGR_AGRS.csv'.
  lw_file-file = p_filer8. APPEND lw_file TO lt_files.

  p_filer9 = '.\_TOBJ.csv'.
  lw_file-file = p_filer9. APPEND lw_file TO lt_files.

  p_file_l = '.\_LIC_USERS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_LIC_USERS_' s_ts '.csv'  INTO p_file_l.
  lw_file-file = p_file_l. APPEND lw_file TO lt_files.

  p_file_g = '.\_GEN_TRXS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_GEN_TRXS_'  s_ts '.csv' INTO p_file_g.
  lw_file-file = p_file_g. APPEND lw_file TO lt_files.

  p_fileu1 = '.\_ALIAS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ALIAS_'  s_ts '.csv' INTO p_fileu1.
  lw_file-file = p_fileu1. APPEND lw_file TO lt_files.

*-$- SELSCR
INITIALIZATION.
  l_firstlast            =   sy-datum.
  IF l_firstlast+4(2)    <>  '01'.
    l_firstlast+4(2)    =   l_firstlast+4(2) - 1.
  ELSE.
    l_firstlast+4(2)     =  '12'.
    l_firstlast(4)       =   l_firstlast(4) - 1.
  ENDIF.

  l_firstlast+6(2)    =   '01'.
  p_perios = l_firstlast.

*  title_1 = 'Cliente'.
*  %_p_comp_%_app_%-text   = 'Component'.
*  %_p_custo_%_app_%-text  = 'Customer Name'.

  title_2 = 'Use'.
  %_p_use_%_app_%-text    = 'Use Data Generation'.
  %_p_periot_%_app_%-text = 'Period'.
  %_p_perios_%_app_%-text = 'Date'.
  %_p_file_u_%_app_%-text = 'Use Data File'.

  title_3 = 'Roles & Users'.
  %_p_role_%_app_%-text   = 'R & U Data Generation'.
  %_p_filer1_%_app_%-text = 'AGR_USERS'. " 'AGR Roles Data File'.
  %_p_filer2_%_app_%-text = 'AGR Define Data File'.
  %_p_filer3_%_app_%-text = 'AGR 1251 Data File'.
  %_p_filer4_%_app_%-text = 'AGR Texts Data File'.
  %_p_filer5_%_app_%-text = 'USER General Data File'.
  %_p_filer6_%_app_%-text = 'AGR 1252 Data File'.
  %_p_filer7_%_app_%-text = 'Textos TCODE'.
  %_p_filer8_%_app_%-text = 'AGR AGRS'.
  %_p_filer9_%_app_%-text = 'TOBJ'.

  title_4 = 'Licenses'.
  %_p_licens_%_app_%-text = 'License Data Generation'.
  %_p_file_l_%_app_%-text = 'User License Data File'.

  title_5 = 'General'.
  %_p_gene_%_app_%-text   = 'General Data Generation'.
  %_p_file_g_%_app_%-text = 'Transaction Data File'.

  title_6 = 'User Anonymization'.
  %_p_ushake_%_app_%-text = 'User Alias Generation'.
  %_p_fileu1_%_app_%-text = 'Alias Data File'.

*  %_p_spra1_%_app_%-text  = 'Roles Description Language'.
  %_p_summar_%_app_%-text = 'Summary Only'.

*  title0 = 'Use'.
*  title1 = 'Roles & Users'.
*  title2 = 'General'.
*  title3 = 'User Anonymization'.
*  title4 = 'Cliente'.
*  title5 = 'Licenses'.

  GET TIME STAMP FIELD ts.
  s_ts = ts.
  CONDENSE s_ts.
* CLEAR p_file.

*  CONCATENATE:  '/tmp/Use_' p_comp '_' p_periot '_' p_perios'.txt' INTO p_file.
*  CONCATENATE p_custo '_' sy-sysid '_' sy-mandt INTO l_fileprefix.

  CONCATENATE   '.\_USE_' p_comp '_' p_periot '.csv' INTO p_file_u.
*  CONCATENATE   '.\' l_fileprefix '_USE_' p_comp '_' p_periot '_' p_perios'.csv' INTO p_file_u.
  lw_file-file = p_file_u. APPEND lw_file TO lt_files.

  p_filer1 = '.\_ROL_AGR_USER.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_USER_' s_ts '.csv' INTO p_filer1.
  lw_file-file = p_filer1. APPEND lw_file TO lt_files.

  p_filer2 = '.\_ROL_AGR_DEFINE.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_DEFINE_' s_ts '.csv' INTO p_filer2.
  lw_file-file = p_filer2. APPEND lw_file TO lt_files.

  p_filer3 = '.\_ROL_AGR_1251.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_1251_' s_ts '.csv' INTO p_filer3.
  lw_file-file = p_filer3. APPEND lw_file TO lt_files.

  p_filer4 = '.\_ROL_AGR_TEXTS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_TEXTS_' s_ts '.csv' INTO p_filer4.
  lw_file-file = p_filer4. APPEND lw_file TO lt_files.

  p_filer5 = '.\_USE_GEN_DA.csv'.
*  CONCATENATE   '.\' l_fileprefix '_USE_GEN_DA_'  s_ts '.csv' INTO p_filer5.
  lw_file-file = p_filer5. APPEND lw_file TO lt_files.

  p_filer6 = '.\_ROL_AGR_1252.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ROL_AGR_1252_' s_ts '.csv' INTO p_filer6.
  lw_file-file = p_filer6. APPEND lw_file TO lt_files.

  p_filer7 = '.\_S_TCODE.csv'.
*  CONCATENATE   '.\' l_fileprefix '_S_TCODE_' s_ts '.csv'  INTO p_filer7.
  lw_file-file = p_filer7. APPEND lw_file TO lt_files.

  p_filer8 = '.\_ROL_AGR_AGRS.csv'.
  lw_file-file = p_filer8. APPEND lw_file TO lt_files.

  p_filer9 = '.\_TOBJ.csv'.
  lw_file-file = p_filer9. APPEND lw_file TO lt_files.

  p_file_l = '.\_LIC_USERS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_LIC_USERS_' s_ts '.csv'  INTO p_file_l.
  lw_file-file = p_file_l. APPEND lw_file TO lt_files.

  p_file_g = '.\_GEN_TRXS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_GEN_TRXS_'  s_ts '.csv' INTO p_file_g.
  lw_file-file = p_file_g. APPEND lw_file TO lt_files.

  p_fileu1 = '.\_ALIAS.csv'.
*  CONCATENATE   '.\' l_fileprefix '_ALIAS_'  s_ts '.csv' INTO p_fileu1.
  lw_file-file = p_fileu1. APPEND lw_file TO lt_files.

*  Condense: p_file, p_filer
  SELECT SINGLE * FROM opsystem INTO lw_opsystem WHERE opsys = sy-opsys.

  lw_opsystem-filesys = to_upper( lw_opsystem-filesys ).

  IF lw_opsystem-filesys EQ l_lifeswin.
    LOOP AT lt_files INTO lw_file.
      CREATE OBJECT lc_winpath
        EXPORTING
          i_file = lw_file-file.
      CASE sy-tabix.
        WHEN 1.
          p_file_u = lc_winpath->get_winpath( ).
        WHEN 2.
          p_filer1 = lc_winpath->get_winpath( ).
        WHEN 3.
          p_filer2 = lc_winpath->get_winpath( ).
        WHEN 4.
          p_filer3 = lc_winpath->get_winpath( ).
        WHEN 5.
          p_filer4 = lc_winpath->get_winpath( ).
        WHEN 6.
          p_filer5 = lc_winpath->get_winpath( ).
        WHEN 7.
          p_filer6 = lc_winpath->get_winpath( ).
        WHEN 8.
          p_filer7 = lc_winpath->get_winpath( ).
        WHEN 9.
          p_filer8 = lc_winpath->get_winpath( ).
        WHEN 10.
          p_filer9 = lc_winpath->get_winpath( ).
        WHEN 11.
          p_file_l = lc_winpath->get_winpath( ).
        WHEN 12.
          p_file_g = lc_winpath->get_winpath( ).
        WHEN 13.
          p_fileu1 = lc_winpath->get_winpath( ).
      ENDCASE.

      FREE lc_winpath.
    ENDLOOP.
  ENDIF.

  l_instr = '2022 Novis'.

START-OF-SELECTION.
*------------------------------------------------------------------------&UAN
  PERFORM data.

END-OF-SELECTION.

  CLEAR: l_fileprefix.
