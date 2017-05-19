require 'rails_helper'

feature 'Admin sees payments' do
  scenario 'admin can see payments made by users' do
    bob = Fabricate(:user)
    Payment
  end
end
