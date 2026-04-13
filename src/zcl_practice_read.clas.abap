CLASS zcl_practice_read DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_practice_read IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    "Short form read

*    READ ENTITY zi_travel_gani_m
*    FROM VALUE #( ( %key-TravelId = '00000075'
*                    %control = VALUE #(
*                    AgencyId = if_abap_behv=>mk-on
*                    CustomerId = if_abap_behv=>mk-on
*                    BeginDate = if_abap_behv=>mk-on
*                    )
*                 ) )
*    RESULT DATA(it_result)
*    FAILED DATA(it_failed).

*    READ ENTITY zi_travel_gani_m
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000075' ) )
*    RESULT DATA(it_result)
*    FAILED DATA(it_failed).


*    READ ENTITY zi_travel_gani_m
*    FIELDS ( AgencyId CustomerId BeginDate )
*    WITH VALUE #( ( %key-TravelId = '00000075' ) )
*    RESULT DATA(it_result)
*    FAILED DATA(it_failed).

*    READ ENTITY zi_travel_gani_m BY \_Booking
*        ALL FIELDS
*        WITH VALUE #( ( %key-TravelId = '00000075' ) )
*        RESULT DATA(it_result)
*        FAILED DATA(it_failed).

*    READ ENTITIES OF zi_travel_gani_m
*     ENTITY zi_travel_gani_m
*     ALL FIELDS WITH VALUE #( (  %key-TravelId = '00000075' ) )
*      RESULT DATA(it_result)
*      ENTITY zi_booking_gani_m
*      ALL FIELDS WITH VALUE #( ( %key-TravelId = '00000075' %key-BookingId = '0001' ) )
*      RESULT DATA(it_result1)
*       FAILED DATA(it_failed).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( 'Read Failed' ).
*    ELSE.
*      out->write( it_result ).
*      out->write( it_result1 ).
*    ENDIF.



*    IF it_failed IS NOT INITIAL.
*      out->write( 'Read Failed' ).
*    ELSE.
*      out->write( it_result ).
*      out->write( it_result1 ).
*    ENDIF.
    DATA:lt_book TYPE TABLE FOR CREATE zi_travel_gani_m\_Booking.

    MODIFY ENTITY zi_travel_gani_m
    CREATE FROM VALUE #(
                         ( %cid = 'cid1'
                          %data-BeginDate = '20240425'
                          %control-BeginDate = if_abap_behv=>mk-on
     ) )
     CREATE BY \_Booking
     FROM VALUE #( ( %cid_ref = 'cid1'
                     %target = VALUE #( ( %cid = 'cid11'
                                          %data-BookingDate = '20240425'
                                          %control-BookingDate = if_abap_behv=>mk-on
                                       ) )
                   ) )
   FAILED FINAL(it_failed)
   MAPPED FINAL(it_mapped)
   REPORTED FINAL(it_reported).
    IF it_failed IS NOT INITIAL.
      out->write( it_failed ).
    ELSE.
      COMMIT ENTITIES.
    ENDIF.




  ENDMETHOD.

ENDCLASS.
