#include <sourcemod>

#include <bash2>
#include <ripext>

#pragma newdecls required
#pragma semicolon 1

ConVar gCV_Webhook;
ConVar gCV_OnlyBans;
ConVar gCV_UseEmbeds;

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
	gCV_OnlyBans = CreateConVar("bash_discord_only_bans", "0", "If enabled, only bans will be sent.", _, true, 0.0, true, 1.0);
	gCV_UseEmbeds = CreateConVar("bash_discord_use_embeds", "1", "If enabled, embed messages will be sent.", _, true, 0.0, true, 1.0);
	AutoExecConfig(true, "bash-discord", "sourcemod");
}

public void Bash_OnDetection(int client, char[] buffer)
{
	if (gCV_OnlyBans.BoolValue)
	{
		return;
	}

	if (gCV_UseEmbeds.BoolValue)
	{
		FormatEmbedMessage(client, buffer);
	}
	else
	{
		FormatMessage(client, buffer);
	}
}

public void Bash_OnClientBanned(int client)
{
	if (gCV_UseEmbeds.BoolValue)
	{
		FormatEmbedMessage(client, "Banned for cheating.");
	}
	else
	{
		FormatMessage(client, "Banned for cheating.");
	}
}

void FormatEmbedMessage(int client, char[] buffer)
{
	char hostname[128];
	FindConVar("hostname").GetString(hostname, sizeof(hostname));

	char steamId[32];
	GetClientAuthId(client, AuthId_SteamID64, steamId, sizeof(steamId));

	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	SanitizeName(name);

	char player[512];
	Format(player, sizeof(player), "[%s](http://www.steamcommunity.com/profiles/%s)", name, steamId);

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

void FormatMessage(int client, char[] buffer)
{
	char hostname[128];
	FindConVar("hostname").GetString(hostname, sizeof(hostname));

	char steamId[32];
	GetClientAuthId(client, AuthId_SteamID64, steamId, sizeof(steamId));

	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	SanitizeName(name);

	char content[1024];
	Format(content, sizeof(content), "[%s](http://www.steamcommunity.com/profiles/%s) %s", name, steamId, buffer);

	// Suppress Discord mentions and embeds.
	// https://discord.com/developers/docs/resources/channel#allowed-mentions-object
	// https://discord.com/developers/docs/resources/channel#message-object-message-flags
	JSONArray parse = new JSONArray();
	JSONObject allowedMentions = new JSONObject();
	allowedMentions.Set("parse", parse);

	JSONObject json = new JSONObject();
	json.SetString("username", hostname);
	json.SetString("content", content);
	json.Set("allowed_mentions", allowedMentions);
	json.SetInt("flags", 4);

	SendMessage(json);

	delete parse;
	delete allowedMentions;
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

void SanitizeName(char[] name)
{
	ReplaceString(name, MAX_NAME_LENGTH, "(", "", false);
	ReplaceString(name, MAX_NAME_LENGTH, ")", "", false);
	ReplaceString(name, MAX_NAME_LENGTH, "]", "", false);
	ReplaceString(name, MAX_NAME_LENGTH, "[", "", false);
}
