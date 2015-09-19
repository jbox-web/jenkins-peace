## Jenkins ~~War~~ Peace

[![GitHub license](https://img.shields.io/github/license/jbox-web/jenkins-peace.svg)](https://github.com/jbox-web/jenkins-peace/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/jenkins-peace.svg)](https://github.com/jbox-web/jenkins-peace/releases/latest)
[![Gem](https://img.shields.io/gem/v/jenkins-peace.svg)](https://rubygems.org/gems/jenkins-peace/versions/1.0.0)
[![Gem](https://img.shields.io/gem/dtv/jenkins-peace.svg)](https://rubygems.org/gems/jenkins-peace/versions/1.0.0)
[![Build Status](https://travis-ci.org/jbox-web/jenkins-peace.svg?branch=master)](https://travis-ci.org/jbox-web/jenkins-peace)
[![Code Climate](https://codeclimate.com/github/jbox-web/jenkins-peace/badges/gpa.svg)](https://codeclimate.com/github/jbox-web/jenkins-peace)
[![Test Coverage](https://codeclimate.com/github/jbox-web/jenkins-peace/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/jenkins-peace/coverage)
[![Dependency Status](https://gemnasium.com/jbox-web/jenkins-peace.svg)](https://gemnasium.com/jbox-web/jenkins-peace)
[![PullReview stats](https://www.pullreview.com/github/jbox-web/jenkins-peace/badges/master.svg?)](https://www.pullreview.com/github/jbox-web/jenkins-peace/reviews/master)

### A small console application to manage Jenkins war files, easy, and in peace ;)

## Installation

```ruby
gem install jenkins-peace
```

No need to add it to your Gemfile, it will be globally available.

## Usage

```sh
Commands:
  jenkins.peace clean               # Remove all war files
  jenkins.peace download <version>  # Download war file corresponding to version passed in params
  jenkins.peace help [COMMAND]      # Describe available commands or one specific command
  jenkins.peace infos               # Display infos about this gem
  jenkins.peace install <version>   # Install war file corresponding to version passed in params (will download then unpack war file)
  jenkins.peace latest              # Display infos about the latest version of war file installed
  jenkins.peace list                # List war files installed
  jenkins.peace remove <version>    # Remove war file corresponding to version passed in params
  jenkins.peace server <version>    # Start a server with the war file corresponding to version passed in params
  jenkins.peace unpack <version>    # Unpack war file corresponding to version passed in params
```


## Contributors

A big thank to [them](https://github.com/jbox-web/gh-preview/blob/master/AUTHORS) for their contribution!

## Contribute

You can contribute to this plugin in many ways such as :

* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations
