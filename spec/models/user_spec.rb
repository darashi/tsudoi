require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  fixtures :users, :events

  before(:each) do
    @owner = users(:created_event_owner)
  end

  it "は複数のイベントを所有できること(イベントの登録)" do
    @owner.owned_events[0].should == events(:created_event)
    @owner.owned_events[1].should == events(:created_event2)
  end

  describe "#loginについて:" do
    it "既に同じログイン名のユーザが存在していた場合、バリデーションに失敗すること" do
      @user = User.new(
        :login => "snoozer-05",
        :email => "snoozer.05@ruby-sapporo.orq",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user.save!
      @user2 = User.new(
        :login => "snoozer-05",
        :email => "snoozer.05@qmail.com",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user2.should_not be_valid
    end

    it "大文字/小文字のみが違うログイン名のユーザが存在していた場合、バリデーションに失敗すること" do
      @user = User.new(
        :login => "snoozer-05",
        :email => "snoozer.05@ruby-sapporo.orq",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user.save!
      @user2 = User.new(
        :login => "SNOOZER-05",
        :email => "snoozer.05@qmail.com",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user2.should_not be_valid
    end
  end

  describe "#emailについて:" do
    it "既に同じemailアドレスのユーザが存在していた場合、バリデーションに失敗すること" do
      @user = User.new(
        :login => "snoozer-05",
        :email => "snoozer.05@ruby-sapporo.orq",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user.save!
      @user2 = User.new(
        :login => "snoozer-07",
        :email => "snoozer.05@ruby-sapporo.orq",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user2.should_not be_valid
    end

    it "アドレスとして不正なものが入力された場合、バリデーションに失敗すること" do
      @user = User.new(
        :login => "snoozer-05",
        :email => "hofahofahofa",
        :password => "hogehoge",
        :password_confirmation => "hogehoge"
      )
      @user.should_not be_valid
    end
  end

end

describe User,"がイベントに参加表明した場合:" do
  fixtures :users, :events

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = events(:created_event)
    @user.participates_in @event
  end

  it "参加を表明したイベントに所有されること" do
    @user.events[0].should == @event
  end

end

describe User,"が参加表明したイベントをキャンセルした場合:" do
  fixtures :users, :events

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = events(:created_event)
    @user.participates_in @event
    @user.cancels @event
  end

  it "参加を表明したイベントに所有されていないこと" do
    @user.events[0].should_not == @event
  end

end

describe User,"が参加表明していないイベントをキャンセルした場合:" do
  fixtures :users, :events

  before(:each) do
    @user = users(:tsudoi_user1)
    @event = events(:created_event)
    @user.cancels @event
  end

  it "参加を表明したイベントに所有されていないこと" do
    @user.events[0].should_not == @event
  end

end

describe User,"がイベントを登録しているにも関わらず、アカウントを削除した場合" do
  it "登録していたイベントが削除されていること" 
end

