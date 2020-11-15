#if defined _bash_included
	#endinput
#endif
#define _bash_included

/**
 * Called when bash logs a cheat detection/indicator.
 *
 * @param client					Client index.
 * @param buffer					Log content.
 * @noreturn						
 */
forward void Bash_OnDetection(int client, char[] buffer);