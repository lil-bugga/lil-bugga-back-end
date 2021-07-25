# lil bugga back-end

## Links

Hosted: https://lil-bugga.herokuapp.com/

Back-End Trello: https://trello.com/b/z0PAejSN/lil-bugga-back-end

Project: https://github.com/lil-bugga/project-documentation

Front-End: https://github.com/lil-bugga/lil-bugga-front-end

NB: Back-end heroku deployment is api only.

## Description

_For project features, go to the project readme linked above._
The **lil bugga back-end** is an **API** and **PostgreSQL database** designed to support the lil bugga frontend.
It supplies endpoints for creation and signing users, generating projects and tickets. As well as controlling authorisation and access based on users roles relative to a project.

## Testing Command

_How to run test suite._
To run the testing suite use the following command from the root directory of _lil-bugga-backend_:

```sh
rspec -fd
```

This will run all of the projects rspec tests from the `/spec/` folder. It is also configured to generate a coverage report when run. This is located in `/public/coverage/index.html` after RSpec tests have concluded and can be opened with any web browser.

Note that there were some dependency issues with **simpleCov**, the gem used to help create the coverage report, and it should be considered indicative only.

## Stack

- Ruby on Rails
- PostgreSQL
- Heroku
- RSpec testing library

## Libraries

- Faker
  - Faker is a gem used to generate fake, realistic-looking data. In this project, it is used solely for testing purposes and for generating realistic-looking seed data quickly. It should have no impact upon production implementation
- Bcrypt
  - Bcrypt is a gem that is included by default with a rails package. Whilst it needs to be uncommented in the `Gemfile` it is a useful gem that adds powerful methods for hashing passwords in the application. When enabled in the bundle file it adds the `has_secure_password` method to the project. When configured in the user model it sets a field called `password_confimation` that must be met as well as the regular password input field. If the two passwords match on a POST request Bcrypt hashes the password using its encryption algorithm and stores them in a database field called `password_digest`. Likewise, for authentication it encrypts the received password using the same algorithm and confirms a match.
- Knock
  - The Knock gem is used by the project to generate `JWT` bearer tokens used to authenticate users on the site. When a user connects to the site and is authenticated by `Bcrypt` a unique JWT token is generated using knock to identify them and transmitted in the response back. In subsequent requests to the server, if a user is required to authenticate they must post this `JWT token` in the request header. By default, this token is valid for 24 hours. We found this default acceptable and have opted to leave it as is.
- Rack-cors
  - `CORS` or Cross Origin Resource Sharing is a service used to authenticate network traffic across the internet. In this implementation, the `cors` gem is used to whitelist different URI's, preventing non-whitelisted domains from being able to submit API requests. Due to implementation issues with Netlify, this is currently set to enable all sources to make requests. Whilst not ideal, the back-end is not using any resources outside of the PostgreSQL database, and because authentication is required so we find the risk is acceptable.
- RSpec-rails
  - RSpec is a popular and well-known testing library for rails. I used it to generate my test suite.
- Factory_bot_rails
  - The `Factory bot` gem is a helper gem to assist with testing libraries. It allows you to write a framework or scaffold example of a model in a separate file. This scaffold can then be imported into the testing suite and used to build or create model entries to test against. Removing this code from the test files. It is by no means necessary but does simplify the testing implementation.
- Rails-controller-testing
  - rails controller testing allows you to make and mock(or imitate) data hitting your API endpoints. This is a useful tool that allows the testing suite to better and more predictably test the logic of controller methods.
- SimpleCov
  - SimpleCov generates an HTML file based on testing results allowing you to see a representation of testing done on the files specified. As a metric of test quality, SimpleCov should be seen as unreliable, as it only counts the number of lines your tests read, vs the number of lines actually in the file. However, it does provide some simple insight into the completeness of the test suite.
- Database_cleaner
  - Database cleaner is a tool used to complement the test suite. It acts to remove database entries made by the test suite in a way defined in its configuration. In this implementation, once tests have been completed database cleaner will rollback all commits since the initialisation of the test suite, essentially giving you a clean slate to work from.
