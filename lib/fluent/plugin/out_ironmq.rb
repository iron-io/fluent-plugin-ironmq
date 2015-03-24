module Fluent
  require 'iron_mq'

  class IronmqOutput < BufferedOutput
    Fluent::Plugin.register_output('ironmq', self)

    include SetTagKeyMixin
    config_set_default :include_tag_key, false

    include SetTimeKeyMixin
    config_set_default :include_time_key, true

    config_param :project_id, :string
    config_param :token, :string
    config_param :queue_name, :string
    config_param :host, :string, :default => 'mq-aws-us-east-1.iron.io'
    config_param :delay_seconds, :integer, :default => 0
    config_param :include_tag, :bool, :default => true
    config_param :tag_property_name, :string, :default => '__tag'

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
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      if @include_tag
        record[@tag_property_name] = tag
      end

      record.to_msgpack
    end

    def write(chunk)
      messages = []
      chunk.msgpack_each {|record| messages << { :body => record.to_json, :delay => @delay_seconds } }
      @queue.post(messages)
    end

    unless method_defined?(:log)
      define_method(:log) { $log }
    end
  end
end
