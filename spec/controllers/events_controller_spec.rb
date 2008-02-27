require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do

  describe "#index" do
    describe "登録イベントが存在していない場合" do
      before(:each) do
        get 'index'
      end

      it "ステータスコードが 200 であること" do
        response.should be_success
      end

      it "events/index がレンダリングされること" do
        response.should render_template(:index)
      end

      it "@events は空であること" do
        assigns[:events].should == []
      end
    end

    describe "登録イベントが1件以上存在している場合" do
      before(:each) do
        @event = mock("event")
        @mock_event1.stub!(:title).and_return("Ruby勉強会@札幌-1")
        @mock_event2.stub!(:title).and_return("Ruby勉強会@札幌-2")
        @events = [@mock_event]
        Event.stub!(:find).and_return(@events)
        get 'index'
      end

      it "ステータスコードが 200 であること" do
        response.should be_success
      end

      it "events/index がレンダリングされること" do
        response.should render_template(:index)
      end

      it "@events に登録イベントのコレクションが格納されていること" do
        assigns[:events].should == @events
      end
    end
  end

  describe "#show" do
    describe "/events/show/1" do
      describe "レコードが存在していない場合" do
        before(:each) do
          Event.stub!(:find)
          get 'show', :id => 1
        end

        it "ステータスコードが 404 であること" do
          response.headers["Status"].should == "404 Not Found"
        end

        it "404ファイル がレンダリングされること" do
          response.should render_template("#{RAILS_ROOT}/public/404.html")
        end

        it "@event に該当するイベントが格納されていないこと" do
          assigns[:event].should == nil
        end
      end

      describe "レコードが存在している場合" do
        before(:each) do
          @event = mock("event")
          Event.should_receive(:find).with("1").and_return(@event)
          get 'show', :id => 1
        end

        it "ステータスコードが 200 であること" do
          response.should be_success
        end

        it "/events/show がレンダリングされること" do
          response.should render_template(:show)
        end

        it "@event に該当するイベントが格納されていること" do
          assigns[:event].should equal(@event)
        end
      end
    end
  end

end
