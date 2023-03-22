class Post < ApplicationRecord

    validates :start_time, {presence: true}
    validates :finish_time, {presence: true}

    def user
        return User.find_by(id: self.user_id)
    end

    def working_second_set
        return self.finish_time.to_i - self.start_time.to_i
    end

    def working_hour_set
        return Time.at(self.finish_time.to_i - self.start_time.to_i).utc.strftime("%H:%M")
    end

end
