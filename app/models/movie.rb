require 'elasticsearch/model'

class Movie < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  Movie.import

  RUNTIME_HASH = { "1" => (0..89), "2" => (90..120), "3" => (120..10000) }

  has_many :reviews

  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validate :release_date_is_in_the_future

  mount_uploader :image, ImageUploader

  scope :by_runtime, -> (duration) { where(runtime_in_minutes: RUNTIME_HASH[duration]) }

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size if reviews.size > 0
  end

  protected

  def release_date_is_in_the_future
    if release_date
      errors.add(:release_date, "should be in the future") if release_date < Date.today
    end
  end

end
