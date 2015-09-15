#
# Cookbook Name:: consul
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

group 'consul' do
  gid '34221'
end

user 'consul' do
  comment 'User to run consul as'
  uid '34221'
  gid '34221'
  home '/consul'
  shell '/sbin/nologin'
end
