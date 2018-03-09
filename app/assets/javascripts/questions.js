$(document).on('turbolinks:load', function () {
  $('.edit-question-link').click(function (e) {
    e.preventDefault();
    var question_id;
    $(this).hide;
    question_id = $(this).data('questionId');
    console.log(question_id);
    return $('form#edit-question-' + question_id).show();
  });
});

$(document).on('turbolinks:load', function () {
  $('.vote-buttons').bind('ajax:success', function (e) {
    response = JSON.parse(e.detail[2].response)
    $('#question_' + response.id + '_total_votes').html('total:' + response.total)
    $('#question_' + response.id + '_up_votes').html('likes:' + response.upvotes)
    $('#question_' + response.id + '_down_votes').html('dislikes:' + response.downvotes)
    $('.unvote-question').show()
  })
}).bind('ajax:success', function (e) {
  response = JSON.parse(e.detail[2].response)
  var errors;
  if (e.detail[2].status === 401) {
    return $('.question-errors').html(response.error);
  }
  errors = response.error;
  $.each(errors, function (index, value) {
    return $('.question-errors').html(value).addClass('alert alert-warning alert-dismissible');
  });
})


$(document).on('turbolinks:load', function () {
  $('.unvote-question').bind('ajax:success', function (e) {
    response = JSON.parse(e.detail[2].response)
    $('#question_' + response.id + '_total_votes').html('total:' + response.total)
    $('#question_' + response.id + '_up_votes').html('likes:' + response.upvotes)
    $('#question_' + response.id + '_down_votes').html('dislikes:' + response.downvotes)
    $('.unvote-question').hide()
  })
})

$(document).on('turbolinks:load', function () {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function () {
      console.log("Connected")
      this.perform('follow')
    },
    received: function (data) {
      $('.questions-list').append(data)
      console.log(data)
    }
  }
)});