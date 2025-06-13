<div align="center">
    <img width="150" src="https://github.com/flynnsol/Sheldr/blob/main/images/logo.png" alt="Sheldr Logo"/>
</div>

## Why Sheldr?

While searching for CLI tools to use in a Ruby project I came across TTY (teletype) and was excited about how it functioned. Unfortunately, TTY hasn't been maintained for years and no longer was able to run when I tried to use it. I also noticed that it had some potential for updating and making things more fluid for an end user, so I started working on Sheldr.

## What does Sheldr do?

Sheldr allows you to quickly create new CLI applications while using the Sheldr CLI itself. Below you'll find more instructions on what those commands are and how to utilize them to create projects of different sizes and complexity.

## How to use Sheldr:

> [!IMPORTANT]
> Sheldr is in a very early state of functionality with minor error management.

<br>

Install Sheldr by using:

    $ gem install sheldr

Navigate to the folder that you want your project to be created in and then run:

    $ sheldr new app

"app" being the name of your application. This will create a new project with a structure like so:

```
app/
|-- exe/
|   |-- app
|-- lib/
|   |-- app/
|   |   |-- commands/
|   |   |   |-- version.rb
|   |   |-- commands.rb
|   |   |-- version.rb
|   |-- app.rb
|-- tests/
|-- .gitignore
|-- CHANGELOG.md
|-- CODE_OF_CONDUCT.md
|-- Gemfile
|-- Gemfile.lock
|-- LICENSE.txt
|-- Rakefile
|-- app.gemspec
```

You can now run your application by navigating to app/exe and running:

    $ ruby app

Which will show you the list of commands, currently only having one which you can test with:

    $ ruby app version

To add commands to your new app you can use the "add" command from your app/ directory:

    $ sheldr add command

There are many optional arguments for both the "new" and "add" commands which I will list below:


> New

    $ sheldr new app --author="authorname"
    $ sheldr new app --email="email"
    $ sheldr new app --summary="summary"
    $ sheldr new app --description="description"
    $ sheldr new app --homepage="homepageURI"
    $ sheldr new app --rubyversion=">= 3.1.0"
    $ sheldr new app --allowed_push_host="https://rubygems.org"
    $ sheldr new app --sourcecode_uri="sourcecodeURI"
    $ sheldr new app --changelog_uri="changelogURI"

> Add

    $ sheldr add command --description="description"
    $ sheldr add command --aliases="[alias1, alias2]"
    $ sheldr add command --args="[argname, true, description][argname2, description2]"
    $ sheldr add command --options="[optionname, defaultfield, description][optionname2, defaultfield2, description2]"

## Feature Functionality Tracking

- [x] "new" command working to create project
- [x] "add" command working to add commands to project
- [ ] allow arguments for "new" command
    - [ ] license (do after template files are being used)
    - [x] author
    - [x] email
    - [x] summary
    - [x] description
    - [x] homepage
    - [x] rubyversion
    - [x] allowed_push_host
    - [x] sourcecode_uri
    - [x] chargelog_uri
- [ ] allow arguments for "add" command
    - [x] description
    - [x] aliases
    - [x] arguments
    - [/] options
    - [ ] subcommands
        - [ ] subcommand arguments
        - [ ] subcommand options
        - [ ] subcommand examples
    - [ ] examples
- [ ] switch to creating files from template files