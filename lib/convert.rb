require 'fileutils'

INPUT_FILE = 'media/walle.mov'
BASENAME = File.basename(INPUT_FILE, File.extname(INPUT_FILE))

FileUtils.remove_dir('tmp')
Dir.mkdir('tmp')

`ffmpeg -i #{INPUT_FILE} tmp/#{BASENAME}_%4d.png`
`ffmpeg -i #{INPUT_FILE} -vf "[in] format=rgba, split [T1], fifo, lutrgb=r=minval:g=minval:b=minval, [T2] overlay [out]; [T1] fifo, lutrgb=r=maxval:g=maxval:b=maxval [T2]" tmp/#{BASENAME}_alpha_%4d.png`

Dir['tmp/*_alpha_*'].each_with_index do |file, index|
  `convert tmp/#{BASENAME}_#{'%04d' % (index + 1)}.png tmp/#{BASENAME}_alpha_#{'%04d' % (index + 1)}.png -append tmp/#{BASENAME}_combined_#{'%04d' % (index + 1)}.png`
end

`ffmpeg -i tmp/#{BASENAME}_combined_%4d.png -r 24 -b 1500k -vcodec libvpx -f webm -g 24 media/walle.webm`
`ffmpeg -i tmp/#{BASENAME}_combined_%4d.png -r 24 -b 1500k -vcodec libtheora -g 24 media/walle.ogv`
`ffmpeg -i tmp/#{BASENAME}_combined_%4d.png -r 24 -b 1500k -vcodec libx264 -g 24 media/walle.mp4`
