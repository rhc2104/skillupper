class UrlToName
  MAP =
    {
      # The homepage also contains the outer layer matrix content
      '/' => 'outer_layer_matrix',
      '/spiral_matrix/outer_layer' => 'outer_layer_matrix',

      '/spiral_matrix/two_layers' => 'two_layers_matrix',
      '/spiral_matrix/matrix' => 'matrix',
      '/n_queens/validate_queen_placement' => 'validate_queen_placement',
      '/n_queens/next_row' => 'next_row_columns',
      '/n_queens/n_queens' => 'n_queens',
      '/fibonacci/naive' => 'naive_fibonacci',
      '/fibonacci/memoization' => 'memoization_fibonacci',
      '/fibonacci/bottom_up' => 'bottom_up_fibonacci',
      '/basketball_scores/naive_permutations' => 'naive_permutations',
      '/basketball_scores/memoize_permutations' => 'memoize_permutations',
      '/basketball_scores/bottom_up_permutations' => 'bottom_up_permutations',
    }

  def self.content_name(request)
    MAP[request.fullpath]
  end
end
