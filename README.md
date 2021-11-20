# BASH 2.0

**Commands**
```
bash2_stats - Show strafe stats
bash2_admin - toggle admin mode, lets you enable/disable printing of bash logs into the chat.
bash2_test  - trigger a test message so you can know if webhooks are working :)
```


**Cvars**

```
bash_antinull - lets you disable or enable null kicking
bash_banlength - lets you set banlength
bash_autoban - disable/enable automatic banning. 
bash_discord - Enable/Disable discord logging
bash_discord_webhook - The url for the discord webhook.
bash_discord_only_bans - If enabled, only kicks and bans will be printed to the discord log. 
bash_persistent_data - Saves and reload strafe stats on player rejoin.
```

### Depencenies
Discord API (https://github.com/Deathknife/sourcemod-discord) + SteamWorks & SMJansson.

### Anticheat bypass
If you are using bhoptimer, you can add "bash_bypass" to a styles special string to disable detection for this style.


![Bash2.0 Discord Demo](https://i.imgur.com/lrvCf1F.png)
