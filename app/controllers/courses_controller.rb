class CoursesController < AuthenticationsController
  skip_before_action :ensure_instructor_or_admin!, only: [:index]

  def index
    @user = current_user
    @courses = Course.joins(:user).where(
      "users.class_code = :class_code OR :class_code = ANY (courses.permitted_class_codes)",
      class_code: @user.class_code
    )
  end



  def show
    @course = Course.find(params[:id])
  end

  def new
    @user = current_user
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user

    if @course.save
      redirect_to courses_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])

    if @course.update(course_params)
      redirect_to course_path(@course)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    redirect_to courses_path, status: :see_other
  end

  private
  def course_params
    params.require(:course).permit(:name, :details)
  end
end

# def units
#   @units = Course.find(params[:id]).units
#   respond_to do |format|
#     format.json { render json: @units }
#   end
# end

# def lessons
#   unit = Unit.find(params[:unit_id])
#   @lessons = unit.lessons
#   respond_to do |format|
#     format.json { render json: @lessons }
#   end
# end

# def chatrooms
#   @lesson = Lesson.find(params[:lesson_id])
#   @chatrooms = @lesson.chatrooms
# end
