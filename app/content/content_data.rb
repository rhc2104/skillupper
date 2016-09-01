# When a new instance of ContentData is created,
# it is added to a lookup table to be fetched by name.
# TODO: Figure out how to put data into multiple files
class ContentData
  @@instances = {}

  attr_reader :name, :test_values, :expected_values, :parameters, :previous_code_to_show

  def initialize(values)
    if @@instances[values[:name]]
      raise "Trying to create duplicate ContentData #{values[:name]}"
    end

    @name = values[:name]
    @test_values = values[:test_values]
    @expected_values = values[:expected_values]
    @function_name = values[:function_name]
    @parameters = values[:parameters]
    @previous_code_to_show = values[:previous_code_to_show]

    @@instances[values[:name]] = self
  end

  def self.get_instance(name)
    @@instances[name]
  end

  def function_name(language_name)
    if ['ruby', 'python'].include?(language_name)
      @function_name.underscore
    elsif language_name === 'javascript'
      @function_name
    else
      raise "Invalid language #{language_name}"
    end
  end

  # This is fed to client, assuming we can hack camel => underscore client side
  def camel_function_name
    @function_name
  end

end

content_data = []

# Spiral Matrix
spiral_matrix = {function_name: 'traverseMatrix', parameters: ['matrix']}
test_matrix =
  [['A', 'B', 'C', 'D', 'E'],
   ['F', 'G', 'H', 'I', 'J'],
   ['K', 'L', 'M', 'N', 'O'],
   ['P', 'Q', 'R', 'S', 'T'],
   ['U', 'V', 'W', 'X', 'Y']]
small_matrix = [['A']]
content_data.push(spiral_matrix.merge({
  name: 'outer_layer_matrix',
  test_values: [[test_matrix], [small_matrix]],
  expected_values: [['A', 'B', 'C', 'D', 'E', 'J', 'O', 'T', 'Y', 'X', 'W', 'V', 'U', 'P', 'K', 'F'], ['A']],
}))
content_data.push(spiral_matrix.merge({
  name: 'two_layers_matrix',
  test_values: [[test_matrix], [small_matrix]],
  expected_values: [['A', 'B', 'C', 'D', 'E', 'J', 'O', 'T', 'Y', 'X', 'W', 'V', 'U', 'P', 'K', 'F', 'G', 'H', 'I', 'N', 'S', 'R', 'Q', 'L'], ['A']],
  previous_code_to_show: 'outer_layer_matrix',
}))
content_data.push(spiral_matrix.merge({
  name: 'matrix',
  test_values: [[test_matrix], [small_matrix]],
  expected_values: [['A', 'B', 'C', 'D', 'E', 'J', 'O', 'T', 'Y', 'X', 'W', 'V', 'U', 'P', 'K', 'F', 'G', 'H', 'I', 'N', 'S', 'R', 'Q', 'L', 'M'], ['A']],
  previous_code_to_show: 'two_layers_matrix',
}))

# N Queens
valid_placement = [8, [[0, 5], [2, 6], [3, 0], [4, 3], [5, 7], [6, 4], [7, 2]], [1, 1]]
same_row = [8, [[0, 5], [2, 6], [3, 0], [4, 3], [5, 7], [6, 4], [7, 2]], [0, 1]]
same_column = [8, [[0, 5], [2, 6], [3, 0], [5, 7], [6, 4], [7, 2]], [1, 0]]
along_diagonal = [8, [[0, 5], [2, 6], [4, 3], [5, 7], [6, 4], [7, 2]], [1, 0]]

content_data.push({
  name: 'validate_queen_placement',
  function_name: 'validateQueenPlacement',
  parameters: ['size', 'existingQueens', 'newQueen'],
  test_values: [valid_placement, same_row, same_column, along_diagonal],
  expected_values: [true, false, false, false],
})

content_data.push({
  name: 'next_row_columns',
  function_name: 'nextRowColumns',
  parameters: ['size', 'existingQueens', 'nextRow'],
  test_values: [
    [8, [[0, 1], [1, 3]], 2],
    [8, [[0, 1], [1, 3], [1, 5]], 3],
    [8, [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]], 1],
    [8, [], 0],
  ],
  expected_values: [[0, 5, 6, 7], [0, 2, 6], [], [0, 1, 2, 3, 4, 5, 6, 7]],
  previous_code_to_show: 'validate_queen_placement',
})

content_data.push({
  name: 'n_queens',
  function_name: 'nQueens',
  parameters: ['size'],
  test_values: [[1], [2], [3], [4], [5], [6], [7], [8], [9]],
  expected_values: [1, 0, 0, 2, 10, 4, 40, 92, 352],
  previous_code_to_show: 'next_row_columns',
})

# Fibonacci
fibonacci = {function_name: 'fibonacci', parameters: ['n']}

content_data.push(fibonacci.merge({
  name: 'naive_fibonacci',
  test_values: [[1], [2], [3], [4], [5], [6], [7], [8], [9], [10]],
  expected_values: [1, 1, 2, 3, 5, 8, 13, 21, 34, 55],
}))

fibonacci_dynamic_programming = fibonacci.merge({
  test_values: [[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [50], [70]],
  expected_values: [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 12586269025, 190392490709135],
})
content_data.push(fibonacci_dynamic_programming.merge({
  name: 'memoization_fibonacci',
  previous_code_to_show: 'naive_fibonacci',
}))
content_data.push(fibonacci_dynamic_programming.merge({name: 'bottom_up_fibonacci'}))

# Basketball Scores
basketball_scores = {function_name: 'basketballScorePermutations', parameters: ['points']}
content_data.push(basketball_scores.merge({
  name: 'naive_permutations',
  test_values: [[0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10]],
  expected_values: [1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274],
}))
basketball_scores_dynamic_programming = basketball_scores.merge({
  test_values: [[0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [20], [40], [60]],
  expected_values: [1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 121415, 23837527729, 4680045560037375],
})
content_data.push(basketball_scores_dynamic_programming.merge({
  name: 'memoize_permutations',
  previous_code_to_show: 'naive_permutations',
}))
content_data.push(basketball_scores_dynamic_programming.merge({
  name: 'bottom_up_permutations',
}))

content_data.each do |data|
  ContentData.new(data)
end
