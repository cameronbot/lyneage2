class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_filter :authenticate_user!, only: :create

  respond_to :json
  def create
 
    user = User.new(params[:user])
    if user.save
      user = User.find_for_database_authentication(:email => user.email)
      user.ensure_authentication_token!
      render :json => { :authentication_token => user.authentication_token, :user => user }, :status => :created
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end
end