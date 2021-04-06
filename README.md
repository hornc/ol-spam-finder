# DEPRECATED
This tool is no longer maintained. The regex based blocking from this tool has now been incorporated into the [Open Library](https://github.com/internetarchive/openlibrary) admin interface properly.


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


## License
ol-spam-finder (DEPRECATED)
Copyright © 2015-2016 Charles Horn.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
[GNU Affero General Public License](COPYING) for more details.
