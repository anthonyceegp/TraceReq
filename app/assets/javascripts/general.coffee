$(document).on 'turbolinks:load', ->
  $('.clickable-row td:not(:last-child)').click ->
    window.location = $(this).parent().data('href')
    return
  return