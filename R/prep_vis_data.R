library(tidyverse)
library(glue)
library(janitor)





# Create dataset for vis chapter

abs_url <- "https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&employee%20income%20by%20occupation%20and%20sex%202010-11%20to%202015-16.002.xls&6524.0.55.002&Data%20Cubes&0EA1D11D25DDC473CA2582B000172727&0&2011-2016&19.06.2018&Latest"

file <- "data/abs.xls"

download.file(abs_url, destfile = file)

x_rename <- function(x, y) str_replace_all(x, "x", y)

read_abs_file <- function(.sheet, .rows) {
  
base <- readxl::read_excel(file, sheet = .sheet, range = glue("A8:D{.rows}")) %>% 
  clean_names()

.varname <- "persons."
persons <- readxl::read_excel(file, sheet = .sheet, range = glue("E8:J{.rows}")) %>% 
  clean_names() %>% 
  rename_at(vars(starts_with("x")), funs(x_rename(., .varname)))

.varname <- "median."
median <- readxl::read_excel(file, sheet = .sheet, range = glue("K8:P{.rows}")) %>% 
  clean_names() %>% 
  rename_at(vars(starts_with("x")), funs(x_rename(., .varname)))


.varname <- "average."
average <- readxl::read_excel(file, sheet = .sheet, range = glue("Q8:V{.rows}")) %>% 
  clean_names() %>% 
  rename_at(vars(starts_with("x")), funs(x_rename(., .varname)))


base %>% 
  bind_cols(persons) %>% 
  bind_cols(median) %>% 
  bind_cols(average) %>% 
  gather("key", "value", -sa3:-sex) %>% 
  separate(key, c("type", "year")) %>% 
  spread(type, value) %>% 
  rename(median_income = median,
         average_income = average) %>% 
  mutate(median_income = as.double(median_income),
         average_income = as.double(average_income),
         persons = as.double(persons))

}


out <- bind_rows(read_abs_file(5, 4382),
                 read_abs_file(6, 4058))

occs <- out$occupation %>% unique()
occs_short <- c(
  "Admin",
  "Service",
  "Labourer",
  "Driver",
  "Manager",
  "Professional",
  "Sales",
  "Trades",
  "Total"
)

out <- out %>% 
  mutate(occ_short = case_when(
    occupation == occs[1] ~ occs_short[1],
    occupation == occs[2] ~ occs_short[2],
    occupation == occs[3] ~ occs_short[3],
    occupation == occs[4] ~ occs_short[4],
    occupation == occs[5] ~ occs_short[5],
    occupation == occs[6] ~ occs_short[6],
    occupation == occs[7] ~ occs_short[7],
    occupation == occs[8] ~ occs_short[8],
    occupation == occs[9] ~ occs_short[9]))

# Get state information
sa3_info <- absmapsdata::sa32016 %>% 
  sf::st_drop_geometry() %>% 
  select(sa3 = sa3_code_2016,
         sa3_name = sa3_name_2016,
         sa4_name = sa4_name_2016,
         gcc_name = gcc_name_2016,
         state = state_name_2016,
         sa3_sqkm = areasqkm_2016) %>% 
  mutate(state = strayr::strayr(state),
         sa3 = as.double(sa3))



out <- out %>% 
  left_join(sa3_info) %>% 
  select(sa3, sa3_name, sa3_sqkm, 
         sa4_name, gcc_name, 
         occupation, occ_short,
         sex, year, 
         median_income, 
         average_income, 
         workers = persons)

write_csv(out, "data/sa3_income.csv")
