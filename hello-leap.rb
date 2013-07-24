#!/usr/bin/env ruby

require 'leap-motion'

class MyListener < Leap::Motion::Listener
  def on_init x
    puts "on_init: #{x}"
  end

  def on_connect x
    puts "on_connect: #{x}"
  end

  def on_disconnect x
    puts "on_disconnect: #{x}"
  end

  def on_exit x
    puts "on_exit: #{x}"
  end

  def on_frame x
    # puts "on_frame: #{x}"
    # p x.frame.pointables.count
    # pos = x.frame.pointables.frontmost.tip_position; puts "#{pos.x}, #{pos.y}, #{pos.z}"

    return unless x.frame.pointables.count == 2

    left_pos  = x.frame.pointables.leftmost.tip_position
    right_pos = x.frame.pointables.rightmost.tip_position

    puts "#{left_pos.x}, #{right_pos.x}"

    # p x.frame.pointable

    # exit
  end

  def on_focus_gained x
    puts "on_focus_gained: #{x}"
  end

  def on_focus_lost x
    puts "on_focus_lost: #{x}"
  end
end

listener = MyListener.new
controller = Leap::Motion::Controller.new
controller.add_listener listener

sleep
