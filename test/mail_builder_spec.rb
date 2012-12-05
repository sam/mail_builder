#!/usr/bin/env jruby

# encoding: UTF-8

require File.dirname(__FILE__) + '/helper'

describe MailBuilder do

  it "must encode recipients properly" do
    mailer(:to => "bernerd@wieck.com").build_headers.strip
      .must_equal "to: bernerd@wieck.com"
    
    mailer(:to => '"Bernerd" <bernerd@wieck.com>').build_headers.strip
      .must_equal "to: \"=?utf-8?Q?Bernerd?=\" <bernerd@wieck.com>"
  end

  it "must encode multiple recipients properly" do
    desired_to = 'to: "=?utf-8?Q?Bernerd?=" <bernerd@wieck.com>, "=?utf-8?Q?Adam?=" <adam@wieck.com>'
    
    mailer(:to => '"Bernerd" <bernerd@wieck.com>, "Adam" <adam@wieck.com>')
      .build_headers.strip.must_equal desired_to
    mailer(:to => ['"Bernerd" <bernerd@wieck.com>', '"Adam" <adam@wieck.com>'])
      .build_headers.strip.must_equal desired_to
  end

  it "must encode all addresses" do
    [ "from", "to", "cc", "bcc", "reply-to" ].each do |field|
      mailer(field => '"Bernerd" <bernerd@wieck.com>').build_headers.strip
        .must_equal "#{field}: \"=?utf-8?Q?Bernerd?=\" <bernerd@wieck.com>"
    end
  end

  it "must rfc2045 encode properly" do
    mailer.rfc2045_encode('<a href="http://google.com">Google</a>')
      .must_equal '<a href=3D"http://google.com">Google</a>'
  end

  it "must rfc2047 encode properly" do
    mailer.rfc2047_encode("This + is = a _ test * subject")
      .must_equal "=?utf-8?Q?This_+_is_=3D_a_=5F_test_*_subject?="
      
    mailer.rfc2047_encode("\303\244\303\244\303\244\303\266\303\266\303\266")
      .must_equal "=?utf-8?Q?=C3=A4=C3=A4=C3=A4=C3=B6=C3=B6=C3=B6?="
  end

  it "mailer must not error on build if empty" do
    -> { mailer.to_s }.wont_raise
  end

end