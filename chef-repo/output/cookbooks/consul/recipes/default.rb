#
# Cookbook Name:: consul
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

group 'consul' do
  gid 34221
end

user 'consul' do
  comment 'User to run consul as'
  uid 34221
  gid 34221
  home '/consul'
  shell '/sbin/nologin'
end

directory '/apps' do
  owner 'root'
  group 'root'
  mode '0755'
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

group 'docker'

file '/var/run/docker.sock' do
  group 'docker'
end

user 'ubuntu' do
  gid 'docker'
  action :modify
end

docker_image 'consul' do
  repo 'registry.dev.databricks.com/universe/consul'
  action :pull
end

file = File.open("/metadata/consul_agent_name", "r")
node.default['name'] = file.read.strip

template '/apps/consul/run-consul.sh' do
  source 'run-consul.sh.erb'
  owner 'consul'
  group 'consul'
  mode '0775'
end

template '/apps/consul/config/server.json' do
  source 'server.json.erb'
  owner 'consul'
  group 'consul'
  mode '0660'
end
