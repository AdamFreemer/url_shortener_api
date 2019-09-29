class Link < ApplicationRecord
  default_scope { order(views: :desc).limit(100) }

  def self.generate_slug
    # The conditional below is to account for the flaw in the log statement, 
    # when the link count is below 2 in the database.
    digits = Link.count > 1 ? Math.log(Link.count, 66).ceil : 1
    self.slug_characters(digits)
  end

  def self.slug_characters(slug_digits)
    alphanumcase = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    unreserved = ['-', '_', '.', '~']
    # unreserved = the balance of the RFC 3986 unreserved character set
    characters = [alphanumcase, unreserved].map(&:to_a).flatten
    (0...slug_digits).map { characters[rand(characters.length)] }.join
  end

  def self.index_slug
    return unless ActiveRecord::Base.connection.indexes(:links).first.name.include?('slug')
    
    ActiveRecord::Base.connection.indexes(:links).first.name  
  end

  def self.index_url
    return unless ActiveRecord::Base.connection.indexes(:links).second.name.include?('url')
    
    ActiveRecord::Base.connection.indexes(:links).second.name  
  end
end
