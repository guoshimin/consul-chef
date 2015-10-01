default['docker']['image']['extra'] = 'linux-image-extra-$(uname -r)'

default['name'] = '$(cat /metadata/consul_agent_name)'
