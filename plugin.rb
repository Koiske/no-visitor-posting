# name: no-visitor-posting
# version: 1.1.0
# authors: buildthomas, boyned/Kampfkarren

enabled_site_setting :no_visitor_posting_enabled

after_initialize do

  # Restrict TL0 from sending new DMs
  module GuardianInterceptor
    def can_send_private_message?(target, notify_moderators: false)
      value = super(target, notify_moderators: notify_moderators)

      if SiteSetting.no_visitor_posting_enabled
        return value && user.trust_level != TrustLevel[0]
      end

      value
    end
  end
  Guardian.send(:prepend, GuardianInterceptor)

  # Let TL0 reply to DMs
  module PostGuardianInterceptor
    def can_create_post?(parent)
      value = super(parent)

      if SiteSetting.no_visitor_posting_enabled
        return false if !value

        if user.trust_level == TrustLevel[0]
          # visitors can only reply to private messages
          return parent.try(:private_message?) == true
        end
      end

      value
    end
  end
  PostGuardian.send(:prepend, PostGuardianInterceptor)

  # Restrict TL0 from creating new topics
  module TopicGuardianInterceptor
    def can_create_topic?(parent)
      if SiteSetting.no_visitor_posting_enabled
        return false if user.trust_level == TrustLevel[0]
      end

      super(parent)
    end
  end
  TopicGuardian.send(:prepend, TopicGuardianInterceptor)

end
