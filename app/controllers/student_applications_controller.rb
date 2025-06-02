class StudentApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student_application, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :application_not_found

  def index
    @student_applications = current_user.admin? ? StudentApplication.all : current_user.student_applications

    respond_to do |format|
      format.html
      format.json { render json: @student_applications }
    end
  end

  def show
    user = @student_application.user
    @recommendations = Recommendation.where(student_email: user.email, course_id: @student_application.course_id)
    @sections = Course.find(@student_application.course_id).sections
  end

  def new
    @student_application = StudentApplication.new
    @courses = Course.order(title: :asc)
  end

  def edit
    @courses = Course.order(title: :asc)
  end

  def create
    @student_application = current_user.student_applications.build(student_application_params)

    if @student_application.save
      redirect_to @student_application, notice: "Student application was successfully created."
    else
      @courses = Course.order(title: :asc)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    status = student_application_params[:status]

    if status == 'approved'
      handle_approval
    elsif status == 'denied'
      handle_denial
    end

    if @student_application.update(student_application_params)
      redirect_to @student_application, notice: "Student application was successfully updated."
    else
      @courses = Course.order(title: :asc)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student_application.destroy
    redirect_to student_applications_url, notice: "Student application was successfully destroyed."
  end

  private

  def set_student_application
    @student_application = StudentApplication.find(params[:id])
  end

  def student_application_params
    params.require(:student_application).permit(:status, :contact_info, :preferences_in_grading_assignments, :course_id)
  end

  def authorize_access
    unless current_user.admin? || @student_application.user == current_user
      redirect_to root_url, alert: "You are not authorized to view or edit this application."
    end
  end

  def application_not_found
    redirect_to student_applications_path, alert: "Application not found."
  end

  def handle_approval
    course = Course.find(@student_application.course_id)
    section = Section.find_by(id: params[:section_id])

    if section.nil?
      redirect_to action: :show, alert: "Please select a valid section!"
      return
    end

    if section.required_graders <= 0
      redirect_to action: :show, alert: "This section does not need any more graders!"
      return
    end

    @student_application.user.sections << section
    section.decrement!(:required_graders)
  end

  def handle_denial
    user = @student_application.user
    course = Course.find(@student_application.course_id)

    user.sections.each do |section|
      if course.sections.include?(section)
        user.sections.delete(section)
        section.increment!(:required_graders)
      end
    end
  end
end
