require "./crababel"

{% if @top_level.has_constant?("Crumble") %}
  {% if Crumble.has_constant?("Action") %}
    abstract class Crumble::Action
      include ::Crumble::Crababel
    end
  {% end %}

  {% if Crumble.has_constant?("Turbo") && Crumble::Turbo.has_constant?("Action") %}
    abstract class Crumble::Turbo::Action
      include ::Crumble::Crababel
    end
  {% end %}
{% end %}
