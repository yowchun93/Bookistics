class UpdateBooksDetailsUrl < ActiveRecord::Migration
  class Book < ActiveRecord::Base
  end

  def self.up
    Book.all.each do |book|
      amazon = AmazonBook.find_by_asin book.asin
      book.update_attributes! :details_url => amazon.details_url
    end
  end

  def self.down
  end
end
