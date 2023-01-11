require 'google/apis/oauth2_v2'
class Api::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[google_login]
  include ActionController::HttpAuthentication::Token::ControllerMethods
  def google_login
    oauth2 = Google::Apis::Oauth2V2::Oauth2Service.new
    userinfo = oauth2.tokeninfo(access_token: params[:token])
    user = User.find_or_create_by(email: userinfo.email)
    if user.present?
      jwt = JwtToken.render_user_authorized_token user.jwt_payload
      render json: { token: "Bearer #{jwt}", user: UserSerializer.new(user) }
    else
      render json: { error: 'Failed to login google' }, status: :bad_request
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end
