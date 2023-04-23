# frozen_string_literal: true

# GitHub module holds all abstractions related to GitHub
module GitHub
  RELEVANT_KEYS_FROM_RESPONSE =
    %w[
      id
      owner
      full_name
      html_url
      description
      created_at
      updated_at
      license
    ].freeze

  def self.get_response(query, logger)
    response = HTTParty.get(ENV['GITHUB_SEARCH_URL'] + "?q=#{query}", headers:)
    case response.code
    when 400...600
      logger.error("#{response.code} Error handling request: #{response}")
      return []
    end

    sliced_response(response)
  end

  def self.sliced_response(response)
    response['items'].map { |item| item.slice(*RELEVANT_KEYS_FROM_RESPONSE) }
  end

  def self.headers
    {
      'Accept' => 'application/vnd.github+json',
      'Authorization' => "Bearer #{ENV['GITHUB_BEARER']}",
      'X-GitHub-Api-Version' => '2022-11-28'
    }
  end
end
