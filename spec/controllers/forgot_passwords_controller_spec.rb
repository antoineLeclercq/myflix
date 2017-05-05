require 'rails_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with blank input' do
      it 'redirects to the forgot password page' do
        post :create, email: ''

        expect(response).to redirect_to(forgot_password_path)
      end

      it 'shows an error message' do
        post :create, email: ''

        expect(flash[:error]).to eq('You need to specify your email in order to reset your password.')
      end
    end

    context 'with existing email' do
      after { ActionMailer::Base.deliveries.clear }

      it 'sends out an email to the email address' do
        Sidekiq::Testing.inline! do
          Fabricate(:user, email: 'joe@example.com')
          post :create, email: 'joe@example.com'

          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end

      it 'redirects to the forgot password confirmation page' do
        Fabricate(:user, email: 'joe@example.com')
        post :create, email: 'joe@example.com'

        expect(response).to redirect_to(forgot_password_confirmation_path)
      end
    end

    context 'with non existing email' do
      it 'redirects to forgot password page' do
        post :create, email: 'joe@example.com'
        expect(response).to redirect_to(forgot_password_path)
      end

      it 'shows error message' do
        post :create, email: 'joe@example.com'
        expect(flash[:error]).to eq('There is no user in our system with this email.')
      end
    end
  end
end
