# install the required libraries

install.packages("dplyr")
install.packages("dummies")
install.packages("tidyr")
install.packages("xlsx")

# Load the installed libraries for use

library(dplyr)
library(tidyr)
library(xlsx)
library(dummies)

# Read the Refine.xlsx file from system.

df <- read.xlsx("refine.xlsx", 1)  # read xlsx file into temp varibale df.

# Write xlsx file to csv
write.csv(df, file = "refine_orginal.csv")

# 0: Load the data in RStudio
# 
# Save the data set as a CSV file called refine_original.csv and load it in RStudio into a data frame.

# Load the CSV file for use

refinedata <- read.csv("refine_orginal.csv")

# remove the Sr.no column ( X )  from the dataframe

refinedata <- subset(refinedata, select = -c(X))

#____________________________________________________________________________________________________________________________

# 1: Clean up brand names
# 
# Clean up the 'company' column so all of the misspellings of the brand names are standardized. 
# For example, you can transform the values in the column to be: philips, akzo, van houten and unilever (all lowercase)
# 

refinedata$company <- tolower(refinedata$company) # Convert to lower case

#Transforming all the comapny names to suggestions
refinedata$company <- gsub(pattern = "phillips", replacement = "philips", refinedata$company)
refinedata$company <- gsub(pattern = "phlips|fillips|phllips|phillps|", replacement = "philips", refinedata$company)
refinedata$company <- gsub(pattern = "akzo|akz0|ak zo", replacement = "akzo", refinedata$company)
refinedata$company <- gsub(pattern = "unilver|unilever", replacement = "unilever", refinedata$company)

#___________________________________________________________________________________________________________________________
# 2: Separate product code and number
# 
# Separate the product code and product number into separate columns i.e. add two new columns called product_code and product_number, containing the product code and number respectively

refinedata <- separate(refinedata, Product.code...number., c("product_code", "product_number"), sep = "-")

#___________________________________________________________________________________________________________________________
# 3: Add product categories
# 
# You learn that the product codes actually represent the following product categories:
#   
# p = Smartphone
# 
# v = TV
# 
# x = Laptop
# 
# q = Tablet
# 
# In order to make the data more readable, add a column with the product category for each record

refinedata$product_categories <- sub(pattern = "p", replacement = "Smartphone", refinedata$product_categories)
refinedata$product_categories <- sub(pattern = "v", replacement = "TV", refinedata$product_categories)
refinedata$product_categories <- sub(pattern = "x", replacement = "Laptop", refinedata$product_categories)
refinedata$product_categories <- sub(pattern = "q", replacement = "Tablet", refinedata$product_categories)

# ________________________________________________________________________________________________________________
# 4: Add full address for geocoding
# 
# You'd like to view the customer information on a map. In order to do that, the addresses need to be in a 
# form that can be easily geocoded. Create a new column full_address that 
# concatenates the three address fields (address, city, country), separated by commas.

refinedata <- unite(refinedata, "full_address", c("address","city","country"), sep = ",")


# 5: Create dummy variables for company and product category
# 
# Both the company name and product category are categorical variables i.e. they take only a fixed set of values. In order to use them in further analysis you need to create dummy variables. Create dummy binary variables for each of them with the prefix company_ and product_ i.e.,
# 
# Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever.
# 
# Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet.

refinedata.dummy_pro <- as.data.frame(dummy(refinedata$product_categories, sep = "_"))
refinedata.dummy_company <- as.data.frame(dummy(refinedata$company, sep = "_"))
refinedata <- cbind(refinedata, refinedata.dummy_company, refinedata.dummy_pro)

refinedata

# 
# 6: Submit the project on Github
# 
# Include your code, the original data as a CSV file refine_original.csv, and the cleaned up data as a CSV file called refine_clean.csv.

write.csv(refinedata, file = "refine_clean.csv")


