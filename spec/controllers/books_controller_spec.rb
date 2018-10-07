require 'rails_helper'

describe BooksController do 
  let(:user) { User.create! }
  before { controller.stub(:current_user) { user } }
  
  context "when there is ASIN" do 
    let(:asin) { "the-asin" }
    let!(:book_attributes) { 
      {
        asin: asin,
        title: "50 Shades of Yellow",
        authors: "William Shakespeare",
        details_url: "http://example.com/hamlet"
      }
    }
    
    context "when book is in the database" do 
      let!(:book) { Book.create!(book_attributes) }
      
      it "adds book to the user if he does not have it " do 
        user.should_receive(:add_book).with(book)
        post :create, id: asin 
      end
    
    end
    
    context "when the book is not in the database" do     
      it "adds book to the user if book is in Amazon" do 
        amazon_book = double(:AmazonBook)
        allow(amazon_book).to receive(:attributes).and_return(book_attributes)
        AmazonBook.stub(:find_by_asin).with(asin) { amazon_book }
        post :create, id: asin 
        user.books.count.should == 1
        user.books.first.title.should == "50 Shades of Yellow"
      end
      
      it "does not add book to the user if book is not in Amazon" do 
        AmazonBook.stub(:find_by_asin).with(asin) { nil }
        post :create, id: asin 
        user.books.should be_empty
      end
    end
  # when there is ASIN
  end
  
  context "when there is not an ASIN" do
    it "does not add book to the user" do 
      post :create
      user.books.should be_empty
    end
  end

end