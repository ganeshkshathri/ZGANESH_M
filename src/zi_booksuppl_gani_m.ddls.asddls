@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface for booking supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_booksuppl_gani_m
  as select from zbooksupp_gani_m
  association        to parent zi_booking_gani_m as _booking        on  $projection.BookingId = _booking.BookingId
                                                                    and $projection.TravelId  = _booking.TravelId
  association [1..1] to zi_travel_gani_m         as _travel         on  $projection.TravelId = _travel.TravelId
  association [1..1] to /DMO/I_Supplement        as _supplement     on  $projection.SupplementId = _supplement.SupplementID
  association [1..*] to /DMO/I_SupplementText    as _supplementText on  $projection.SupplementId = _supplementText.SupplementID
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _supplement,
      _supplementText,
      _booking,
      _travel

}
