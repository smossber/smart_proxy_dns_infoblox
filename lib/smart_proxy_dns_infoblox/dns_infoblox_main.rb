require 'dns/dns'
require 'dns_common/dns_common'
require 'infoblox'
module Proxy::Dns::Infoblox
  class Record < ::Proxy::Dns::Record
    include Proxy::Log
    include Proxy::Util
	# THIS IS THE FORK

    attr_reader :example_setting, :optional_path, :required_setting, :required_path

    def initialize
      ENV['WAPI_VERSION']='2.0'
      @infoblox_user = ::Proxy::Dns::Infoblox::Plugin.settings.infoblox_user
      @infoblox_pw   = ::Proxy::Dns::Infoblox::Plugin.settings.infoblox_pw
      @infoblox_host = ::Proxy::Dns::Infoblox::Plugin.settings.infoblox_host
      @conn          = ::Infoblox::Connection.new(username: @infoblox_user ,password: @infoblox_pw, host: @infoblox_host,ssl_opts: {verify: false} )
      super(@infoblox_host, ::Proxy::Dns::Plugin.settings.dns_ttl)
    end

    # Calls to these methods are guaranteed to have non-nil parameters
    def create_a_record(fqdn, ip)
	logger.debug "Skipping FQDN check"
	#logger.debug "Starting check if the FQDN is already in use"
      #raise(Proxy::Dns::Collision, "#{fqdn} is already in use") if dns_find(fqdn)
      a_record = Infoblox::Arecord.new(connection: @conn, name: fqdn, ipv4addr: ip)
      a_record.post
    end

    def create_ptr_record(fqdn, ip)
      #ip here comes in as 2.1.168.192.in-addr.arpa, so we need to strip and reverse.
      logger.debug "Skipping FQDN check"
      #raise(Proxy::Dns::Collision, "#{ip} is already in use") if dns_find(ip)
      fixed_ip = ip.chomp('.in-addr.arpa').split('.').reverse .join('.')
      ptr_record = Infoblox::Ptr.new(connection: @conn, ptrdname: fqdn, ipv4addr: fixed_ip)

      ptr_record.post
      # FIXME: add a reverse 'PTR' record with ip, fqdn
      # Raise an error if the IP is already in DNS but with a different FQDN:
      #   raise(Proxy::Dns::Collision, "#{ip} is already used by #{fqdn_in_use}")
    end

    def remove_a_record(fqdn)
      a_record = Infoblox::Arecord.find( @conn, {name: fqdn}).first
	# EDIT
	# checks if the record could be fetched and is not null
	# If it couldn't, then don't do anything instead of failing
	unless a_record.nil?
      #a_record.delete || raise(Proxy::Dns::NotFound.new("Cannot find DNS entry for #{fqdn}"))
      		a_record.delete
	else
		logger.info "Couldn't find A record, skipping"
	end
    end

    def remove_ptr_record(ip)
      #ip here comes in as 2.1.168.192.in-addr.arpa, so we need to strip and reverse.
      fixed_ip = ip.chomp('.in-addr.arpa').split('.').reverse .join('.')
      ptr_record = Infoblox::Ptr.find(@conn, { ipv4addr: fixed_ip }).first
	# EDIT
	# checks if the record could be fetched and is not null
	# If it couldn't, then don't do anything instead of failing
	unless ptr_record.nil?	
	      ptr_record.ipv6addr=nil
	      ptr_record.view=nil
		ptr_record.delete
	      #ptr_record.delete || raise(Proxy::Dns::NotFound.new("Cannot find DNS entry for #{ip}"))
	else
		logger.debug "Couldn't find PTR record, skipping.."
	end
      # FIXME: remove the reverse 'PTR' record with ip
      # Raise an error if the IP is not in DNS:
      #   raise Proxy::Dns::NotFound.new("Cannot find DNS entry for #{ip}")
    end
  end
end
