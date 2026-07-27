require "http_accept"

module Crumble
  module Crababel
    def self.locale_for(ctx)
      accept_language = ctx.request.headers["Accept-Language"]?
      ::Crababel.locale(if accept_language
        HTTP::Accept::Language.best_locale(
          ::Crababel.locales,
          HTTP::Accept::Language.parse(accept_language),
          "en",
        )
      else
        "en"
      end)
    end

    macro t
      ::Crumble::Crababel.locale_for(ctx).{{ @type.name.split("::").map(&.underscore).join(".").id }}
    end
  end
end
