# ChalkDust

Subscriptions connect models, events build activity feeds.

Designed to scale.

ChalkDust can be used to build activty feeds such as followings and friendships
by allowing models to subscribe to activity feeds published by other models.

Every time an activity occurs it is copied to all subscribers of the target of
that activity. This creates an activity feed per subscriber. This results in
more data but scales better and allows additional features such as the ability
of the subscriber to delete/hide activity items.

Each publisher can create multiple feeds by means of topics. For example a
user might publish activities with topics of 'family' or 'work'.

[![Code Climate](https://codeclimate.com/github/krisleech/chalk_dust.png)](https://codeclimate.com/github/krisleech/chalk_dust)
[![Build Status](https://travis-ci.org/krisleech/chalk_dust.png?branch=master)](https://travis-ci.org/krisleech/chalk_dust)
[![endorse](https://api.coderwall.com/krisleech/endorsecount.png)](https://coderwall.com/krisleech)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chalk_dust'
```

ChalkDust has a dependency on ActiveRecord (3.0 or 4.0) and a soft dependency
on Rails. If you are using Rails you can install the migrations as follows:

```
rails generate chalk_dust:install_migrations
```

## Usage

### Subscribing

A subscription connects two objects, e.g "Sam" follows "My first blog post"

```ruby
ChalkDust.subscribe(user, :to => post)
```

```ruby
ChalkDust.subscribers_of(post) # => [user]
```

#### Self-subscribing

Typically you will want to self-subscribe models on creation to themseleves so
an activity feed is built for the model itself.

```ruby
ChalkDust.self_subscribe(user)
# or
ChalkDust.subscribe(user, :to => user)
```

#### Undirected subscriptions

All subscriptions are directed. You can create a two way subscription, e.g a
friendship, as follows:

```ruby
ChalkDust.subscribe(bob,   :to => alice, :undirected => true)
# or
ChalkDust.subscribe(bob,   :to => alice)
ChalkDust.subscribe(alice, :to => bob)
```

#### Topics

If you want the subscription to only apply to activities with a particular
topic you can do so as follows:

```ruby
ChalkDust.subscribe(alice, :to => bob, :topic => 'work')
ChalkDust.subscribe(alice, :to => bob, :topic => 'family')
```

This is useful if you need to publish multiple activity feeds for an object.

Example uses for this would be seperate public and private activity streams
for an object, or something like circles.

### Publishing activity

Describes an event where X (performer) did Y (activity) to Z (target).

```ruby
ChalkDust.publish_event(user, 'added', comment)
```

If the activity should be published to the feed of an object other than the
target then it can be either be passed with the `:root` argument:

```ruby
ChalkDust.publish_event(user, 'added', comment, :root => comment.post)
```

#### Topics

Optionally publish an event to a specific topic:

```ruby
ChalkDust.publish_event(user, 'uploaded', photo, :root => user,
                                                 :topic => 'family')
```

### Activity Feeds

```ruby
ChalkDust.activity_feed_for(user, :since => 2.weeks.ago)
ChalkDust.activity_feed_for(post, :since => 2.weeks.ago)
```

#### Topics

Fetch an activity feed for a specific topic:

```ruby
ChalkDust.activity_feed_for(user, :topic => 'family')
```

If you do not specify a topic you will only get activities which where not
published with a topic. To get all activities (those with and without a topic)
pass `:all` to `:topic`:

```ruby
ChalkDust.activity_feed_for(user, :topic => :all)
```

You can still use `'all'` as a regular topic, but you can not specify it as a
symbol as you can with other topics.

### Unsubscribing

```ruby
ChalkDust.unsubscribe(user, :from => post)
ChalkDust.unsubscribe(user, :from => post, :topic => 'work')
ChalkDust.unsubscribe(user, :from => post, :topic => :all)
```

## Compatibility

Tested with MRI 1.9.x, MRI 2.0.0, JRuby (1.9 and 2.0 mode) against both
ActiveRecord 3.0 and 4.0.

See the [build status](https://travis-ci.org/krisleech/chalk_dust) for details.

## Contributing

Contributions welcome, please fork and send a pull request.

## Running Specs

To run the specs for all supported combinations of Ruby and ActiveRecord:

```
wwtd
```

To run the specs for a specific version of ActiveRecord:

```
env BUNDLE_GEMFILE=$PWD/gemfiles/activerecord-3.0 bundle exec rspec spec
env BUNDLE_GEMFILE=$PWD/gemfiles/activerecord-4.0 bundle exec rspec spec
```

## Thanks

Thanks to Igor @ Lifetrip Limited for allowing this code to be open sourced.

## License

Copyright (c) 2013 Lifetrip Limited

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
