class Entry < ApplicationRecord
  belongs_to :ticket
  belongs_to :author
end
