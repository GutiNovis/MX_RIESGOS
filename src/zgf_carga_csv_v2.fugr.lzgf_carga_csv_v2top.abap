FUNCTION-POOL zgf_carga_csv_v2.             "MESSAGE-ID ..

* INCLUDE LZGF_CARGA_CSV_V2D...              " Local class definition

*DATA: out_alias        TYPE STANDARD TABLE OF  zbc_alias,
*      out_trx          LIKE  zbc_trxs,
*      out_1251         LIKE  zbc_1251,
*      out_1252         LIKE  zbc_1252,
*      out_rol_agr_pr   LIKE  zbc_rol_agr_pr,
*      out_rol_agr_de   LIKE  zbc_rol_agr_de,
*      out_use_gen_da   LIKE  zbc_rol_agr_da,
*      out_use_total    LIKE  zbc_use_total,
*      out_rol_agr_text LIKE  zagr_texts.

DATA: wa_agr_users  TYPE zagr_users,
      wa_agr_define TYPE zagr_define,
      wa_agr_1251   TYPE zagr_1251,
      wa_agr_texts  TYPE zagr_texts,
      wa_use_gen_da TYPE zuse_gen_da,
      wa_agr_1252   TYPE zagr_1252,
      wa_tstct      TYPE ztstct,
      wa_agr_agrs   TYPE zagr_agrs,
      wa_tobj       TYPE ztobj.

DATA: ti_agr_users  TYPE TABLE OF zagr_users,
      ti_agr_define TYPE TABLE OF zagr_define,
      ti_agr_1251   TYPE TABLE OF zagr_1251,
      ti_agr_texts  TYPE TABLE OF zagr_texts,
      ti_use_gen_da TYPE TABLE OF zuse_gen_da,
      ti_agr_1252   TYPE TABLE OF zagr_1252,
      ti_tstct      TYPE TABLE OF ztstct,
      ti_agr_agrs   TYPE TABLE OF zagr_agrs,
      ti_tobj       TYPE TABLE OF ztobj.
