class User < ApplicationRecord
    validates :name, {presence: true}
    validates :email, {presence: true, uniqueness: true}
    validates :password, {presence: true}
    validates :authority, {presence: true}


    def post
        @posts =  Post.where(user_id: self.id)
        return @posts.last
    end

    def this_month_posts_set(user, )

    end

    def time_set(post)
        @st_time = post&.start_time
        @fn_time = post&.finish_time
    end

    def st_num_set
        return self&.strftime("%w").to_i
    end

    def working_second_set
        return self.finish_time.to_i - self.start_time.to_i
    end

    def overwork_terms_set(break_time)
        return  break_time == nil || (break_time * 60) 
    end

end
