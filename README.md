# Particlecmd

A simple command parser for CLI utils and/or bots/whatever

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'particlecmd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install particlecmd

## Usage

```ruby
require 'particlecmd'

sample = ParticleCMD::Definition.new 'add' do |d|
  d.positional 'a', description: 'First value'
  d.positional 'b', description: 'Second value'
  
  d.collect_extra

  d.flag 'multiply', description: 'Multiply instead of adding'

  d.option 'divide', argname: 'X', description: 'Divide the result by X'
end

require 'shellwords'
puts (sample.match ParticleCMD::Info.new Shellwords.split '1 2 3 \\\' 4 5 "6 7\' 8" --multiply --divide=123').inspect
# #<ParticleCMD::Result:0x000056286c6ab630 @extra=["3", "'", "4", "5", "6 7' 8"], @positionals={"a"=>"1", "b"=>"2"}, @flags={"multiply"=>true}, @options={"divide"=>"123"}>
# returns nil if definition and info do not match
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/handicraftsman/particlecmd.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
