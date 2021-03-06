require 'yaml'

DEFAULT_TERM_OF_SERVICE = <<EOS
Feel free to use here to play with MakeStack!
Please note that we don't gurantee service level.
We may lose data. We may accidentally drop database.
We may stop servers without notice. If you need a
stable MakeStack Server you must create your own
instance on AWS or somewhere else. This is just a
playground to try MakeStack. Enjoy!`
EOS

DEFAULT_PRIVACY_POLICY = <<EOS
Infomation we collect
---------------------

- Account information such as an email address and password.
- Integration information such as API keys of external services.
- Log data sent from devices.
- App source code.
- Deployed packages.
- Device IDs and secret keys generated by MakeStack Server to authenticate devices and
  verify messages sent from devices.

How we use information we collect
---------------------------------

Read source code[1] for details. If you have any questions about privacy,
please create an issue on GitHub[1].

[1]: https://github.com/makestack/makestack
EOS

namespace :config do
  task :generate do
    config_json = {
      RECAPTCHA_SITEKEY: ENV.fetch('RECAPTCHA_SITEKEY'),
      WELCOME_MESSAGE: ENV.fetch('WELCOME_MESSAGE', 'This is a demonstration place to play with MakeStack.'),
      TERM_OF_SERVICE: ENV.fetch('TERM_OF_SERVICE', DEFAULT_TERM_OF_SERVICE.gsub("\n", ' ')),
      PRIVACY_POLICY: ENV.fetch('PRIVACY_POLICY', DEFAULT_PRIVACY_POLICY),
      ROUTER_MODE: ENV.fetch('ROUTER_MODE', 'hash')
    }.to_json

    settings_yml = {
      protocol: ENV.fetch('SERVER_PROTOCOL'),
      host: ENV.fetch('SERVER_HOST'),
      port: ENV.fetch('SERVER_PORT'),
      mailer_sender: ENV.fetch('MAILER_SENDER', "bot@#{ENV.fetch('SERVER_HOST')}"),
      outgoing_webhook_limit_per_hour: ENV.fetch('OUTGOING_WEBHOOK_LIMIT_PER_HOUR', 5000),
      push_to_sakuraio_limit_per_hour: ENV.fetch('PUSH_TO_SAKURAIO_LIMIT_PER_HOUR', 5000)
    }.stringify_keys.to_yaml

    open('ui/config.json', 'w').write(config_json)
    open('config/settings.production.yml', 'w').write(settings_yml)

    puts "generated ui/config.json and config/settings.production.yml!"
  end
end
