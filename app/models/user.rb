class User < ApplicationRecord
    validates :name, {presence: true}
    validates :email, {presence: true, uniqueness: true}
    validates :password, {presence: true}
    validates :authority, {presence: true}


    def post
        @posts =  Post.where(user_id: self.id)
        return @posts.last
    end

    def working_second_set
        return self.finish_time.to_i - self.start_time.to_i
    end

end
