require "tracker/version"
require 'tracker/track_methods'
require 'active_record'
require 'rails'

module Tracker
  ActiveRecord::Base.send(:include, TrackMethods)
end
