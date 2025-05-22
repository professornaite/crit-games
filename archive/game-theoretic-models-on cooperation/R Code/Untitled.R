
# population size
N = 1000

# mutation rate
mutation.rate = 0.005

# Set the payoffs; b is often used for 'benefit' of cooperation; c for 'cost' of cooperation
b <- 1 
c <- 0

# visualise payoffs; column names labeled "C" for cooperate and "D" for defect
x <- c(paste(b-c, b-c, sep = ", "), paste(-c, b, sep = ", ")) 
y <- c(paste(b, -c, sep = ", "), paste(0, 0, sep = ", "))
df <- data.frame(x,y)
colnames(df) <- c("C", "D")
rownames(df) <- colnames(df) 
df

start <- c(1, -1)
prob <- c(0.30, 0.70)
population <- sample(start, N, replace = TRUE, prob = prob)
length(population[population==1]) / length(population)
length(population[population==-1]) / length(population)

