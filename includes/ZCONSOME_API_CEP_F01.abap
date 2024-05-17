*&---------------------------------------------------------------------*
*& Include          ZCONSOME_API_CEP_F01
*&---------------------------------------------------------------------*

FORM f_monta_parametros .
* Parametrização da Interface (Chamada HTTP)
  gv_url           = 'https://brasilapi.com.br/api/cep/v1/' && p_cep.
  gv_url_method    = 'GET'.

ENDFORM. "f_montar parametros

*&---------------------------------------------------------------------*
*& Form f_chama_api
*&---------------------------------------------------------------------*
*& Chama API Brasil
*&---------------------------------------------------------------------*
FORM f_chama_api .

  DO 1 TIMES.

*-----------------------------------------------------------------------------------------*
* Instanciar Objeto HTTP
*-----------------------------------------------------------------------------------------*
    "// Create HTTP client by url
    CALL METHOD cl_http_client=>create_by_url
      EXPORTING
        url                = gv_url
        proxy_host         = gv_proxy_host
        proxy_service      = gv_proxy_service
      IMPORTING
        client             = go_http_client
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4.

    IF sy-subrc IS NOT INITIAL.
      gv_erro = |Erro na funcionalidade CREATE_BY_URL. Subrc: { sy-subrc }|.
      EXIT. " sai do DO..
    ENDIF.

    "// Setting request method
    go_http_client->request->set_method( gv_url_method ).

    "// Adding Body
    CALL METHOD go_http_client->request->set_cdata
      EXPORTING
        data = gv_body.


*-----------------------------------------------------------------------------------------*
* // Envio das Informações ao destino HTTP
*-----------------------------------------------------------------------------------------*
    "// Send data By Http
    CALL METHOD go_http_client->send
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5.

    "// Get reveice from Http
    IF sy-subrc IS INITIAL.
      CALL METHOD go_http_client->receive
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 5.

      IF sy-subrc <> 0.
        gv_erro = |Erro na funcionalidade HTTP_CLIENT->RECEIVE. Subrc: { sy-subrc }|.

        CALL METHOD go_http_client->get_last_error
          IMPORTING
            code    = DATA(gv_codgv_erro)
            message = DATA(gv_messaggv_erro).

        IF gv_messaggv_erro IS NOT INITIAL.
          gv_erro = |{ gv_erro } { gv_codgv_erro } { gv_messaggv_erro }|.
        ENDIF.

        EXIT. " sai do DO..
      ENDIF.

    ELSE.
      gv_erro = |Erro na funcionalidade HTTP_CLIENT->SEND. Subrc: { sy-subrc }|.
      EXIT. " sai do DO..
    ENDIF.

    "// Get Body from Http response
    gv_response = go_http_client->response->get_cdata( ).

    "// Get HTTP Response
    CALL METHOD go_http_client->response->get_status
      IMPORTING
        code   = gv_http_code       " HTTP Status Code
        reason = gv_http_reason.    " HTTP status description

  ENDDO.

  " Check if HTTPs code start with '2' (200,201,202..)
  IF gv_http_code IS NOT INITIAL AND NOT gv_http_code BETWEEN 200 AND 299.
    gv_erro = |{ gv_erro } Erro técnico HTTP. Code: { gv_http_code }-{ gv_http_reason }|.
  ENDIF.

  SHIFT gv_erro LEFT DELETING LEADING space.

  "// Close Connection
  IF go_http_client IS NOT INITIAL.
    go_http_client->close(
                EXCEPTIONS
                  http_invalid_state = 1
                  OTHERS             = 2
    ).
  ENDIF.
ENDFORM. "f_chama_api

FORM f_deserialize.
  /ui2/cl_json=>deserialize( EXPORTING json = gv_response
                                       pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                              CHANGING data = gs_response ).
ENDFORM. "f_deserialize


FORM f_display_response.

  WRITE:/ 'Cep: ',            gs_response-cep,
        / 'Estado',           gs_response-state,
        / 'Cidade',           gs_response-city,
        / 'Bairro',           gs_response-neighborhood,
        / 'Rua / Avenida: ',  gs_response-street.

ENDFORM. "f_display_response