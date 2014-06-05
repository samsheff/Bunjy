jQuery(function($) {
  $('#addDebitCardForm').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });
});

function stripeResponseHandler(status, response) {
  if (response.error) {
      // show the errors on the form
      $("#payment-errors").text(response.error.message);
      $('#addDebitCardForm').find('button').prop('disabled', false);
  } else {
      var form$ = $("#addDebitCardForm");
      // token contains id, last4, and card type
      var token = response['id'];
      // insert the token into the form so it gets submitted to the server
      form$.append("<input type='hidden' name='payment_method[stripe_token]' value='" + token + "'/>");
      // and submit
      form$.get(0).submit();
    }
}
