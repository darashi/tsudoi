class SearchController < ApplicationController

  def people
    @people_pages, @peoples = paginate :users, :per_page => 10, :order => 'created_at desc', :conditions => ['name like ?', "%#{params[:people][:name]}%"]
  end
end
