class RecommendationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommendation, only: %i[show edit update destroy]

  def index
    @recommendations = Recommendation.all
    @recommendations = @recommendations.where(course_id: params[:course_filter]) if params[:course_filter].present?
  end

  def show; end

  def new
    @recommendation = Recommendation.new(prof_email: current_user.email)
    @courses = Course.order(title: :asc)
  end

  def edit
    @courses = Course.order(title: :asc)
    @sections = @recommendation.course.sections
  end

  def create
    @recommendation = Recommendation.new(recommendation_params.merge(prof_email: current_user.email))

    if @recommendation.save
      redirect_to @recommendation, notice: "Recommendation was successfully created."
    else
      @courses = Course.order(title: :asc)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @recommendation.update(recommendation_params)
      redirect_to @recommendation, notice: "Recommendation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recommendation.destroy!
    redirect_to recommendations_url, notice: "Recommendation was successfully destroyed."
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:student_email, :course_id, :section_id_
