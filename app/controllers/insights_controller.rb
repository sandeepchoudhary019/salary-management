class InsightsController < ActionController::API
  def country
    render json: SalaryInsightsService.country_metrics(params[:country]), status: :ok
  end

  def job_title
    render json: SalaryInsightsService.job_title_average_in_country(
      country: params[:country],
      job_title: params[:job_title]
    ), status: :ok
  end
end
