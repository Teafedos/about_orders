class Client < ApplicationRecord
    has_many :purchase

    validates :name, presence: true
    validates :name, presence: true
end
