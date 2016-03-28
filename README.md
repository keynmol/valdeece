# valdeece

**Very** simple runtime data structure validation. Read it as "val deese" (nuts)

This is work in progress, of course, very raw, unstable and outright dangerous. I will try to keep evolving this as I go along and use it in my real code.

Have you every thought that half of R users' problems could be solved by adding at least soft type annotations?..

## why?

This came to me after two hours of debugging a complicated Shiny app where one of the methods was receiving a data frame rather than an integer vector it expected. So I took it a bit further.

## how?

Suppose you're writing a function that summarises average number of users per page only using long visits for selected users. You expect interactions data to be a data frame like this one:

```
Source: local data frame [10 x 3]

   UserId                                              URL  Long
    (int)                                            (chr) (lgl)
1      17          http://www.other-website.com/index.html FALSE
2       7          http://www.other-website.com/index.html  TRUE
3      20        http://www.other-website.com/profile.html FALSE
4      19 http://www.other-website.com/shopping/cart.html  FALSE
5      17 http://www.other-website.com/shopping/cart.html  FALSE
6       9                http://www.website.com/index.html FALSE
7       8                http://www.website.com/index.html FALSE
8       8                http://www.website.com/index.html  TRUE
9      11 http://www.other-website.com/shopping/cart.html   TRUE
10      4          http://www.other-website.com/index.html FALSE
```

You would write your function like this:

```R
average_long_visits <- function(interactions, selected_users) {
    # validations
    is_data_frame(interactions,
                    UserId = numeric_vector,
                    URL = string_vector,
                    Long = logical_vector
    ) %>%
    is_numeric_vector(selected_users, non_empty=T) %>%
    is_valid

    # safe computation
    interactions %>% 
        filter(UserId %in% selected_users) %>%
        filter(Long) %>%
        count(UserId, URL) %>%
        group_by(URL) %>%
        summarise(AverageUsers = mean(n))

}
```
Now we can make sure that the data is being validated:

```
> average_long_visits(interactions, 11)
Source: local data frame [1 x 2]

                                         URL AverageUsers
                                       (chr)        (dbl)
1 http://www.website.com//shopping/cart.html            1

> average_long_visits("asd", "hello")
Error in validate(validator$checks) :
  Valdeece failed to validate your input:
     Expected interactions to be a data frame
     Expected selected_users to be a vector of numeric

> average_long_visits(data_frame(UserId = factor(1), URL=F, Long="all wrong"), 1)
Error in validate(validator$checks) :
  Valdeece failed to validate your input:
     Expected interactions$UserId to be a vector of numeric
     Expected interactions$URL to be a vector of strings
     Expected interactions$Long to be a vector of logicals
```

**N.B.: it's not trivial to get the names of values right (depending on the frame they were called from), so it's very unpredictable. But at least it will blow up at the right moment with a semi-decent message. Semi-valdeecent. Fuck yeah**

## and?

Just read tests and drop me an email at `keynmol [at] gmail.com` if you got questions or suggestions.