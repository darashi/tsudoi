require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  fixtures :users, :events

  before(:each) do
    @created_event = events(:created_event)
  end

  it "は登録を行ったユーザに所有されること" do
    @created_event.owner.should == users(:created_event_owner)
  end

  describe "#titleについて:" do
    it "空でない場合、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should be_valid
    end

    it "空の場合、バリデーションに失敗すること" do
      @event = Event.new(
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should_not be_valid
    end

    it "既に同じタイトルのイベントが存在していた場合、バリデーションに失敗すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.save!
      @event2 = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge2",
        :deadline => 20.day.since,
        :published_at => Time.now
      )
      @event2.should_not be_valid
    end
  end

  describe "#urlについて:" do
    it "URLが入力されていた場合、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should be_valid
    end

    it "空であっても、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should be_valid
    end

    it "URL以外の内容が入力されていた場合、バリデーションに失敗すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "aaaaaa",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should_not be_valid
    end
  end

  describe "#deadlineについて:" do
    it "現在日時以降の日付が入力されていた場合、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should be_valid
    end

    it "空の場合、バリデーションに失敗すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :published_at => Time.now
      )
      @event.should_not be_valid
    end

    it "日付以外の内容が入力されていた場合、バリデーションに失敗すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 123456,
        :published_at => Time.now
      )
      @event.should_not be_valid
    end

    it "過去の日付が入力されていた場合、バリデーションに失敗すること"do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.ago,
        :published_at => Time.now
      )
      @event.should_not be_valid
    end
  end

  describe "#published_atについて:" do
    it "現在日時以降の日付が入力されていた場合、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should be_valid
    end

    it "空で保存された場合、現在日時が設定され、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since
      )
      @event.save!
      @event.reload
      @event.published_at.to_date.should == Date.today
      @event.should be_valid
    end

    it "日付以外の内容が入力されていた場合、バリデーションに失敗すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 10.day.since,
        :published_at => 1234567
      )
      @event.should_not be_valid
    end

    it "#deadlineよりも未来の日付が入力されていた場合、バリデーションに失敗すること"do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :url => "http://ruby-sapporo.org/news/hogehoge",
        :deadline => 3.day.ago,
        :published_at => 7.day.ago
      )
      @event.should_not be_valid
    end
  end

end

describe Event,"にユーザが参加表明を行った場合" do
  fixtures :users, :events

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = events(:created_event)
    @event.members << @user
  end

  it "は参加を表明したユーザを所有すること" do
    @event.members[0].should == @user
  end

end

describe Event,"にユーザが参加表明を行った時に、募集期限当日だった場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :deadline => 10.hour.since
    )
    @event.save!
    @event.reload
    @user.participates_in(@event)
  end
  
  it "は参加を表明したユーザを所有すること" do
    @event.members[0].should == @user
  end
end

describe Event,"にユーザが参加表明を行った時に、既に募集期限を過ぎていた場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :deadline => 1.second.since
    )
    @event.save!
    @event.reload
    sleep 1
    @user.participates_in(@event)
  end
  
  it "は参加を表明したユーザを所有していないこと" do
    @event.members[0].should_not == @user
  end
end

describe Event,"にユーザが参加表明を行った時に、公開当日だった場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :deadline => 1.second.since,
      :published_at => Time.now
    )
    @event.save!
    @event.reload
    @user.participates_in(@event)
  end
  
  it "は参加を表明したユーザを所有すること" do
    @event.members[0].should == @user
  end
end

describe Event,"にユーザが参加表明を行った時に、まだ公開前だった場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :deadline => 2.second.since,
      :published_at => 1.second.since
    )
    @event.save!
    @event.reload
    @user.participates_in(@event)
  end
  
  it "は参加を表明したユーザを所有していないこと" do
    @event.members[0].should_not == @user
  end
end

describe Event,"にユーザが参加表明した後、当該イベントが削除された場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :deadline => 2.second.since,
      :published_at => 1.second.since
    )
    @event.save!
    @event.reload
    @user.participates_in(@event)
    @event.destroy
  end
  
  it "ユーザの参加イベントに当該イベントが含まれていないこと" do
    @user.events.should be_empty
  end
end

