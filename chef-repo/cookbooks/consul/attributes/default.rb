default['docker']['image']['extra'] = 'linux-image-extra-$(uname -r)'

default['name'] = '$(cat /metadata/consul_agent_name)'

default['consul']['uid'] = 34221
default['consul']['gid'] = 34221
