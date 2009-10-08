module Chargable
  include Processing::Proxy
  include Math

  def self.included(base)
    base.class_eval do
      attr_accessor :charge
    end
  end
  
  def chargable(charge)
    @charge = charge
  end
end