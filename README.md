Use the following logins on the production App:
- Email: test@myflix.com
- Password: password

Features involving emails will not work for now because the production app is using a Mailgun Sandbox which requires to add authorized users. In the future a custom domain will be added and verified by Mailgun which will allow for these features to work. 
In the meantime, if you wish to test these features, please send me your email at: antoine.leclercq.49@gmail.com and I will add you to the list of authorized users.

# Features
## Implemented:
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

## To be implemented:
- Payments using Stripe
- Admins can add videos and video images (stored with S3)

# Development
## Current:
- TDD using comprehensive unit, model, and integration test coverage with RSpec and Capybara
- GitHub workflow

## Future development process:
- Continuous development using Circle CI
- Use a unicorn server
- Utilize sidekiq for email sending
- Use Raven for monitoring production server errors
- Heroku deployment utilized staging and production servers
