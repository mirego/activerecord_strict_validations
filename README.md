# ActiveRecord::MySQL::Strict

[![Gem Version](https://badge.fury.io/rb/activerecord_mysql_strict.png)](https://rubygems.org/gems/activerecord_mysql_strict)

`ActiveRecord::MySQL::Strict` adds validations to ActiveRecord models to make sure they do not trigger errors in MySQL strict mode.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_mysql_strict'
```

## Usage

```ruby
create_table "events" do |t|
  t.string   "name"
  t.string   "email", limit: 128
  t.text     "description"
  t.integer  "people_count"
end

class Event < ActiveRecord::Base
  validates_strict_columns
end

# String columns

event = Event.new(name: '.' * 400)
event.valid? # => false

event = Event.new(name: '.' * 255)
event.valid? # => true

event = Event.new(email: '.' * 200)
event.valid? # => false

event = Event.new(email: '.' * 100)
event.valid? # => true

# Text columns

event = Event.new(description: '.' * 70000)
event.valid? # => false

event = Event.new(description: '.' * 65535)
event.valid? # => true

# Integer columns

event = Event.new(people_count: 9999999999)
event.valid? # => false

event = Event.new(people_count: 2147483647)
event.valid? # => true
```

### Options

You can use a few options when calling `validates_strict_columns`:

```ruby
class Event < ActiveRecord::Base
  validates_strict_columns, only: [:name]
end

class Event < ActiveRecord::Base
  validates_strict_columns, except: [:people_count]
end
```

## License

`ActiveRecord::MySQL::Strict` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/activerecord_mysql_strict/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.
