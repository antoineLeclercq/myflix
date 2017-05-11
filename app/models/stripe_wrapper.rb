module StripeWrapper
  class Charge
    def self.create(options={})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: "usd",
        description: options[:description],
        source: options[:source]
      )
    end
  end
end
