*&---------------------------------------------------------------------*
*&  Include           Z_REPORTE_E01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN.

  CASE sscrfields.
    WHEN 'F11'.
*      PERFORM mostrar_monitor.
*    WHEN 'F02'.
*      IF p_cb_usu = 'X' AND p_cb_rol = 'X'.
*        MESSAGE e001(pn) WITH 'Debe seleccionar una opción o ninguna (no ambas)'.
*      ENDIF.
*      PERFORM mostrar_reporte_roles.
  ENDCASE.

INITIALIZATION.
  title1    = 'Datos generales'.
  title2_1  = 'Selección de datos AGR_1251'.
  title2_2  = 'Selección de datos USR02'.
  title3    = 'Análisis de riesgo'.
  title4    = 'Tipo de análisis'.
  title5    = 'Status de usuario'.
*  titlex  = 'Ruta de archivos para analizar'.
  title6    = 'Monitor de análisis'.
  but1 = 'Ir al monitor'.
  but2 = 'Mantenedor de reglas.'.

START-OF-SELECTION.

  PERFORM get_risk.
  PERFORM get_data.
  CASE 'X'.
    WHEN p_cb_rt.
    WHEN p_cb_sf.
      CASE 'X'.
        WHEN p_cb_rol.
        WHEN p_cb_per.
        WHEN p_cb_usu.
          CASE 'X'.
            WHEN vista_h.
              PERFORM analisis_sod_usuario_horiz.
            WHEN vista_v.
              PERFORM analisis_sod_usuario.
            WHEN OTHERS.
          ENDCASE.
        WHEN p_cb_ocr.
        WHEN OTHERS.
      ENDCASE.
    WHEN OTHERS.
  ENDCASE.


END-OF-SELECTION.

  CASE 'X'.
    WHEN vista_h.
      IF lt_rep_usuario_hor[] IS NOT INITIAL.
        PERFORM display_alv_1 USING lt_rep_usuario_hor[] p_cb_usu p_cb_rol.
      ELSE.
        MESSAGE 'No se encontraron coincidencias' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF..
    WHEN vista_v.
      IF lt_rep_usuario[] IS NOT INITIAL.
        PERFORM display_alv_1 USING lt_rep_usuario[] p_cb_usu p_cb_rol.
      ELSE.
        MESSAGE 'No se encontraron coincidencias' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF..
    WHEN OTHERS.
  ENDCASE.
