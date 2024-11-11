class ApplicationController < ActionController::API
  before_action :authenticate_user!
  #protect_from_forgery with: :null_session
  private
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    payload = JWT.decode(token, Rails.application.secret_key_base)[0]
    @current_user = User.find(payload['user_id'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
  def current_user
    @current_user
  end
end
