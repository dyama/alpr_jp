#!/usr/bin/env ruby
# coding: utf-8

require 'fileutils'
require 'rmagick'

dir = File.expand_path(File.dirname(__FILE__))
pdir = "#{dir}/pos"
ndir = "#{dir}/neg"
plist = "#{pdir}/pos.txt"
nlist = "#{ndir}/neg.txt"
vec = "#{pdir}/pos.vec"
rdir = "#{dir}/res"

libdir = "#{dir}/../../opencv-3.4.8/build/lib"
bindir = "#{dir}/../../opencv-3.4.8/build/bin"

score = 0.85

w = 36
h = 18

["#{ndir}/*.txt", "#{pdir}/*.vec", "#{pdir}/*.txt" ].each do |pattern|
  Dir.glob(pattern).each do |file|
    File.delete(file)
  end
end
FileUtils.rm_r(rdir) if Dir.exist?(rdir)
FileUtils.mkdir_p(rdir)

files = Dir.glob("#{ndir}/*.{jpg,png,jpeg}").to_a.map {|file| "#{File.expand_path(file)}\n" }
files = files.sample(250)
File.write(nlist, files.join)
nbneg = files.size

files = Dir.glob("#{pdir}/*.{jpg,png,jpeg}").to_a.map {|file|
  image = Magick::Image.read(file).first
  iw = image.columns
  ih = image.rows
  "#{File.basename(file)} 1 0 0 #{iw} #{ih}\n"
}
File.write(plist, files.join)
nbpos = files.size

cmd = "LD_LIBRARY_PATH=#{libdir} #{bindir}/opencv_createsamples"
cmd << " -info #{plist} -vec #{vec} -w #{w} -h #{h}"
#cmd << " -bg #{nlist} -maxxangle 0.1 -maxyangle 0.1 -maxzangle 0.1"
#cmd << " -maxidev 100"
cmd << " -num #{nbpos} -bgcolor 255 -bgthresh 5"

puts cmd

puts `#{cmd}`

args = {
  data: rdir,
  vec: vec,
  bg: nlist,
  numPos: (nbpos * score).to_i,
  numNeg: nbneg,
  numStages: 12,
  stageType: 'BOOST',
  featureType: 'LBP',
  w: w,
  h: h,
  bt: 'GAB',
  minHitRate: 0.999,
  maxFalseAlarmRate: 0.1,
  maxDepth: 1,
  # mode: 'ALL',
  precalcValBufSize: 5000,
  precalcIdxBufSize: 1000,
}

s = "LD_LIBRARY_PATH=#{libdir} #{bindir}/opencv_traincascade"
args.each do |k, v|
  s += " -#{k} #{v}" unless v.nil?
end

puts s

File.write("#{dir}/run_train.sh", s)

