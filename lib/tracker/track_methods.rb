require 'active_support/inflector'
require_relative 'tracker'

module Tracker
  module TrackMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def track(*args)
        raise ArgumentMissing if args.nil?

        args.each do |arg|
          case
            when arg.is_a?(Hash)
              attribute = arg.keys.first
            when arg.is_a?(Symbol)
              attribute = arg
          end

          send(:define_method, "tracking_#{ attribute }") do
            case
              when arg.is_a?(Hash)
                attribute = arg.keys.first
                values =  ([] << arg.values.first).flatten
              when arg.is_a?(Symbol)
                attribute = arg
            end
            attribute_value = self.send(attribute)
            attribute_changed = self.send("#{ attribute }_changed?")
            if attribute_changed && (values.is_a?(Array) ? values.map(&:to_sym).include?(attribute_value.to_sym) : true)
              ::Tracker::Tracker.create(class_name_record: self.class.to_s, attribute_name_record: attribute.to_s, after_value_record: self.send(attribute))
            end
          end

          after_save "tracking_#{ attribute }"

        end
      end
    end
  end
end