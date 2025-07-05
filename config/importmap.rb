# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "rhino-editor", to: "rhino-editor.js"
pin "sortablejs" # @1.15.2
pin "flatpickr" # @4.6.13
pin "stimulus-flatpickr" # @3.0.0
