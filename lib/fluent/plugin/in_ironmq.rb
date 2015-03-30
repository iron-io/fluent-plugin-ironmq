module Fluent
  require 'iron_mq'

  class IronmqInput < Input
    Fluent::Plugin.register_input('ironmq', self)

    config_param :project_id, :string
    config_param :token, :string
    config_param :tag, :string
    config_param :host, :string, :default => 'mq-aws-us-east-1.iron.io'
    config_param :queue_name, :string
    config_param :receive_interval, :time, :default => 1
    config_param :max_number_of_messages, :integer, :default => 1

    def configure(conf)
      super
    end

    def start
      super

      @ironmq = IronMQ::Client.new(
          :host => @host,
          :token => @token,
          :project_id => @project_id
      )

      @queue = @ironmq.queue(@queue_name)

      @finished = false
      @thread = Thread.new(&method(:run_periodic))
    end

    def shutdown
      super

      @finished = true
      @thread.join
    end

    unless method_defined?(:log)
      define_method(:log) { $log }
    end

    def run_periodic
      until @finished
        begin
          sleep @receive_interval

          if @max_number_of_messages > 1
            @queue.get(:n => @max_number_of_messages).each do |message|
              submit_event(message)
            end
          else
            msg = @queue.get
            if msg
              submit_event(msg)
            end            
          end
        rescue
          log.error "failed to emit or receive", :error => $!.to_s, :error_class => $!.class.to_s
          log.warn_backtrace $!.backtrace
        end
      end
    end

    def submit_event(msg)
      record = {}
      record['id'] = msg.id.to_s
      record['body'] = msg.body.to_s
      record['timeout'] = msg.timeout.to_s

      Engine.emit(@tag, Time.now.to_i, record)
    end
  end
end