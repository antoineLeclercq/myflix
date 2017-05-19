require 'rails_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_1ALDdLJOUYpKB5iy1RWRAqq5",
      "object" => "event",
      "api_version" => "2017-04-06",
      "created" => 1495210039,
      "data" => {
        "object" => {
          "id" => "ch_1ALDdKJOUYpKB5iyleYt9giO",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1495210038,
          "currency" => "usd",
          "customer" => "cus_AgPasMWL1hfyfm",
          "description" => "myflix subscription",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {
          },
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1ALDdKJOUYpKB5iyleYt9giO/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1ALDchJOUYpKB5iyWFSueaPY",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_AgPasMWL1hfyfm",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 5,
            "exp_year" => 2018,
            "fingerprint" => "nifCU2XNgFpRDxq4",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "MYFLIX SUBSC",
          "status" => "failed",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_Agaogdq4hmwf1S",
      "type" => "charge.failed"
    }
  end

  it 'deactivates user with event data from stripe webhook on failed charge', :vcr do
    bob = Fabricate(:user, email: 'bob@example.com', stripe_customer_token: 'cus_AgPasMWL1hfyfm')
    post '/stripe_events', event_data
    expect(bob.reload).not_to be_active
  end
end
