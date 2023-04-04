module ActiveRecord
  module Associations
    if Rails::VERSION::MAJOR > 6
      raise "This extension is not compatible with Rails > 6"
    end

    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private def replace_keys(record, force: false)
        super

        target_type = if record
          if owner.class.ancestors.include?(PolymorphicIntegerType::Extensions)
            record.class.base_class
          else
            record.class.polymorphic_name
          end
        end

        if force || owner[reflection.foreign_type] != target_type
          owner[reflection.foreign_type] = target_type
        end
      end
    end
  end
end
