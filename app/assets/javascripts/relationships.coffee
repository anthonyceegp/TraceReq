# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).on 'resize', ->
  $table = $('#editableTable')
  $fixedColumn = $('#fixedColumn')
  $fixedColumn.find('th').each (i, elem) ->
    $(this).height $table.find('th:eq(' + i + ')').height()
    $(this).width $table.find('th:eq(' + i + ')').width()
    return
  return

