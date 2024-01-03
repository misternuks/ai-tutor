class UnitsController < ApplicationController
  def index
    @course = Course.find(params[:course_id])
    @units = @course.units
    render json: @units
  end

  def show
    @unit = Unit.find(params[:id])
  end

  def new
    @course = Course.find(params[:course_id])
    @unit = Unit.new
  end

  def create
    @course = Course.find(params[:course_id])
    @unit = Unit.new(unit_params)
    @unit.course = @course
    if @unit.save
      redirect_to course_path(@course)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @unit = Unit.find(params[:id])
    @course = @unit.course
  end

  def update
    @unit = Unit.find(params[:id])
    @course = @unit.course

    if @unit.update(unit_params)
      redirect_to unit_path(@unit)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @unit = Unit.find(params[:id])
    @course = @unit.course
    @unit.destroy
    redirect_to course_path(@course), status: :see_other
  end

  private
  def unit_params
    params.require(:unit).permit(:name, :details, :course_id)
  end
end
