# -*- encoding: utf-8 -*-

#
# Reference: https://github.com/stompgem/stomp/wiki/extended-ssl-overview
#
if Kernel.respond_to?(:require_relative)
  require_relative("../ssl_common")
else
  $LOAD_PATH << File.dirname(__FILE__)
  require "../ssl_common"
end
include SSLCommon
#
# == SSL Use Case 1 - User Supplied Ciphers
#
# If you need your own ciphers list, this is how.
# Stomp's default list will work in many cases.  If you need to use this, you
# will know it because SSL connect will fail.  In that case, determining
# _what_ should be in the list is your responsibility.
#
class ExampleSSL1C
  # Initialize.
  def initialize		# Change the following as needed.
    @host = ENV['STOMP_HOST'] ? ENV['STOMP_HOST'] : "localhost"
    # It is very likely that you will have to specify your specific port number.
    # 61611 is currently my AMQ local port number for ssl client auth not required.
		@port = ENV['STOMP_PORT'] ? ENV['STOMP_PORT'].to_i : 61611
  end
  # Run example.
  def run
    ciphers_list = [["DHE-RSA-AES256-SHA", "TLSv1/SSLv3", 256, 256], ["DHE-DSS-AES256-SHA", "TLSv1/SSLv3", 256, 256], ["AES256-SHA", "TLSv1/SSLv3", 256, 256], ["EDH-RSA-DES-CBC3-SHA", "TLSv1/SSLv3", 168, 168], ["EDH-DSS-DES-CBC3-SHA", "TLSv1/SSLv3", 168, 168], ["DES-CBC3-SHA", "TLSv1/SSLv3", 168, 168], ["DHE-RSA-AES128-SHA", "TLSv1/SSLv3", 128, 128], ["DHE-DSS-AES128-SHA", "TLSv1/SSLv3", 128, 128], ["AES128-SHA", "TLSv1/SSLv3", 128, 128], ["RC4-SHA", "TLSv1/SSLv3", 128, 128], ["RC4-MD5", "TLSv1/SSLv3", 128, 128], ["EDH-RSA-DES-CBC-SHA", "TLSv1/SSLv3", 56, 56], ["EDH-DSS-DES-CBC-SHA", "TLSv1/SSLv3", 56, 56], ["DES-CBC-SHA", "TLSv1/SSLv3", 56, 56], ["EXP-EDH-RSA-DES-CBC-SHA", "TLSv1/SSLv3", 40, 56], ["EXP-EDH-DSS-DES-CBC-SHA", "TLSv1/SSLv3", 40, 56], ["EXP-DES-CBC-SHA", "TLSv1/SSLv3", 40, 56], ["EXP-RC2-CBC-MD5", "TLSv1/SSLv3", 40, 128], ["EXP-RC4-MD5", "TLSv1/SSLv3", 40, 128]]

    ssl_opts = Stomp::SSLParams.new(:ciphers => ciphers_list)

    #
    # SSL Use Case 1
    #
    hash = { :hosts => [
        {:login => 'guest', :passcode => 'guest', :host => @host, :port => @port, :ssl => ssl_opts},
      ],
      :reliable => false, # YMMV, to test this in a sane manner
    }
    #
    puts "Connect starts, SSL Use Case 1"
    c = Stomp::Connection.new(hash)
    puts "Connect completed"
    puts "SSL Verify Result: #{ssl_opts.verify_result}"
    #
    c.disconnect()
  end
end
#
e = ExampleSSL1C.new
e.run

