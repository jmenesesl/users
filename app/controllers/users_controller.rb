class UsersController < ApplicationController
$pages = 4

def index
    @pagy, @users = pagy(User.all, items: $pages)
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
       @pagy, @users = pagy(User.where(["usertype LIKE ?", "%#{params[:usertype]}%"]), items: $pages)
     else
       @pagy, @users = pagy(User.all, items: $pages)
     end

   rescue Pagy::OutOfRangeError => e
     render 'new';
   end

   def search_by_email_or_permalink
     if params[:usertype] != 'All'
       puts 'TIENE USERTYPE\n'
       puts params[:usertype]
       @pagy, @users = pagy(User.where(["email LIKE ? and usertype LIKE ?", "%#{params[:term]}%", "%#{params[:usertype]}%"]).or(User.where(["id_permalink LIKE ? and usertype LIKE ?", "%#{params[:term]}%", "%#{params[:usertype]}%"])), items: $pages)
     else
       puts 'NO TIENE USERTYPE\n'
       @pagy, @users = pagy(User.where(["email LIKE ?", "%#{params[:term]}%"]).or(User.where(["id_permalink LIKE ?", "%#{params[:term]}%"])), items: $pages)
     end
   end

  #  def search_by_email_or_permalink
  #   @pagy, @users = pagy(User.where(["email LIKE ?", "%#{params[:term]}%"]).or(User.where(["id_permalink LIKE ?", "%#{params[:term]}%"])), items: $pages)
  #  end

   def show
     @user = User.find(params[:id_permalink])# :email])
     respond_with @user
   end

   def new
     @user = User.new
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
end
