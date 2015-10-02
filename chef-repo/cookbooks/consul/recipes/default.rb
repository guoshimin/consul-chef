#
# Cookbook Name:: consul
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

directory '/apps' do
  owner 'root'
  group 'root'
  mode '0755'
end

group 'consul' do
  gid node['consul']['gid']
end

user 'consul' do
  comment 'User to run consul as'
  uid node['consul']['uid']
  gid 'consul'
  home '/apps/consul'
  shell '/sbin/nologin'
end

directory '/apps/consul' do
  owner 'consul'
  group 'consul'
  mode '0750'
end

directory '/apps/consul/data' do
  owner 'consul'
  group 'consul'
  mode '0750'
end

directory '/apps/consul/config' do
  owner 'consul'
  group 'consul'
  mode '0750'
end

# Install package for aufs.
package node['docker']['image']['extra']

docker_service 'default' do
  storage_driver 'aufs'
end

group 'docker' do
  append true
  members ['ubuntu']
end

FileUtils.chown nil, 'docker', '/var/run/docker.sock'

docker_image 'consul' do
  repo 'registry.dev.databricks.com/universe/consul'
  action :pull
end

file = File.open("/metadata/consul_agent_name", "r")
node.default['name'] = file.read.strip

template '/home/ubuntu/run-consul.sh' do
  source 'run-consul.sh.erb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0775'
end

template '/apps/consul/config/server.json' do
  source 'server.json.erb'
  owner 'consul'
  group 'consul'
  mode '0660'
end

template '/home/ubuntu/consul-cli.sh' do
  source 'consul-cli.sh.erb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0775'
end
