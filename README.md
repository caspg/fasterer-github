[![Code Climate](https://codeclimate.com/github/caspg/gh_fasterer/badges/gpa.svg)](https://codeclimate.com/github/caspg/gh_fasterer)
[![Test Coverage](https://codeclimate.com/github/caspg/gh_fasterer/badges/coverage.svg)](https://codeclimate.com/github/caspg/gh_fasterer/coverage)
## TODO
- update Readme
- rename repo to `fasterer-gh` and change files structure

# GhFasterer

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gh_fasterer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gh_fasterer

## Request Rate Limit - Github Api

Github api rate limit for unauthenticated requests is 60 request per hour. Fortunately, authenticated requests get a higher rate limit, which allows to make up to 5,000 requests per hour. To provide your github `client_id` and `client_secret` you have to use configure block:

```ruby
GhFasterer.configure do |config|
  config.client_id = 'YOUR_GITHUB_CLIENT_ID'
  config.client_secret = 'YOUR_GITHUB_CLIENT_SECRET'
end
```

## Usage

To scan whole repo, run:
```ruby
GhFasterer.scan('owner', 'repo')
```

You can also scan specific file:
```ruby
GhFasterer.scan('owner', 'repo', 'lib/gh_fasterer.rb')
```

## Example output

```ruby
$ GhFasterer.scan('owner', 'repo', 'path/to/file.rb')

{
  :repo_owner => 'owner',
  :repo_name => 'repo',
  :fasterer_offences => {
    :hash_merge_bang_vs_hash_brackets => [
      {
        :path => "https://api.github.com/repos/owner/repo/contents/path/to/file.rb?ref=master",
        :lines => [10, 17, 19]
      }
    ]
  },
  :errors => [],
  :api_errors => []
}
```

Example output when parser encounters some error and api returns error code:
```ruby
{
  :repo_owner => 'owner',
  :repo_name => 'repo',
  :fasterer_offences => {},
  :errors => [
    { path: 'path/to/file.rb' }
  ],
  :api_errors => [
    { code: 404, msg_body: 'some message from github api', path: 'path/to/file.rb' }
  ]
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/caspg/gh_fasterer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

