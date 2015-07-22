class CommentsController < ApplicationController


  def create
    comment = Comment.new
    comment.message = params['comment']
    comment.user_id = params['current_user']
    comment.circle_id = params['circle_id']
    comment.save!

    render :nothing => true
  end
end
