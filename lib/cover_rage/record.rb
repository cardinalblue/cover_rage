# frozen_string_literal: true

module CoverRage
  Record = Data.define(:path, :revision, :source, :execution_count, :last_executed_at) do
    def self.merge(existing_records, current_records)
      records_to_save = []
      current_records.each do |current_record|
        existing_record = existing_records.find { _1.path == current_record.path }
        records_to_save <<
          if existing_record.nil? || current_record.revision != existing_record.revision
            current_record
          else
            existing_record + current_record
          end
      end
      records_to_save
    end

    def +(other)
      with(
        execution_count: execution_count.map.with_index do |item, index|
          other_item = other.execution_count[index]
          if item.nil? && other_item.nil? then nil
          elsif item.nil? || other_item.nil? then other_item
          else item + other_item
          end
        end,
        last_executed_at: last_executed_at.map.with_index do |item, index|
          other_item = other.last_executed_at[index]
          if item.nil? && other_item.nil? then nil
          elsif item.nil? || other_item.nil? then other_item
          else [item, other_item].max
          end
        end
      )
    end
  end
end
