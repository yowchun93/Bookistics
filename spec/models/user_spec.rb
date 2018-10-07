require 'spec_helper'

describe User do 
  let(:asin) { "the asin" }
  let!(:book_attributes) { 
    {
      asin: asin,
      title: "50 Shades of Yellow",
      authors: "William Shakespeare",
      details_url: "http://example.com/hamlet"
    }
  }
  let!(:book) { Book.create!(book_attributes) }

  it "adds the book to the user" do 
    user = User.create!
    user.add_book(book)
    user.books.should == [book]
  end
  it "does not add the book to use if he already has it" do 
    user = User.create!
    user.add_book(book)
    expect { user.add_book(book) }.not_to change { user.books.count } 
  end
end