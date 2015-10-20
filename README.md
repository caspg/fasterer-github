[![Code Climate](https://codeclimate.com/github/caspg/fasterer-github/badges/gpa.svg)](https://codeclimate.com/github/caspg/fasterer-github)
[![Test Coverage](https://codeclimate.com/github/caspg/fasterer-github/badges/coverage.svg)](https://codeclimate.com/github/caspg/fasterer-github/coverage)

# fasterer-github

This is a [fasterer](https://github.com/DamirSvrtan/fasterer) extension which allows to scan GitHub repo using GitHub API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fasterer-github'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fasterer-github

## Request Rate Limit - Github Api

Github api rate limit for unauthenticated requests is 60 request per hour. Fortunately, authenticated requests get a higher rate limit, which allows to make up to 5,000 requests per hour.

## Configuration

You can use configure block to provide `access_token`:
```ruby
Fasterer::Github.configure do |config|
  config.access_token = 'YOUR_GITHUB_ACCESS_TOKEN'
end
```

Instead of `access_token`, you can also add `client_id` and `client_secret`:

```ruby
Fasterer::Github.configure do |config|
  config.client_id = 'YOUR_GITHUB_CLIENT_ID'
  config.client_secret = 'YOUR_GITHUB_CLIENT_SECRET'
end
```

## Usage

To scan whole repo, run:
```ruby
Fasterer::Github.scan('owner', 'repo')
```

You can also scan specific file:
```ruby
Fasterer::Github.scan('owner', 'repo', 'lib/fasterer-github.rb')
```

## Example output

```ruby
$ Fasterer::Github.scan('owner', 'repo', 'path/to/file.rb')

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

Bug reports and pull requests are welcome on GitHub at https://github.com/caspg/fasterer-github.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

