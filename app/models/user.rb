class User < ActiveRecord::Base
  has_many :authentications
  has_many :reading_logs
  has_many :books, :through => :reading_logs

  self.per_page = 180

  def to_param
    nickname
  end

  def has_book? (asin)
    self.books.any? { |user_book| user_book.asin == asin }
  end

  def find_log (asin)
    self.reading_logs.select { |log| log.book.asin == asin }.first if self.has_book?(asin)
  end

  def add_book(book)
    if !self.has_book? book.asin
      self.books << book
      self.save!
    end
  end

  class << self
    def create_from_auth (auth)
      user = User.new

      if auth['user_info']
        user.name       = auth['user_info']['name'] if auth['user_info']['name']
        user.avatar_url = auth['user_info']['image'] if auth['user_info']['image']
        user.nickname   = auth['user_info']['nickname'] || "User#{ (Random.new.rand * 99999).to_i.to_s }"
      end

      user.authentications.build(:provider => auth['provider'], :uid => auth['uid'])
      user.save!
      user
    end

    def from_param (param)
      self.where('nickname = ?', param).first
    end

    def param_exists? (param)
      self.where('nickname = ?', param).exists?
    end
  end
end
