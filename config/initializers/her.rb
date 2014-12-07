# config/initializers/her.rb
Her::API.setup url: "http://orient-vega.codio.io:9292" do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use Her::Middleware::DefaultParseJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
end