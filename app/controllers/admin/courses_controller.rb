class Admin::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @courses = Course.includes(:user).order('users.class_code')
  end

  def edit_permissions
    @course = Course.find(params[:id])

    # Get the class code of the instructor who created the course
    instructor_class_code = @course.user.class_code

    # Fetch all class codes and their associated instructors, excluding the course's instructor class code
    instructors = User.where(instructor: true)
                      .where.not(class_code: instructor_class_code)
                      .select(:class_code, :username, :email)
                      .distinct

    @class_codes_with_instructors = instructors.map do |user|
      {
        class_code: user.class_code,
        label: "#{user.class_code} - #{user.username || user.email}"
      }
    end

    # Handle class codes without an instructor, excluding the course's instructor class code
    existing_class_codes = @class_codes_with_instructors.map { |item| item[:class_code] }
    all_class_codes = User.distinct.pluck(:class_code) - [instructor_class_code]
    missing_class_codes = all_class_codes - existing_class_codes

    missing_class_codes.each do |class_code|
      @class_codes_with_instructors << {
        class_code: class_code,
        label: "#{class_code} - No instructor"
      }
    end
  end

  def update_permissions
    @course = Course.find(params[:id])
    instructor_class_code = @course.user.class_code
    permitted_class_codes = params.dig(:course, :permitted_class_codes) || []

    # Ensure the instructor's class_code is not included
    permitted_class_codes = permitted_class_codes - [instructor_class_code]

    if @course.update(permitted_class_codes: permitted_class_codes)
      redirect_to admin_courses_path, notice: 'Permissions updated successfully.'
    else
      flash.now[:alert] = 'Failed to update permissions.'
      render :edit_permissions
    end
  end

  private

  def ensure_admin!
    redirect_to(root_path, alert: "You are not authorized to perform this action.") unless current_user.admin?
  end
end
