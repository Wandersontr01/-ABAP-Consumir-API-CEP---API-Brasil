*&---------------------------------------------------------------------*
*& Include          ZCONSOME_API_CEP_SRC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_cep    TYPE c            LENGTH 8 OBLIGATORY LOWER CASE DEFAULT '29010935'.

  SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK b2.