require 'fileutils'

module SecEdgar
  PollFiling = Struct.new(
      :cik,
      :company_name,
      :type,
      :date_str,
      :ftp_link,
      :client,
      :title,
      :term,
      :file_id) do
    def date
      Date.parse(date_str)
    end

    def link
      "http://www.sec.gov/Archives/#{ ftp_link }"
    end

    def content(&error_blk)
      @content ||= client.fetch(ftp_link, nil)
    rescue RestClient::ResourceNotFound => e
      puts "404 Resource Not Found: Bad link #{ self.link }"
      if block_given?
        error_blk.call(e, self)
      else
        raise e
      end
    end
  end

  class Poll
    attr_reader :client, :year, :quarter, :local_base

    def initialize(year = 1993, qtr = 1, client = SecEdgar::FtpClient.instance, local_base = "./assets")
      @client = client
      @year = year
      @quarter = qtr
      @local_base = local_base
    end

    def self.all(from_year, to_year, &blk)
      polls_by_year(from_year, to_year).each do |poll|
        poll.form4s.each do |filing|
          blk.call(filing)
        end
      end
    end

    def self.polls_by_year(from_year, to_year)
      polls = []
      (from_year..to_year).each do |yr|
        (1..4).each do |qtr|
          polls << self.new(yr, qtr)
        end
      end
      polls
    end

    def to_s
      "<Poll y: #{ year } q: #{ quarter }>"
    end

    def index
      unless File.exist?(local_file)
        puts "fetching from sec #{ to_s }..."
        fetch
      end
      File.read(local_file)
    end

    def form4s
      filings.select do |line|
        line =~ form4_regexp
      end.map do |f|
        begin
          PollFiling.new(*f.split("|"), client)
        rescue => e
          puts line
          raise e
        end
      end
    end

    def filings
      index.scrub.split("\n").select do |line|
        line =~ filing_regexp
      end
    end

    def local_file
      "#{ local_dir }/master.idx"
    end

    private

    def form4_regexp
      /^(\d+\|.*\|4\|.*.txt)$/i
    end

    def filing_regexp
      /^(\d+\|.*\|.*.txt)$/i
    end

    def remote
      "/edgar/full-index/#{ year }/QTR#{ quarter }/master.idx"
    end

    def local_dir
      path = "#{ local_base }/#{  year.to_s }/QTR#{ quarter }"
      FileUtils.mkdir_p(path)
      path
    end

    def fetch
      client.fetch(remote, local_file)
    rescue => e
      puts "SecEdgar::Poll#fetch_quarter failed for #{ year }, QTR#{ quarter }"
      puts "local: #{ local_file }"
      puts "remote: #{ remote }"
      puts e.message
    ensure
      verify_download
    end

    def verify_download
      File.delete(local_file) unless File.size?(local_file)
    end
  end
end
