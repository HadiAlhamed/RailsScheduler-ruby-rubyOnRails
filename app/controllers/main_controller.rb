class MainController  < ApplicationController
    def index
        if session[:user_id]
             @user = User.find_by(id: session[:user_id]) #find throws when not found , find_by doesn't throw
        end
    end
end