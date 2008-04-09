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

  describe "#capacityについて:" do
    it "数値以外の内容が入力されていた場合、バリデーションに失敗すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :capacity => "100人",
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should_not be_valid
    end

    it "数値が入力されていた場合、バリデーションに成功すること" do
      @event = Event.new(
        :title => "Ruby勉強会@札幌-n",
        :capacity => 10,
        :deadline => 10.day.since,
        :published_at => Time.now
      )
      @event.should be_valid
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

describe Event,"現在日時が#published_atと#deadlineの間で、参加人数が#capacityに達していない場合" do
  before(:each) do
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 1,
      :deadline => 3.day.since,
      :published_at => 7.day.ago
    )
  end

  it "イベント状態が参加受付中であること" do
    @event.state.should == :open
  end
end

describe Event,"現在日時が#published_atと#deadlineの間で、参加人数が#capacityに達していた場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 1,
      :deadline => 3.day.since,
      :published_at => 7.day.ago
    )
    @event.save!
    @event.reload
    @event.members << @user
  end

  it "イベント状態が参加締切であること" do
    @event.state.should == :closed
  end
end

describe Event,"現在日時が#published_atと#deadlineを過ぎていて、参加人数が#capacityに達していない場合" do
  before(:each) do
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 1,
      :deadline => 1.second.since,
      :published_at => 7.day.ago
    )
    sleep 1
  end

  it "イベント状態が参加締切であること" do
    @event.state.should == :closed
  end
end

describe Event,"現在日時が#published_atと#deadlineを過ぎていて、参加人数が#capacityに達していた場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 1,
      :deadline => 1.second.since,
      :published_at => 7.day.ago
    )
    @event.save!
    @event.reload
    @event.members << @user
    sleep 1
  end

  it "イベント状態が参加締切であること" do
    @event.state.should == :closed
  end
end

describe Event,"現在日時が#published_atと#deadlineに達していなくて、参加人数が#capacityに達していない場合" do
  before(:each) do
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 1,
      :deadline => 7.day.since,
      :published_at => 3.day.since
    )
  end

  it "イベント状態が公開前であること" do
    @event.state.should == :prep
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

describe Event,"にユーザが参加表明を行った時に、既に定員に達していた場合" do
  fixtures :users

  before(:each) do
    @user1 = users(:created_event_owner)
    @user2 = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 1,
      :deadline => 2.second.since
    )
    @event.save!
    @event.reload
    @user1.participates_in(@event)
    @user2.participates_in(@event)
  end
  
  it "は参加を表明したユーザを所有していないこと" do
    @event.members.size.should == 1
    @event.members[0].should == @user1
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

describe Event, "にユーザが参加表明した後、定員数を現在の参加人数より少なくしようとした場合" do
  fixtures :users

  before(:each) do
    @user1 = users(:created_event_owner)
    @user2 = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 2,
      :deadline => 2.second.since
    )
    @event.save!
    @event.reload
    @user1.participates_in(@event)
    @user2.participates_in(@event)
    @event.capacity = 1
  end
  
  it "定員数の変更を行えないこと" do
    @event.should_not be_valid
  end
end

describe Event, "にユーザが参加表明した後、公開日を未来日に変更しようとした場合" do
  fixtures :users

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = Event.new(
      :title => "Ruby勉強会@札幌-n",
      :url => "http://ruby-sapporo.org/news/hogehoge",
      :capacity => 2,
      :deadline => 20.day.since
    )
    @event.save!
    @event.reload
    @user.participates_in(@event)
    @event.published_at = 10.day.since
  end
  
  it "公開日の変更を行えないこと" do
    @event.should_not be_valid
  end
end
