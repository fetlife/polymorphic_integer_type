module PolymorphicIntegerType
  class TypeCaster < ActiveRecord::Type::Value

    attr_reader :mapping, :klass
    def initialize(mapping:, klass: )
      @mapping = mapping
      @klass = klass
    end

    def deserialize(value)
      mapping[value] && mapping[value].to_s
    end

    def cast(value)
      mapped_value(value)
    end

    def mapped_value(value)
      if value.is_a?(Integer)
        return mapping[value]
      end

      if value.kind_of? String
        value = klass.send(:compute_type, value)
      end

      return value.sti_name if mapping.value?(value.sti_name)

      if value.kind_of?(Class) && value <= ActiveRecord::Base
        return value.polymorphic_name if value.respond_to?(:polymorphic_name) && mapping.value?(value.polymorphic_name)
        return value.sti_name if mapping.value?(value.sti_name)
        return value.base_class.to_s if mapping.value?(value.base_class.to_s)
        return value.base_class.sti_name if mapping.value?(value.base_class.sti_name)
      end

      value
    end

    def serialize(value)
      case value
      when Integer
        value
      else
        val = mapping.key(mapped_value(value))
        val
      end
    end

  end
end