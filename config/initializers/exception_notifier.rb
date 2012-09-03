unless (Rails.env.development? || Rails.env.test?)
  Yorkshire::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[YORKSHIRE] ",
    :sender_address => "notifier <notifier@yorkshire.yoomee.com>",
    :exception_recipients => %w{developers@yoomee.com}
end