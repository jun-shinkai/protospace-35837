class PrototypesController < ApplicationController
  before_action :authenticate_user!,  only: [:new, :edit, :destroy]
  before_action :set_proto, except: [:index, :new, :create]
  before_action :move_to_index, except: [:index, :show]
  before_action :redirect_user, only: [:edit]
  def index
   @prototypes =  Prototype.all
  end
  
  def new
   @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
   if @prototype.save
    redirect_to root_path
  else
    render :new
  end
  end

  def show
    @comment   = Comment.new
    @comments  = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    @prototype.update(prototype_params)
    if @prototype.save
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    @prototype.destroy
    if @prototype.destroy
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def prototype_params
  params.require(:prototype).permit( :title, :catch_copy, :concept,:image).merge(user_id: current_user.id)
  end

  def set_proto
    @prototype = Prototype.find(params[:id])
   end

  def move_to_index
    unless user_signed_in?
    redirect_to action: :index
    end
  end  
  def redirect_user
    if current_user != @prototype.user
    redirect_to root_path
    end  
  end
end
