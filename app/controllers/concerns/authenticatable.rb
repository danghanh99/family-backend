module Authenticatable
  def authorize_request
    beaber = request.headers['Authorization']
    token = beaber.split(' ')[1] if beaber.present?
    decode_auth_token = JwtToken.decode(token)
    @current_user = User.find_by(id: decode_auth_token[:user_id])
    unless @current_user.present?
      render json: { error: 'Login failed' }, status: :bad_request
      nil
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end
