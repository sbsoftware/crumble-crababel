require "http_accept"

module Crumble
  module Crababel
    macro t
      accept_language = ctx.request.headers["Accept-Language"]?
      locale = if accept_language
        HTTP::Accept::Language.best_locale(
          ::Crababel.locales,
          HTTP::Accept::Language.parse(accept_language),
          "en",
        )
      else
        "en"
      end
      ::Crababel.locale(locale).{{ @type.name.split("::").map(&.underscore).join(".").id }}
    end
  end
end
