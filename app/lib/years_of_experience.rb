module YearsOfExperience
  ZERO_TO_ONE = '0-1'
  TWO_TO_THREE = '2-3'
  FOUR_TO_SIX = '4-6'
  SEVEN_TO_NINE = '7-9'
  TEN_PLUS = '10+'

  def self.values
    constants(false).map{|c| const_get c }
  end
end
