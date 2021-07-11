require "rails_helper"

RSpec.describe "No Visitor Posting" do
  let(:visitor) {
    Fabricate(:user, trust_level: TrustLevel[0])
  }

  let(:non_visitor) {
    Fabricate(:user, trust_level: TrustLevel[2])
  }

  context "while enabled" do
    before do
      SiteSetting.no_visitor_posting_enabled = true
    end

    it "should not let visitors create topics" do
      expect(Guardian.new(visitor).can_create_topic?(nil)).to be(false)
    end

    it "should not let visitors create posts" do
      expect(Guardian.new(visitor).can_create_post?(nil)).to be(false)
    end

    it "should not let visitors send messages" do
      expect(Guardian.new(visitor).can_send_private_message?(Fabricate(:user))).to be(false)
    end

    it "should let visitors reply to messages" do
      pm = Fabricate(
        :topic,
        archetype: Archetype.private_message,
        subtype: 'system_message',
        category_id: nil
      )

      expect(Guardian.new(visitor).can_create_post?(pm)).to be(true)
    end

    it "should let non visitors send messages" do
      expect(Guardian.new(non_visitor).can_send_private_message?(Fabricate(:user))).to be(true)
    end

    it "should let non visitors create topics and posts" do
      expect(Guardian.new(non_visitor).can_create_topic?(nil)).to be(true)
      expect(Guardian.new(non_visitor).can_create_post?(nil)).to be(true)
    end
  end
end
