# config/initializers/her.rb
Her::API.setup url: API_BASE_URL do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use Her::Middleware::DefaultParseJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
  c.use Faraday::Response::RaiseError
end