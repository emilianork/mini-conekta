# coding: utf-8
class Payment < ActiveRecord::Base

  after_initialize :set_default_values

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w(created rejected completed),
                                  message: "%{value} no es un status válido" }

  def set_default_values
    self.status ||= "created"
  end
end
