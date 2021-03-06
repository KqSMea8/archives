# Deploying to Heroku

[Heroku](https://heroku.com) is a fabulous Platform-as-a-Service that
allows you to deploy your own MakeStack Server easily.

Just click this button to save your time
----------------------------------------

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/makestack/makestack)


Prepare for deploy
------------------

You need these stuffs before deployment.

- [Heroku account](https://heroku.com)
- [Google reCAPTCHA API key](https://www.google.com/recaptcha/)
- [Skylight account](https://skylight.io)
- [Timber account](https://timber.io)
- [Sentry account](https://sentry.io)
- [SendGrid account](https://sendgrid.com/) (or another SMTP server)
- Heroku CLI toolchain

Setting up the repository
--------------------------
We highly recommend you to fork [makestack/makestack](https://github.com/makestack/makestack) on
to your own GitHub account.

```bash
git clone https://github.com/your-github-account/makestack.git
cd path/to/makestack
git checkout -b production
```

**Note:** Make sure that you are in a branch other than `master`. You had better not
to add changes to `master`. Using `master` would confuse you when you want to merge
upstream changes.

Create a Heroku app
--------------------
```bash
heroku create -a HEROKU_APP_NAME
```

Set environment variables
--------------------------
Define environment variables defined in `app.json`.

**Note:** Since Heroku does not provide a mail server, MakeStack Server is not
able to send e-mails (e.g. user registration confirmation e-mail) by default. Instead
you can use [SendGrid to send e-mails for free](https://sendgrid.com/docs/Classroom/Basics/Email_Infrastructure/recommended_smtp_settings.html).

Configuration (Heroku)
-----------------------

```bash
cd path/to/makestack
heroku addons:create heroku-redis:hobby-dev
heroku buildpacks:set --index 1 https://github.com/makestack/heroku.git
heroku buildpacks:set --index 2 heroku/nodejs
heroku buildpacks:set --index 3 heroku/ruby
```

Don't forget to follow instructions of Skylight, Timber, and Sentry.

Deploy to Heroku
-----------------
```bash
git push heroku production:master
```

This would take 5-6 minutes.

Database Creation
------------------
```bash
heroku run rails db:migrate
```

Open in the web browser
------------------------
MakeStack Server is now ready for operation. Have fun!

```bash
heroku open
```
