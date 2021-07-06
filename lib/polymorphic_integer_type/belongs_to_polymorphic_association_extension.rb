module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private def replace_keys(record, force: false)
        super

        target_type = record ? record.class.base_class : nil

        if force || owner[reflection.foreign_type] != target_type
          owner[reflection.foreign_type] = target_type
        end
      end
    end
  end
end
