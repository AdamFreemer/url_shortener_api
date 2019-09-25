class LinkSerializer < ActiveModel::Serializer
  attributes :url, :short_url, :title, :views
end

def short_url
  if Rails.env = "development"
    "http://localhost:3001/api/v1/links/#{self.slug}"
  else
    "http://somedomain.com/api/v1/links/#{self.slug}"
  end
end
