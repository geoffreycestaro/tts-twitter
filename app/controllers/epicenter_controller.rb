class EpicenterController < ApplicationController
   before_action :authenticate_user!
   include TweetsHelper
def tag_tweets
    @tag = Tag.find(params[:id])
end

def feed
    @following_tweets = []

    Tweet.all.each do |tweet|
      if current_user.following.include?(tweet.user_id) || current_user.id == tweet.user_id
        @following_tweets.push(tweet)
      end

    end
end

  def show_user
    @user = User.find(params[:id])
  end

  def now_following
    # We are adding the user.id of the user you want to 
    # follow to your following array.
    # and we want to make sure it's saved in there as an integer
    current_user.following.push(params[:id].to_i)
    current_user.save

    redirect_to show_user_path(id: params[:id])
  end

  def unfollow
    current_user.following.delete(params[:id].to_i)
    current_user.save

    redirect_to show_user_path(id: params[:id])
  end


  def epi_tweet
    
    @tweet = Tweet.create(message: params[:tweet][:message], user_id: params[:tweet][:user_id].to_i)

    @tweet = get_tagged(@tweet)
    @tweet.save

    redirect_to root_path
  end
end