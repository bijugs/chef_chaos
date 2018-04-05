#
# Cookbook Name:: chef_chaos
# Recipe:: default
#
# Copyright 2018, Biju Nair
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
package "stress-ng" do
  action :install
end

template "#{Chef::Config[:file_cache_path]}/cpu_burn.sh" do
  source "cpu_burn.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

#bash 'Saturate_CPU' do
#  cwd "#{Chef::Config[:file_cache_path]}"
#  code <<-EOH
#    ./cpu_burn.sh
#  EOH
#  user 'root'
#end

#execute 'Stress' do
#  command "/usr/bin/#{node['chef_chaos']['conditions']["#{node['chef_chaos']['conditions'].length}".length][1]}"
#  user 'root'
#end

ruby_block 'run-chaos-condition' do
  block do
    len = node['chef_chaos']['conditions'].length-1
    cond = rand(len)
    cmd = node['chef_chaos']['conditions'][cond][1]
    Chef::Log.info("Running chaos condition -> '#{cmd}' ")
    c = Mixlib::ShellOut.new(cmd)
    c.run_command
  end
  action :run
end
