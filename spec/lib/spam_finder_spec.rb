require 'spec_helper'
require 'spam_finder'

RSpec.describe SpamFinder do
  let(:book) { double() } 

  let(:spam_titles) do
    [
      "awdawf카지노블랙잭 コ ＳＨＳ２８２。ＣＯＭさ 카지노투데이",
      "릴게임사이트#ｄｄａ２１,ｃｏｍ#인터넷바둑이사이트o4t",
      # "네임드사다리 のの[ 카-톡: B E T 7 m] のの네임드사다리 のの[ 카-톡: B E T 7 m] のの",
      "〝圣诞特惠〞办《思克莱德大学毕业证》｛Q&Wechat3225997026｝成绩单学历认证University of Strathclyde",
      "【办雅思OFFER】办理维多利亚大学毕业证Q/微:1901184762 Diploma/degree transcripts for Victoria University",
      "OIO ↔6875 ↔86IO 강남안마 강남오피 강남안마방 강남역안마 강남구안마 강남마사지 강남안마시술소 강남오피방 강남역오피 강남구오피 강남오피방",
    ]
  end

  it "classifies spammy titles as spam" do
    spam_titles.each_with_index do |title, i|   
      allow(book).to receive(:title) { title }
      expect(subject.is_spam?(book)).to (be true), "Title at index #{i} not caught: #{title}"
    end
  end

  it "does not error if there is no title" do
    allow(book).to receive(:title) { nil }
    expect(subject.is_spam?(book)).to be false
  end
end
