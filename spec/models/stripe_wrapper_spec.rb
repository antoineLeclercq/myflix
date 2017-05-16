require 'rails_helper'

describe StripeWrapper, :vcr do
  let(:valid_token) do
    token = Stripe::Token.create(
      card: {
        number: '4242424242424242',
        exp_month: 5,
        exp_year: 2018,
        cvc: '314'
      },
    )
  end

  let(:declined_card_token) do
    token = Stripe::Token.create(
      card: {
        number: '4000000000000002',
        exp_month: 5,
        exp_year: 2018,
        cvc: '314'
      },
    )
  end

  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful charge' do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: 'Sign up charge',
          source: valid_token
        )

        expect(response).to be_successful
      end

      it 'makes a card declined charge' do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: 'Sign up charge',
          source: declined_card_token
        )

        expect(response).not_to be_successful
      end

      it 'returns an error for card declined charges' do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: 'Sign up charge',
          source: declined_card_token
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      it 'creates a customer with a valid card' do
        bob = Fabricate(:user, email: 'bob@example.com')
        response = StripeWrapper::Customer.create(
          user: bob,
          card: valid_token
        )

        expect(response).to be_successful
      end

      it 'does not create a customer with a declined card' do
        bob = Fabricate(:user, email: 'bob@example.com')
        response = StripeWrapper::Customer.create(
          user: bob,
          card: declined_card_token
        )

        expect(response).not_to be_successful
      end

      it 'does not create a customer with a declined card' do
        bob = Fabricate(:user, email: 'bob@example.com')
        response = StripeWrapper::Customer.create(
          user: bob,
          card: declined_card_token
        )

        expect(response).not_to be_successful
      end

      it 'returns an error for card declined charges' do
        bob = Fabricate(:user, email: 'bob@example.com')
        response = StripeWrapper::Customer.create(
          user: bob,
          card: declined_card_token
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end
