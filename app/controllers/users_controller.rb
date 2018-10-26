class UsersController < ApplicationController
$pages = 4
require 'rest_client'
require 'json'

def index
    # @pagy, @users = pagy(User.all, items: $pages)
    # @max_retries = 3
    # begin
    #   response = RestClient.get('http://www.google.com/noexiste', timeout: 10)
    # rescue RestClient::ResourceNotFound => error
    #   @retries ||= 0
    #   if @retries < @max_retries
    #     @retries += 1
    #     puts "WAITING RESPONSE"
    #     puts 'RETRY'
    #     # puts response.code
    #     retry
    #   else
    #
    #     puts "FINALIZADO"
    #     redirect_to users_list_path
    #     # raise error
    #   end
    # ensure
    #   # ESTA PARTE SIEMPRE SE EJECUTA
    # end

    response = RestClient::Request.execute(method: :get, url: 'http://0.0.0.0:3000/users/search_by_email_or_permalink',
                            timeout: 20, headers: {params: {page: 3, term: 'su', usertype: 'Pro'}})
    puts response.body # Regresa la información html obtenida en el campo anterior
    # url = 'http://0.0.0.0:3000/users/new'
    # json = {"id_permalink"=>"abc123", "email"=>"", "usertype"=>"Pro", "creations"=>"crea1", "credit_subscription"=>"300", "creation_date"=>"13/02/1995"}


    # RestClient::Request.execute(method: :post,
    #                         url: url,
    #                         payload: ' {"id_permalink"=>"abc123", "email"=>"", "usertype"=>"Pro", "creations"=>"crea1", "credit_subscription"=>"300", "creation_date"=>"13/02/1995"}',
    #                         headers: {"Content-Type" => "application/json"}
    #                        )
    #                        puts "waiting response"
    #                         if response.code != 201
    #                           puts 'ERROR EN AÑADIR USER'
    #                                 session[:notification] = "Error: "+t('error_saving_exception').to_s
    #                           return
    #                         end
    #
    # response = RestClient.post(url, json)
    #                              puts "waiting response"
    #                               if response.code != 201
    #                                 puts 'ERROR EN AÑADIR USER'
    #                                       session[:notification] = "Error: "+t('error_saving_exception').to_s
    #                                 return
    #                               end
  # render json: {status: 'SUCCESS', message: 'Users loaded', data: User.last(1)}, status: :ok #regresa como respuesta un objeto json
end

  def list
      if params[:usertype].nil?
        @pagy, @users = pagy(User.all, items: $pages)
    else
      if params[:usertype] != 'All'
        @pagy, @users = pagy(User.where(["usertype LIKE ?", "%#{params[:usertype]}%"]), items: $pages)
      else
        @pagy, @users = pagy(User.all, items: $pages)
      end
    end
   end

   def search
     if params[:usertype] != 'All'
       if params[:term].nil?
         @pagy, @users = pagy(User.where(["usertype LIKE ?", "%#{params[:usertype]}%"]), items: $pages)
       else
         @pagy, @users = pagy(User.where(["(email LIKE ? or id_permalink LIKE ?) and usertype LIKE ?", "%#{params[:term]}%","%#{params[:term]}%", "%#{params[:usertype]}%" ]), items: $pages)
       end
     else
       @pagy, @users = pagy(User.all, items: $pages)
     end
     respond_to do |format|
       format.js
       format.html { render 'list'}
     end

     rescue Pagy::OutOfRangeError => e
       render 'new';
   end

   def search_by_email_or_permalink
     if params[:usertype] != 'All'
        @pagy, @users = pagy(User.where(["email LIKE ? and usertype LIKE ?", "%#{params[:term]}%", "%#{params[:usertype]}%"]).or(User.where(["id_permalink LIKE ? and usertype LIKE ?", "%#{params[:term]}%", "%#{params[:usertype]}%"])), items: $pages)
     else
       @pagy, @users = pagy(User.where(["email LIKE ?", "%#{params[:term]}%"]).or(User.where(["id_permalink LIKE ?", "%#{params[:term]}%"])), items: $pages)
     end

     respond_to do |format|
       format.js
       format.html { render 'list'}
     end
   end

  def userDetails
    @user = User.where(["id = ?", "#{params[:user_id]}"])
  end

  def relatedUsers
    @pagy, @users = pagy(User.where(["email LIKE ?", "#{params[:term]}%"]), items: $pages)
    @user = User.where(["id = ?", "#{params[:user_id]}"])

    if params[:page].nil? # Determinamos si está paginando para modificar atributos del css
      @paginate = false;
    else
      @paginate = true; # Cerrar ventana details y abrir render
    end

    respond_to do |format|
      format.js # Por defecto regresa un js (primer intento)
      format.html { render 'userDetails'} # En caso de solicitar html renderiza la pagina
    end
  end

   def show
     @user = User.find(params[:id_permalink])
     respond_with @user
   end

   def new
     @user = User.new
     render status: 201, json: @user.to_json
   end

   def user_params
      params.require(:users).permit(:id_permalink, :email, :usertype, :creations, :credit_subscription, :creation_date)
   end

   def create
     @user = User.new(user_params)

     if @user.save
       redirect_to :action => 'list'
     else
       render :action => 'new'
     end
   end

   def edit
     @user = User.find(params[:id_permalink])
   end

   def update
     @user = User.find(params[:id_permalink])
     if @user.update_attributes(user_params)
       redirect_to :action => 'show'
     else
       render :action => 'edit'
     end
   end

   def delete
     User.find(params[:id_permalink]).destroy
     redirect_to :action => 'list'
   end

   private
   def remote_request

   end
end
