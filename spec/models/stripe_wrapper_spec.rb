require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    before do
      Stripe.api_key = ENV['stripe_api_key']
    end

    describe '.create' do
      let (:token) do
        Stripe::Token.create(
          card: {
            number: "4242424242424242",
            exp_month: 5,
            exp_year: 2018,
            cvc: "314"
          },
        )
      end

      it 'makes a successful charge', :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: 'Sign up charge',
          source: token
        )

        expect(response.currency).to eq('usd')
        expect(response.amount).to eq(999)
      end
    end
  end
end
