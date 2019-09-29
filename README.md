# RAILS URL SHORTENER API README

This readme is the basic requirements and setup guide to run this application in your location development environment.

#### Requirements:

* Ruby > 2.6.3
* Bundler > 2.0
* Redis installed
* Postgres installed
* Familiarity with CURL or an API client like Postman (preferred)
* A JSON viewing plugin in your browser would be helpful

#### Basic Setup Instructions:

1. Clone the directory: 

    ```
    $ git clone https://github.com/AdamFreemer/url_shortener_api.git
    ```
    
2. Navigate in your console into the app directory and switch to Ruby v2.6.3 

3. `$ bundle install`

4. Setup the database:
    ```
    $ rake db:create; rake db:migrate;
    ```

#### Running the Application:

* You will need 3 tabs or windows in your console to run the application

1. In your first window, run the rails server: 
    ```
    $ rails s -p 3001
    ```
2. In a second window, start up a redis server:
    ```
    $ redis-server
    ```
3. In a third window, run Sidekiq:
    ```
    bundle exec sidekiq
    ```

#### Using the API

* Note: you can substitute `https://micro-url-api.herokuapp.com` in place of `localhost:3001` in the instructions below, to test against the active Heroku demo app of this repo. 

1. To create a short url link:
    
    * In your client, create a POST to: `localhost:3001/api/v1/links`
    * In the body of your request, create a JSON structure as such:
    ```
    {
      "url": "https://www.yamaha.com"
    }
    ```
    * Send the request. 
    * You should receive a JSON response back similar to below:
    ```
      {
        "url": "https://www.yamaha.com",
        "short_url": "http://localhost:3001/api/v1/links/A"
      }
    ```
2. To view the newly created short link's information:

    * In your client, create a GET to: `localhost:3001/api/v1/links/{short code}`
    * Noting the { short code } is what was returned in your create API call (this will most likely be a single character).
    * You can also get a JSON response directly from your browser by copying and pasting the link returned from your create API call.
    * Note: Every time you perform a GET request, it will increment the view counter for this url.

3. To view the top 100 urls sorted by view count:
    * Create a GET request in your API testing client or paste in your browser for a JSON respons:
    ```
    http://localhost:3001/api/v1/top_urls
    ```

#### Notes on the short link algorithm:

The code that governs the short link slug creation is located in the Link model:
    
  ```
  def self.generate_slug
    # The conditional is to account for the flaw in the log statement 
    # below a count of 2 in the database
    digits = Link.count > 1 ? Math.log(Link.count, 66).ceil : 1
    self.slug_characters(digits)
  end
  
  def self.slug_characters(slug_digits)
    alphanumcase = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    unreserved = ['-', '_', '.', '~']
    # nreserved = the balance of the RFC 3986 unreserved character set
    characters = [alphanumcase, unreserved].map(&:to_a).flatten
    (0...slug_digits).map { characters[rand(characters.length)] }.join
  end
  ```
  I chose to use a base 66 (26 uppercase characters + 26 lowercase + 10 numeric + 4 RFC 3986 unreserved remaining characters) character set. The thought here was to keep to the standard available character set dictated by RFC URI standards, but be as large of a character set as reasonbly possible, to minimize the slug digit count.

  The `generate_slug` class method uses a logarithmic calculation of the number of links in the database, to determine how many digits are required for the shortest slug (based off of our base 66 character set).

  The `slug_characters` class method takes the slug generated, and creates a randomized string (slug) with the number of characters specified in the `generate_slug` method.

  This mechanism is then leveraged in the Links controller, by a Rails 6 DHH inspired (https://sikac.hu/use-create-or-find-by-to-avoid-race-condition-in-rails-6-0-f44fca97d16b) create_or_find_by style approach. This approach utilizes uniqueness indexes created on the Links table, to perform a select and create all in 1 database request. Of the several current techniques in eliminating race conditions encountered during uniqueness validations, with their benefits and draw backs, given the scope of this project, I thought this was a reasonable solution.

