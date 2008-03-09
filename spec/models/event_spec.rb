require File.dirname(__FILE__) + '/../spec_helper'

describe Event do

  it "は登録を行ったユーザに所有されること"

  it "は参加を表明したユーザを所有すること"

  describe "#title" do
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

  describe "#url" do
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

  describe "#deadline" do
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

  describe "#published_at" do
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

