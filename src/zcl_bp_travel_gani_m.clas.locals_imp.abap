CLASS lhc_zi_travel_gani_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_gani_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_gani_m RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_gani_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_gani_m~copytravel.

    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_gani_m~recalctotalprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_gani_m~rejecttravel RESULT result.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_gani_m\_booking.


    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_gani_m.

ENDCLASS.

CLASS lhc_zi_travel_gani_m IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*           ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
               quantity          = CONV #( lines( lt_entities ) )
*           subobject         =
*           toyear            =
             IMPORTING
               number            = DATA(lv_latest_num)
               returncode        = DATA(lv_code)
               returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid = ls_entities-%cid %key = ls_entities-%key ) TO failed-zi_travel_gani_m.
          APPEND VALUE #( %cid = ls_entities-%cid %key = ls_entities-%key %msg = lo_error  ) TO reported-zi_travel_gani_m.
        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).

*    DATA:lt_travel_tech_m TYPE TABLE FOR MAPPED EARLY zi_travel_gani_m,
*         ls_travel_tech_m LIKE LINE OF lt_travel_tech_m.

    DATA(lv_curr_num) = lv_latest_num - lv_qty.

    LOOP AT lt_entities INTO ls_entities.
      lv_curr_num = lv_curr_num + 1.
*      ls_travel_tech_m = VALUE #( %cid = ls_entities-%cid TravelId = lv_curr_num ).
*      APPEND ls_travel_tech_m TO mapped-zi_travel_gani_m.
      APPEND VALUE #( %cid = ls_entities-%cid TravelId = lv_curr_num ) TO mapped-zi_travel_gani_m.
    ENDLOOP.



  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA: lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travel_gani_m
    IN LOCAL MODE
    ENTITY zi_travel_gani_m BY \_Booking
    FROM CORRESPONDING #(  entities )
    LINK  DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group>) GROUP BY <ls_group>-TravelId.

      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                       FOR ls_link IN lt_link_data USING KEY entity
                                       WHERE ( source-TravelId = <ls_group>-TravelId )
                                       NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                            THEN ls_link-target-BookingId
                                                                            ELSE lv_max  ) ).
      lv_max_booking = REDUCE #( INIT lv_max =  lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity
                                  WHERE ( TravelId = <ls_group>-TravelId )
                                  FOR ls_booking IN ls_entity-%target
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                            THEN ls_booking-BookingId
                                                                            ELSE lv_max  ) ).
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity WHERE TravelId = <ls_group>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.
            APPEND  CORRESPONDING #( <ls_booking> ) TO  mapped-zi_booking_gani_m ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
            <ls_new_map_book>-BookingId = lv_max_booking.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

  METHOD acceptTravel.
  ENDMETHOD.

  METHOD copyTravel.
  ENDMETHOD.

  METHOD recalcTotalPrice.
  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

ENDCLASS.
