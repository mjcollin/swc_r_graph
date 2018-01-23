# install.packages("RSQLite")
library(RSQLite)

con <- dbConnect(drv=SQLite(),
                 dbname="data/survey.db")

query <- dbSendQuery(con,
                     "SELECT * FROM Survey JOIN Visited
                     ON Survey.taken = Visited.id")

readings <- dbFetch(query)

dbClearResult(query)
dbDisconnect(con)

library(dplyr)

sal <- readings %>%
  select(dated, site, quant, reading) %>%
  filter(quant=='sal')

sal <- na.omit(sal)

# 
sal <- sal %>%
  mutate(cor_reading = 
           ifelse(reading > 1, reading/100, reading)
         )


sal$dated <- as.Date(sal$dated)

library(ggplot2)

ggplot(data=sal,
       aes(x=dated, y=cor_reading, by=site, color=site)) + 
       geom_line() + 
       geom_point()

ggsave("output/sal_graph.jpg", device="jpg")



