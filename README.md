# BASH 2.0

## Commands

```
bash2_stats - Show strafe stats
bash2_admin - toggle admin mode, lets you enable/disable printing of bash logs into the chat.
bash2_test  - trigger a test message so you can know if webhooks are working :)
```

## ConVars

### shavit-bash.sp

```
bash_antinull - lets you disable or enable null kicking
bash_banlength - lets you set banlength
bash_autoban - disable/enable automatic banning.
bash_persistent_data - Saves and reload strafe stats on player rejoin.
```

### shavit-bash-discord.sp

```
bash_discord_webhook - The url for the Discord webhook.
bash_discord_only_bans - If enabled, only bans will be sent to Discord.
```

## Depencenies

* [REST in Pawn](https://forums.alliedmods.net/showthread.php?t=298024) (only needed for shavit-bash-discord.sp)

## Anticheat bypass

If you are using bhoptimer, you can add "bash_bypass" to a styles special string to disable detection for this style.


![Bash2.0 Discord Demo](https://i.imgur.com/lrvCf1F.png)
