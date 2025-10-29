// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const attachAlertCloseHandler = () => {
  document.addEventListener("click", (e) => {
    const btn = e.target.closest('[data-bs-dismiss="alert"]')
    if (!btn) return
    e.preventDefault()
    const alertEl = btn.closest('.alert')
    if (alertEl) {

      alertEl.remove()
    }
  }, { passive: true })
}

document.addEventListener("DOMContentLoaded", attachAlertCloseHandler)
document.addEventListener("turbo:load", attachAlertCloseHandler)

const attachBackToHomeHandler = () => {
  document.addEventListener("click", (e) => {
    const btn = e.target.closest('[data-action="back-to-home"]')
    if (!btn) return
    e.preventDefault()
    let canGoBack = false
    try {
      if (document.referrer) {
        const ref = new URL(document.referrer)
        canGoBack = ref.origin === window.location.origin
      }
    } catch (_) {}
    if (canGoBack && history.length > 1) {
      history.back()
    } else {
      if (window.Turbo && typeof window.Turbo.visit === 'function') {
        window.Turbo.visit(btn.getAttribute('href'))
      } else {
        window.location.href = btn.getAttribute('href')
      }
    }
  }, { passive: false })
}

document.addEventListener("DOMContentLoaded", attachBackToHomeHandler)
document.addEventListener("turbo:load", attachBackToHomeHandler)
