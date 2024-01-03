class LessonsController < ApplicationController
  def index
    @unit = Unit.find(params[:unit_id])
    @lessons = @unit.lessons
    render json: @lessons
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def new
    @unit = Unit.find(params[:unit_id])
    @lesson = Lesson.new
  end

  def create
    @unit = Unit.find(params[:unit_id])
    @lesson = Lesson.new(lesson_params)
    @lesson.unit = @unit

    if @lesson.save
      redirect_to unit_path(@unit)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
    @unit = @lesson.unit
  end

  def update
    @lesson = Lesson.find(params[:id])
    @unit = @lesson.unit

    if @lesson.update(lesson_params)
      redirect_to lesson_path(@lesson)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    @unit = @lesson.unit
    @lesson.destroy

    redirect_to unit_path(@unit), status: :see_other
  end

  private
  def lesson_params
    params.require(:lesson).permit(:name, :details)
  end
end
