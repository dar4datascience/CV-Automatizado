
library(pacman)
p_load(here,
       fs,
       glue,
       pagedown,
       rmarkdown,
       googlesheets4)

source("CV_printing_functions.R")
here::i_am("render_cv.R")

# Profiles
business_intelligence <- "https://docs.google.com/spreadsheets/d/1tOuqM4UL5oN-gUaP6bO1mdf52WTuKBgTYqxk7IJ25s4/edit?usp=sharing"

#gs4_auth()

cv_data <- create_CV_object(
  data_location = business_intelligence,
  cache_data = FALSE,
  sheet_is_publicly_readable = FALSE
)

readr::write_rds(cv_data, 'cached_positions.rds')
cache_data <- TRUE

print("hellow im here 1")

# Knit the HTML version
rmarkdown::render("CV_job.Rmd",
                  params = list(pdf_mode = FALSE, cache_data = cache_data),
                  output_file = 
                    here::here("docs","index.html")
)

print("hellow im here 2")
# Knit the PDF version to temporary html location
tmp_html_cv_loc <- fs::file_temp(ext = ".html")
rmarkdown::render("CV_job.Rmd",
                  params = list(pdf_mode = TRUE, cache_data = cache_data),
                  output_file = tmp_html_cv_loc)
print("hellow im here 3")
# Convert to PDF using Pagedown
pagedown::chrome_print(input = tmp_html_cv_loc,
                       output = "aketzali_natividad_martinez.pdf")
print("hellow im here 4")