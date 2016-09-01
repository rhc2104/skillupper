Rails.application.routes.draw do
  devise_for :users

	root 'home#home'
  post '/', to: 'home#sign_up'

  get 'terms', to: 'home#terms'

  post 'submit', to: 'submit#submit', constraints: { format: 'json' }

	get 'spiral_matrix/outer_layer', to: 'spiral_matrix#outer_layer'
	get 'spiral_matrix/two_layers', to: 'spiral_matrix#two_layers'
	get 'spiral_matrix/matrix', to: 'spiral_matrix#matrix'
  get 'spiral_matrix/recap', to: 'spiral_matrix#recap'

  get 'n_queens/validate_queen_placement', to: 'n_queens#validate_queen_placement'
  get 'n_queens/next_row', to: 'n_queens#next_row'
  get 'n_queens/n_queens', to: 'n_queens#n_queens'
  get 'n_queens/recap', to: 'n_queens#recap'

  # Dynamic programming
  get 'fibonacci/naive', to: 'fibonacci#naive'
  get 'fibonacci/memoization', to: 'fibonacci#memoization'
  get 'fibonacci/bottom_up', to: 'fibonacci#bottom_up'
  get 'fibonacci/recap', to: 'fibonacci#recap'

  get 'basketball_scores/naive_permutations', to: 'basketball_scores#naive_permutations'
  get 'basketball_scores/memoize_permutations', to: 'basketball_scores#memoize_permutations'
  get 'basketball_scores/bottom_up_permutations', to: 'basketball_scores#bottom_up_permutations'

end
