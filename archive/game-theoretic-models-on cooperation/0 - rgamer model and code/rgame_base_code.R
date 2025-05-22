# critical analysis of cooperative and non-cooperative games


# rgamer for education
# https://github.com/yukiyanai/rgamer
# install.packages("devtools")
devtools::install_github("yukiyanai/rgamer")

library(rgamer)

# An example of a normal-form game (prisoner's dilemma)
# Define player, strategy and payoffs
game0 <- normal_form(
  players = c("Player 1", "Player 2"),
  s1 = c("Cooperate", "Defect"),
  s2 = c("Cooperate", "Defect"),
  payoffs1 = c(-1, 0, -3, -2),
  payoffs2 = c(-1, -3, 0, -2)
)

# Specify payoffs for each cell of the game matrix
game0b <- normal_form(
  players = c("Player 1", "Player 2"),
  s1 = c("Cooperate", "Defect"),
  s2 = c("Cooperate", "Defect"),
  cells = list(c(-1, -1), c(-3,0), c(0, -3), c(-2, -2)),
  byrow = TRUE
)

# Pass to solve_nfg() function to get the table of the game and the Nash Equillibrium
s_game0 <- solve_nfg(game0, show_table = FALSE)
#> Pure-strategy NE: [Defect, Defect]

s_game0$table
