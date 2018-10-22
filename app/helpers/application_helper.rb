module ApplicationHelper
  include Pagy::Frontend
  def pagy_url_for(page, pagy)
    params = request.query_parameters.merge(:only_path => true, pagy.vars[:page_param] => page )
    url_for(params)
  end
end
