require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe "basic functionality" do
	def app
		Sinatra::Application
	end
	
	it "say 'hello world'" do
		get '/'
		last_response.should be_ok
		last_response.body.should == "hello world"
	end

end

describe "URL shortener" do
  def app
		Sinatra::Application
	end
	
	it "should redirect to home if no url given" do
		get '/shorten?'
		last_response.status.should == 302
		last_response.headers["location"].should == "http://example.org/"
	end
	
	it "should return a json object containing a url" do
		get '/shorten?url=www.google.com'
		parsed_body = JSON.parse last_response.body
		parsed_body["url"].nil?.should == false
	end	
end

# TODO : come up with better URLs to be testing on
describe "URL redirector" do
  def app
		Sinatra::Application
	end
	
	it "should redirect to home if no such shortened url exists" do
		get '/NOTEXISTANT'
		last_response.status.should == 302
		last_response.headers["location"].should == "http://example.org/"
	end

	it "should redirect me to google.com" do
		get '/abc123'
		last_response.status.should == 302
		last_response.headers["location"].should == "http://www.google.com/" # using google bad? Answer: not bad.
	end
end
