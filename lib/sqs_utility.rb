class SqsUtility
  @@client = Aws::SQS::Client.new
  @@default_queue_url = ENV.fetch('SQS_QUEUE_URL')
  @@max_messages = 10

  def self.receive_message(options = {})
    queue_url = options[:url].presence || @@default_queue_url
    @@client.receive_message(queue_url: queue_url)
  end

  def self.delete_message(msg, options = {})
    queue_url = options[:url].presence || @@default_queue_url
    @@client.delete_message(
      queue_url: queue_url,
      receipt_handle: msg[:receipt_handle]
    )
  end

  def self.receive_messages(options = {})
    queue_url = options[:url].presence || @@default_queue_url
    max_messages = options[:max].presence || @@max_messages
    msgs = []
    while true
      msg = @@client.receive_message(queue_url: queue_url)
      break if msg.messages.empty?

      msgs.push(msg)
      break if msgs.size >= max_messages
    end
    msgs
  end

  def self.delete_messages(msgs, options = {})
    msgs.each do |msg|
      self.delete_message(msg, options)
    end
  end
end
