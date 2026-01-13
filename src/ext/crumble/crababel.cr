require "http_accept"

module Crumble
  module Crababel
    macro t
      locale = HTTP::Accept::Language.best_locale(::Crababel.locales, HTTP::Accept::Language.parse(ctx.request.headers["Accept-Language"]), "en")
      ::Crababel.locale(locale).{{ @type.name.split("::").map(&.underscore).join(".").id }}
    end
  end
end
