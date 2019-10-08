class CreateLinkSerializer < ActiveModel::Serializer
  attributes :url, :short_url
end

def short_url
  if Rails.env == 'development'
    "http://localhost:3001/#{self.slug}"
  else
    "https://micro-url-api.herokuapp.com/#{self.slug}"
  end
end
