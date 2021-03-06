0.9.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.8.1...v0.9.0) March 1th, 2016
------------------------------
* Different style for production env
* Improved email to name in the user model
* User.with_role(:role) now works on rails 4+

0.8.1 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.8.0...v0.8.1) February 18th, 2016
------------------------------
* Improved the documentation
* Fixed a bug on the travis test

0.8.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.7.0...v0.8.0) February 17th, 2016
------------------------------
* Permitted params now use the _id suffix for foreign key fields, in this way the parent resourse can be saved
* Improved the dsl generated for active admin
* Improved tests

0.7.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.6.1...v0.7.0) February 16th, 2016
------------------------------
* resources are now being created with dsl activeadmin like boilerplate parameter
* new generator leosca:massive to create multiple resources from scaffold.txt file, check the documentation for more details
* improved the documentation
* several little improvements

0.6.1 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.6.0...v0.6.1) February 9th, 2016
------------------------------
* Removed Rails 3.2 from tests
* Removed Ruby 1.9 and 2.1 from tests

0.6.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.5.3...v0.6.0) February 9th, 2016
------------------------------
* Rails 5 ready
* Now leosca generator prepares the activeadmin dsl for index, show, filters and form
* New user name method inside the model to show a name from email
* Updated italian devise message to align with version 3.5 of devise

0.5.3 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.5.2...v0.5.3) November 9th, 2015
------------------------------
* Removed a bug that occurs during the destroy
* Removed obsolete test cases from travis

0.5.2 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.5.1...v0.5.2) November 5th, 2015
------------------------------
* Little improvements to work with rails 4.2
* Removed devise default user

0.5.1 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.5.0...v0.5.1) Jennuary 20th, 2015
------------------------------
* Tutorial updated
* Change in Ability model: the pre configured user profile now cannot destroy resource
* License updated

0.5.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.4.1...v0.5.0) Jennuary 7th, 2015
------------------------------
* Removed custom cancan integration, now activeadmin includes it
* Improved the template for rails 4.2
* removed the dependency with active admin which version 1 remains in beta
* Improved Readme and test.rake

0.4.1 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.4.0...v0.4.1) July 22th, 2014
------------------------------
* Added formtastic github url
* Turbolinks now works
* Several little improvements

0.4.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.3.0...v0.4.0) April 11th, 2014
------------------------------
* Rails 4.1 passed
* Improved rake tests, now active:tests:all perform test from rails 3.2 to 4.1
* Added Rails 4.1 tests to Travis CI

0.3.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.2.3...v0.3.0) April 8th, 2014
------------------------------
* New, edit and destroy buttons are now shown only if authorized
* The activeadmin method "default_actions" now show only authorized links
* Turned on turbolinks by default. You can remove jquery.turbolinks from active_admin.js.coffee

0.2.3 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.2.2...v0.2.3) March 21th, 2014
------------------------------
* Improved rake test to iterate several rails versions (currently 3.2.x and 4.0.x)
* Code improvements

0.2.2 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.2.1...v0.2.2) March 12th, 2014
------------------------------
* Added suite test
* Travis integration

0.2.1 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.2.0...v0.2.1) March 11th, 2014
------------------------------
* Turbolinks now working with ActiveAdmin
* Git initial commit fixed (now double quoted comment)

0.2.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.1.0...v0.2.0) March 6th, 2014
------------------------------
* Tested with Rails 4.0, Ruby 2.0 and ActiveAdmin 1.0.0pre
* Now "references" data types into seeds.rb have more consistent data
* Improved i18n integration
* Restored original TestUnit
* Improved cancan integration

0.1.0 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.7...v0.1.0) February 18th, 2013
------------------------------
* Added alias batch_action to ability so who can update can also use batch action. Still You will need to authorize every action.

0.0.7 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.6...v0.0.7) January 16th, 2013
------------------------------
* Added devise locale yaml
* Added roles? method to authentication model (user)
* Fixed custom active admin sass

0.0.6 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.5...v0.0.6) January 14th, 2012
------------------------------
* Configuration parameters moved into a yaml file (config.yml)
* Template updated

0.0.5 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.4...v0.0.5) September 26th, 2012
------------------------------
* Added support to activeadmin 0.0.5
* Added cancan's unauthorized message to localization

0.0.4 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.3...v0.0.4) August 13th, 2012
------------------------------
* Now you can use any name instead of *User*

0.0.3 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.2...v0.0.3) August 10th, 2012
------------------------------
* Improved cancan integration
* Localization yaml file cleaned from some previous leonardo stuff

0.0.2 [☰](https://github.com/marcomd/Active_Leonardo/compare/v0.0.1...v0.0.2) May 23th, 2012
------------------------------
* Minor changement

0.0.1 May 23th, 2012
------------------------------
* First release