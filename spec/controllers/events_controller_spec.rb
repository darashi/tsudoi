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
end

