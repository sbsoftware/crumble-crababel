require "./spec_helper"
require "http"

private struct FakeCtx
  getter request

  def initialize(@request : HTTP::Request)
  end
end

private class Greeting
  include Crumble::Crababel

  getter ctx

  def initialize(@ctx : FakeCtx)
  end

  def message
    t
  end
end

describe Crumble::Crababel do
  it "falls back to the default locale when Accept-Language is missing" do
    request = HTTP::Request.new("GET", "/", headers: HTTP::Headers.new)
    greeting = Greeting.new(FakeCtx.new(request))

    greeting.message.should eq("Hello")
  end

  it "uses the Accept-Language header when present" do
    headers = HTTP::Headers{"Accept-Language" => "de"}
    request = HTTP::Request.new("GET", "/", headers: headers)
    greeting = Greeting.new(FakeCtx.new(request))

    greeting.message.should eq("Hallo")
  end
end
