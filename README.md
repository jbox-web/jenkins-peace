## Jenkins ~~War~~ Peace

[![GitHub license](https://img.shields.io/github/license/jbox-web/jenkins-peace.svg)](https://github.com/jbox-web/jenkins-peace/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/jenkins-peace.svg)](https://github.com/jbox-web/jenkins-peace/releases/latest)
[![Gem](https://img.shields.io/gem/v/jenkins-peace.svg)](https://rubygems.org/gems/jenkins-peace/versions/1.0.0)
[![Gem](https://img.shields.io/gem/dtv/jenkins-peace.svg)](https://rubygems.org/gems/jenkins-peace/versions/1.0.0)
[![Build Status](https://travis-ci.org/jbox-web/jenkins-peace.svg?branch=master)](https://travis-ci.org/jbox-web/jenkins-peace)
[![Code Climate](https://codeclimate.com/github/jbox-web/jenkins-peace/badges/gpa.svg)](https://codeclimate.com/github/jbox-web/jenkins-peace)
[![Test Coverage](https://codeclimate.com/github/jbox-web/jenkins-peace/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/jenkins-peace/coverage)
[![Dependency Status](https://gemnasium.com/jbox-web/jenkins-peace.svg)](https://gemnasium.com/jbox-web/jenkins-peace)

### A small console application to manage Jenkins war files, easy, and in peace ;)

This gem aims to replace [jenkins-war](https://rubygems.org/gems/jenkins-war/versions/1.514) to manage Jenkins war files.

The previous version of this gem used to embed the war file directly in the GitHub repo which could lead to very long upload/download time and some warnings from Github about large files.

This one uses a cache directory to store Jenkins war files (```/<home directory>/.jenkins/war-files```).


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

## Example

```sh
nicolas@desktop:~$ jenkins.peace list
+------------------+-------------------------------------------------------+-------------------------------------------------------------------------+-------------+
|  Version         |  Location                                             |  Classpath                                                              |  Installed  |
+------------------+-------------------------------------------------------+-------------------------------------------------------------------------+-------------+
|  latest (1.629)  |  /home/nicolas/.jenkins/war-files/latest/jenkins.war  |  /home/nicolas/.jenkins/wars/latest/WEB-INF/lib/jenkins-core-1.629.jar  |  true       |
|  1.628           |  /home/nicolas/.jenkins/war-files/1.628/jenkins.war   |  /home/nicolas/.jenkins/wars/1.628/WEB-INF/lib/jenkins-core-1.628.jar   |  true       |
+------------------+-------------------------------------------------------+-------------------------------------------------------------------------+-------------+
```

## Contributors

A big thank to [them](https://github.com/jbox-web/jenkins-peace/blob/master/AUTHORS) for their contribution!

## Contribute

You can contribute to this plugin in many ways such as :

* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations
