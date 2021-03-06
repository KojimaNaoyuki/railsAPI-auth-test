class MemosController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  before_action :set_memo, only: [:show, :update, :destroy]

  # GET /memos
  def index
    @memos = Memo.all

    render json: @memos
  end

  # GET /memos/1
  def show
    render json: @memo
  end

  # POST /memos
  def create
    @memo = Memo.new(memo_params)

    if @memo.save
      render json: @memo, status: :created, location: @memo
    else
      render json: @memo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /memos/1
  def update
    if @memo.update(memo_params)
      render json: @memo
    else
      render json: @memo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /memos/1
  def destroy
    @memo.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_memo
      @memo = Memo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def memo_params
      params.permit(:title, :content)
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        auth_user = User.find_by(token: token)
        auth_user != nil ? true : false
      end
end
end
