class SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_course, only: [:show, :new, :create, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :section_not_found

  def index
    @sections = Section.all
    section_ids = User.pluck(:section_id).compact
    @sections_not_having_graders = Section.where.not(id: section_ids)
    @sections_having_graders = Section.where(id: section_ids)
  end

  def show
    @section = @course.sections.find(params[:id])
  end

  def new
    @section = @course.sections.build
  end

  def create
    @section = @course.sections.build(section_params)
    if @section.save
      redirect_to @section, notice: "Section was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @section = @course.sections.find(params[:id])
  end

  def update
    @section = @course.sections.find(params[:id])
    if @section.update(section_params)
      redirect_to @course, notice: "Section was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section = @course.sections.find(params[:id])
    @section.destroy
    redirect_to @course, notice: "Section was successfully deleted."
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def section_params
    params.require(:section).permit(
      :section_number, :component, :instruction_mode, :building_description,
      :required_graders, :monday, :tuesday, :wednesday, :thursday, :friday,
      :saturday, :sunday, :start_time, :end_time, :start_date, :end_date, user_ids: []
    )
  end

  def authenticate_admin!
    unless current_user&.verified && current_user.role == "admin"
      redirect_to root_path, alert: "Access denied."
    end
  end

  def section_not_found
    redirect_to courses_path, alert: "Section not found."
  end
end
