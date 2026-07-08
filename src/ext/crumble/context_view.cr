require "./crababel"

{% if @top_level.has_constant?("Crumble") && Crumble.has_constant?("ContextView") %}
  module Crumble::ContextView
    include ::Crumble::Crababel
  end
{% end %}
