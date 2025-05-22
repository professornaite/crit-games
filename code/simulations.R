# this file will contain simulations of the game theory analysis

# Cold War Nuclear Deterrence Game Theory Simulation
# Simulates US-USSR nuclear strategy interactions based on arsenal sizes
# Model incorporates Mutually Assured Destruction (MAD) principles[1][2]

library(ggplot2)
library(dplyr)

# Initialize parameters (values based on historical estimates[4][5])
params <- list(
  years = seq(1949, 1991),  # Cold War timeframe
  initial_us = 50,         # US nuclear stockpile 1949
  initial_ussr = 1,        # USSR nuclear stockpile 1949
  max_arsenal = 40000,     # Peak Soviet stockpile (1986)[4]
  detection_probability = 0.2,  # Chance of hidden weapons detection
  first_strike_success = 0.7,   # Probability of successful first strike
  retaliation_threshold = 0.3,  # Min surviving weapons needed for retaliation
  escalation_factor = 1.2       # Arms race multiplier
)

# Game theory payoff matrix (modified Prisoner's Dilemma)[1][2]
payoffs <- matrix(c(
  # Cooperate             Defect
  c(0, 0),               c(-10, 10),    # US Cooperate
  c(10, -10),            c(-100, -100)  # US Defect
), ncol = 2, byrow = TRUE)

simulate_cold_war <- function(params) {
  # Initialize data structure
  history <- data.frame(
    Year = params$years,
    US_Arsenal = numeric(length(params$years)),
    USSR_Arsenal = numeric(length(params$years)),
    US_Action = character(length(params$years)),
    USSR_Action = character(length(params$years)),
    Outcome = character(length(params$years))
  )
  
  # Set initial values
  history$US_Arsenal[1] <- params$initial_us
  history$USSR_Arsenal[1] <- params$initial_ussr
  
  for (i in 2:length(params$years)) {
    # Calculate perceived arsenal sizes with detection uncertainty
    us_perception <- history$US_Arsenal[i-1] * 
      (1 + params$detection_probability * runif(1, -0.5, 0.5))
    ussr_perception <- history$USSR_Arsenal[i-1] * 
      (1 + params$detection_probability * runif(1, -0.5, 0.5))
    
    # Strategic decision making based on MAD principles[1][2]
    us_action <- ifelse(ussr_perception > history$US_Arsenal[i-1] * params$retaliation_threshold,
                        "Cooperate", "Defect")
    ussr_action <- ifelse(us_perception > history$USSR_Arsenal[i-1] * params$retaliation_threshold,
                          "Cooperate", "Defect")
    
    # Update arsenals based on actions
    if (us_action == "Defect" && ussr_action == "Defect") {
      # Mutual assured destruction scenario[1]
      history$US_Arsenal[i] <- history$US_Arsenal[i-1] * 0.1
      history$USSR_Arsenal[i] <- history$USSR_Arsenal[i-1] * 0.1
      outcome <- "MAD"
    } else if (us_action == "Defect") {
      # First strike scenario
      if (runif(1) < params$first_strike_success) {
        history$USSR_Arsenal[i] <- history$USSR_Arsenal[i-1] * 0.1
        outcome <- "US First Strike Success"
      } else {
        history$US_Arsenal[i] <- history$US_Arsenal[i-1] * 0.5
        outcome <- "Failed First Strike"
      }
    } else if (ussr_action == "Defect") {
      # Soviet first strike
      if (runif(1) < params$first_strike_success) {
        history$US_Arsenal[i] <- history$US_Arsenal[i-1] * 0.1
        outcome <- "USSR First Strike Success"
      } else {
        history$USSR_Arsenal[i] <- history$USSR_Arsenal[i-1] * 0.5
        outcome <- "Failed First Strike"
      }
    } else {
      # Arms race dynamics[3][4]
      history$US_Arsenal[i] <- min(
        history$US_Arsenal[i-1] * params$escalation_factor,
        params$max_arsenal
      )
      history$USSR_Arsenal[i] <- min(
        history$USSR_Arsenal[i-1] * params$escalation_factor,
        params$max_arsenal
      )
      outcome <- "Arms Race"
    }
    
    # Store results
    history$US_Action[i] <- us_action
    history$USSR_Action[i] <- ussr_action
    history$Outcome[i] <- outcome
  }
  
  return(history)
}

# Run simulation and visualize results
set.seed(2023)
sim_results <- simulate_cold_war(params)

# Plot arsenal development
ggplot(sim_results, aes(x = Year)) +
  geom_line(aes(y = US_Arsenal, color = "United States"), linewidth = 1.2) +
  geom_line(aes(y = USSR_Arsenal, color = "Soviet Union"), linewidth = 1.2) +
  scale_color_manual(values = c("United States" = "blue", "Soviet Union" = "red")) +
  labs(title = "Cold War Nuclear Arsenal Simulation",
       y = "Nuclear Warheads",
       color = "Country") +
  theme_minimal()

# Display strategic outcomes
sim_results %>%
  group_by(Outcome) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  ggplot(aes(x = Outcome, y = Count, fill = Outcome)) +
  geom_col() +
  labs(title = "Simulation Outcomes Distribution",
       x = "Strategic Outcome",
       y = "Frequency") +
  theme_minimal()
