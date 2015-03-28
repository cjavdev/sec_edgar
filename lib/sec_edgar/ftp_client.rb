module SecEdgar
  class FtpClient
    include Singleton

    def initialize
      @ftp = Net::FTP.new
      @ftp.passive = true
      connect
      login

      at_exit do
        puts "Closing Sec4::FtpClient..."
        @ftp.close
      end
    end

    def fetch(remote_url, local_url)
      @ftp.getbinaryfile(remote_url, local_url)
    end

    def connect
      @ftp.connect('ftp.sec.gov', 21)
    rescue => e
      puts "Sec4::FtpClient connection failed"
      puts e.message
    end

    def login
      @ftp.login
    rescue => e
      puts "Sec4::FtpClient login failed"
      puts e.message
    end
  end
end
