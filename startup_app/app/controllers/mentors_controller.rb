class MentorsController < ApplicationController

  before_action :set_mentor, only: [:edit, :show, :update]
  before_action  :require_user, except: [:show,:index,:new,:create]

  #before_action :require_same_mentor, only: [:edit, :update]
  # before_action :require_admin, only: [:destroy]

  def index
    @mentors = Mentor.all.page(params[:page])
  end

  def new
    if !logged_in_user?
       flash[:danger] = "You need to make an account to our site first..please sign up or log in to your account"
      redirect_to members_path
    else
    @mentor = Mentor.new
    end
  end

  def create
    @mentor = Mentor.new(mentor_params)
    @mentor.user = current_user
    if @mentor.save
      session[:mentor_id] = @mentor.id
      flash[:success] = "Successfully signed up!"
      redirect_to mentor_path(@mentor)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @mentor = Mentor.find(params[:id])
    if @mentor.update(mentor_params)
      flash[:success] = "Successfully updated mentor!"
      redirect_to mentors_path
    else
      render 'edit'
    end
  end

  def show

  end

  def destroy
    @mentor = Mentor.find(params[:id])
    if @mentor.destroy
      flash[:danger] = "Mentor deleted"
      redirect_to mentors_path
    else
      flash[:danger] = "Sry, your requested action couldn't be performed!"
      redirect_to mentors_path
    end
  end

  private

  def set_mentor
    @mentor = Mentor.find(params[:id])
  end

  def mentor_params
    params.require(:mentor).permit(:experience, category_ids: [])
  end

  def require_same_mentor
    if current_mentor != @mentor #&& !current_mentor.admin?
      flash[:warning] = "You aren't authorized to perform this action"
      redirect_to mentors_path
    end
  end

  def require_admin
    if logged_in_mentor? #and !current_mentor.admin?
      flash[:warning] = "You aren't admin mentor"
      redirect_to pages_home_path
    end
  end

end
