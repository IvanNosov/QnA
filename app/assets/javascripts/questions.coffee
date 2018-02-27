$(document).on 'turbolinks:load', ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide
    question_id = $(this).data('questionId')
    console.log(question_id)
    $('form#edit-question-' + question_id).show()