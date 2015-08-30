class JobsController < ApplicationController
  before_action :authenticate!,except:[:index,:show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def myjobs
    @jobs = current_user.jobs
  end

  def index
    @jobs = Job.all
    render :layout => 'root'
  end

  def show
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: '已成功更新工作資訊' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end
  def create
    @job = current_user.jobs.build(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: '成功新增工作資訊' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to :jobs, notice: '工作資訊已刪除' }
      format.json { head :no_content }
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
      params.require(:job).permit(
        :title,:description,:requirement,:job_type,:location,:salary_high,:salary_low,
        :company_name,:company_url,:apply_info,:begginer)
  end


end
