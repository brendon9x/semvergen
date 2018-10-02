Semvergen
=========

Interactive semantic version and gem publishing

## Usage

Include `semvergen` in your gemfile:

```ruby
gem 'semvergen'
```

To bump the the gem's version:
```bash
$ semvergen bump
```

To release the current gem version:
```bash
$ semvergen release
```

## Using Semvergen with rubygems.org

* Make sure that you are logged in to rubygems (`gem signin`)
* Create a file named `.gem_server` with the following contents:
```
rubygems.org
```

## Using Semvergen with a custom gemserver

* Create a file named `.gem_server` and place your gemserver's url, together with the required credentials, in the file.

Example:
```
username:password@gems.com
```
