*&---------------------------------------------------------------------*
*&  Include           Z_EXTRACTOR_TOP
*&---------------------------------------------------------------------*

*-$- TYPES

TYPES: BEGIN OF t_extract01,
         tasktype  TYPE swnctasktyperaw,
         account   TYPE swncuname,
         tasktdesc TYPE swnctasktype,
         entry_id  TYPE swncentryid,
         count     TYPE swnccntagg,
       END OF t_extract01.

TYPES: BEGIN OF t_extract02,
         tasktype(1),
         account     TYPE swncuname,
         tasktdesc   TYPE swnctasktype,
         entry_id    TYPE swncentryid,
         count(24),
       END OF t_extract02.

TYPES: BEGIN OF t_trxs,
         tcode       TYPE tcode,
         progname    TYPE program_id,
         description TYPE ttext_stct,
       END OF t_trxs.

TYPES:BEGIN OF t_user,
        mandt         TYPE symandt,
        bname         TYPE xubname,
        persnum       TYPE ad_persnum,
        name_last     TYPE ad_namelas,
        name_text     TYPE ad_namtext,
        mc_name_first TYPE ad_mc_nmfi,
        mc_name_last  TYPE ad_mc_nmla,
        gltgv         TYPE xugltgv,
        gltgb         TYPE xugltgb,
        ustyp         TYPE xuustyp,
        class         TYPE xuclass,
        trdat         TYPE xuldate,
        ltime         TYPE xultime,
        uflag         TYPE string,
        name_textc    TYPE ad_namtext,
      END OF t_user.

TYPES: BEGIN OF t_ulock,
         bname TYPE xubname,
         gltgv TYPE xugltgv,
         gltgb TYPE xugltgb,
         ustyp TYPE xuustyp,
         class TYPE xuclass,
         trdat TYPE xuldate,
         ltime TYPE xultime,
         uflag TYPE xuuflag,
       END OF t_ulock.

TYPES: BEGIN OF t_user_addr,
         bname      TYPE xubname,
         name_textc TYPE ad_namtext,
       END OF t_user_addr.

TYPES: BEGIN OF t_ushake,
         bname TYPE xubname,
         alias TYPE xubname,
       END OF t_ushake.

TYPES: tt_ushake TYPE STANDARD TABLE OF t_ushake.

TYPES: BEGIN OF t_userlic,
         usr06       TYPE usr06,
         sscr_allow  TYPE flag,
         active      TYPE rsuvmflag,
         sondervers  TYPE rsuvmflag,
         country     TYPE rsuvmflag,
         charge_info TYPE slim_charge_info_litype,
         utyptext    TYPE utyptext,
         sort        TYPE rsuvmsort,
       END OF t_userlic.

TYPES: BEGIN OF t_file,
         file TYPE  localfile,
       END OF t_file.

TYPES: BEGIN OF t_tcode,
         tcode TYPE tcode,
       END OF t_tcode.

*$-Local Classes
CLASS lcl_winpath DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING i_file TYPE rlgrap-filename.
    METHODS get_winpath RETURNING VALUE(l_winpath) TYPE localfile.
  PRIVATE SECTION.

    DATA: l_file   TYPE localfile,
          lo_winfs TYPE REF TO cl_fs_windows_path.
ENDCLASS.

CLASS lcl_ushaker DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS shake RETURNING VALUE(alias) TYPE xubname.
    METHODS get_alias IMPORTING bname TYPE xubname EXPORTING alias TYPE xubname.
    METHODS get_alias_table EXPORTING lt_ushake TYPE tt_ushake .

  PRIVATE SECTION.
    DATA: l_prefix   TYPE string,
          l_sufix(5) TYPE n,
          last_alias TYPE xubname.
    DATA: lt_ushake   TYPE tt_ushake.
ENDCLASS.

*$-
CLASS lcl_winpath IMPLEMENTATION.
  METHOD constructor.
    me->l_file = i_file.
  ENDMETHOD.                    "constructor

  METHOD get_winpath.
    me->lo_winfs =  cl_fs_windows_path=>create_windows_path( name = me->l_file ).
    l_winpath = lo_winfs->get_path_name( ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ushaker IMPLEMENTATION.
  METHOD constructor.
    FIELD-SYMBOLS: <fs_ushake> TYPE t_ushake.
    CONCATENATE  sy-sysid sy-mandt INTO me->l_prefix.
    me->l_sufix  = '00000'.
    SELECT  bname FROM usr02  INTO  TABLE me->lt_ushake.
    LOOP AT lt_ushake ASSIGNING <fs_ushake>.
      <fs_ushake>-alias = me->shake( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD shake.
    me->l_sufix = me->l_sufix + 1.
    CONCATENATE me->l_prefix '_' me->l_sufix(5) INTO alias.
  ENDMETHOD.

  METHOD get_alias.
    DATA: lw_ushake TYPE t_ushake.
    alias = bname.
    READ TABLE me->lt_ushake INTO lw_ushake WITH KEY bname = bname.
    IF sy-subrc = 0.
      alias = lw_ushake-alias.
    ENDIF.
  ENDMETHOD.

  METHOD get_alias_table.
    lt_ushake = me->lt_ushake.
  ENDMETHOD.
ENDCLASS.

*-$- DATA
DATA: lt_ucode     TYPE STANDARD TABLE OF swncaggusertcode,
      lw_ucode     TYPE swncaggusertcode,
      lt_extract01 TYPE STANDARD TABLE OF  t_extract01,
      lw_extract01 TYPE  t_extract01,
      lt_extract02 TYPE STANDARD TABLE OF  t_extract02,
      lw_extract02 TYPE  t_extract02.
DATA: lw_agr_user   TYPE agr_users,
      lw_agr_define TYPE agr_define,
      lw_agr_agrs   TYPE agr_agrs,
      lw_agr_texts  TYPE agr_texts,
      lw_agr_1251   TYPE agr_1251,
      lw_tstct      TYPE tstct,
      lw_agr_1252   TYPE agr_1252,
      lw_agr_prof   TYPE agr_prof,
      lw_usr01      TYPE usr01,
      lt_agr_user   TYPE STANDARD TABLE OF agr_users,
      lt_agr_define TYPE STANDARD TABLE OF agr_define,
      lt_agr_agrs   TYPE STANDARD TABLE OF agr_agrs,
      lt_agr_texts  TYPE STANDARD TABLE OF agr_texts,
      lt_agr_1251   TYPE STANDARD TABLE OF agr_1251,
      lt_1251_aux   TYPE STANDARD TABLE OF agr_1251,
      lt_tobj       TYPE STANDARD TABLE OF tobj,
      lw_tobj       TYPE tobj,
      lt_tstct      TYPE STANDARD TABLE OF tstct,
      lt_tcode      TYPE STANDARD TABLE OF t_tcode,
      lt_agr_1252   TYPE STANDARD TABLE OF agr_1252,
      lt_agr_prof   TYPE STANDARD TABLE OF agr_prof,
      lt_username   TYPE STANDARD TABLE OF v_username,
      lw_username   TYPE v_username,
      lt_user       TYPE STANDARD TABLE OF t_user,
      lw_user       TYPE t_user,
      lt_ulock      TYPE STANDARD TABLE OF t_ulock,
      lw_ulock      TYPE t_ulock,
      lt_user_addr  TYPE STANDARD TABLE OF t_user_addr,
      lw_user_addr  TYPE t_user_addr,
      lt_ushake     TYPE STANDARD TABLE OF t_ushake,
      lw_ushake     TYPE t_ushake,
      lt_tstcv      TYPE STANDARD TABLE OF tstcv,
      lw_tstcv      TYPE tstcv,
      lt_tstc       TYPE STANDARD TABLE OF tstc,
      lw_tstc       TYPE tstc,
      lt_trxs       TYPE STANDARD TABLE OF t_trxs,
      lw_trxs       TYPE t_trxs,
      lw_userlic    TYPE t_userlic,
      lw_usr06      TYPE usr06,
      lt_usr06      TYPE STANDARD TABLE OF usr06,
      lw_tutypa     TYPE tutypa,
      lt_tutypa     TYPE STANDARD TABLE OF tutypa,
      lw_tutypnow   TYPE tutypnow,
      lt_tutypnow   TYPE STANDARD TABLE OF tutypnow.

DATA: line_file01 TYPE string,
      pname(80).

DATA: ts          TYPE timestamp,
      s_ts        TYPE string,
      s_st_aux    TYPE string,
      s_st_aux2   TYPE string,
      l_firstlast TYPE d.

DATA: lw_opsystem TYPE opsystem,
      l_lifeswin  TYPE filesys_d VALUE 'WINDOWS NT',
      lc_winpath  TYPE REF TO lcl_winpath,
      lw_file     TYPE t_file,
      lt_files    TYPE STANDARD TABLE OF t_file.

DATA: lw_line TYPE string,
      lt_line TYPE STANDARD TABLE OF string.

DATA: lc_ushaker   TYPE REF TO lcl_ushaker,
      l_fileprefix TYPE string.

DATA: lv_text_p01   TYPE char40,
      lv_incremento TYPE i VALUE 1,
      lv_porcentaje TYPE i.
