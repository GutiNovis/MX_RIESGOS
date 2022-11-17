*&---------------------------------------------------------------------*
*&  Include           Z_REPORTE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_RISK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_risk .
  " Tabla de riesgos standar
  SELECT *
    FROM zbase_risks
    INTO TABLE lt_zbase_risks.
*    IF " algun flag para revisar por riegos Z.
  " Tabla de riesgos Z
  SELECT *
    FROM zbase_risks_z
    APPENDING TABLE lt_zbase_risks.
*    into TABLE lt_zbase_risks_z.
*    ENDIF.
  " Tabla de textos de riesgo
  SELECT *
    FROM zrisks_t
    INTO TABLE lt_zrisks_t.
  " Tabla de textos de funciones
  SELECT *
    FROM zfunction_t
    INTO TABLE lt_zfunction_t.

  SELECT *
    FROM zbase_function
    INTO TABLE lt_zbase_function.

  SELECT *
    FROM zbusiness_proc_t
    INTO TABLE lt_zbusiness_proc_t.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM zuse_gen_da
    INTO TABLE lt_zuse_gen_da
    WHERE bname IN s_user
      AND ustyp IN s_ustyp.

  SELECT *
    FROM zagr_users
    INTO TABLE lt_zagr_users
  WHERE uname IN s_user.

  SELECT *
    FROM zagr_1251
    INTO TABLE lt_zagr_1251
    WHERE agr_name IN s_agr
      AND object EQ 'S_TCODE'.

  SELECT *
    FROM zagr_1252
    INTO TABLE lt_zagr_1252
    WHERE agr_name IN s_agr.

*  SELECT *
*    FROM ztb_itab
*    INTO TABLE lt_ztb_itab.
**    WHERE agr_name IN s_agr.




*
*  SELECT *
*    FROM ztb_1251
*    INTO TABLE lt_ztb_1251
*    WHERE agr_name IN s_agr.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ANALISIS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM analisis_sod_usuario.
  LOOP AT lt_zuse_gen_da INTO DATA(wa_zuse_gen_da)." USUARIOS
    LOOP AT lt_zagr_users INTO DATA(wa_zagr_users) WHERE uname EQ wa_zuse_gen_da-bname. " Roles - Usuarios

      SORT lt_zagr_1251 BY low.
      DELETE ADJACENT DUPLICATES FROM lt_zagr_1251 COMPARING low.

      LOOP AT lt_zagr_1251 INTO DATA(wa_zagr_1251) WHERE agr_name EQ wa_zagr_users-agr_name " Roles - TX
                                                     AND object EQ 'S_TCODE'.

        READ TABLE lt_zbase_function INTO DATA(wa_zbase_function) WITH KEY tcode = wa_zagr_1251-low." Obtener datos de la función asociada a la TX
        IF sy-subrc EQ 0.
*          LOOP AT lt_zbase_risks INTO DATA(wa_zbase_risks) WHERE process_grc_ac01 = wa_zbase_function-process_grc_ac01. " Obtener datos del riesgo asociado a la función
*            IF wa_zbase_risks-process_grc_ac02 IS NOT INITIAL.
*
*            ENDIF.
*            READ TABLE
          APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario>).
          <fs_rep_usuario>-id_sistema = p_sist.
          <fs_rep_usuario>-id_user = wa_zuse_gen_da-bname.
          <fs_rep_usuario>-nombre = wa_zuse_gen_da-mc_name_first.
          <fs_rep_usuario>-apellido = wa_zuse_gen_da-mc_name_last.
          <fs_rep_usuario>-tipo_user = wa_zuse_gen_da-ustyp.
          <fs_rep_usuario>-grupo_user = wa_zuse_gen_da-class.
          <fs_rep_usuario>-fecha_ini = wa_zuse_gen_da-gltgv.
          <fs_rep_usuario>-fecha_fin = wa_zuse_gen_da-gltgb.
          <fs_rep_usuario>-accion_tx = wa_zagr_1251-low.
*            <fs_rep_usuario>-riesgo = wa_zbase_risks-riesgo.
          <fs_rep_usuario>-funcion = wa_zbase_function-process_grc_ac01.
*          ENDLOOP.

        ENDIF.
*        <fs_rep_usuario>-apellido = wa_zuse_gen_da-mc_name_last.
*        <fs_rep_usuario>-apellido = wa_zuse_gen_da-mc_name_last.
      ENDLOOP.
    ENDLOOP.

    " se lee el proceso de negocio
*    READ TABLE lt_zbusiness_proc_t INTO DATA(wa_zbusiness_proc_t) WITH KEY process_grc = <fs_zbase_risks>-process_grc
*                                                                           spras = p_langu.
  ENDLOOP.
  SORT lt_rep_usuario BY funcion.
  " Busqueda de riesgos
  LOOP AT lt_rep_usuario ASSIGNING <fs_rep_usuario>. " WHERE ok IS INITIAL.

    DATA(lv_tabix) = sy-tabix.

    LOOP AT lt_zbase_risks INTO DATA(wa_zbase_risks) WHERE process_grc_ac01 EQ <fs_rep_usuario>-funcion.
      IF wa_zbase_risks-process_grc_ac02 IS NOT INITIAL.
        LOOP AT lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq2>) WHERE id_user = <fs_rep_usuario>-id_user
                                                                    AND funcion = wa_zbase_risks-process_grc_ac02.
*                                                                    AND ok IS INITIAL.
*        READ TABLE lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq2>) WITH KEY funcion = wa_zbase_risks-process_grc_ac02                                                                             .
*        IF sy-subrc EQ 0.
          DATA(flag) = ''.
          IF wa_zbase_risks-process_grc_ac03 IS NOT INITIAL.
            flag = 'X'.
            LOOP AT lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq3>) WHERE id_user = <fs_rep_usuario>-id_user
                                                                        AND funcion = wa_zbase_risks-process_grc_ac03.
*                                                                        AND ok IS INITIAL.
*            READ TABLE lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq3>) WITH KEY funcion = wa_zbase_risks-process_grc_ac03.
*            IF sy-subrc EQ 0.
              flag = ''.
*              <fs_rep_usuario>-riesgo = wa_zbase_risks-riesgo.
*              <fs_rep_usuario>-ok = 'X'.

              <fs_busq3>-proc_neg = wa_zbase_risks-process_grc.
              <fs_busq3>-riesgo = wa_zbase_risks-riesgo.
              <fs_busq3>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
*              <fs_busq3>-ok = 'X'.
*            ENDIF.
            ENDLOOP.
          ENDIF.
          IF flag IS INITIAL.
            <fs_rep_usuario>-proc_neg = wa_zbase_risks-process_grc.
            <fs_rep_usuario>-riesgo = wa_zbase_risks-riesgo.
            <fs_rep_usuario>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
            <fs_rep_usuario>-ok = 'X'.

            <fs_busq2>-proc_neg = wa_zbase_risks-process_grc.
            <fs_busq2>-riesgo = wa_zbase_risks-riesgo.
            <fs_busq2>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
*            <fs_busq2>-ok = 'X'.
            LOOP AT lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq1>) WHERE id_user = <fs_rep_usuario>-id_user
                                                                        AND funcion EQ <fs_rep_usuario>-funcion.
*                                                                        AND ok IS INITIAL.
              <fs_busq1>-proc_neg = wa_zbase_risks-process_grc.
              <fs_busq1>-riesgo = wa_zbase_risks-riesgo.
              <fs_busq1>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
*              <fs_busq1>-ok = 'X'.
            ENDLOOP.
          ENDIF.
*        ENDIF.
        ENDLOOP.
      ENDIF.
*    IF lv_tabix NE 4.
*      DELETE lt_rep_usuario INDEX lv_tabix.
*
*    ENDIF.
    ENDLOOP.
  ENDLOOP.
  " Eliminar registros sin riesgos, y por nivel de riesgo
  IF lt_rep_usuario[] IS NOT INITIAL.
    DELETE lt_rep_usuario WHERE riesgo IS INITIAL.
    IF p_cb_baj IS INITIAL
      AND lt_rep_usuario[] IS NOT INITIAL.
      DELETE lt_rep_usuario WHERE nivel_riesgo = '2'.
    ENDIF.
    IF p_cb_med IS INITIAL
      AND lt_rep_usuario[] IS NOT INITIAL.
      DELETE lt_rep_usuario WHERE nivel_riesgo = '0'.
    ENDIF.
    IF p_cb_alt IS INITIAL
      AND lt_rep_usuario[] IS NOT INITIAL.
      DELETE lt_rep_usuario WHERE nivel_riesgo = '1'.
    ENDIF.
    IF p_cb_cri IS INITIAL
      AND lt_rep_usuario[] IS NOT INITIAL.
      DELETE lt_rep_usuario WHERE nivel_riesgo = '3'.
    ENDIF.
  ENDIF.
  " Completar información final
  LOOP AT lt_rep_usuario ASSIGNING <fs_rep_usuario>.
    READ TABLE lt_zbusiness_proc_t INTO DATA(wa_zbusiness_proc_t) WITH KEY process_grc = <fs_rep_usuario>-proc_neg
                                                                           spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-proc_neg = wa_zbusiness_proc_t-process_grc.
      <fs_rep_usuario>-desc_proc_neg = wa_zbusiness_proc_t-descripcion.
    ENDIF.
    READ TABLE lt_zrisks_t INTO DATA(wa_zrisks_t) WITH KEY riesgo = <fs_rep_usuario>-riesgo
                                                           spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-desc_riesgo = wa_zrisks_t-descripcion.
    ENDIF.
    READ TABLE lt_zfunction_t INTO DATA(wa_zfunction_t) WITH KEY funcion = <fs_rep_usuario>-funcion
                                                                 spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-desc_funcion = wa_zfunction_t-descripcion.
    ENDIF.
    CASE <fs_rep_usuario>-nivel_riesgo.
      WHEN '0'. " Medio
        <fs_rep_usuario>-indic_riesgo = '@5D@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'Medium'.
      WHEN '1'. " Alto
        <fs_rep_usuario>-indic_riesgo = '@5C@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'High'.
      WHEN '2'. " Bajo
        <fs_rep_usuario>-indic_riesgo = '@ED@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'Low'.
      WHEN '3'. " Critico
        <fs_rep_usuario>-indic_riesgo = '@1B@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'Critical'.
      WHEN OTHERS.
        <fs_rep_usuario>-indic_riesgo = '@0S@'.
    ENDCASE.
    <fs_rep_usuario>-tip_riesgo = '1'.
    <fs_rep_usuario>-d_tip_riesgo = 'Segregación de Funciones'.
  ENDLOOP.

  " se recorren los riesgos
*  LOOP AT lt_zbase_risks ASSIGNING <fs_zbase_risks>.
**    APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario>).
**    <fs_rep_usuario>-id_sistema = p_sist.
**    " se lee el proceso de negocio
**    READ TABLE lt_zbusiness_proc_t INTO DATA(wa_zbusiness_proc_t) WITH KEY process_grc = <fs_zbase_risks>-process_grc
**                                                                           spras = p_langu.
**    IF sy-subrc EQ 0.
**      <fs_rep_usuario>-proc_neg = wa_zbusiness_proc_t-process_grc.
**      <fs_rep_usuario>-desc_proc_neg = wa_zbusiness_proc_t-descripcion.
**    ENDIF.
**    <fs_rep_usuario>-riesgo = <fs_zbase_risks>-riesgo.
**    <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac01.
**    APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario2>).
**    MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario2>.
**    <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac02.
**    IF <fs_zbase_risks>-process_grc_ac03 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario3>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario3>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac03.
**    ENDIF.
**    IF <fs_zbase_risks>-process_grc_ac04 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario4>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario4>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac04.
**    ENDIF.
**    IF <fs_zbase_risks>-process_grc_ac05 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario5>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario5>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac05.
**    ENDIF.
**    IF <fs_zbase_risks>-process_grc_ac06 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario6>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario6>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac06.
**    ENDIF.
**
**    SORT lt_rep_usuario BY riesgo funcion.
**
**
**
**
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ANALISIS_SOD_USUARIO_HORIZ
*&---------------------------------------------------------------------*
FORM analisis_sod_usuario_horiz .
  " Se recorre la tabla una vez para completar con Tx y usuarios
  " Se establecen las funciones a partir de las Tx.
  LOOP AT lt_zuse_gen_da INTO DATA(wa_zuse_gen_da)." USUARIOS
    LOOP AT lt_zagr_users INTO DATA(wa_zagr_users) WHERE uname EQ wa_zuse_gen_da-bname. " Roles - Usuarios

      SORT lt_zagr_1251 BY low.
      DELETE ADJACENT DUPLICATES FROM lt_zagr_1251 COMPARING low.

      LOOP AT lt_zagr_1251 INTO DATA(wa_zagr_1251) WHERE agr_name EQ wa_zagr_users-agr_name " Roles - TX
                                                     AND object EQ 'S_TCODE'.

        READ TABLE lt_zbase_function INTO DATA(wa_zbase_function) WITH KEY tcode = wa_zagr_1251-low." Obtener datos de la función asociada a la TX
        IF sy-subrc EQ 0.
*          LOOP AT lt_zbase_risks INTO DATA(wa_zbase_risks) WHERE process_grc_ac01 = wa_zbase_function-process_grc_ac01. " Obtener datos del riesgo asociado a la función
*            IF wa_zbase_risks-process_grc_ac02 IS NOT INITIAL.
*
*            ENDIF.
*            READ TABLE
          APPEND INITIAL LINE TO lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_rep_usuario>).
          <fs_rep_usuario>-id_sistema = p_sist.
          <fs_rep_usuario>-id_user = wa_zuse_gen_da-bname.
          <fs_rep_usuario>-nombre = wa_zuse_gen_da-mc_name_first.
          <fs_rep_usuario>-apellido = wa_zuse_gen_da-mc_name_last.
          <fs_rep_usuario>-tipo_user = wa_zuse_gen_da-ustyp.
          <fs_rep_usuario>-grupo_user = wa_zuse_gen_da-class.
          <fs_rep_usuario>-fecha_ini = wa_zuse_gen_da-gltgv.
          <fs_rep_usuario>-fecha_fin = wa_zuse_gen_da-gltgb.
          <fs_rep_usuario>-accion_tx_1 = wa_zagr_1251-low.
*            <fs_rep_usuario>-riesgo = wa_zbase_risks-riesgo.
          <fs_rep_usuario>-funcion_1 = wa_zbase_function-process_grc_ac01.
*          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " se lee el proceso de negocio
*    READ TABLE lt_zbusiness_proc_t INTO DATA(wa_zbusiness_proc_t) WITH KEY process_grc = <fs_zbase_risks>-process_grc
*                                                                           spras = p_langu.
  ENDLOOP.
  SORT lt_rep_usuario_hor BY funcion_1.
  " Busqueda de riesgos
  LOOP AT lt_rep_usuario_hor ASSIGNING <fs_rep_usuario>." WHERE ok IS INITIAL.

    DATA(lv_tabix) = sy-tabix.
    " Recorre la tabla de riesgos
    LOOP AT lt_zbase_risks INTO DATA(wa_zbase_risks) WHERE process_grc_ac01 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac02 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac03 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac04 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac05 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac06 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac07 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac08 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac09 EQ <fs_rep_usuario>-funcion_1
                                                        OR process_grc_ac10 EQ <fs_rep_usuario>-funcion_1.
      IF wa_zbase_risks-process_grc_ac02 IS NOT INITIAL.
        " Se busca un segundo registro con la misma función
        LOOP AT lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_busq2>) WHERE id_user = <fs_rep_usuario>-id_user
                                                                        AND funcion_1 = wa_zbase_risks-process_grc_ac02.


*        READ TABLE lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_busq2>) WITH KEY id_user = <fs_rep_usuario>-id_user
*                                                                                  funcion_1 = wa_zbase_risks-process_grc_ac02.
*        IF sy-subrc EQ 0.
          IF <fs_rep_usuario>-funcion_1 NE <fs_busq2>-funcion_1.
*        LOOP AT lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_busq2>) WHERE id_user = <fs_rep_usuario>-id_user
*                                                                        AND funcion_1 = wa_zbase_risks-process_grc_ac02.
            " AND ok IS INITIAL.
*        READ TABLE lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq2>) WITH KEY funcion = wa_zbase_risks-process_grc_ac02                                                                             .
*        IF sy-subrc EQ 0.
            DATA(flag) = ''. " Se establece una variable para determinar un error
            IF wa_zbase_risks-process_grc_ac03 IS NOT INITIAL.
              flag = 'X'." tiene 3ra función, se debe validar si el registro de salida la posee.
              READ TABLE lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_busq3>) WITH KEY id_user = <fs_rep_usuario>-id_user
                                                                                        funcion_1 = wa_zbase_risks-process_grc_ac03.
              IF sy-subrc EQ 0.
*          LOOP AT lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_busq3>) WHERE id_user = <fs_rep_usuario>-id_user
*                                                                          AND funcion_1 = wa_zbase_risks-process_grc_ac03.
                " AND ok IS INITIAL.
*            READ TABLE lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_busq3>) WITH KEY funcion = wa_zbase_risks-process_grc_ac03.
*            IF sy-subrc EQ 0.
                flag = ''.
*              <fs_rep_usuario>-riesgo = wa_zbase_risks-riesgo.
                <fs_rep_usuario>-funcion_3 = <fs_busq3>-funcion_1.
                <fs_rep_usuario>-accion_tx_3 = <fs_busq3>-accion_tx_1.
*                <fs_rep_usuario>-ok = 'X'.

*              <fs_busq3>-proc_neg = wa_zbase_risks-process_grc.
*              <fs_busq3>-riesgo = wa_zbase_risks-riesgo.
*              <fs_busq3>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
                <fs_busq3>-ok = 'X'.
              ENDIF.
*          ENDLOOP.
            ENDIF.
            IF flag IS INITIAL.
              <fs_rep_usuario>-proc_neg = wa_zbase_risks-process_grc.
              <fs_rep_usuario>-riesgo = wa_zbase_risks-riesgo.
              <fs_rep_usuario>-funcion_2 = <fs_busq2>-funcion_1.
              <fs_rep_usuario>-accion_tx_2 = <fs_busq2>-accion_tx_1.
              <fs_rep_usuario>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
              <fs_rep_usuario>-ok = 'X'.

***            <fs_busq2>-proc_neg = wa_zbase_risks-process_grc.
***            <fs_busq2>-riesgo = wa_zbase_risks-riesgo.
***            <fs_busq2>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
***            <fs_busq2>-ok = 'X'.
***            LOOP AT lt_rep_usuario_hor ASSIGNING FIELD-SYMBOL(<fs_busq1>) WHERE id_user = <fs_rep_usuario>-id_user
***                                                                            AND funcion_1 EQ <fs_rep_usuario>-funcion_1.
***              " AND ok IS INITIAL.
***              <fs_busq1>-proc_neg = wa_zbase_risks-process_grc.
***              <fs_busq1>-riesgo = wa_zbase_risks-riesgo.
***              <fs_busq1>-nivel_riesgo = wa_zbase_risks-nivel_riesgo.
***              <fs_busq1>-ok = 'X'.
***            ENDLOOP.
            ENDIF.
          ENDIF.
*        ENDIF.
        ENDLOOP.
      ENDIF.
*    IF lv_tabix NE 4.
*      DELETE lt_rep_usuario INDEX lv_tabix.
*
*    ENDIF.
    ENDLOOP.


  ENDLOOP.
  " Eliminar registros sin riesgos, y por nivel de riesgo
  IF lt_rep_usuario_hor[] IS NOT INITIAL.
    DELETE lt_rep_usuario_hor WHERE riesgo IS INITIAL.
    IF p_cb_baj IS INITIAL
      AND lt_rep_usuario_hor[] IS NOT INITIAL.
      DELETE lt_rep_usuario_hor WHERE nivel_riesgo = '2'.
    ENDIF.
    IF p_cb_med IS INITIAL
      AND lt_rep_usuario_hor[] IS NOT INITIAL.
      DELETE lt_rep_usuario_hor WHERE nivel_riesgo = '0'.
    ENDIF.
    IF p_cb_alt IS INITIAL
      AND lt_rep_usuario_hor[] IS NOT INITIAL.
      DELETE lt_rep_usuario_hor WHERE nivel_riesgo = '1'.
    ENDIF.
    IF p_cb_cri IS INITIAL
      AND lt_rep_usuario_hor[] IS NOT INITIAL.
      DELETE lt_rep_usuario_hor WHERE nivel_riesgo = '3'.
    ENDIF.
  ENDIF.
  " Completar información final
  LOOP AT lt_rep_usuario_hor ASSIGNING <fs_rep_usuario>.
    READ TABLE lt_zbusiness_proc_t INTO DATA(wa_zbusiness_proc_t) WITH KEY process_grc = <fs_rep_usuario>-proc_neg
                                                                           spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-proc_neg = wa_zbusiness_proc_t-process_grc.
      <fs_rep_usuario>-desc_proc_neg = wa_zbusiness_proc_t-descripcion.
    ENDIF.
    " Descripción del riesgo
    READ TABLE lt_zrisks_t INTO DATA(wa_zrisks_t) WITH KEY riesgo = <fs_rep_usuario>-riesgo
                                                           spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-desc_riesgo = wa_zrisks_t-descripcion.
    ENDIF.
    " Descripción de la función 1
    READ TABLE lt_zfunction_t INTO DATA(wa_zfunction_t) WITH KEY funcion = <fs_rep_usuario>-funcion_1
                                                                 spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-desc_funcion_1 = wa_zfunction_t-descripcion.
    ENDIF.
    READ TABLE lt_zfunction_t INTO wa_zfunction_t WITH KEY funcion = <fs_rep_usuario>-funcion_2
                                                           spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-desc_funcion_2 = wa_zfunction_t-descripcion.
    ENDIF.
    READ TABLE lt_zfunction_t INTO wa_zfunction_t WITH KEY funcion = <fs_rep_usuario>-funcion_3
                                                           spras = p_langu.
    IF sy-subrc EQ 0.
      <fs_rep_usuario>-desc_funcion_3 = wa_zfunction_t-descripcion.
    ENDIF.
    CASE <fs_rep_usuario>-nivel_riesgo.
      WHEN '0'. " Medio
        <fs_rep_usuario>-indic_riesgo = '@5D@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'Medium'.
      WHEN '1'. " Alto
        <fs_rep_usuario>-indic_riesgo = '@5C@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'High'.
      WHEN '2'. " Bajo
        <fs_rep_usuario>-indic_riesgo = '@ED@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'Low'.
      WHEN '3'. " Critico
        <fs_rep_usuario>-indic_riesgo = '@1B@'.
        <fs_rep_usuario>-d_nivel_riesgo = 'Critical'.
      WHEN OTHERS.
        <fs_rep_usuario>-indic_riesgo = '@0S@'.
    ENDCASE.
    <fs_rep_usuario>-tip_riesgo = '1'.
    <fs_rep_usuario>-d_tip_riesgo = 'Segregación de Funciones'.
  ENDLOOP.

  " se recorren los riesgos
*  LOOP AT lt_zbase_risks ASSIGNING <fs_zbase_risks>.
**    APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario>).
**    <fs_rep_usuario>-id_sistema = p_sist.
**    " se lee el proceso de negocio
**    READ TABLE lt_zbusiness_proc_t INTO DATA(wa_zbusiness_proc_t) WITH KEY process_grc = <fs_zbase_risks>-process_grc
**                                                                           spras = p_langu.
**    IF sy-subrc EQ 0.
**      <fs_rep_usuario>-proc_neg = wa_zbusiness_proc_t-process_grc.
**      <fs_rep_usuario>-desc_proc_neg = wa_zbusiness_proc_t-descripcion.
**    ENDIF.
**    <fs_rep_usuario>-riesgo = <fs_zbase_risks>-riesgo.
**    <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac01.
**    APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario2>).
**    MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario2>.
**    <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac02.
**    IF <fs_zbase_risks>-process_grc_ac03 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario3>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario3>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac03.
**    ENDIF.
**    IF <fs_zbase_risks>-process_grc_ac04 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario4>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario4>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac04.
**    ENDIF.
**    IF <fs_zbase_risks>-process_grc_ac05 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario5>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario5>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac05.
**    ENDIF.
**    IF <fs_zbase_risks>-process_grc_ac06 IS NOT INITIAL.
**      APPEND INITIAL LINE TO lt_rep_usuario ASSIGNING FIELD-SYMBOL(<fs_rep_usuario6>).
**      MOVE-CORRESPONDING <fs_rep_usuario> TO <fs_rep_usuario6>.
**      <fs_rep_usuario>-funcion = <fs_zbase_risks>-process_grc_ac06.
**    ENDIF.
**
**    SORT lt_rep_usuario BY riesgo funcion.
**
**
**
**
*  ENDLOOP.
ENDFORM.
