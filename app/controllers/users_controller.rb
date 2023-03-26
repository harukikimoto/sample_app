class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :only_owner, {only: [:index]}
  before_action :only_my_user_show_page, {only: [:show, :edit, :update]}

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @user = User.find_by(id: params[:id])
    @e = Enumerator.new do |yielder|
      head = Date.current
      tail = @user.created_at.prev_month
    
      while tail <= head
        yielder << head
        head = head.prev_month
      end
    end
    
    @posts = Post.where(user_id: @user.id)
    @posts.each do |post|
      if post.finish_time == nil
        UserMailer.with(user: @user).forgot_to_press.deliver_later
      end
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      authority: params[:authority]
    )
    if @user.save
        UserMailer.with(user: @user).welcome_email.deliver_later
        session[:user_id] = @user.id
          if @user.authority == 1
            redirect_to("/users/#{@user.id}")
          else
            redirect_to("/users/index")
          end
      else
        render("users/new")
      end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    
    
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def login_form
  end
  
  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      if @user.authority == 1
        redirect_to("/posts/new")
      else
        redirect_to("/users/index")
      end
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]

      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def only_owner
      if @current_user.authority == 1
          flash[:notice] = "オーナーである必要があります。"
          redirect_to("/users/#{@current_user.id}")
      end
  end

  def only_my_user_show_page
      if @current_user.authority == 1
          if params[:id].to_i != @current_user.id
              flash[:notice] = "他のユーザーの情報は閲覧できません。"
              redirect_to("/users/#{@current_user.id}")
          end
      end
  end

  def forbid_login_user
      if @current_user 
      flash[:notice] = "すでにログインしています"
      redirect_to("/users/#{@current_user.id}")
      end
    end
  end
end
