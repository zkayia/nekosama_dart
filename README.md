
# nekosama_dart

Unofficial dart api for neko-sama.fr.

Package                                   |Version
---                                       |:---:
[nekosama](/packages/nekosama/)           |2.0.0
[nekosama_hive](/packages/nekosama_hive/) |2.0.0


## Which one to use ?

[nekosama](/packages/nekosama/) is the base package with all the methods needed to interract with the website.

[nekosama_hive](/packages/nekosama_hive/) is a extension of [nekosama](/packages/nekosama/) with a search database using [Hive](https://github.com/hivedb/hive).
Whereas the base package only allows fetching the database as a whole, leaving the user to implement seaching/sorting, this extension handles storing and querying the database.
Be aware that this package is very unefficient and quite slow.
