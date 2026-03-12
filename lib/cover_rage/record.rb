# frozen_string_literal: true

module CoverRage
  Record = Data.define(:path, :revision, :source, :execution_count, :last_executed_at) do
    def self.merge(existing, current)
      records_to_save = []
      current.each do |record|
        found = existing.find { _1.path == record.path }
        records_to_save <<
          if found.nil? || record.revision != found.revision
            record
          else
            record + found
          end
      end
      records_to_save
    end

    def +(other)
      with(
        execution_count: execution_count.map.with_index do |item, index|
          item.nil? ? nil : item + other.execution_count[index]
        end,
        last_executed_at: last_executed_at.map.with_index do |item, index|
          if item.nil? && other.last_executed_at[index].nil? then nil
          elsif item.nil? then other.last_executed_at[index]
          elsif other.last_executed_at[index].nil? then item
          else [item, other.last_executed_at[index]].max
          end
        end
      )
    end
  end
end
