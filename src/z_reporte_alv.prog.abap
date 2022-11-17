*----------------------------------------------------------------------*
***INCLUDE Z_REPORTE_ALV.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv_1 USING ut_table TYPE ANY TABLE p_cb_usu p_cb_rol.

  DATA: lr_table       TYPE REF TO cl_salv_table,
        lr_sorts       TYPE REF TO cl_salv_sorts,
        lr_layout      TYPE REF TO cl_salv_layout,
        ls_key         TYPE salv_s_layout_key,
        lr_layout_grid TYPE REF TO cl_salv_form_layout_grid.

  DEFINE set_texts.
    lr_table->get_columns( )->get_column( &1 )->set_short_text( &2 ).
    lr_table->get_columns( )->get_column( &1 )->set_medium_text( &3 ).
    lr_table->get_columns( )->get_column( &1 )->set_long_text( &4 ).
  END-OF-DEFINITION.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = lr_table
        CHANGING
          t_table      = ut_table.

*Activar funciones ALV
*Set Status gui
*      lr_table->set_screen_status( pfstatus      = 'SALV_TABLE_STANDARD'
*                                   report        = sy-repid
*                                   set_functions = lr_table->c_functions_all ).
*Activar funciones ALV
      lr_table->get_functions( )->set_all( ).
*Activar variantes
      ls_key-report = sy-repid.
      ls_key-handle = 'MAIN'.
      lr_table->get_layout( )->set_key( ls_key ).
      lr_table->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
      lr_table->get_layout( )->set_default( abap_true ).

*Optimizar ancho columnas
      lr_table->get_columns( )->set_optimize( abap_true ).
      lr_sorts = lr_table->get_sorts( ).
      lr_sorts->add_sort( 'RIESGO' ).

*Setear textos columnas
      IF p_cb_usu = 'X'.
*        set_texts: 'ID_ANALISIS'                  'I.A'  'Id A' 'Id Análisis',
*               'VERSION'           'Ver.'  'Versión' 'Versión',
*               'MANDANTE'                'Mnt.'  'Mand' 'Mandante',
*               'ID_SISTEMA'           'I.S'  'Id. Sis.'  'Id sistema',
*               'AMBIENTE'           'Amb'  'Ambt.'  'Ambiente',
*               'NOM_SIST'           'N.S.'  'Nom. Sis.'  'Nombre sistema',
*               'SISTEMA'           'T.S.'  'Tipo S.'  'Tipo sistema',
*               'BNAME'           'N.U.'  'Nom.Us.'  'Usuario',
*               'USERALIAS'           'Alias'  'Alias'  'Alias',
*               'ROL'           'Rol'  'Rol'  'Rol',
*               'PERSNUM'           'P.N'  'Pers.Num.'  'Pers.Num.',
*               'NAME_LAST'           'N.'  'Nombre'  'Nombre',
*               'NAME_TEXT'           'N.'  'Nom.Txt.'  'Texto nombre',
*               'MC_NAME_FIRST'           'NF'  'Name first'  'Name first',
*               'MC_NAME_LAST'           'N.L'  'Name last'  'Name last',
*               'SEMAFORO'           'Icon'  'Icon'  'Icon',
*               'RIESGO'           'I.R.'  'Id Riesgo'  'Id riesgo',
*               'UFLAG'           'flag'  'flag'  'flag',
*               'OBJETO'           'Obj'  'Objt.'  'Objeto',
*               'NIVEL' 'Obj'  'Objt.'  'Objeto',
*                'OBJVALUEFROM' 'OVD'  'Objt.'  'Objeto',
*                'OBJVALUETO'  'OVH'  'Objt.'  'Objeto',
*                'CONDICION'    'Cond'  'Objt.'  'Objeto',
*                'STATUS'   'Stat'  'Objt.'  'Objeto',
*                'PROCESS_GRC_AC1'  'GRC1'  'Objt.'  'Objeto',
*                'PROCESS_GRC_AC2'  'GRC2'  'Objt.'  'Objeto',
*                'PROCESS_GRC_AC3'  'GRC3'  'Objt.'  'Objeto',
*                'PROCESS_GRC_AC4'  'GRC4'  'Objt.'  'Objeto',
*                'PROCESS_GRC_AC5'  'GRC5'  'Objt.'  'Objeto',
*                'PROCESS_GRC_AC'  'GRC'  'Objt.'  'Objeto'.

      ENDIF.
      IF p_cb_rol = 'X'.
        lr_table->get_columns( )->get_column( 'BNAME' )->set_visible( space ).
        lr_table->get_columns( )->get_column( 'PERSNUM' )->set_visible( space ).
        lr_table->get_columns( )->get_column( 'NAME_LAST' )->set_visible( space ).
        lr_table->get_columns( )->get_column( 'NAME_TEXT' )->set_visible( space ).
        lr_table->get_columns( )->get_column( 'MC_NAME_FIRST' )->set_visible( space ).
        lr_table->get_columns( )->get_column( 'MC_NAME_LAST' )->set_visible( space ).
        lr_table->get_columns( )->get_column( 'UFLAG' )->set_visible( space ).
        set_texts: 'ID_ANALISIS'                  'I.A'  'Id A' 'Id Análisis',
               'VERSION'           'Ver.'  'Versión' 'Versión',
               'MANDANTE'                'Mnt.'  'Mand' 'Mandante',
               'ID_SISTEMA'           'I.S'  'Id. Sis.'  'Id sistema',
               'AMBIENTE'           'Amb'  'Ambt.'  'Ambiente',
               'NOM_SIST'           'N.S.'  'Nom. Sis.'  'Nombre sistema',
               'SISTEMA'           'T.S.'  'Tipo S.'  'Tipo sistema',
               'ROL'           'Rol'  'Rol'  'Rol',
               'SEMAFORO'           'Icon'  'Icon'  'Icon',
               'OBJETO'           'Obj'  'Objt.'  'Objeto'.
      ENDIF.

*Set Top of list
*      CREATE OBJECT lr_layout_grid.
*      lr_layout_grid->create_flow( row = 1  column = 1 )->create_label( text = text-t01 ).
*      lr_layout_grid->create_flow( row = 1  column = 2 )->create_text( text = sy-datum ).
*      lr_layout_grid->create_flow( row = 2  column = 1 )->create_label( text = text-t02 ).
*      lr_layout_grid->create_flow( row = 2  column = 2 )->create_text( text = sy-uname ).
*      lr_layout_grid->create_flow( row = 3  column = 1 )->create_label( text = text-t03 ).
*      lr_layout_grid->create_flow( row = 3  column = 2 )->create_text( text = lines( ut_table ) ).
*      lr_table->set_top_of_list( lr_layout_grid ).

      lr_table->display( ).

    CATCH cx_salv_msg .
      EXIT.
    CATCH cx_salv_not_found .
      EXIT.
  ENDTRY.

ENDFORM.
