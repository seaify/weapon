require 'exception_notification/rails'

# config/initializers/exception_notification.rb
require 'exception_notification/sidekiq'

# 自定义 notifier(slack)
module ExceptionNotifier
  class SlackNotifier

    attr_accessor :notifier

    def initialize(options)
      begin
        webhook_url = options.fetch(:webhook_url)
        @message_opts = options.fetch(:additional_parameters, {})
        @notifier = Slack::Notifier.new webhook_url, options
      rescue
        @notifier = nil
      end
    end

    def call(exception, options={})
      message = [
          "时间: #{ Time.now.to_s }",
          "URL: #{ options[:env]["REQUEST_URI"] }",
          "参数: #{ options[:env]["action_dispatch.request.parameters"] }",
          "用户IP: #{ options[:env]["action_dispatch.remote_ip"] }",
          "异常: #{ [exception.message, exception.backtrace].flatten.join("\n") }",
          "==============================================="
      ].join("\n\n")

      @notifier.ping(message, @message_opts) if valid?
    end

    protected

    def valid?
      !@notifier.nil?
    end
  end
end

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production?
  end

  config.add_notifier :slack, {
                                :webhook_url => "slack_webhook_url",
                                :channel     => "slack_channel",
                            }

end
