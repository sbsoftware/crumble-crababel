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

private class LocalizedPage < Crumble::Page
  root_path "/localized-page"

  template do
    html do
      body do
        p { t }
      end
    end
  end
end

private class LocalizedResource < Crumble::Resource
  root_path "/localized-resource"

  def index
    render t
  end
end

describe Crumble::Crababel do
  it "returns the default locale when Accept-Language is missing" do
    request = HTTP::Request.new("GET", "/", headers: HTTP::Headers.new)

    Crumble::Crababel.locale_for(FakeCtx.new(request)).should eq(Crababel::En)
  end

  it "returns the best matching locale for the Accept-Language header" do
    headers = HTTP::Headers{"Accept-Language" => "de-DE,de;q=0.9,en;q=0.8"}
    request = HTTP::Request.new("GET", "/", headers: headers)

    Crumble::Crababel.locale_for(FakeCtx.new(request)).should eq(Crababel::De)
  end

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

  it "is available in Crumble::Page subclasses" do
    headers = HTTP::Headers{"Accept-Language" => "de"}
    res = String.build do |io|
      ctx = Crumble::Server::TestRequestContext.new(response_io: io, resource: LocalizedPage.uri_path, headers: headers)
      LocalizedPage.handle(ctx).should eq(true)
      ctx.response.flush
    end

    res.should contain("Hallo von der Seite")
  end

  it "is available in Crumble::Resource subclasses" do
    headers = HTTP::Headers{"Accept-Language" => "de"}
    res = String.build do |io|
      ctx = Crumble::Server::TestRequestContext.new(response_io: io, resource: LocalizedResource.uri_path, headers: headers)
      LocalizedResource.handle(ctx).should eq(true)
      ctx.response.flush
    end

    res.should contain("Hallo von der Resource")
  end
end
