require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  it "は複数のイベントを所有できること(イベントの登録)"

  it "は複数のイベントに所有されること(イベントへの参加)"

  describe "#login" do
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

    it "大文字/小文字のみ違いのあるログイン名のユーザが存在していた場合、バリデーションに失敗すること" do
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

  describe "#email" do
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

