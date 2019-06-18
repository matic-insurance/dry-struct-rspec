module RSpec
  module Dry
    module Struct
      class Matcher
        attr_reader :attr_name, :attr_type

        def initialize(attr_name, attr_type = nil)
          @attr_name = attr_name
          @attr_type = attr_type
        end

        def matches?(actual)
          @actual = actual
          @actual_attribute = actual.schema.key(@attr_name).type
          correct_attr_type?
        rescue KeyError
          false
        end

        def description
          "have #{@attr_name.inspect} attribute"
        end

        def failure_message
          return attr_not_found_message(@actual) if @actual_attribute.nil?
          attr_type_mismatch_message(@actual)
        end

        def failure_message_when_negated
          "#{unexpected_message(@actual)}, but it was found"
        end

        private

        def correct_attr_type?
          @attr_type.nil? || @actual_attribute == @attr_type
        end

        def attr_not_found_message(actual)
          "#{expected_message(actual)}, but it was not found"
        end

        def attr_type_mismatch_message(actual)
          "#{expected_message(actual)}, but type is wrong"
        end

        def expected_message(actual)
          "expected #{actual} to have #{@attr_name.inspect} attribute"
        end

        def unexpected_message(actual)
          expected_message(actual).gsub('to have', 'to not have')
        end
      end
    end
  end
end
