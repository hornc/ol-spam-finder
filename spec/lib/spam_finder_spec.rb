require 'spec_helper'
require 'spam_finder'

RSpec.describe SpamFinder do
  let(:book) { double() } 

  let(:spam_titles) do
    [
      "awdawf카지노블랙잭 コ ＳＨＳ２８２。ＣＯＭさ 카지노투데이",
      "릴게임사이트#ｄｄａ２１,ｃｏｍ#인터넷바둑이사이트o4t",
      "〝圣诞特惠〞办《思克莱德大学毕业证》｛Q&Wechat3225123456｝成绩单学历认证University of Strathclyde",
      "【办雅思OFFER】办理维多利亚大学毕业证Q/微:1901234567 Diploma/degree transcripts for Victoria University",
      "OIO ↔6875 ↔86IO 강남안마 강남오피 강남안마방 강남역안마 강남구안마 강남마사지 강남안마시술소 강남오피방 강남역오피 강남구오피 강남오피방",
      "토토파트너 ¤¤€¤¤ ⑵⑷⒣-⑴⑴ .⒞⒪⒨ (code: buzz) ¤¤€¤¤  토토파트너",
      "[부산해운대고구려] 부산해운대고구려 한사장 01086801234 ♡",
      "사설토토총판 ф ф Ka-Tok: S p o 7 7 7 ф ф",
      "사설토토사이트 Ж Ж 카-톡: S p o 7 7 7 Ж Ж ",
      "온라인사설토토 のの[ 깨^톡: B E t 7 M] のの온라인사설토토 のの[ 깨^톡: B E t 7 M] のの ",
      "Vashikaran Mantra Expert Aghori Tantrik In Mumbai +91 9950124567",
      "SOme spam +012345678 here",
      "비아그라 판매사이트 ∵ ENJ3、C0M ∵ 비아그라 정품 판매 프로코밀 판매",
      #"띵동사이트◇Т­Ι­Μ­Ε 8­2 ，ｃ­О­Μ◇코드:kiss",
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
