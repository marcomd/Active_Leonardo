# Leolay Generators

[![Version     ](https://badge.fury.io/rb/active_leonardo.svg)                        ](https://rubygems.org/gems/active_leonardo)
[![Travis CI   ](http://img.shields.io/travis/marcomd/Active_Leonardo/master.svg)     ](https://travis-ci.org/marcomd/Active_Leonardo)
[![Quality     ](http://img.shields.io/codeclimate/github/marcomd/Active_Leonardo.svg)](https://codeclimate.com/github/marcomd/Active_Leonardo)

A layout and customized scaffold generator for Rails to combine with active admin gem
It generates the layout, the style, the internationalization and it helps you to startup active_admin gems

## Compatibility

This version has been tested on:

* Rails `3.2` `4.0` `4.1` `4.2` and Ruby `1.9.3` `2.0.0` `2.1.5` on Windows OS
* Rails `3.2` `4.0` `4.1` `4.1` and Ruby `1.9.3` `2.0.0` `2.1.5` on Linux OS

Click on Travis badge for more details.


## Install

    gem install active_leonardo

or

    rails new ActiveLeo -m https://db.tt/gPe6A0l9

or

    click [here](https://dl.dropboxusercontent.com/u/52600966/active_template.rb) to download the template.

or

    You can also get it from the gem root folder


## Usage

Once you install the gem, the generators will be available to all Rails applications on your system.

To run the generator, go to your rails project directory and type:

    rails generate leolay || rails destroy leolay
    rails generate leosca || rails destroy leosca

You can run it more times and right like scaffold, it's smart and won't generate tons of identical code (thanks thor)

**Warning**: Leosca destroy do not remove variables parts inserted into feed like time values.

### Step by step

1.  Firstly, create layout and initialize your project:

        rails new ActiveLeo -m YOUR_TEMPLATE_PATH (see above: install paragraph)

    Answer y to all gems you need.
    After the questions it will start generations.
    If it is the first generation there will be a conflict on locales/en.yml, type y to overwrite.

    Will be:
    * Created a default layout like active admin
    * Created i18n files
    * Created user management on active admin
    * Customized application.rb to exclude javascript and stylesheet for every resource you will create



2.  You will get an application ready to work, run:

        rails s

    and try it on http://localhost:3000

    If you get this message:

    *undefined local variable or method `new_user_registration_path'*

    be sure user model have **:registerable** devise's module otherwise add it into user model or you have to remove registerable code from

        app\views\application\_session.html.erb

    You can login as three different profiles loaded with a previous db:seed:

    1. admin@activeleo.com,   password: abcd1234 [this profile can do everything]

    2. manager@activeleo.com, password: abcd1234 [can read, create, update and destroy]

    3. user@activeleo.com,    password: abcd1234 [can read, create and update]

    There is a fourth profile for _guest_ users who can only see the data. In addition to these you can create all the profiles you need according to cancan rules.


3.  Create your resource:

        rails g leosca product name:string description:text active:boolean items:integer price:decimal

    This will act as a normal scaffold and has more new features:

    1. will be invoked new leosca_controller which is a customized scaffold_controller
    2. attributes will be insert into i18n files for a quick translation
    3. seeds will be created for you to populate new table
    4. invoke active admin generator to add the new resource with a custom configuration to work with cancan


4.  Apply to db as always you do:

        rake db:migrate
        rake db:seed

That's all!
The new application is ready to be customized to suit your needs:

* start to develop user front end
* take advantage of active admin and its dsl to quickly setup administration section



You could also customize leonardo templates both views and controller.
To copy under your project folder run:

    rails g leosca:install

Then go to

    lib\generators\erb

to edit erb views like you would do with original scaffold.
Go to

    lib\generators\rails

if you want to customize more.


For more information about usage:

    rails g leolay --help
    rails g leosca --help


### Example:

leolay:

    rails generate leolay
    rails generate leolay --skip-authentication --skip-authorization

leosca:

    rails generate leosca product name:string
    rails generate leosca product name:string --skip-seeds
    rails generate leosca product name:string --seeds=60          => if you need more records

if you made a mistake and want to start from scratch just replace generate with destroy to remove all files and inserted code

Of course, these options are in addition to those provided by the original scaffold


### Available layout

Currently the only one available is provided by ActiveAdmin
* active [default]


## How to test this project locally

Download this project and go inside the folder

Install the bundle wherever you want:

```ruby
bundle install --path=mybundle
```

Check current tasks typing:

```ruby
rake -T
```

    rake active:tests:all[inspection,rails_versions]  # Tests all rails versions
    rake active:tests:newapp[inspection,rails]        # Creates a test rails ap...
    rake active:tests:prepare[rails,path]             # Prepare the environment...

If you want to test everything we planned

```ruby
rake active:tests:all[inspection]
```

if you pass the argument inspection you can check the application under the test folder:

    test/TestApp_xxx_32
    test/TestApp_xxx_40
    test/TestApp_xxx_41
    test/TestApp_xxx_42

where xxx is the current ruby version and the last number the rails version.
Remember everytime you run a test that folders will be deleted and recreated.

Every rails version has its own bundle under ActiveLeonardo\mybundle_xx folder.

If you want to specify the rails version type:

```ruby
rake active:tests:all[inspection,4.2]
```

or multiple versions

```ruby
rake active:tests:all[inspection,4.1-4.2]
```

you may also specify your rails as ENV variables, for example on windows:

```ruby
set CI_RAILS=4.2
bundle install --path=mybundle_42
rake active:tests:newapp[inspection,4.2]
```

Do **NOT** exec rake tests from bundle to avoid its bubble.


## Tutorial

On my [Blog](http://mastrodonato.it/) you can find some other info.


## Found a bug?

Please open an issue on github or ask
* m.mastrodonato@gmail.com
* marcovlonghitano@gmail.com


## Rails 3.2.x

It works


## Rails 3.1.x

It should work but has not been tested


## Rails 2 and Rails 3.0.x

This Generators does not work with versions earlier 3.1




