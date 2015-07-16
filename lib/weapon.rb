require 'thor'
#Hello weapon
class Weapon < Thor
  #used to test love
  attr_reader :love
  def self.hi(ff)
    puts "Hello world!"
    puts ff
  end

  def what
    puts "what"
  end

end
