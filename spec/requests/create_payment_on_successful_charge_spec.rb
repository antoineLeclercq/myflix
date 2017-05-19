require 'rails_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_1AJx2pJOUYpKB5iyium2VxLu",
      "object" => "event",
      "api_version" => "2017-04-06",
      "created" => 1494907943,
      "data" => {
        "object" => {
          "id" => "ch_1AJx2oJOUYpKB5iydqEEEUZW",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_1AJx2oJOUYpKB5iySrNUF80C",
          "captured" => true,
          "created" => 1494907942,
          "currency" => "usd",
          "customer" => "cus_AfHcwQOlHFPQt0",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_1AJx2oJOUYpKB5iyyIerPjPl",
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1AJx2oJOUYpKB5iydqEEEUZW/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1AJx2oJOUYpKB5iykBpANgAZ",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => "12345",
            "address_zip_check" => "pass",
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_AfHcwQOlHFPQt0",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 1,
            "exp_year" => 2019,
            "fingerprint" => "9MPJb3dwwMsodK2s",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "myflix subscription",
          "status" => "succeeded",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_AfHcbJblkRlfdh",
      "type" => "charge.succeeded"
    }
  end

  context 'charge succeeded' do
    it 'creates a payment with the webhook from stripe', :vcr do
      post '/stripe_events', event_data
      expect(Payment.count).to eq(1)
    end

    it 'creates a payment associated with a user', :vcr do
      bob = Fabricate(:user, stripe_customer_token: 'cus_AfHcwQOlHFPQt0')
      post '/stripe_events', event_data
      expect(Payment.first.user).to eq(bob)
    end

    it 'creates a payment with the amount', :vcr do
      bob = Fabricate(:user, stripe_customer_token: 'cus_AfHcwQOlHFPQt0')
      post '/stripe_events', event_data
      expect(Payment.first.amount).to eq(999)
    end

    it 'creates a payment with a reference id', :vcr do
      bob = Fabricate(:user, stripe_customer_token: 'cus_AfHcwQOlHFPQt0')
      post '/stripe_events', event_data
      expect(Payment.first.reference_id).to eq('ch_1AJx2oJOUYpKB5iydqEEEUZW')
    end
  end
end
