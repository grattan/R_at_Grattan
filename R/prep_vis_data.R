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


prep <- bind_rows(read_abs_file(5, 4382),
                 read_abs_file(6, 4058),
                 read_abs_file(7, 1250))

occs <- unique(prep$occupation)

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

dat <- prep %>% 
  mutate(occ_short = case_when(
    occupation == occs[1] ~ occs_short[1],
    occupation == occs[2] ~ occs_short[2],
    occupation == occs[3] ~ occs_short[3],
    occupation == occs[4] ~ occs_short[4],
    occupation == occs[5] ~ occs_short[5],
    occupation == occs[6] ~ occs_short[6],
    occupation == occs[7] ~ occs_short[7],
    occupation == occs[8] ~ occs_short[8],
    occupation == occs[9] ~ occs_short[9])) %>% 
  filter(occupation != "Total earners")


# Get income percentiles by SA3
perc <- dat %>% 
  mutate(income = persons * average_income) %>% 
  group_by(year, sa3) %>% 
  summarise(persons = sum(persons, na.rm = T),
            total_income = sum(income, na.rm = T),
            average_income = total_income  / persons) %>% 
  filter(persons > 0) %>% 
  mutate(income_percentile = grattan::weighted_ntile(average_income, persons, 100)) %>% 
  select(year, sa3, 
         sa3_income_percentile = income_percentile)


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


# Combine and get 
out <- dat %>% 
  left_join(perc) %>% 
  left_join(sa3_info) %>% 
  mutate(gender = if_else(sex == "Females", "Women", "Men"),
         year = as.double(year) + 1,
         total_income = average_income * persons,
         prof = if_else(occupation %in% c("Professionals", "Managers"),
                        "Professional",
                        "Non-professional"),
         prof = factor(prof, levels = c("Professional", "Non-professional"))) %>% 
  select(sa3, sa3_name, sa3_sqkm, 
         sa3_income_percentile,
         sa4_name, gcc_name, state,
         occupation, occ_short, prof,
         gender, year, 
         median_income, 
         average_income, 
         total_income,
         workers = persons) %>% 
  filter(!is.na(workers))


write_csv(out, "data/sa3_income.csv")

