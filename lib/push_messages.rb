module PushMessages

  def self.enabled?
    return true if Thread.current[:push_messages].class == Array
    false
  end

  def self.init
    return true if enabled?
    Thread.current[:push_messages] = []
  end

  def self.send(data)
    if !PushMessages.enabled?
      Sessions.broadcast(
        data[:message],
        data[:type],
        data[:current_user_id],
      )
      return true
    end
    Thread.current[:push_messages].push data
  end

  def self.finish
    return false if !enabled?
    Thread.current[:push_messages].each { |data|
      Sessions.broadcast(
        data[:message],
        data[:type],
        data[:current_user_id],
      )
    }
    Thread.current[:push_messages] = nil
    true
  end

end
