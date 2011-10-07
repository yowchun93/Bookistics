class AddDontIncludeInStatisticsToReadingLogs < ActiveRecord::Migration
  def self.up
    add_column :reading_logs, :use_for_statistics, :boolean, :default => true, :null => false
    execute "UPDATE reading_logs SET use_for_statistics = 'f' WHERE start_date is not null and start_date = finish_date"
  end

  def self.down
    remove_column :reading_logs, :use_for_statistics
  end
end
