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
      "정품 비아그라 판매 ［ bia2.me ］ 칙칙이 판매 정력제 구입 발기부전치료제 구입 최음제 추천 fgd",
      "최음제 판매 사이트 ［ bia2.me ］ 흥분제 추천 흥분제 구입 프로코밀 효과 레비트라 정품 구입 ",
      "1 CALL 91-8875212345 online love marriage specialist baba ji Germany",
      "CALL +91=8875212345 online love marriage specialist baba ji Germany",
      "未正常毕业加拿大文凭Q微541 123 123办理加拿大亚岗昆学院毕业证成绩单学历认证使馆认证文凭学生卡驾照 Blahblah",
      "哪里办理OSU成绩单毕业证？Q/微信285 345 678文凭办理俄亥俄州立大学毕业证学历认证offer",
      "կ우송대원룸_010-6677-1923_կ수수료무료_자양동원룸կ",
      #"띵동사이트◇Т­Ι­Μ­Ε 8­2 ，ｃ­О­Μ◇코드:kiss",
    ]
  end

  let(:good_titles) do
    [
      "Much Ado About Nothing",
      "Great Cocktails 1910-1923",
      "1955-1957 - Things happened",
      "道德經",
      "로보카 폴리 마음을 전해",
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

  it "does not flag good titles as spam" do
    good_titles.each_with_index do |title, i|
      allow(book).to receive(:title) { title }
      expect(subject.is_spam?(book)).to (be false), "Good title at index #{i} mistakenly flagged as spam: #{title}"
    end
  end
end
