#if defined _bash_included
	#endinput
#endif
#define _bash_included

/**
 * Called when BASH logs a cheat detection/indicator.
 *
 * @param client        Client index.
 * @param buffer        Log content.
 * @noreturn
 */
forward void Bash_OnDetection(int client, char[] buffer);

/**
 * Called when BASH bans a client.
 *
 * @param client        Client index.
 * @noreturn
 */
forward void Bash_OnClientBanned(int client);

public SharedPlugin __pl_bash =
{
	name = "shavit-bash2",
	file = "shavit-bash2.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};
