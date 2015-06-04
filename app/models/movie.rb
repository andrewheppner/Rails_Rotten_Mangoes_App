class Movie < ActiveRecord::Base

  RUNTIME_HASH = { "1" => (0..89), "2" => (90..120), "3" => (120..10000) }

  has_many :reviews

  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validate :release_date_is_in_the_future

  mount_uploader :image, ImageUploader

  scope :by_runtime, -> (duration) { where(runtime_in_minutes: RUNTIME_HASH[duration]) }
  scope :by_director, -> (director) { where("director LIKE (?)", "%#{director}%") }
  scope :by_title, -> (title) { where("title LIKE (?)", "%#{title}%") }

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size if reviews.size > 0
  end

  def self.search(search_params)
    movies = self.all
    movies = movies.by_title(search_params[:title]) if search_params[:title]
    movies = movies.by_director(search_params[:director]) if search_params[:director]
    movies = movies.by_runtime(search_params[:duration]) if search_params[:duration]
  end

  protected

  def release_date_is_in_the_future
    if release_date
      errors.add(:release_date, "should be in the future") if release_date < Date.today
    end
  end

end
