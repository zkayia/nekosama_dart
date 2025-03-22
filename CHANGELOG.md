
# 3.0.0
Too much stuff

# 2.4.0

### Features
- new getVideoUrls method to fetch all video players urls
- added website infos to NSHome and getHome

### Fixes
- fixed the NSSources and source db url being off
- fixed the fromString factory of enums not taking into account some values
- fixed default value for Uri parsing when the initial value was invalid

### Miscellaneous
- deprecated getVideoUrl in favour of getVideoUrls
- added code metrics
- switched to space indent in nekosama_hive

# 2.3.1

### Fixes
- avoid using NekoSamaExceptions as the initial exception to prevent chaining

### Miscellaneous
- added a package comparison in the global readme
- fixed a type in nekosama_hive readme

# 2.3.0

### Features
- NekoSamaExceptions now provide the initial exception

# 2.2.1

### Fixes
- added missing exports in nekosama_hive

### Miscellaneous
- renamed NSNewEpisode file to match class name
- moved NSSearchDbStats to nekosama_hive (unused in nekosama)

# 2.2.0

### Features
- added new genres: battle royale, cyberpunk, isekai, mafia, magic & military

# 2.1.0

### Features
- added asList and asString getters to NSTitles

### Miscellaneous
- centralized changelogs to nekosama's

# 2.0.0

- migrated the Hive search implementation into nekosama_hive
- made the api not bound to a source, source is now given as a parameter in methods that need it

### Features
- added getSearchDb & getRawSearchDb search db fetch methods
- readded getEpisode method with a force option
- added api dispose method


# 1.0.0

Initial version.
