require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

enable :sessions
use Rack::MethodOverride

configure :development do
    DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/gamblers.db")
end

configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end
  
  # model for user data
  class User_data
    include DataMapper::Resource
    property :Username, String, :key => true
    property :Password, String
    property :total_win, Integer
    property :total_loss, Integer
    property :total_profit, Integer
  end

  DataMapper.finalize
#   DataMapper.auto_upgrade!

get '/' do
    send_file 'public/home.html'
end

get '/signup' do
    erb :signup
end

post '/signup' do
    # User_data.create(:Username => params[:Username], :Password => params[:Password], :total_win => 0, :total_loss => 0, :total_profit => 0)
    # redirect :login
    username = params[:Username]
    password = params[:Password]

    existing_user = User_data.first(Username: username)

    if existing_user
        erb :signup, locals: { error_message: 'Username already exists' }
    elsif username.length < 1 || password.length < 1
        erb :signup, locals: { error_message: 'Please enter a username and password' }
    else

        user = User_data.new(
            Username: username,
            Password: password,
            total_win: 0,
            total_loss: 0,
            total_profit: 0
        )

        redirect :login

    # if user.save
    #     redirect :login
    # else
    #     redirect :signup
    # end
    end
end


get '/login' do
    erb :login
end

post '/login' do
    @user = User_data.get(params[:Username])
    if @user && @user.Password == params[:Password]
        session[:admin] = true # login
        session[:Username] = @user.Username
        session[:session_win] = 0
        session[:session_loss] = 0
        session[:session_profit] = 0
        session[:total_win] = @user.total_win
        session[:total_loss] = @user.total_loss
        session[:total_profit] = @user.total_profit
        session[:roll] = 0

        redirect :start_bet
    else
        erb :login, locals: {error_message: "Incorrect username or password"}
    end
end

get '/start_bet' do
    halt(401,'Not Authorized') unless session[:admin]
    erb :start_bet
end

post '/start_bet' do
    @money = params[:money].to_i
    @number = params[:number].to_i

    if @number < 1 || @number > 6
        erb :start_bet, locals: { error_message: 'Please enter a number between 1 and 6' }
    elsif @money <= 0
        erb :start_bet, locals: { error_message: 'Please enter a bet amount greater than 0' }
    else
        @roll = rand(1..6) # Generate a new random roll number for each bet

        if @number == @roll
            session[:session_win] += (5 * @money).to_i
            session[:total_win] += (5 * @money).to_i
            session[:session_profit] = session[:session_win] - session[:session_loss]
            session[:total_profit] = session[:total_win] - session[:total_loss]
            erb :start_bet, :layout => :bet_win_layout
        else
            session[:session_loss] += @money
            session[:total_loss] += @money
            session[:session_profit] = session[:session_win] - session[:session_loss]
            session[:total_profit] = session[:total_win] - session[:total_loss]
            erb :start_bet, :layout => :bet_lose_layout
        end
    
    end
end

post '/logout' do
    @user = User_data.get(session[:Username])
    @user.update(:total_win => session[:total_win], :total_loss => session[:total_loss], :total_profit => session[:total_profit])
    session.clear
    redirect :login
end

get '/users' do
    @users = User_data.all
    erb :user_list
end

delete '/users/:id' do
    user = User_data.get(params[:id])

    if user
        user.destroy
        redirect '/users', 303
    else
        status 404
        "User not found"
    end
end

    

