require "./crababel"

module Crumble
  class Form
    include ::Crumble::Crababel

    macro default_label_caption(field)
      t.{{field.id}}
    end
  end
end
