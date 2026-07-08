require "spec"
require "crumble"

{% unless Crumble.has_constant?("Action") %}
  abstract class Crumble::Action
    include Crumble::Server::ViewHandler

    def initialize(@request_ctx); end

    def window_title : String?
      nil
    end
  end
{% end %}

{% unless Crumble.has_constant?("Turbo") %}
  module Crumble::Turbo
  end
{% end %}

{% unless Crumble::Turbo.has_constant?("Action") %}
  abstract class Crumble::Turbo::Action
    include Crumble::Server::ViewHandler

    def initialize(@request_ctx); end

    def window_title : String?
      nil
    end
  end
{% end %}

require "../src/crumble-crababel"
