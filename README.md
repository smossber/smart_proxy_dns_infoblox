# SmartProxyDnsInfoblox

*Introduction here*


Fork of smart_proxy_dns_infoblox plugin, configured to work with Satellite Capsule 6.2.6.
Satellite Capsule 6.2 is based on the Smart Proxy 1.11, while the latest versions of this plugins are based on the 1.13 version.
The changes in Smart Proxy 1.12 introduces a new way to load dependencies, breaking backward compatability.

This fork resets the head to commit 0962, version 0.0.3 of the plugin, and adds ssl_opts { verify: false }to the @connection.


## Installation

Make sure that the infoblox gem is installed, as this is a dependency of this gem.

Clone this repo.

	git clone https://github.com/smossber/smart_proxy_dns_infoblox.git

Build the gem

	cd smart_proxy_dns_infoblox
	gem build smart_proxy_dns_plugin.gemspec

Install the Gem

	gem install smart_proxy_dns_plugin-0.0.3.gem

Tell the smart proxy bundler to include the plugin

	echo "gem 'smart_proxy_dns_infoblox'" > /usr/share/foreman-proxy/bundler.d/dns_infoblox.rb

See [How_to_Install_a_Smart-Proxy_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Smart-Proxy_Plugin)
for how to install Smart Proxy plugins


## Configuration

To enable this DNS provider, edit `/etc/foreman-proxy/settings.d/dns.yml` and set:

    :use_provider: dns_infoblox

Configuration options for this plugin are in `/etc/foreman-proxy/settings.d/dns_infoblox.yml` and include:

	---
	:infoblox_user: "infoblox_user"
	:infoblox_pw: "infoblox_user_pw"
	:infoblox_host: "infoblox.example.com"
	
	
## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) 2017 *your name*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

