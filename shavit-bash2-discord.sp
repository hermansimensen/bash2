#include <sourcemod>

#include <bash2>
#include <ripext>

#pragma newdecls required
#pragma semicolon 1

ConVar gCV_Webhook;
ConVar gCV_OnlyBans;

public Plugin myinfo =
{
	name = "[BASH] Discord",
	author = "Eric",
	description = "",
	version = "1.0.0",
	url = "https://github.com/hermansimensen/bash2"
};

public void OnPluginStart()
{
	gCV_Webhook = CreateConVar("bash_discord_webhook", "", "Discord webhook.", FCVAR_PROTECTED);
	gCV_OnlyBans = CreateConVar("bash_discord_only_bans", "0", "If enabled, only bans will be sent to Discord.", _, true, 0.0, true, 1.0);
	AutoExecConfig(true, "bash-discord", "sourcemod");
}

public void Bash_OnDetection(int client, char[] buffer)
{
	if (gCV_OnlyBans.BoolValue)
	{
		return;
	}

	FormatMessage(client, buffer);
}

public void BASH_OnClientBanned(int client)
{
	FormatMessage(client, "Banned for cheating.");
}

void FormatMessage(int client, char[] buffer)
{
	char hostname[128];
	FindConVar("hostname").GetString(hostname, sizeof(hostname));

	char steamId[32];
	GetClientAuthId(client, AuthId_SteamID64, steamId, sizeof(steamId));

	char player[512];
	Format(player, sizeof(player), "[%N](http://www.steamcommunity.com/profiles/%s)", client, steamId);

	// https://discord.com/developers/docs/resources/channel#embed-object
	// https://discord.com/developers/docs/resources/channel#embed-object-embed-field-structure
	// https://discord.com/developers/docs/resources/webhook#webhook-object-jsonform-params
	JSONObject playerField = new JSONObject();
	playerField.SetString("name", "Player");
	playerField.SetString("value", player);
	playerField.SetBool("inline", true);

	JSONObject eventField = new JSONObject();
	eventField.SetString("name", "Event");
	eventField.SetString("value", buffer);
	eventField.SetBool("inline", true);

	JSONArray fields = new JSONArray();
	fields.Push(playerField);
	fields.Push(eventField);

	JSONObject embed = new JSONObject();
	embed.SetString("title", hostname);
	embed.SetString("color", "16720418");
	embed.Set("fields", fields);

	JSONArray embeds = new JSONArray();
	embeds.Push(embed);

	JSONObject json = new JSONObject();
	json.SetString("username", "BASH 2.0");
	json.Set("embeds", embeds);

	SendMessage(json);

	delete playerField;
	delete eventField;
	delete fields;
	delete embed;
	delete embeds;
	delete json;
}

void SendMessage(JSONObject json)
{
	char webhook[256];
	gCV_Webhook.GetString(webhook, sizeof(webhook));

	if (webhook[0] == '\0')
	{
		LogError("Discord webhook is not set.");
		return;
	}

	HTTPRequest request = new HTTPRequest(webhook);
	request.Post(json, OnMessageSent);
}

public void OnMessageSent(HTTPResponse response, any value, const char[] error)
{
	if (response.Status != HTTPStatus_NoContent)
	{
		LogError("Failed to send message to Discord. Response status: %d.", response.Status);
	}
}
