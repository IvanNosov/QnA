$(document).on 'turbolinks:load', ->
  $('.edit-btn').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

# $(document).on 'turbolinks:load', ->
#   $('form.answer-voting').bind 'ajax:success', (e) ->
#     response = JSON.parse(e.detail[2].response)
#     $('#rating_'+response.id).html(response.rating)


# $(document).on 'turbolinks:load', ->
#   $('form.answer-voting').bind 'ajax:success', (e) ->
#     response = JSON.parse(e.detail[2].response)
#     $('#rating_'+ response.id).html(response.rating)
#     $('[data-id='+response.id+']').show()
#   .bind 'ajax:error', (e) ->
#     response = JSON.parse(e.detail[2].response)
#     if (e.detail[2].status == 401)
#       return $('.answer-errors').html(response.error)
#     errors = response.errors
#     $.each response.errors, (index, value) ->
#       $('#answer_' + response.id + '-errors').html(value)

# $(document).on 'turbolinks:load', ->
#   $('.unvote-answer').bind 'ajax:success', (e) ->
#     xhr = e.detail[2]
#     id = $(this).data('id')
#     $('#rating_' + id).html(xhr.responseText)
#     $(this).hide()
