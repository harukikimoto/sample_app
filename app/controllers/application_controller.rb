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

    

    

    
