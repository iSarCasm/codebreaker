# Codebreaker

## Tests

```rspec
Codebreaker::ConsoleInterface
  #start
    calls #welcome
    calls #play
    calls #goodbye
  #welcome
    displays Welcome Message
    creates a new Game
  #play
    selects difficulty
    shows difficulty
    starts guessing
    sets @played flag
    displays results
    asks for replay
    reply "y"
      starts over again
    reply else
      breakes the loop
  #select_difficulty
    displays difficulty info
    asks user to input choice
    by default
      calls restart when played
    otherwise
      calls start with new difficulty
  #difficulty_info
    displays symbols range
    displays symbols count
    displays attempts
    displays hints left
  #guessing
    asks for guess
    guess
      calls guess on Game
      displays the response
    hint
      shows one of the symbols of code
  #results
    won game
      displays victory text
      shows attempts taken
      shows result score
    lost game
      displays lose text
      displays the real answer
  #ask_for_replay
    shows replay message
    asks for answer
  #goodbye
    displays bye-bye text

Codebreaker
  has a version number

Codebreaker::Game
  instance
    #start
      resets number of attempts
      resets number of hints
      generates new code
      calls generate_code method
      changes state to :playing
      clears @elements_revealed
    #restart
      calls #start with previous difficulty
    #guess
      decrements attempts number
      last attempt
        which is wrong
          loses the game
      secret is [1, 2, 2, 4]
        when [1, 2, 3, 4] returns [3, 0]
        when [1, 1, 1, 1] returns [1, 0]
        when [6, 5, 2, 2] returns [1, 1]
        when [3, 2, 3, 2] returns [1, 1]
        when [4, 3, 2, 1] returns [1, 2]
        when [5, 2, 3, 4] returns [2, 0]
      secret is [4, 5, 6, 6]
        when [1, 2, 3, 4] returns [0, 1]
        when [1, 1, 1, 1] returns [0, 0]
        when [6, 5, 2, 2] returns [1, 1]
        when [4, 4, 4, 6] returns [2, 0]
        when [4, 5, 6, 6] returns [4, 0]
        when [5, 4, 6, 6] returns [2, 2]
      secret is [1, 1, 1, 2]
        when [1, 2, 3, 4] returns [1, 1]
        when [1, 1, 1, 1] returns [3, 0]
        when [6, 5, 2, 2] returns [1, 0]
        when [1, 2, 2, 3] returns [1, 1]
        when [1, 1, 2, 1] returns [2, 2]
        when [5, 2, 3, 4] returns [0, 1]
      when guess length doesn`t match code length
        raises IndexError
    #lost?
      returns true when @state=:lost
      returns false when @state!=:lost
    #won?
      returns true when @state=:won
      returns false when @state!=:won
    #hint
      reveals one element of code
      is unique
      decrements number of hints left
      when no more hints
        raises an error
    #win
      changes state to :won
      changes score
    #lose
      changes state to :lost
      changes score
    private
      #extract_exact_matches
        secret is [1, 2, 2, 4]
          when [1, 2, 3, 4] returns 3
          when [1, 1, 1, 1] returns 1
          when [6, 5, 2, 2] returns 1
          when [1, 2, 2, 3] returns 3
          when [4, 3, 2, 1] returns 1
          when [5, 2, 3, 4] returns 2
        secret is [4, 5, 6, 6]
          when [1, 2, 3, 4] returns 0
          when [1, 1, 1, 1] returns 0
          when [6, 5, 2, 2] returns 1
          when [4, 4, 4, 6] returns 2
          when [4, 5, 6, 6] returns 4
          when [5, 4, 6, 6] returns 2
        secret is [1, 1, 1, 2]
          when [1, 2, 3, 4] returns 1
          when [1, 1, 1, 1] returns 3
          when [6, 5, 2, 2] returns 1
          when [1, 2, 2, 3] returns 1
          when [1, 1, 2, 1] returns 2
          when [5, 2, 3, 4] returns 0
      #extract_close_matches
        secret is [1, 2, 2, 4]
          when [1, 2, 3, 4] returns 3
          when [1, 1, 1, 1] returns 1
          when [6, 5, 2, 2] returns 2
          when [1, 2, 2, 3] returns 3
          when [4, 3, 2, 1] returns 3
          when [5, 2, 3, 4] returns 2
        secret is [4, 5, 6, 6]
          when [1, 2, 3, 4] returns 1
          when [1, 1, 1, 1] returns 0
          when [6, 5, 2, 2] returns 2
          when [4, 4, 4, 6] returns 2
          when [4, 5, 6, 6] returns 4
          when [5, 4, 6, 6] returns 4
        secret is [1, 1, 1, 2]
          when [1, 2, 3, 4] returns 2
          when [1, 1, 1, 1] returns 3
          when [6, 5, 2, 2] returns 1
          when [1, 2, 2, 3] returns 2
          when [1, 1, 2, 1] returns 4
          when [5, 2, 3, 4] returns 1
      #generate_code
        by default
          has 4 elements
          all elements between 1..6

Finished in 0.04023 seconds (files took 0.08552 seconds to load)
112 examples, 0 failures
```

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'codebreaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install codebreaker

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/codebreaker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

