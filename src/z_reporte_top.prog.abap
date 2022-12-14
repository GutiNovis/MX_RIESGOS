*&---------------------------------------------------------------------*
*&  Include           Z_REPORTE_TOP
*&---------------------------------------------------------------------*
INCLUDE <icon>.
TABLES: sscrfields,
        agr_users,
        usr10,
        ust12,
        tstc,
*        zbc_tiposistdm,
        usr02,
        suid_st_node_logondata,
*        zbc_clientesdm,
*        zbc_log_analisdm,
        agr_define,
        agr_1251.

" TYPES --
TYPES: BEGIN OF ty_rep1,
         id_sistema     TYPE syst-sysid,
         proc_neg       TYPE zed_proceso_negocio,
         desc_proc_neg  TYPE zed_descripcion,
         id_user        TYPE xubname,
         nombre         TYPE ad_mc_nmfi,
         apellido       TYPE ad_namelas,
         tipo_user      TYPE usr02-ustyp,
         grupo_user     TYPE suid_st_node_logondata-class,
*         motivo_bloq    TYPE ,
         fecha_ini      TYPE xugltgv,
         fecha_fin      TYPE xugltgb,
         riesgo	        TYPE zed_riesgo,
         desc_riesgo    TYPE zed_descripcion,
         funcion        TYPE zed_funcion_grc,
         desc_funcion   TYPE zed_descripcion,
         accion_tx      TYPE zed_accion_tx,
         indic_riesgo   TYPE icon_d,
         nivel_riesgo   TYPE char1,
         d_nivel_riesgo TYPE zed_desc_nivel_riesgo,
         tip_riesgo     TYPE char1,
         d_tip_riesgo   TYPE char30,
         ok             TYPE char1,
       END OF ty_rep1,
       BEGIN OF ty_rep2,
         id_sistema     TYPE syst-sysid,
         proc_neg       TYPE zed_proceso_negocio,
         desc_proc_neg  TYPE zed_descripcion,
         id_user        TYPE xubname,
         nombre         TYPE ad_mc_nmfi,
         apellido       TYPE ad_namelas,
         tipo_user      TYPE usr02-ustyp,
         grupo_user     TYPE suid_st_node_logondata-class,
*         motivo_bloq    TYPE ,
         fecha_ini      TYPE xugltgv,
         fecha_fin      TYPE xugltgb,
         riesgo	        TYPE zed_riesgo,
         desc_riesgo    TYPE zed_descripcion,
         funcion_1      TYPE zed_funcion_grc,
         desc_funcion_1 TYPE zed_descripcion,
         accion_tx_1    TYPE zed_accion_tx,
         funcion_2      TYPE zed_funcion_grc,
         desc_funcion_2 TYPE zed_descripcion,
         accion_tx_2    TYPE zed_accion_tx,
         funcion_3      TYPE zed_funcion_grc,
         desc_funcion_3 TYPE zed_descripcion,
         accion_tx_3    TYPE zed_accion_tx,
         funcion_4      TYPE zed_funcion_grc,
         desc_funcion_4 TYPE zed_descripcion,
         accion_tx_4    TYPE zed_accion_tx,
         funcion_5      TYPE zed_funcion_grc,
         desc_funcion_5 TYPE zed_descripcion,
         accion_tx_5    TYPE zed_accion_tx,
         indic_riesgo   TYPE icon_d,
         nivel_riesgo   TYPE char1,
         d_nivel_riesgo TYPE zed_desc_nivel_riesgo,
         tip_riesgo     TYPE char1,
         d_tip_riesgo   TYPE char30,
         ok             TYPE char1,
       END OF ty_rep2,
       BEGIN OF ty_rep3,
         id_sistema     TYPE syst-sysid,
         proc_neg       TYPE zed_proceso_negocio,
         desc_proc_neg  TYPE zed_descripcion,
         id_user        TYPE xubname,
         nombre         TYPE ad_mc_nmfi,
         apellido       TYPE ad_namelas,
         tipo_user      TYPE usr02-ustyp,
         grupo_user     TYPE suid_st_node_logondata-class,
*         motivo_bloq    TYPE ,
         fecha_ini      TYPE xugltgv,
         fecha_fin      TYPE xugltgb,
         riesgo	        TYPE zed_riesgo,
         desc_riesgo    TYPE zed_descripcion,
         funcion_1      TYPE zed_funcion_grc,
         desc_funcion_1 TYPE zed_descripcion,
         accion_tx_1    TYPE zed_accion_tx,
         funcion_2      TYPE zed_funcion_grc,
         desc_funcion_2 TYPE zed_descripcion,
         accion_tx_2    TYPE zed_accion_tx,
         funcion_3      TYPE zed_funcion_grc,
         desc_funcion_3 TYPE zed_descripcion,
         accion_tx_3    TYPE zed_accion_tx,
         funcion_4      TYPE zed_funcion_grc,
         desc_funcion_4 TYPE zed_descripcion,
         accion_tx_4    TYPE zed_accion_tx,
         funcion_5      TYPE zed_funcion_grc,
         desc_funcion_5 TYPE zed_descripcion,
         accion_tx_5    TYPE zed_accion_tx,
         indic_riesgo   TYPE icon_d,
         nivel_riesgo   TYPE char1,
         d_nivel_riesgo TYPE zed_desc_nivel_riesgo,
         tip_riesgo     TYPE char1,
         d_tip_riesgo   TYPE char30,
         ok             TYPE char1,
       END OF ty_rep3,
       BEGIN OF ty_rep4,
         id_sistema     TYPE syst-sysid,
         proc_neg       TYPE zed_proceso_negocio,
         desc_proc_neg  TYPE zed_descripcion,
         id_user        TYPE xubname,
         nombre         TYPE ad_mc_nmfi,
         apellido       TYPE ad_namelas,
         tipo_user      TYPE usr02-ustyp,
         grupo_user     TYPE suid_st_node_logondata-class,
*         motivo_bloq    TYPE ,
         fecha_ini      TYPE xugltgv,
         fecha_fin      TYPE xugltgb,
         riesgo	        TYPE zed_riesgo,
         desc_riesgo    TYPE zed_descripcion,
         funcion_1      TYPE zed_funcion_grc,
         desc_funcion_1 TYPE zed_descripcion,
         accion_tx_1    TYPE zed_accion_tx,
         funcion_2      TYPE zed_funcion_grc,
         desc_funcion_2 TYPE zed_descripcion,
         accion_tx_2    TYPE zed_accion_tx,
         funcion_3      TYPE zed_funcion_grc,
         desc_funcion_3 TYPE zed_descripcion,
         accion_tx_3    TYPE zed_accion_tx,
         funcion_4      TYPE zed_funcion_grc,
         desc_funcion_4 TYPE zed_descripcion,
         accion_tx_4    TYPE zed_accion_tx,
         funcion_5      TYPE zed_funcion_grc,
         desc_funcion_5 TYPE zed_descripcion,
         accion_tx_5    TYPE zed_accion_tx,
         indic_riesgo   TYPE icon_d,
         nivel_riesgo   TYPE char1,
         d_nivel_riesgo TYPE zed_desc_nivel_riesgo,
         tip_riesgo     TYPE char1,
         d_tip_riesgo   TYPE char30,
         ok             TYPE char1,
       END OF ty_rep4.

* tabla ZTB_ITAB
DATA: BEGIN OF itab OCCURS 0,
        mandt  TYPE mandt,
        bname  TYPE xubname,
        aliasu TYPE xubname,
      END OF itab.
* tabla ZTB_TRXS
DATA: BEGIN OF t_trxs OCCURS 0,
        tcode       TYPE tcode,
        progname    TYPE program_id,
        description TYPE ttext_stct,
      END OF t_trxs.

* tabla ZTB_1251
DATA: BEGIN OF t_1251 OCCURS 0,
        mandt    TYPE  mandt,
        agr_name TYPE  agr_name,
        counter  TYPE  menu_num_6,
        object   TYPE  agobject,
        auth     TYPE  agauth,
        variant  TYPE  tpr_vari,
        field    TYPE  agrfield,
        low      TYPE  agval,
        high     TYPE  agval,
        modified TYPE  tpr_st_mod,
        deleted  TYPE  tpr_st_del,
        copied   TYPE  tpr_st_cop,
        neu      TYPE  tpr_st_new,
        node     TYPE  seu_id,
      END OF t_1251.

*tabla ZTB_1252
DATA: BEGIN OF t_1252 OCCURS 0,
        mandt    TYPE  mandt,
        agr_name TYPE  agr_name,
        counter  TYPE  menu_num_6,
        varbl    TYPE  agrorgvar,
        low      TYPE  agval,
        high     TYPE  agval,
      END OF t_1252.

* tabla ZTB_ROL_AGR_PR
DATA: BEGIN OF t_rol_agr_pr OCCURS 0,
        mandt    TYPE  mandt,
        agr_name TYPE  agr_name,
        langu    TYPE  langu,
        profile  TYPE  xuprofile,
        ptext    TYPE  xutext,
      END OF t_rol_agr_pr.

*tabla ZTB_ROL_AGR_DE
DATA: BEGIN OF t_rol_agr_de OCCURS 0,
        mandt      TYPE  symandt,
        agr_name   TYPE  agr_name,
        parent_agr TYPE  par_agr,
        create_usr TYPE  syuname,
        create_dat TYPE  menu_date,
        create_tim TYPE  menu_time,
        create_tmp TYPE  char10,
        change_usr TYPE  syuname,
        change_dat TYPE  menu_date,
        change_tim TYPE  menu_time,
        change_tmp TYPE  char10,
        attributes TYPE  menu_attr,
        text       TYPE  char100,
      END OF t_rol_agr_de.

* tabla ZTB_USE_GEN_DA
DATA: BEGIN OF t_use_gen_da OCCURS 0,
        mandt         TYPE symandt,
        bname         TYPE xubname,
        persnum       TYPE ad_persnum,
        name_last     TYPE ad_namelas,
        name_text     TYPE ad_namtext,
        mc_name_first TYPE ad_mc_nmfi,
        mc_name_last  TYPE ad_mc_nmla,
        gltgv         TYPE xugltgv,
        gltgb         TYPE xugltgb,
        trdat         TYPE xuldate,
        ltime         TYPE xultime,
        uflag         TYPE char10,
      END OF t_use_gen_da.

DATA: BEGIN OF t_rol_agr_us OCCURS 0,
        agr_name TYPE  agr_name,
        uname    TYPE  xubname,
      END OF t_rol_agr_us.

DATA: BEGIN OF t_use_total OCCURS 0,
        tasktype(1),
        account         TYPE swncuname,
        tasktdesc       TYPE swnctasktype,
        entry_id        TYPE swncentryid,
        contador(24),
        l_entry_id1(40),
        l_entry_id2(32),
      END OF t_use_total.

* FIELD SYMBOLS DEL ANALISIS.
FIELD-SYMBOLS: <fs_itab> LIKE itab.
" Tablas internas
DATA: lt_zbase_risks      TYPE STANDARD TABLE OF zbase_risks,
      lt_zbase_risks_z    TYPE STANDARD TABLE OF zbase_risks_z,
      lt_zrisks_t         TYPE STANDARD TABLE OF zrisks_t,
      lt_zfunction_t      TYPE STANDARD TABLE OF zfunction_t,
      lt_zbase_function   TYPE STANDARD TABLE OF zbase_function,
      lt_zbusiness_proc_t TYPE STANDARD TABLE OF zbusiness_proc_t,
      lt_zagr_1251        TYPE STANDARD TABLE OF ztab_1251,
      lt_zagr_1252        TYPE STANDARD TABLE OF ztab_1252,
*      lt_ztb_itab         TYPE STANDARD TABLE OF ztb_itab,
      lt_zagr_users       TYPE STANDARD TABLE OF zagr_users,
      lt_zuse_gen_da      TYPE STANDARD TABLE OF zuse_gen_da,
      lt_rep_usuario      TYPE TABLE OF ty_rep1,
      lt_rep_usuario_hor  TYPE TABLE OF ty_rep2.
