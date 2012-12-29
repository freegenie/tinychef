module Tinychef
  
  class Destination 
    
    attr_reader :user, :host
     
    def initialize(dest)
      if dest.include? '@'
        @user, @host = dest.split('@')
      else
        @user = nil ; @host = dest
      end
    end
    
    def to_s
      if user.nil? 
        host
      else
        "#{user}@#{host}"
      end
    end
  end
end