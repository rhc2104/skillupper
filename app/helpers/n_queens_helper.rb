module NQueensHelper
  def coordinates_match(objs, row, col)
    objs.each do |obj|
      return true if obj[0] == row && obj[1] == col
    end
    false
  end

  def queen_can_visit(queens, row, col)
    queens.each do |queen|
      if row == queen[0] || col == queen[1] || (row - queen[0]).abs == (col - queen[1]).abs
        return true
      end
    end
    false
  end
end
