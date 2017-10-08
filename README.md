# README

## Environment

* Ruby 2.4.2p198

* Rails 5.1.4

* Postgres 10.0.1 (mysql2 gem isn't compatible with ruby 2.4.x)

## Installing Rails

Follow this tutorial: https://medium.com/ruby-on-rails-web-application-development/how-to-install-rubyonrails-on-windows-7-8-10-complete-tutorial-2017-fc95720ee059

## Disable “LF will be replaced by CLRF” warning in Git on Windows

```
git config --global core.safecrlf false
```


## How can I ignore a file that is already committed to the repo?

See this: https://gist.github.com/tsrivishnu/a2f3adbbca9fcad5f3597af301ad1abb

## Coffee-script-source 1.9.0 does not work on windows
```
gem 'coffee-script-source', '1.8.0'
```

```
bundle update coffee-script-source
```