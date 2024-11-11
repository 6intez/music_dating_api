module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: [:create]

      def create
        user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation, audio_files: [])
        @user = User.new(user_params)
        if @user.save
          token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)

          render json: { message: 'Пользователь создан успешно', user: @user, token: token }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def random
        @user = User.where.not(id: current_user.id)
                    .where.not(id: current_user.liked_users.pluck(:id))
                    .order("RANDOM()")
                    .first

        if @user
          render json: {
            id: @user.id,
            name: @user.name,
            audio_files: @user.audio_files.map { |file| url_for(file) }
          }, status: :ok
        else
          render json: { message: "Нет доступных профилей для просмотра." }, status: :not_found
        end
      end

      def matches
        render json: current_user.matches.map { |user| user_response(user) }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, audio_files: [])
      end

      def user_response(user)
        {
          id: user.id,
          name: user.name,
          audio_files: user.audio_files.map { |file| url_for(file) }
        }
      end
    end
  end
end