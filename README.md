##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.3.1](https://github.com/organization/project-name/blob/master/.ruby-version#L1)
- Rails [7.1.3](https://github.com/organization/project-name/blob/master/Gemfile#L12)

##### 1. Check out the repository

```bash
git clone git@github.com:andreephan/entrance_exam.git
```

##### 2. Create .env file

Copy the sample .env_sample file and edit the database configuration as required.

```bash
cp .env_example .env
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

##### 4. Gems Installing

Run the following commands to install gems

```ruby
bundle install
```

##### 5. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

##### 6. Run Rspec

You can run rspec using the command given below.

```ruby
bundle exec rspec
```

and you can check coverage percentage in coverage/index.html

##### 7. API documents

You can generate API documents using the command given below.

```ruby
rake rswag:specs:swaggerize
```

and you can check coverage percentage in [/api-docs/index.html](http://localhost:3000/api-docs/index.html)