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
    $('#answer_' + response.id + '_total_votes').html(response.total)

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
  if (($('.question-answers').length)) {
    var question_id;
    question_id = $('.question-answers').data('questionId')

    App.cable.subscriptions.create('AnswersChannel', {
      connected: function () {
        this.perform('follow', {
          question_id: question_id
        })
      },
      received: function (data) {
        $('#question_' + question_id + '_answers').append(data)
        voteAnswer();
        editAnswer();
      }
    })
  } else if (App.answers) {
    App.answers.unsubscribe();
    App.answers = null;
  }
}

function updateComments() {
  if (($('.question-answers').length)) {
    var question_id;
    question_id = $('.question-answers').data('questionId')

    App.comments = App.cable.subscriptions.create(
      "CommentsChannel", {
        connected: function () {
          this.perform('follow', {
            question_id: question_id
          })
        },
        received: function (data) {
          switch (data.type) {
            case 'Question':
              $('.question-comments').append(data.html);
              break;
            case 'Answer':
              $('.answer-comments-' + data.id).append(data.html);
              break;
          }
        }
      });
  } else if (App.comments) {
    App.comments.unsubscribe();
    App.comments = null;
  }
}

$(document).on('turbolinks:load', function () {
  editAnswer();
  voteAnswer();
  updateAnswers();
  updateComments();
})