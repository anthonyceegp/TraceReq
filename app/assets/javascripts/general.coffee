$(document).on 'turbolinks:load', ->
  $('.clickable-row td:not(.not-clikable)').click ->
    window.location = $(this).parent().data('href')
    return
  return