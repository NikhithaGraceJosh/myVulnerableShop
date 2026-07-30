import "@hotwired/turbo-rails"
import "controllers"

import jquery from "jquery"

import * as ActiveStorage from "@rails/activestorage"

// Legacy feature modules use jQuery's global API. Keep that compatibility at
// the edge of the application while loading every dependency through importmap.
// report_preview/lazyload also use the `$` global at their top level, so they
// must load dynamically too -- a static import would run before this
// assignment regardless of where it's written in this file.
window.$ = window.jQuery = jquery

await Promise.all([
  import("jquery-ui-dist"),
  import("chosen-js"),
  import("nouislider"),
  import("owl.carousel"),
  import("cocoon"),
  import("bootstrap"),
  import("report_preview"),
  import("lazyload")
])

ActiveStorage.start()
