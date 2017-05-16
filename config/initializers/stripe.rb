Stripe.api_key = ENV['stripe_api_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    event.data.object
  end
end
