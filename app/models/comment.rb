class Comment < ActiveRecord::Base
  belongs_to :circle
  belongs_to :use

end
