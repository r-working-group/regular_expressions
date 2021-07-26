#### Resources -----------------------------------------------
# The official stringr guide to how it handles regular expressions
https://stringr.tidyverse.org/articles/regular-expressions.html

# Interactive testing for regular expressions
https://regexr.com/
  
# General reference for all regex operators
http://rexegg.com/regex-quickstart.html

# The most basic functions!
# grep() finds indices in a character vector that have strings that match a pattern
# grepl() tells you whether each index in a character vector matches a pattern, TRUE/FALSE
# gsub() replaces the part of a string that matches a pattern with another string
# stringr::str_extract() pulls out the first part of a string that matches a pattern
# stringr::str_split() splits a character string into a character vector at points that match a pattern

#### EXAMPLE ONE -----------------------------------------------
text1 <- "hellohello666"
text2 <- "hello hello 666"

## Basic regex
grepl(x = text1,
      pattern = "hello")
grepl(x = text1,
      pattern = "hello hello")
grepl(x = text2,
      pattern = "hello hello")


## Multiples
# Zero or more
stringr::str_extract(string = text1,
                     pattern = "(hello)*")
# One or more
stringr::str_extract(string = text1,
                     pattern = "(hello)+")
# Zero or one
stringr::str_extract(string = text1,
                     pattern = "(hello)?")

## Starts and ends
# Starts with
stringr::str_extract(string = text1,
                     pattern = "^hello")
# Ends with
stringr::str_extract(string = text1,
                     pattern = "hello$")

## Wildcards
# "Word" characters (alphanumerics)
stringr::str_extract(string = text1,
                     pattern = "\\w")
stringr::str_extract(string = text1,
                     pattern = "\\W")

stringr::str_extract(string = text2,
                     pattern = "\\w")
stringr::str_extract(string = text2,
                     pattern = "\\W")

# Digits
stringr::str_extract(string = text1,
                     pattern = "\\d")
stringr::str_extract(string = text1,
                     pattern = "\\D")

# Spaces
stringr::str_extract(string = text1,
                     pattern = "\\s")
stringr::str_extract(string = text2,
                     pattern = "\\s")

# Anything
stringr::str_extract(string = text1,
                     pattern = ".")
stringr::str_extract(string = text2,
                     pattern = ".")

# Any of
grepl(x = c("aesthetic", "effervescent", "irredeemable", "opulent", "unctuous", "pariah"),
      pattern = "^[aeiou]")

## Groupings
grepl(x = c("aeiou: vowels", "a, e, i, o, u: vowels", "vowels: aeiou"),
      pattern = "(aeiou)")

grepl(x = c("aeiouaeiou", "aeiou", "aeiou aeiou"),
      pattern = "(aeiou){2}")

grepl(x = c("aeiouaeiou", "aeiouu"),
      pattern = "aeiou{2}")


#### EXAMPLE TWO -----------------------------------------------
# The first stanza of "Jabberwocky" by Lewis Carroll
poem <- c("’Twas brillig, and the slithy toves
            Did gyre and gimble in the wabe:
            All mimsy were the borogoves,
            And the mome raths outgrabe.")

# That's just a block of text, but we'd like each line to be its own string
poem_vector <- stringr::str_split(string = poem,
                                  # The way a line break is represented is with "\n"
                                  # But "\" is an escape character, so we need to escape
                                  # the escape character, hence "\\n"
                                  pattern = "\\n",
                                  simplify = TRUE)

# trimws() trims whitespace from the ends of strings
# It can be applied to a vector to act on each string in the vector
poem_vector <- trimws(x = poem_vector)

# grepl() returns a logical output.
# If you use it on a single string, it just returns TRUE/FALSE
# If you use it on a character vector, it returns TRUE/FALSE for each index in the vector
begins_alphabetic <- grepl(x = poem_vector,
                           pattern = "^\\w",
                           ignore.case = TRUE)

# grep() returns the indices where the pattern was matched
indices_ending_nonalphabetic <- grep(x = poem_vector,
                                     pattern = "\\W$",
                                     ignore.case = TRUE)

# Replace "and" with "&"
poem_vector <- gsub(x = poem_vector,
                    pattern = "and",
                    replacement = "&")

# For each line, get everything before the first comma in that line
before_commas <-stringr::str_extract(string = poem_vector,
                                     # "^" means start of string
                                     # "." is a wildcard meaning ANY character
                                     # "*" means 0 or more of whatever preceded it
                                     # "," means comma
                                     pattern = "^.*,")

# But what if we don't want the comma included in the results?
before_commas <- gsub(x = before_commas,
                      pattern = ",",
                      replacement = "")

# Alternatively, we can get fancy with a lookaround regex
# Note that base R functions like gsub() and grep() don't support this
# This will match any number of characters, but only if they're followed by a comma
before_commas_pattern <- ".*(?=,)"
before_commas_alt <- stringr::str_extract(string = poem_vector,
                                          pattern = before_commas_pattern)

#### EXAMPLE THREE -----------------------------------------------
# Dates in a machine-unfriendly format
dates <- c("April 20, 2021 16:20",
           "October 30, '86 12:00")

# Month extraction
# Pattern is looking at the start of the string with "^"
# then for one or more alphanumeric characters "\w+"
# An alternative way to look for any alphabetic character is [A-z]
month_pattern <- "^\\w+"
months <- stringr::str_extract(string = dates,
                               pattern = month_pattern)

# Day extraction
# Pattern to get at the days
day_pattern <- "\\d+"
# Note that this is the same as "[0-9]+"
# By default, regex stops after it finds the first match in a string
days <- stringr::str_extract(string = dates,
                             pattern = day_pattern)

# As a note:
# str_extract_all() will find all the instances of pattern matches, not just the first
numbers <- stringr::str_extract_all(string = dates,
                                    pattern = day_pattern)

# Pattern to get at years
# Look ahead for one or two digits followed by a space and possibly an apostrophe with (?<=\\d{1,2}, [']?)
# Look behind for a space and two digits with (?=[ ]\\d{2})
# Extract the one or more digits between those lookarounds
years_pattern <- "(?<=\\d{1,2}, [']?)\\d{2,4}(?= \\d{2})"
years <- stringr::str_extract(string = dates,
                              pattern = years_pattern)

# Pattern for hours
# Get the two digits that are followed immediately by a colon
hours_pattern <- "\\d{2}(?=:)"
hours <- stringr::str_extract(string = dates,
                              pattern = hours_pattern)

# Pattern for minutes
# Get the two digits that immediately follow a colon
minutes_pattern <- "(?<=:)\\d{2}"
minutes <- stringr::str_extract(string = dates,
                                pattern = minutes_pattern)

## ALTERNATIVELY
date_split <- stringr::str_split(string = dates[1],
                                 pattern = "\\s",
                                 simplify = TRUE)
# Month
stringr::str_extract(string = date_split[1],
                     pattern = "\\w+")
# Day
stringr::str_extract(string = date_split[2],
                     pattern = "\\d+")
# Year
stringr::str_extract(string = date_split[3],
                     pattern = "\\d+")


time_split <- stringr::str_split(date_split[4],
                                 pattern = ":",
                                 simplify = TRUE)
# Hour
time_split[1]
# Minutes
time_split[2]

#### EXAMPLE FOUR ####
# Extracting latitude and longitude from strings
library(dplyr)

site_ids <- c("Wooton", "Ranch HQ", "Eugene", "Tunis")
coordinates <- c("32.2803, -106.7570",
                 "32.616, -106.741",
                 "44.0458, -123.1499",
                 "36.72, 10.12")

locations <- data.frame(site_id = site_ids,
                        coords = coordinates,
                        stringsAsFactors = FALSE)

locations %>% mutate(lat1 = stringr::str_extract(string = coords,
                                                 # At the start of the string, look for one or more digits
                                                 # followed by a period then one or more digits
                                                 pattern = "^\\d+\\.\\d+"),
                     long1 = stringr::str_extract(string = coords,
                                                  # Look for a string that ends with a comma and a space
                                                  # possibly followed by a - then one or more digits, a period,
                                                  # and finally one or more digits. Don't extract the ", ".
                                                  # TECHNICALLY only needs either the lookaround or the $
                                                  # but it's safest to have both
                                                  pattern = "(?<=, )-?\\d+\\.\\d+$"),
                     lat2 = gsub(x = coords,
                                 # Look for a string that ends in a comma followed by one or more characters
                                 pattern = ",.*$",
                                 replacement = ""),
                     long2 = gsub(x = coords,
                                  # Look for a string that starts with one or more characters followed by a
                                  # comma and space
                                  pattern = "^.+, ",
                                  replacement = ""))
