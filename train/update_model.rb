#!/usr/bin/env ruby
# coding: utf-8

require 'fileutils'

script_dir = File.expand_path(File.dirname(__FILE__))

cascade = "#{script_dir}/res/cascade.xml"
dest_dir = '/usr/share/openalpr/runtime_data'
region_dir = "#{dest_dir}/region"
target = "#{region_dir}/jp.xml"

File.delete(target) if File.exist?(target)
File.copy(cascade, target)

