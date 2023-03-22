class UserMailer < ApplicationMailer

    def welcome_email
        @user = User.find_by(id: params[id])
        mail(
            subject: 'ご登録ありがとうございます',
            to: @user.email
        )
    end

    def forgot_to_press
        @user = User.find_by(id: params[id])
        mail(
            subject: '勤怠ボタンの押し忘れがありました',
            to: @user.email
        )
    end

    def overworked
        @user = User.find_by(id: params[id])
        mail(
            subject: '働きすぎの可能性があります。',
            to: @user.email
        )
    end
end
