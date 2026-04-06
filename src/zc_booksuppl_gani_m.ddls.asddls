@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supp Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_booksuppl_gani_m
  as projection on zi_booksuppl_gani_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplementDesc' ]
      SupplementId,
      _supplementText.Description as SupplementDesc : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _booking : redirected to parent zc_booking_gani_m,
      _supplement,
      _supplementText,
      _travel  : redirected to zc_travel_gani_m
}
