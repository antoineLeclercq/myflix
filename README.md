Use the following email/password on the production App:
- Email: test@myflix.com
- Password: password

# Features
- User authentication using bcrypt
- User can browse videos by category
- Users can review videos (rating + comment)
- Users can add/delete/reorder videos from their videos queue
- Users can follow and unfollow other users
- Users receive a welcome email upon registration
- Tokenized Users, Videos, Categories
- User can reset password by receiving an email with a link
- Users can send emails inviting friends to join
- Friends invited by a current user will automatically follow the current user if they sign up
- Admins can add videos and video images (stored with Amazon S3)
- Payments and subscription using Stripe (lock user's account in case of failed payment)
- User can search videos
- User can perform an advanced search on Videos which uses ELasticsearch in the background

# Development
- TDD using comprehensive unit, model, and integration test coverage with RSpec, Capybara, VCR and Selenium
- GitHub workflow
- Continuous development using Circle CI
- Use Puma as web server
- Use Redis and Sidekiq for background jobs such as email sending
- Use Raven for monitoring staging and production server errors
- Heroku deployment with staging and production servers
