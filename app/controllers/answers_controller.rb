class AnswersController < ApplicationController
  skip_before_action :authenticate_user!

  def quiz
    if Question.find(params[:question_id]).order == 1
      cookies[:score] = nil
      add_to_cookie(params[:score_id])
    else
      add_to_cookie(params[:score_id])
    end

    # this needs to be refactored
    # Get the question order of the current question
    @question_order = Question.find(params[:question_id]).order

    # find the question next in order.
    # returns an array of 1 item. Need to call first
    @question = Question.where(order: @question_order + 1).first
    authorize @question

    respond_to do |format|
      format.js
      # root_change
      format.html { redirect_back fallback_location: secret_path }
    end
  end

  def results
    add_to_cookie(params[:score_id])
    @distrikts = Distrikt.all
    @questions = Question.all
    @question = Question.first
    authorize @question

    result = Result.new(cookies[:score])
    @score = result.get_score
    @score_id = @score.id

    @scores = top_four

    @styles = Style.all.sort {|a,b| Compare.new(b.score, @score).average<=>Compare.new(a.score, @score).average }
  end

  private

  def add_to_cookie(score)
    cookies[:score] = "" if cookies[:score].nil?
    cookies[:score] += "#{score},"
  end

  def top_four
    # This is repeated in the distrikts controller.
    scores = @score.attributes
    scores.delete("id")
    scores.delete("created_at")
    scores.delete("updated_at")
    sorted_scores = scores.sort_by{|k,v| v}.reverse
    sorted_scores[0...4]
  end
end
