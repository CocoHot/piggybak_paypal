Piggybak Paypal
=============

Integration of Paypal Web Payments Pro payment gateway with Piggybak.

Installation
-------

The following markups are supported.  The dependencies listed are required if
you wish to run the library.

1. Add piggybak_paypal gem to Gemfile
  `gem 'piggybak_paypal', :git => 'git://github.com/timmyc/piggybak_paypal.git'`
2. `bundle install`
3. Start the app, and navigate to Rails Admin.  Create a new payment method with Stripe as the calculator and add the following PayPal Config values:
  *test_login
  *test_password
  *test_signature
  *live_login
  *live_password
  *live_signature
4. Configure piggybak's gateway mode:  
  `config.activemerchant_mode = :test` OR `config.activemerchant_mode = :production`
