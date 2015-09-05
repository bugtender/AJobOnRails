class Job < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :from_url, :allow_nil => true
end
