# Source funcions
source('rl/bandit.R')
source('rl/epsilon_greedy_decay.R')
source('rl/optimistic_initial_values.R')
source('rl/ucb1.R')
source('rl/bayes.R')

eps <- run_epsilon_greedy_decay(1.0, 2.0, 3.0, 100000)
oiv <- run_oiv(1.0, 2.0, 3.0, 100000)
ucb <- run_ucb(1.0, 2.0, 3.0, 100000)
bayes <- run
