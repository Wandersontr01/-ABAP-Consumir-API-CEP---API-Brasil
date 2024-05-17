*&---------------------------------------------------------------------*
*& Include          ZCONSOME_API_CEP_TOP
*&---------------------------------------------------------------------*
  TYPES: BEGIN OF ty_response,
           cep          TYPE c LENGTH 8,
           state        TYPE c LENGTH 2,
           city         TYPE string,
           neighborhood TYPE string,
           street       TYPE string,
           service      TYPE string,
         END OF ty_response.

  DATA gs_response TYPE ty_response.


  DATA: gv_url           TYPE string,
        gv_url_method    TYPE string,
        gv_proxy_host    TYPE string,
        gv_proxy_service TYPE string,
        gv_body          TYPE string,
        gv_param_name    TYPE string,
        gv_param_value   TYPE string,
        gv_erro          TYPE string,
        gv_http_code     TYPE i,
        gv_http_reason   TYPE string,

        gt_dados         TYPE TABLE OF ztb_cep_res_wfg,
        gt_fieldcat      TYPE slis_t_fieldcat_alv.


  DATA: go_http_client TYPE REF TO if_http_client,
        gv_response    TYPE string.