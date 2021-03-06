# MailBuilder

[![Build Status](https://secure.travis-ci.org/sam/mail_builder.png)](http://travis-ci.org/sam/mail_builder)

MailBuilder is a library for building RFC compliant MIME messages,
with support for text and HTML emails, as well as attachments.

## Basic Usage

```ruby
require 'rubygems'
require 'mail_builder'

mail = MailBuilder.new
mail.to = "joe@example.com"
mail.text = "Body"

sendmail = IO.popen("#{`which sendmail`.chomp} -i -t", "w+")
sendmail.puts mail
sendmail.close
```

#### or

```ruby
require 'net/smtp'

Net::SMTP.start("smtp.address.com", 25) do |smtp|
  smtp.send_message(mail.to_s, mail.from, mail.to)
end
```

## Advantages

One of the key advantages to using MailBuilder over other libraries
(such as MailFactory) is that costly operations - generating boundaries,
reading attached files, etc. - are delayed until the physical message
is built (by calling `build` or `to_s`).

This gives you the freedom to generate many thousands of emails
with almost no time-cost. The emails could then be passed to some
external system - DRb, database - for final delivery.

```ruby
10_000.times do
  mail = MailBuilder.new('to' => 'joe@example.com')
  mail.html = View.new("mailers/large_mailer")
  mail.attach("large_file.pdf")

  ExternalMailServer.send!(mail)
end
```

The external process would then build the email, at which point the
view would be rendered and attachments read, while the local process
would complete in very little (on my machine, sub-second) time.
