@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_booking_gani_m
  as projection on zi_booking_gani_m
{
  key TravelId,
  key BookingId,
      BookingDate,

      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _customer.LastName         as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _carrier.Name              as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _booking_status._Text.Text as BookingStatusText : localized,
      LastChangedAt,
      /* Associations */
      _BookingSuppl : redirected to composition child zc_booksuppl_gani_m,
      _booking_status,
      _carrier,
      _connection,
      _customer,
      _Travel       : redirected to parent zc_travel_gani_m
}
