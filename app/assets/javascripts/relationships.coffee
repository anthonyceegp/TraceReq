# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $table = $('#editableTable')
  $fixedColumn = $table.clone().insertBefore($table).addClass('fixed-column')
  $fixedColumn.attr 'id', 'fixedColumn'
  $fixedColumn.find('th:not(:first-child),td:not(:first-child)').remove()
  $fixedColumn.find('th').each (i, elem) ->
    $(this).height $table.find('th:eq(' + i + ')').height()
    $(this).width $table.find('th:eq(' + i + ')').width()
    return
  return

$(window).on 'resize', ->
  $table = $('#editableTable')
  $fixedColumn = $('#fixedColumn')
  $fixedColumn.find('th').each (i, elem) ->
    $(this).height $table.find('th:eq(' + i + ')').height()
    $(this).width $table.find('th:eq(' + i + ')').width()
    return
  return