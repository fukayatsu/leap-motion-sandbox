#!/usr/bin/env ruby

require 'leap-motion'
require "coreaudio"
require 'pry'

class Sound
  def initialize
    @dev  = CoreAudio.default_output_device
    @buf  = @dev.output_loop(44000)
  end

  def init(valume, pitch)
    phase = Math::PI * 2.0 * pitch / 44000.0
    44000.times do |i|
      @buf[i] = ((valume * Math.sin(phase*i)) * 0x7FFF).round
    end
  end

  def start
    @buf.start
  end

  def stop
    @buf.stop
  end
end

class MyListener < Leap::Motion::Listener
  def on_init x
    puts "on_init: #{x}"
    @sound = Sound.new
    @sound.init(0.5, 440)
    @sound.start
  end

  def on_frame x
    @count ||= 1
    if @count % 5 == 0
      @count = 1
    else
      @count += 1
      return
    end

    return unless x.frame.pointables.count == 2

    left_pos  = x.frame.pointables.leftmost.tip_position
    right_pos = x.frame.pointables.rightmost.tip_position

    p y = left_pos.y / 100.0
    y = 4.0 if y > 4.0
    y = 1.0 if y < 1.0
    volume = y / 4.0

    x = right_pos.x / 100.0
    x = 0.0 if x < 0.0
    x = 1.0 if x > 1.0
    pitch = 440 * 2 ** (2 * x - 1)

    puts "#{volume}, #{pitch}"
    @sound.init(volume, pitch)
  end

  # def on_connect x
  #   puts "on_connect: #{x}"
  # end

  # def on_disconnect x
  #   puts "on_disconnect: #{x}"
  # end

  # def on_exit x
  #   puts "on_exit: #{x}"
  # end

  # def on_focus_gained x
  #   puts "on_focus_gained: #{x}"
  # end

  # def on_focus_lost x
  #   puts "on_focus_lost: #{x}"
  # end
end

listener = MyListener.new
controller = Leap::Motion::Controller.new
controller.add_listener listener

sleep
