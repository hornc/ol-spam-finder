require 'spec_helper'
require 'spam_finder'

RSpec.describe SpamFinder do
  let(:book) { double() } 

  let(:spam_titles) do
    [
      "awdawf카지노블랙잭 コ ＳＨＳ２８２。ＣＯＭさ 카지노투데이",
      "【办雅思OFFER】办理维多利亚大学毕业证Q/微:1901184762 Diploma/degree transcripts for Victoria University",
      "릴게임사이트#ｄｄａ２１,ｃｏｍ#인터넷바둑이사이트o4t",
    ]
  end

  it "classifies spammy titles as spam" do
    spam_titles.each_with_index do |title, i|   
      allow(book).to receive(:title) { title }
      expect(subject.is_spam?(book)).to (be true), "Title at index #{i} not caught: #{title}"
    end
  end
end
