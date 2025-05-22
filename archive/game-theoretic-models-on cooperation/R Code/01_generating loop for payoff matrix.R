##### PROLOG
# Code written on: January 15 2022
# Project: Evolutionary game theoretic models of cooperation
# Edited on: March 9 2022 // June 14 2022 // September 20 2022
# Updated by: Nathan Alexander

##### NOTES
# This files generates some of the initial code for creating a loop for the evolutionary payoff matrices
# These matrices are based on an evolutionary game model and take into account the decisions making process

# Clear Memory
rm(list=ls())

# Set number of generations
maxgen <- 20

# Set population size
N <- 1000

# Set the mutation rate
mutation.rate = 0.005

# Set the payoffs; b is often used for 'benefit' of cooperation; c for 'cost' of cooperation
b <- 3 
c <- 1

# visualise payoffs; column names labeled "C" for cooperate and "D" for defect
x <- c(paste(b-c, b-c, sep = ", "), paste(-c, b, sep = ", ")) 
y <- c(paste(b, -c, sep = ", "), paste(0, 0, sep = ", "))
df <- data.frame(x,y)
colnames(df) <- c("C", "D")
rownames(df) <- colnames(df) 
df

# Set starting population, use all cooperators (this could be used to mimic the evolution of trust game)
# sample(c(1:50), 10, replace = TRUE) will sample from the numbers 1:50 ten times, and put each sampled item back into the mix, where it may be sampled again. 
# In this example we are using the number 1 to mean a cooperator and -1 to mean a defector.
# We can sample from a vector of just a single one (as long as replace = TRUE) 
# By using this method (line above), we generate a population of the right size such that all individuals will be 1 and therefore cooperators.
start <- c(1)
population <- sample(start, N, replace = TRUE)

# alternatively, to start with an equal mix of cooperators and defectors, we could use start <- c(1, -1)
# or if we wanted to use a certain proprtion we could use the ability of sample to make a biased sample. 
# Here we will assign the probability 0.25 to cooperators, and 0.75 to defectors, and check the freqeuncy of our population.
start <- c(1, -1)
prob <- c(0.30, 0.70)
population <- sample(start, N, replace = TRUE, prob = prob)
length(population[population==1]) / length(population)
length(population[population==-1]) / length(population)


# try all defectors
start <- c(-1)
population <- sample(start, N, replace = TRUE)
length(population[population==-1]) / length(population)
  # question: when you use -1 you get defectors? Yes.


# try to create a situation where there is a propotion of defectors and cooperators that could generate a loop with replace = TRUE
# quesiton: what would be the case if replace = FALSE? There is an error message.
            #### Error in sample.int(length(x), size, replace, prob) : 
            #### cannot take a sample larger than the population when 'replace = FALSE'

start <- c(1, -1)
population <- sample(start, N, replace = TRUE)
length(population[population==-1]) / length(population)

start <- c(1, -1)
population <- sample(start, N, replace = TRUE)
length(population[population==1]) / length(population)

# When you use the payoffs that are slightly higher than the inserted df (see code above) you get a net change of zero
# this net change is when player 1 or player 2 defects in the face of cooperation
# cooperating, as a result, is still the desired practice but when the other player defects, the payoffs 


# set up a matrix to store our output from each generation
#output <- matrix(NA, maxgen, 4) will give us a matrix of NAs with 'maxgen' number of rows and 4 columns
# we can store these in colum names "generation number, freq of cooperators, freq of defectors, average payoff"
output <- matrix(NA, maxgen, 4)
colnames(output) <- c("generation", "freq coop", "freq defect", "mean payoff")


################## Set up a loop
  # begin loop
  for (z in 1:maxgen){
    # make two samples, to be matches as pairs of individuals
    player1 <- sample(population, N, replace=FALSE)
    player2 <- sample(population, N, replace=FALSE)
    # make a vector for the payoff to cooperators
    coop.payoff <- 0
    # loop through the population, if player one and player two both equal 1 (i.e., are cooperators)
    for(y in 1:N) {
      if(player1[y]==1 && player2[y]==1) {
        coop.payoff <- coop.payoff + (2 * (b-c))
      }
    }
    # After this loop, store the generation number and payoff to cooperators in the output matrix
    output[z, 1] <- z
    output[z, 2] <- coop.payoff
  }

# The above code demonstrates the basic approach of having a loop of each generation, 
# and nested within that having another loop that goes through each individual in the population and assigns payoffs.
# It is not really useful as it lacks any mutations
  # What are mututions again and how do we use them based on the matching of the Evolution of Trust?


########################## CREATING THE ACTUAL LOOP

# begin loop
for (i in 1:maxgen){

# make pairs of individuals
  player1 <- sample(population, N, replace=FALSE)
  player2 <- sample(population, N, replace=FALSE)

# set payoff counters
  coop.payoff <- 0
  defect.payoff <- 0

# Loop to calculate payoffs based on payoff matrix
  for(j in 1:N){
    # If both players cooperate (=1) payoffs = b-c, b-c
    if(player1[j]==1 && player2[j]==1) {
      coop.payoff <- coop.payoff + (2 * (b-c))
    }
    # If player one cooperates and two defects (1, -1) payoffs = -c, b
    if(player1[j]==1 && player2[j]==-1) {
      coop.payoff <- coop.payoff - c
      defect.payoff <- defect.payoff + b
    }
    # If player one defects and two cooperates (-1, 1) payoffs = b, -c
    if(player1[j]==-1 && player2[j]==1) {
      coop.payoff <- coop.payoff - c
      defect.payoff <- defect.payoff + b
    }
    # If both players defect (-1, -1) payoffs = 0, 0
    if(player1[j]==-1 && player2[j]==-1) {
      coop.payoff <- coop.payoff + 0
      defect.payoff <- defect.payoff + 0
    }
  }

## In the code above, we are looking at PAYOFFS TO THE STRATEGY as opposed to individuals
  

# generate new population based on payoffs
  if(coop.payoff < 0){coop.payoff <- 0}
  SUM <- coop.payoff + defect.payoff
  pop.coop <- coop.payoff / SUM * N * 3
  pop.defect <- defect.payoff / SUM * N * 3
  pop.offspring <- c(rep(1,pop.coop), rep(-1,pop.defect)) 
  population <- sample(pop.offspring,N,replace=FALSE)
  
#calculate frequency of coopeators and defectors in this population
  fc <- sum(population == 1) / (sum(population == 1) + sum(population == -1))
  fd <- sum(population == -1) / (sum(population == 1) + sum(population == -1))
  

# ONE IMPORTANT STEP is to mutate our population
  # m is defined as the number of mutations expected (mutiation rate times population size)
  # we use sample to pick m (e.g., 5) numbers which represent the indiviudals to mutate (e.g.., 3rd, 454th, 667th, 787th and 990th)
  # these individual sare given the value of 1 or -1 (some may change, others may not, which is important when interpreting mutaiton rate effects)
  
  # mutation
  m <- mutation.rate * N
  mutation.place <- sample(length(population), m, replace = FALSE)
  population[mutation.place] <- sample(c(-1, 1), 5, replace = TRUE)
  

# Record generation number, frequency of cooperators, frequency of defectors, and average payoff in our output matrix
  output <- matrix(NA, maxgen, 4)
  colnames(output) <- c("generation", "freq coop", "freq defect", "average payoff")
  
  output[i, 1] <- i
  output[i, 2] <- fc
  output[i, 3] <- fd
  output[i, 4] <- SUM / N / 2
  
  print(paste("Generation =", i, sep = " "))
}

  
# plotting figures - this code will plot the output from the generations above

par(mfrow=c(2,1)) 
par(mar=c(4.5,4.1,1.1,1.1))
# blue = cooperators
points(output[,1], output[,3], type = "l",lwd=2, col="blue")
    ## there is still an error in the code here; the output is staying that plot.new has not yet been
    ## called, what are some of the ways that this can be fixed? (see document)
plot(output[,1], output[,2], type = "l",lwd=2, col="blue", xlab = "generation", ylab = "frequency", yline = " XXXX ")
# red = defectors
points(output[,1], output[,3], type = "l",lwd=2, col="red")
plot(output[,1], output[,4], type = "l",lwd=2, col="black", xlab = "generation", ylab = "average payoff")
abline(h = 0, lty = 3)
abline(h = (b), lty = 3, col= "green")
abline(h = (-c), lty = 3, col="red")
abline(h = (b-c), lty = 3, col="blue")


