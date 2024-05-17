*&---------------------------------------------------------------------*
*& Report ZCONSOME_API_CEP
*&---------------------------------------------------------------------*
*& ALV Clientes WFG
*&
*& Wanderson Franca
*& https://www.linkedin.com/in/wandersonfg/
*&
*& O programa pesquisa CEP consumindo API do API Brasil
*&---------------------------------------------------------------------*
REPORT zconsome_api_cep.


INCLUDE: zconsome_api_cep_top,
         zconsome_api_cep_src,
         zconsome_api_cep_f01.


*--------------------------------------------------------------------*
* Execuçao
*--------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_monta_parametros.
  PERFORM f_chama_api.
  PERFORM f_deserialize.
  PERFORM f_display_response.

END-OF-SELECTION.