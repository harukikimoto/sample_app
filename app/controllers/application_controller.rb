class ApplicationController < ActionController::Base
    before_action :set_current_user
    before_action :time
    
    def set_current_user
        @current_user = User.find_by(id: session[:user_id])
    end

    def time 
        @t = Time.now
        @num = @t.strftime("%w").to_i
        @weeks = ["日","月","火","水","木","金","土"]
        @week = @weeks[@num]
    end


def authenticate_user
    if @current_user == nil
        flash[:notice] = "ログインが必要です"
        redirect_to("/login")
    end
    end

    def only_owner
        if @current_user.authority == 1
            flash[:notice] = "オーナーである必要があります。"
            redirect_to("/users/#{@current_user.id}")
        end
    end

    def only_user
        if @current_user.authority == 2
            flash[:notice] = "ユーザーである必要があります。"
            redirect_to("/users/index")
        end
    end

    def only_my_user_show_page
        @post = Post.find_by(user_id: params[:id])
        if @current_user.authority == 1
            if params[:id].to_i != @current_user.id || @post.user_id != @current_user.id
                flash[:notice] = "他のユーザーの情報は閲覧できません。"
                redirect_to("/users/#{@current_user.id}")
            end
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

    def forbid_login_user
        if @current_user 
        flash[:notice] = "すでにログインしています"
        redirect_to("/users/#{@current_user.id}")
        end
    end
end
