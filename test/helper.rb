require "doubleshot/setup"

require "minitest/autorun"
require "minitest/pride"
require "minitest/wscolor"

require Pathname(__FILE__).dirname.parent + "lib/mail_builder"

(MailBuilder.private_instance_methods - Object.private_instance_methods).each do |method|
  MailBuilder.send(:public, method)
end

def mailer(options = {})
  MailBuilder.new(options)
end

module MiniTest
  module Assertions
    def assert_nothing_raised *args
      yield
      assert true, "Nothing raised"
    rescue Exception => e
      fail "Expected nothing raised, but got #{e.class}: #{e.message}"
    end
  end

  module Expectations
    infect_an_assertion :assert_nothing_raised, :wont_raise
  end
end