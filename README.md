# Leolay Generators

[![Version     ](http://img.shields.io/gem/v/active_leonardo.svg)                     ](https://rubygems.org/gems/active_leonardo)
[![Travis CI   ](http://img.shields.io/travis/marcomd/Active_Leonardo/master.svg)     ](https://travis-ci.org/marcomd/Active_Leonardo)
[![Quality     ](http://img.shields.io/codeclimate/github/marcomd/Active_Leonardo.svg)](https://codeclimate.com/github/marcomd/Active_Leonardo)

A layout and customized scaffold generator for Rails to combine with active admin gem
It generates the layout, the style, the internationalization and it helps you to startup active_admin gems

## Compatibility

This version has been tested on Rails 4.0.x and Ruby 2.0 on Windows OS


## Install

    gem install active_leonardo

or

    rails new ActiveLeo -m http://dl.dropbox.com/u/52600966/active_template.rb

Click [here](http://dl.dropbox.com/u/52600966/active_template.rb) to download the template.

## Usage

Once you install the gem, the generators will be available to all Rails applications on your system.

To run the generator, go to your rails project directory and type:

    rails generate leolay || rails destroy leolay
    rails generate leosca || rails destroy leosca

You can run it more times and right like scaffold, it's smart and won't generate tons of identical code (thanks thor)

**Warning**: Leosca destroy do not remove variables parts inserted into feed like time values.

### Step by step

1.  Firstly, create layout and initialize your project:

        rails new ActiveLeo -m http://dl.dropbox.com/u/52600966/active_template.rb

    (You can also find the template into gem root folder)

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

    1. admin@activeleo.com, password: abcd1234 [this profile can do everything]

    2. manager@activeleo.com, password: abcd1234 [can read, create and update]

    3. user@activeleo.com, password: abcd1234 [can read, create, update and destroy]


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


## Tutorial

On my [Blog](http://marcomastrodonato.blogspot.it/) you can find some other info.


## Found a bug?

If you are having a problem please submit an issue at
* m.mastrodonato@gmail.com
* marcovlonghitano@gmail.com

## Rails 3.2.x

Use previous 0.1.0 version (tested with activeadmin 0.5.x)

## Rails 2 and Rails 3.0.x

This Generators does not work with versions earlier 3.1




