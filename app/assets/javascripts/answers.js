function editAnswer() {
  return $('.edit-btn').click(function (e) {
    var answer_id;
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    return $('form#edit-answer-' + answer_id).show();
  });
}

function voteAnswer() {
  $('.answer-vote-buttons').bind('ajax:success', function (e) {
    response = JSON.parse(e.detail[2].response)
    $('#answer_' + response.id + '_total_votes').html('total:' + response.total)
    $('#answer_' + response.id + '_up_votes').html('likes:' + response.upvotes)
    $('#answer_' + response.id + '_down_votes').html('dislikes:' + response.downvotes)
  }).bind('ajax:success', function (e) {
    e.preventDefault();
    response = JSON.parse(e.detail[2].response)
    var errors;
    if (e.detail[2].status === 401) {
      return $('.answer_' + response.id + '_errors').html(response.error);
    }
    errors = response.error;
    $.each(errors, function (index, value) {
      return $('.answer_' + response.id + '_errors').html(value)
    });
  })
}

function updateAnswers() {
  var question_id;
  question_id = $('.question-answers').data('questionId')

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function () {

      this.perform('follow', { question_id: question_id })
      console.log("Connected")
    },
    received: function (data) {
      $('#question_' + question_id + '_answers').append(data)
      console.log(data)
    }
  })
}


$(document).on('turbolinks:load', function () {
  editAnswer();
  voteAnswer();
  updateAnswer();
})