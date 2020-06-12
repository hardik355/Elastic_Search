require 'elasticsearch/model'

class Post < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  index_name([Rails.env,base_class.to_s.pluralize.underscore].join('_'))

    # mappings dynamic: false do
    #   indexes :author, type: :text
    #   indexes :title, type: :text, analyzer: :english
    #   indexes :body, type: :text, analyzer: :english
    #   indexes :tags, type: :text, analyzer: :english
    # end

  def self.search_published(query)
    self.search({
      query: {
        bool: {
          must: [
          {
            multi_match: {
              query: query,
              fields: [:author, :title, :body, :tags]
            }
          },
          {
            match: {
              published: true
            }
          }]
        }
      }
    })
  end
  
end
