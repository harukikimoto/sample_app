class PostsController < ApplicationController
  require "date"
  before_action :authenticate_user, {only: [:new, :create, :edit, :update]}
  before_action :only_user, {only: [:new]}
  before_action :only_my_edit_page, {only: [:edit, :update]}
  before_action :overworked_mail , {only: [:register_work_finished_time, :update]}
  
  
  def new
    @working_hour = Post.new
  end

  
  def register_work_starting_time
    @working_hour = Post.new(
      user_id: @current_user.id, 
      start_time: Time.current
    )
    @working_hour.save
    if @working_hour.save
      flash[:notice] = "出勤しました"
      redirect_to("/posts/new")
    end
  end
  
  def register_work_finished_time
    @current_user_posts = Post.where(user_id: @current_user.id)
    @working_hour = @current_user_posts.last
    @working_hour.finish_time = Time.current
    if @working_hour.save
      flash[:notice] = "今日も1日お疲れ様でした。"
      redirect_to("/posts/new")
    end
    @working_second = @working_hour.working_second_set
    overworked_mail(@working_second, @working_hour, @user)
  end
  
  def create
    @current_user_posts = Post.where(user_id: @current_user.id)
    @working_hour = @current_user_posts.last
    @working_hour.break_time = params[:break_time]
    @working_hour.comment = params[:comment]
    
    if @working_hour.save
      flash[:notice] = "休憩しました。"
      redirect_to("/posts/new")
    end
  end
  

  def edit
    @post = Post.find_by(id: params[:id])
  end
  
  def update
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
    @post.start_time = Time.parse(params[:start_time], @post.start_time)
    @post.finish_time = Time.parse(params[:finish_time], @post.finish_time)
    @post.break_time = params[:break_time]
    @post.save

    if @post.user.authority == 1 
      @post.comment = params[:comment]
    else
      @post.owner.comment = params[:owner_comment]
    end

    @working_second = @post.working_second_set
    overworked_mail(@working_second, @post, @user)

    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/users/#{@post.user.id}")
    else
      render("posts/edit")
    end
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "勤怠を削除しました"
    redirect_to("/users/#{@post.user.id}")
  end

  def overworked_mail (second, post, user)
    if 21600 < second && second < 28800
        if post.break_time == nil || (post.break_time * 60) < 2700
        return UserMailer.with(user: user).overworked.deliver_later
        end
    end
    if second > 28800
        if post.break_time == nil || (post.break_time * 60) < 3600
        return UserMailer.with(user: user).overworked.deliver_later
        end
    end
  end

  def only_user
      if @current_user.authority == 2
          flash[:notice] = "ユーザーである必要があります。"
          redirect_to("/users/index")
      end
  end

  def only_my_edit_page
    @post = Post.find_by(id: params[:id])
    if @current_user.authority == 1
        if @post.user_id != @current_user.id 
            flash[:notice] = "他のユーザーの情報は閲覧できません。"
            redirect_to("/users/#{@current_user.id}")
        end
    end
  end
end
