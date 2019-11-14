#!/usr/bin/env ruby
# coding: utf-8

require 'fileutils'

w = 200
h = 100

script_dir = File.expand_path(File.dirname(__FILE__))
project_dir = File.expand_path("#{script_dir}/..")
dest_dir = "#{script_dir}/pos"
targets = %w(事業用 事業用(軽) 自家用 自家用(軽))

FileUtils.rm_r(dest_dir) if Dir.exist?(dest_dir)
FileUtils.mkdir_p(dest_dir)

ctable = ('0'..'9').to_a + ('a'..'f').to_a

Dir.glob("#{project_dir}/{#{targets.join(',')}}/**/*.{jpg,jpeg,png}") do |file|
  dest = "#{dest_dir}/#{ctable.sample(10).join}.jpg"
  `convert -resize #{w}x#{h}! "#{file}" "#{dest}"`
  puts "#{file} => #{dest}"
end

