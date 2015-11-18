This is a web-UI for a script which attempts to identify recently added [OpenLibrary](https://openlibrary.org/) spam entries based on the pattern of a new user who adds many works soon after creation. Most legitimate new users in the system do not add new works immediately.

The main script that does the checking is [here](lib/spam_finder.rb), the rest is just a light UI to display the day in calendar form and generate links to the OL admin interface to delete the spam account, which in turn should delete all the associated works.

There are a number of rake tasks which can be run manually or scheduled to update the database to list all new users who have added works, and identify the ones that look like spam:
```
rake ol_spam:date[date]      # Check for spam on a particular date,  [YYYY-MM-DD]
rake ol_spam:month[month]    # Check for spam on a particular month, [YYYY-MM]
rake ol_spam:yesterday       # Check OL for spam accounts created YESTERDAY
rake ol_spam:current_month   # Check OL for spam accounts for all days in the CURRENT month
rake ol_spam:previous_month  # Check OL for spam accounts for all days in the PREVIOUS month
```
