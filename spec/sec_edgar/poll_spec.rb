require 'spec_helper'

describe SecEdgar::Poll do
  let(:client) { double('ftp_client') }
  context '1993, qtr 1' do
    subject(:poll) do
      SecEdgar::Poll.new(
        1993,
        1,
        client,
        "#{ File.expand_path(File.dirname(File.dirname(__FILE__))) }/../assets"
      )
    end

    it 'does not fetch from sec if local file exists' do
      expect(File.exist?(poll.local_file)).to be(true)
      expect(client).not_to receive(:fetch)
      poll.index
    end

    it 'lists the array of filings' do
      expect(poll.filings.count).to eq(4)
      expect(poll.filings.first).to include("RBS PARTNERS L P /CT")
    end

    it 'lists the array of form4s' do
      expect(poll.form4s.count).to eq(0)
    end
  end

  context '1996, qtr 1' do
    subject(:poll) do
      SecEdgar::Poll.new(
        1996,
        1,
        client,
        "#{ File.expand_path(File.dirname(File.dirname(__FILE__))) }/../assets"
      )
    end

    it 'lists the array of form4s' do
      expect(poll.form4s.count).to eq(150)
    end
  end

  it '::all takes a from and to year and yields all the form4s within that time' do
    expect do |b|
      SecEdgar::Poll.all(1996, 1996, &b)
    end.to yield_control.at_least(150).times
  end
end
