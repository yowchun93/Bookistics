class Statistics
  class << self
    DAYS_PER_YEAR   = 365.25
    MONTHS_PER_YEAR = 12.0
    DAYS_PER_MONTH  = DAYS_PER_YEAR / MONTHS_PER_YEAR

    def app_total_books
      Book.count(:id)
    end

    def app_total_users
      User.count(:id)
    end

    def user_total_books (user)
      user.books.size
    end

    def user_reading_books (user)
      ReadingLog
        .where("user_id = ?
                and start_date is not null
                and finish_date is null
                and use_for_statistics = 't'", user.id)
        .count
    end

    def user_read_books (user)
      ReadingLog
        .where("user_id = ?
                and start_date is not null
                and finish_date is not null
                and use_for_statistics = 't'", user.id)
        .count
    end

    def user_read_pages (user)
      ReadingLog
        .joins(:book)
        .where(
          "reading_logs.user_id = ?
           and reading_logs.start_date is not null
           and reading_logs.finish_date is not null
           and use_for_statistics = 't'", user.id)
        .sum('books.pages').to_i
    end

    def user_unread_books (user)
      ReadingLog
        .where("user_id = ?
                and start_date is null
                and finish_date is null
                and use_for_statistics = 't'", user.id)
        .count
    end

    def user_reading_since (user)
      ReadingLog
        .where("user_id = ? and use_for_statistics = 't'", user.id)
        .minimum('start_date')
    end

    def user_reading_last (user)
      ReadingLog
        .where("user_id = ? and use_for_statistics = 't'", user.id)
        .maximum('finish_date')
    end

    def user_average_books_per_month (user)
      user_average_books_per_year(user) / MONTHS_PER_YEAR
    end

    def user_average_books_per_year (user)
      samples = ReadingLog
                  .select('start_date, finish_date')
                  .where("reading_logs.user_id = ?
                          and start_date is not null
                          and finish_date is not null
                          and use_for_statistics = 't'", user.id)
                  .map { |log| DAYS_PER_YEAR / (log.finish_date - log.start_date).to_f  }
      samples.size != 0 ? (samples.inject(:+) / samples.size) : 0.0
    end

    def user_average_pages_per_day (user)
      user_average_pages_per_year(user) / DAYS_PER_YEAR
    end

    def user_average_pages_per_month (user)
      user_average_pages_per_year(user) / MONTHS_PER_YEAR
    end

    def user_average_pages_per_year (user)
      user_books = user_read_books(user)
      user_books != 0 ? (user_read_pages(user) / user_books) * user_average_books_per_year(user) : 0.0
    end

    def user_average_days_per_book (user)
      books_per_month = user_average_books_per_month(user)

      return 0.0 if books_per_month == 0.0

      DAYS_PER_MONTH / books_per_month
    end
  end
end
