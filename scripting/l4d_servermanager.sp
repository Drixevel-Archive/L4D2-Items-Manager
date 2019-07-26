//Pragma
#pragma semicolon 1
#pragma newdecls required

//Defines
#define PLUGIN_TAG "[Manager] "

//Includes
#include <sourcemod>
#include <sourcemod-misc>

//Globals
ConVar convar_Status;
StringMap g_WeaponAlias;

public Plugin myinfo =
{
	name = "[L4D/2] Server Manager",
	author = "Keith Warren (Drixevel)",
	description = "Allows for easy server management to spawn infected, items, events, etc.",
	version = "1.0.0",
	url = "https://www.github.com/drixevel"
};

public void OnPluginStart()
{
	convar_Status = CreateConVar("sm_servermanager_status", "1", "Status of the plugin.\n(1 = on, 0 = off)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	AutoExecConfig();

	RegAdminCmd("sm_item", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_items", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_giveitem", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_giveitems", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_weapon", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_weapons", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_give", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_giveweapon", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_giveweapons", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_melee", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_meleeweapons", Command_Items, ADMFLAG_SLAY);
	RegAdminCmd("sm_givemeleeweapons", Command_Items, ADMFLAG_SLAY);
	
	RegAdminCmd("sm_spawn", Command_SpawnInfected, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawninfected", Command_SpawnInfected, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawncommon", Command_SpawnCommon, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawnhunter", Command_SpawnHunter, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawnboomer", Command_SpawnBoomer, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawnsmoker", Command_SpawnSmoker, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawncharger", Command_SpawnCharger, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawnjockey", Command_SpawnJockey, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawnspitter", Command_SpawnSpitter, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawntank", Command_SpawnTank, ADMFLAG_SLAY);
	RegAdminCmd("sm_spawnwitch", Command_SpawnWitch, ADMFLAG_SLAY);
	
	RegAdminCmd("sm_panic", Command_ForcePanic, ADMFLAG_SLAY);
	RegAdminCmd("sm_panicevent", Command_ForcePanic, ADMFLAG_SLAY);
	RegAdminCmd("sm_forcepanic", Command_ForcePanic, ADMFLAG_SLAY);
	RegAdminCmd("sm_forcepanicevent", Command_ForcePanic, ADMFLAG_SLAY);
	
	RegAdminCmd("sm_difficulty", Command_SetDifficulty, ADMFLAG_SLAY);
	RegAdminCmd("sm_setdifficulty", Command_SetDifficulty, ADMFLAG_SLAY);
	
	g_WeaponAlias = new StringMap();
	
	//Primary Weapons
	g_WeaponAlias.SetString("ak47", "weapon_rifle_ak47");
	g_WeaponAlias.SetString("ak", "weapon_rifle_ak47");
	g_WeaponAlias.SetString("assaultrifle", "weapon_rifle");
	g_WeaponAlias.SetString("assault", "weapon_rifle");
	g_WeaponAlias.SetString("auto", "weapon_autoshotgun");
	g_WeaponAlias.SetString("autoshottie", "weapon_autoshotgun");
	g_WeaponAlias.SetString("shottie", "weapon_autoshotgun");
	g_WeaponAlias.SetString("awp", "weapon_sniper_awp");
	g_WeaponAlias.SetString("chrome", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("chromeshottie", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("chrome_shottie", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("chromepump", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("chrome_pump", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("pumpchrome", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("pump_chrome", "weapon_shotgun_chrome");
	g_WeaponAlias.SetString("launcher", "weapon_grenade_launcher");
	g_WeaponAlias.SetString("grenadelauncher", "weapon_grenade_launcher");
	g_WeaponAlias.SetString("grenader", "weapon_grenade_launcher");
	g_WeaponAlias.SetString("grenadier", "weapon_grenade_launcher");
	g_WeaponAlias.SetString("rifle", "weapon_hunting_rifle");
	g_WeaponAlias.SetString("hunting", "weapon_hunting_rifle");
	g_WeaponAlias.SetString("huntingrifle", "weapon_hunting_rifle");
	g_WeaponAlias.SetString("military", "weapon_sniper_military");
	g_WeaponAlias.SetString("militaryrifle", "weapon_sniper_military");
	g_WeaponAlias.SetString("autosniper", "weapon_sniper_military");
	g_WeaponAlias.SetString("pump", "weapon_pumpshotgun");
	g_WeaponAlias.SetString("pumpshottie", "weapon_pumpshotgun");
	g_WeaponAlias.SetString("rifledesert", "weapon_rifle_desert");
	g_WeaponAlias.SetString("desertrifle", "weapon_rifle_desert");
	g_WeaponAlias.SetString("desert_rifle", "weapon_rifle_desert");
	g_WeaponAlias.SetString("m60", "weapon_rifle_m60");
	g_WeaponAlias.SetString("scout", "weapon_sniper_scout");
	g_WeaponAlias.SetString("ssg552", "weapon_rifle_sg552");
	g_WeaponAlias.SetString("smg", "weapon_smg");
	g_WeaponAlias.SetString("mp5", "weapon_smg_mp5");
	g_WeaponAlias.SetString("mp5silenced", "weapon_smg_silenced");
	g_WeaponAlias.SetString("silencedmp5", "weapon_smg_silenced");
	g_WeaponAlias.SetString("spas", "weapon_shotgun_spas");
	
	//Secondary
	g_WeaponAlias.SetString("bat", "melee_baseball_bat");
	g_WeaponAlias.SetString("cricket", "melee_cricket_bat");
	g_WeaponAlias.SetString("hl3", "melee_crowbar");
	g_WeaponAlias.SetString("guitar", "melee_electric_guitar");
	g_WeaponAlias.SetString("axe", "melee_fireaxe");
	g_WeaponAlias.SetString("pan", "melee_frying_pan");
	g_WeaponAlias.SetString("club", "melee_golf_club");
	g_WeaponAlias.SetString("sword", "melee_katana");
	g_WeaponAlias.SetString("counterstrike", "melee_knife");
	g_WeaponAlias.SetString("cs", "melee_knife");
	g_WeaponAlias.SetString("dundee", "melee_machete");
	g_WeaponAlias.SetString("magnum", "weapon_pistol_magnum");
	g_WeaponAlias.SetString("stick", "melee_tonfa");
	g_WeaponAlias.SetString("shield", "melee_riotshield");
	
	//Items
	g_WeaponAlias.SetString("shot", "weapon_adrenaline");
	g_WeaponAlias.SetString("ammo", "weapon_ammo_spawn");
	g_WeaponAlias.SetString("ammunition", "weapon_ammo_spawn");
	g_WeaponAlias.SetString("defib", "weapon_defibrillator");
	g_WeaponAlias.SetString("defibuni", "weapon_defibrillator");
	g_WeaponAlias.SetString("explosive", "weapon_upgradepack_explosive");
	g_WeaponAlias.SetString("explosiverounds", "weapon_upgradepack_explosive");
	g_WeaponAlias.SetString("kit", "weapon_first_aid_kit");
	g_WeaponAlias.SetString("firstaid", "weapon_first_aid_kit");
	g_WeaponAlias.SetString("firstaidkit", "weapon_first_aid_kit");
	g_WeaponAlias.SetString("healthkit", "weapon_first_aid_kit");
	g_WeaponAlias.SetString("incendiary", "weapon_upgradepack_incendiary");
	g_WeaponAlias.SetString("incendiaryammo", "weapon_upgradepack_incendiary");
	g_WeaponAlias.SetString("molly", "weapon_molotov");
	g_WeaponAlias.SetString("pills", "weapon_pain_pills");
	g_WeaponAlias.SetString("painpills", "weapon_pain_pills");
	g_WeaponAlias.SetString("pipe", "weapon_pipe_bomb");
	g_WeaponAlias.SetString("pipebomb", "weapon_pipe_bomb");
	g_WeaponAlias.SetString("bile", "weapon_vomitjar");
	g_WeaponAlias.SetString("bilejar", "weapon_vomitjar");
	g_WeaponAlias.SetString("bilebomb", "weapon_vomitjar");
	g_WeaponAlias.SetString("jar", "weapon_vomitjar");
	
	//Carryables
	g_WeaponAlias.SetString("oxygen", "weapon_oxygentank");
	g_WeaponAlias.SetString("propane", "weapon_propanetank");
	g_WeaponAlias.SetString("cola", "weapon_cola_bottles");
	g_WeaponAlias.SetString("bottles", "weapon_cola_bottles");
	g_WeaponAlias.SetString("fireworks", "weapon_fireworkcrate");
	g_WeaponAlias.SetString("crate", "weapon_fireworkcrate");
	g_WeaponAlias.SetString("gas", "weapon_gascan");
	g_WeaponAlias.SetString("can", "weapon_gascan");
	g_WeaponAlias.SetString("keemstar", "weapon_gnome");	
	
	//HookEvent("item_pickup", Event_OnItemPickup);
}

public void OnMapStart()
{
	if (!convar_Status.BoolValue)
		return;

	//Some plugin by Silvers.
	PrecacheModel("models/weapons/melee/v_bat.mdl", true);
	PrecacheModel("models/weapons/melee/v_cricket_bat.mdl", true);
	PrecacheModel("models/weapons/melee/v_crowbar.mdl", true);
	PrecacheModel("models/weapons/melee/v_electric_guitar.mdl", true);
	PrecacheModel("models/weapons/melee/v_fireaxe.mdl", true);
	PrecacheModel("models/weapons/melee/v_frying_pan.mdl", true );
	PrecacheModel("models/weapons/melee/v_golfclub.mdl", true);
	PrecacheModel("models/weapons/melee/v_katana.mdl", true);
	PrecacheModel("models/weapons/melee/v_machete.mdl", true);
	PrecacheModel("models/weapons/melee/v_tonfa.mdl", true);

	PrecacheModel("models/weapons/melee/w_bat.mdl", true);
	PrecacheModel("models/weapons/melee/w_cricket_bat.mdl", true);
	PrecacheModel("models/weapons/melee/w_crowbar.mdl", true);
	PrecacheModel("models/weapons/melee/w_electric_guitar.mdl", true);
	PrecacheModel("models/weapons/melee/w_fireaxe.mdl", true);
	PrecacheModel("models/weapons/melee/w_frying_pan.mdl", true);
	PrecacheModel("models/weapons/melee/w_golfclub.mdl", true);
	PrecacheModel("models/weapons/melee/w_katana.mdl", true);
	PrecacheModel("models/weapons/melee/w_machete.mdl", true);
	PrecacheModel("models/weapons/melee/w_tonfa.mdl", true);

	PrecacheGeneric("scripts/melee/baseball_bat.txt", true);
	PrecacheGeneric("scripts/melee/cricket_bat.txt", true);
	PrecacheGeneric("scripts/melee/crowbar.txt", true);
	PrecacheGeneric("scripts/melee/electric_guitar.txt", true);
	PrecacheGeneric("scripts/melee/fireaxe.txt", true);
	PrecacheGeneric("scripts/melee/frying_pan.txt", true);
	PrecacheGeneric("scripts/melee/golfclub.txt", true);
	PrecacheGeneric("scripts/melee/katana.txt", true);
	PrecacheGeneric("scripts/melee/machete.txt", true);
	PrecacheGeneric("scripts/melee/tonfa.txt", true);
}

public Action Command_Items(int client, int args)
{
	if (!convar_Status.BoolValue)
		return Plugin_Handled;
	
	if (args > 1)
	{
		int target = GetCmdArgTarget(client, 1);
		
		if (IsClientServer(client) && (target < 1 || target > MaxClients))
		{
			ReplyToCommand(client, "%sYou must specify a valid target.", PLUGIN_TAG);
			return Plugin_Handled;
		}
		
		char sItem[32];
		GetCmdArg(2, sItem, sizeof(sItem));
		
		if (!g_WeaponAlias.GetString(sItem, sItem, sizeof(sItem)) && StrContains(sItem, "weapon_", false) != 0)
			Format(sItem, sizeof(sItem), "weapon_%s", sItem);
		
		int weapon;
		
		if (StrContains(sItem, "melee_") == 0)
		{
			weapon = CreateEntityByName("weapon_melee");

			if (IsValidEntity(weapon))
			{
				char sScript[64];
				strcopy(sScript, sizeof(sScript), sItem);
				
				ReplaceString(sScript, sizeof(sScript), "melee_", "");
				DispatchKeyValue(weapon, "melee_script_name", sScript);
				DispatchSpawn(weapon);
				
				EquipPlayerWeapon(target, weapon);
				
				if (client == target)
					ReplyToCommand(client, "%sMelee Weapon Given: %s", PLUGIN_TAG, sItem);
				else
					ReplyToCommand(target, "%sMelee Weapon Given by %N: %s", PLUGIN_TAG, client, sItem);
			}
		}
		else
		{
			weapon = GivePlayerItem(target, sItem);

			if (IsValidEntity(weapon))
			{
				EquipPlayerWeapon(target, weapon);
				
				int cheatsoff = GetCommandFlags("give");
				SetCommandFlags("give",cheatsoff & ~FCVAR_CHEAT);
				FakeClientCommand(client, "give ammo");
				SetCommandFlags("give",cheatsoff|FCVAR_CHEAT);
				
				if (client == target)
					ReplyToCommand(client, "%sItem/Weapon Given: %s", PLUGIN_TAG, sItem);
				else
					ReplyToCommand(target, "%sItem/Weapon Given by %N: %s", PLUGIN_TAG, client, sItem);
			}
		}
	}
	else if (args > 0)
	{
		char sItem[32];
		GetCmdArg(1, sItem, sizeof(sItem));
		
		if (!g_WeaponAlias.GetString(sItem, sItem, sizeof(sItem)) && StrContains(sItem, "weapon_", false) != 0)
			Format(sItem, sizeof(sItem), "weapon_%s", sItem);
		
		int weapon;
		
		if (StrContains(sItem, "melee_") == 0)
		{
			weapon = CreateEntityByName("weapon_melee");

			if (IsValidEntity(weapon))
			{
				char sScript[64];
				strcopy(sScript, sizeof(sScript), sItem);
				
				ReplaceString(sScript, sizeof(sScript), "melee_", "");
				DispatchKeyValue(weapon, "melee_script_name", sScript);
				DispatchSpawn(weapon);
				
				EquipPlayerWeapon(client, weapon);
				ReplyToCommand(client, "%sMelee Weapon Given: %s", PLUGIN_TAG, sItem);
			}
		}
		else
		{
			weapon = GivePlayerItem(client, sItem);

			if (IsValidEntity(weapon))
			{
				EquipPlayerWeapon(client, weapon);
				
				int cheatsoff = GetCommandFlags("give");
				SetCommandFlags("give",cheatsoff & ~FCVAR_CHEAT);
				FakeClientCommand(client, "give ammo");
				SetCommandFlags("give",cheatsoff|FCVAR_CHEAT);
				
				ReplyToCommand(client, "%sItem/Weapon Given: %s", PLUGIN_TAG, sItem);
			}
		}
	}
	else
	{
		if (IsClientServer(client))
		{
			ReplyToCommand(client, "%sThis commands menu is in-game only.", PLUGIN_TAG);
			return Plugin_Handled;
		}

		OpenCategoriesMenu(client);
	}

	return Plugin_Handled;
}

void OpenCategoriesMenu(int client)
{
	if (!convar_Status.BoolValue)
		return;

	Menu menu = new Menu(MenuHandler_Items);
	menu.SetTitle("Items Manager\n \nSelect a category:");

	menu.AddItem("primary", "Primary Weapons");
	menu.AddItem("secondary", "Secondary Weapons");
	menu.AddItem("items", "Items");
	menu.AddItem("carryables", "Carryables");

	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Items(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
				return;

			char sInfo[32];
			menu.GetItem(param2, sInfo, sizeof(sInfo));

			if (StrEqual(sInfo, "primary"))
				OpenPrimaryMenu(param1);
			else if (StrEqual(sInfo, "secondary"))
				OpenSecondaryMenu(param1);
			else if (StrEqual(sInfo, "items"))
				OpenItemsMenu(param1);
			else if (StrEqual(sInfo, "carryables"))
				OpenCarryablesMenu(param1);
		}
		case MenuAction_End:
			delete menu;
	}
}

void OpenPrimaryMenu(int client)
{
	if (!convar_Status.BoolValue)
		return;
	
	Menu menu = new Menu(MenuHandler_PickAnItem);
	menu.SetTitle("Items Manager\n \nManage a primary weapon:");

	menu.AddItem("weapon_rifle_ak47", "AK47");
	menu.AddItem("weapon_rifle", "Assault Rifle");
	menu.AddItem("weapon_autoshotgun", "Auto Shotgun");
	menu.AddItem("weapon_sniper_awp", "AWP");
	menu.AddItem("weapon_shotgun_chrome", "Chrome Shotgun");
	menu.AddItem("weapon_grenade_launcher", "Grenade Launcher");
	menu.AddItem("weapon_hunting_rifle", "Hunting Rifle");
	menu.AddItem("weapon_sniper_military", "Military Sniper");
	menu.AddItem("weapon_pumpshotgun", "Pump Shotgun");
	menu.AddItem("weapon_rifle_desert", "Rifle Desert");
	menu.AddItem("weapon_rifle_m60", "Rifle M60");
	menu.AddItem("weapon_sniper_scout", "Scout");
	menu.AddItem("weapon_rifle_sg552", "SG552");
	menu.AddItem("weapon_smg", "SMG");
	menu.AddItem("weapon_smg_mp5", "SMG MP5");
	menu.AddItem("weapon_smg_silenced", "SMG Silenced");
	menu.AddItem("weapon_shotgun_spas", "Spas Shotgun");

	PushMenuInt(menu, "type", 1);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

void OpenSecondaryMenu(int client)
{
	if (!convar_Status.BoolValue)
		return;

	Menu menu = new Menu(MenuHandler_PickAnItem);
	menu.SetTitle("Items Manager\n \nManage a secondary weapon:");

	menu.AddItem("melee_baseball_bat", "Baseball Bat");
	menu.AddItem("weapon_chainsaw", "Chainsaw");
	menu.AddItem("melee_cricket_bat", "Cricket Bat");
	menu.AddItem("melee_crowbar", "Crowbar");
	menu.AddItem("melee_electric_guitar", "Electric Guitar");
	menu.AddItem("melee_fireaxe", "Fire Axe");
	menu.AddItem("melee_frying_pan", "Frying Pan");
	menu.AddItem("melee_golf_club", "Golf Club");
	menu.AddItem("melee_katana", "Katana");
	menu.AddItem("melee_knife", "Knife");
	menu.AddItem("melee_machete", "Machete");
	menu.AddItem("weapon_pistol_magnum", "Magnum");
	menu.AddItem("melee_tonfa", "Nightstick");
	menu.AddItem("weapon_pistol", "Pistol");
	menu.AddItem("melee_riotshield", "Riot Shield");

	PushMenuInt(menu, "type", 2);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

void OpenItemsMenu(int client)
{
	if (!convar_Status.BoolValue)
		return;

	Menu menu = new Menu(MenuHandler_PickAnItem);
	menu.SetTitle("Items Manager\n \nManage an item:");

	menu.AddItem("weapon_adrenaline", "Adrenaline Shot");
	menu.AddItem("weapon_ammo_spawn", "Ammunition");
	menu.AddItem("weapon_defibrillator", "Defibrillator");
	menu.AddItem("weapon_upgradepack_explosive", "Explosive Rounds");
	menu.AddItem("weapon_first_aid_kit", "First Aid Kid");
	menu.AddItem("weapon_upgradepack_incendiary", "Incendiary Ammo");
	menu.AddItem("weapon_molotov", "Molotov");
	menu.AddItem("weapon_pain_pills", "Pain Pills");
	menu.AddItem("weapon_pipe_bomb", "Pipe Bomb");
	menu.AddItem("weapon_vomitjar", "Vomit Jar");

	PushMenuInt(menu, "type", 3);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

void OpenCarryablesMenu(int client)
{
	if (!convar_Status.BoolValue)
		return;

	Menu menu = new Menu(MenuHandler_PickAnItem);
	menu.SetTitle("Items Manager\n \nManage an item:");

	menu.AddItem("weapon_oxygentank", "Oxygen Tank");
	menu.AddItem("weapon_propanetank", "Propane Tank");
	menu.AddItem("weapon_cola_bottles", "Cola Bottles");
	menu.AddItem("weapon_fireworkcrate", "Fireworks Crate");
	menu.AddItem("weapon_gascan", "Gascan");
	menu.AddItem("weapon_gnome", GetRandomInt(0, 10000) <= 9999 ? "Gnome" : "Keemstar");	//Keemstar

	PushMenuInt(menu, "type", 4);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_PickAnItem(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
				return;

			char sEntity[64]; char sName[MAX_NAME_LENGTH];
			menu.GetItem(param2, sEntity, sizeof(sEntity), _, sName, sizeof(sName));

			int type = GetMenuInt(menu, "type");

			OpenItemManagementMenu(param1, type, sName, sEntity);
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
				OpenCategoriesMenu(param1);
		}
		case MenuAction_End:
			delete menu;
	}
}

void OpenItemManagementMenu(int client, int type, const char[] name, const char[] entity)
{
	if (!convar_Status.BoolValue)
		return;

	Menu menu = new Menu(MenuHandler_ManageItem);
	menu.SetTitle("Items Manager\n \nManage the %s:", name);

	menu.AddItem("spawn", "Spawn this item");
	//menu.AddItem("limit", "Set this items limit");

	PushMenuInt(menu, "type", type);
	PushMenuString(menu, "name", name);
	PushMenuString(menu, "entity", entity);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_ManageItem(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
				return;

			char sInfo[32];
			menu.GetItem(param2, sInfo, sizeof(sInfo));

			int type = GetMenuInt(menu, "type");

			char sName[64];
			GetMenuString(menu, "name", sName, sizeof(sName));

			char sEntity[64];
			GetMenuString(menu, "entity", sEntity, sizeof(sEntity));

			if (StrEqual(sInfo, "spawn"))
			{
				int weapon;

				if (StrContains(sEntity, "melee_") == 0)
				{
					weapon = CreateEntityByName("weapon_melee");

					if (IsValidEntity(weapon))
					{
						char sScript[64];
						strcopy(sScript, sizeof(sScript), sEntity);

						ReplaceString(sScript, sizeof(sScript), "melee_", "");

						DispatchKeyValue(weapon, "melee_script_name", sScript);
						DispatchSpawn(weapon);

						EquipPlayerWeapon(param1, weapon);
					}
				}
				else
				{
					weapon = GivePlayerItem(param1, sEntity);

					if (IsValidEntity(weapon))
					{
						EquipPlayerWeapon(param1, weapon);
						
						int cheatsoff = GetCommandFlags("give");
						SetCommandFlags("give",cheatsoff & ~FCVAR_CHEAT);
						FakeClientCommand(param1, "give ammo");
						SetCommandFlags("give",cheatsoff|FCVAR_CHEAT);
					}
				}

				OpenItemManagementMenu(param1, type, sName, sEntity);
			}
			else if (StrEqual(sInfo, "limit"))
				OpenItemManagementMenu(param1, type, sName, sEntity);
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				switch (GetMenuInt(menu, "type"))
				{
					case 1: OpenPrimaryMenu(param1);
					case 2: OpenSecondaryMenu(param1);
					case 3: OpenItemsMenu(param1);
					case 4: OpenCarryablesMenu(param1);
				}
			}
		}
		case MenuAction_End:
			delete menu;
	}
}

//Apparently, this doesn't work with every weapon. (like ak47)
/* public void Event_OnItemPickup(Event event, const char[] name, bool dontBroadcast)
{
	if (!convar_Status.BoolValue)
		return;

	int client = GetClientOfUserId(event.GetInt("userid"));

	char sItem[64];
	event.GetString("item", sItem, sizeof(sItem));

	PrintToChatAll("%sItem picked up by %N: %s", PLUGIN_TAG, client, sItem);
} */

public Action Command_SpawnInfected(int client, int args)
{
	if (args > 0)
	{
		char infected[32];
		GetCmdArg(1, infected, sizeof(infected));
		vCheatCommand(client, "z_spawn_old", infected);
		
		infected[0] = CharToUpper(infected[0]);
		PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
		
		return Plugin_Handled;
	}
	
	OpenInfectedMenu(client);
	return Plugin_Handled;
}

public Action Command_SpawnCommon(int client, int args)
{
	char infected[32] = "Common";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnHunter(int client, int args)
{
	char infected[32] = "Hunter";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnBoomer(int client, int args)
{
	char infected[32] = "Boomer";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnSmoker(int client, int args)
{
	char infected[32] = "Smoker";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnCharger(int client, int args)
{
	char infected[32] = "Charger";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnJockey(int client, int args)
{
	char infected[32] = "Jockey";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnSpitter(int client, int args)
{
	char infected[32] = "Spitter";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnTank(int client, int args)
{
	char infected[32] = "Tank";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

public Action Command_SpawnWitch(int client, int args)
{
	char infected[32] = "Witch";
	vCheatCommand(client, "z_spawn_old", infected);
	PrintToChat(client, "%sInfected Spawned: %s", PLUGIN_TAG, infected);
	return Plugin_Handled;
}

void OpenInfectedMenu(int client)
{
	Menu menu = new Menu(MenuHandler_Infected);
	menu.SetTitle("Pick an infected:");
	
	menu.AddItem("common", "Common Infected");
	menu.AddItem("hunter", "Hunter");
	menu.AddItem("boomer", "Boomer");
	menu.AddItem("smoker", "Smoker");
	menu.AddItem("charger", "Charger");
	menu.AddItem("jockey", "Jockey");
	menu.AddItem("spitter", "Spitter");
	menu.AddItem("tank", "Tank");
	menu.AddItem("witch", "Witch");
	
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Infected(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
				return;

			char infected[32]; char name[32];
			menu.GetItem(param2, infected, sizeof(infected), _, name, sizeof(name));

			vCheatCommand(param1, "z_spawn_old", infected);
			PrintToChat(param1, "%sInfected Spawned: %s", PLUGIN_TAG, name);
			
			OpenInfectedMenu(param1);
		}
		case MenuAction_End:
			delete menu;
	}
}

public Action Command_ForcePanic(int client, int args)
{
	vCheatCommand(client, "director_force_panic_event");
	PrintToChatAll("%s%N has caused a panic!", PLUGIN_TAG, client);
	return Plugin_Handled;
}

void vCheatCommand(int client, char[] command, char[] arguments = "")
{
	int iCmdFlags = GetCommandFlags(command);
	SetCommandFlags(command, iCmdFlags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "%s %s", command, arguments);
	SetCommandFlags(command, iCmdFlags | FCVAR_CHEAT);
}

public Action Command_SetDifficulty(int client, int args)
{
	char sDifficulty[32];
	GetCmdArgString(sDifficulty, sizeof(sDifficulty));
	
	if (strlen(sDifficulty) == 0)
		sDifficulty = "Normal";
	
	if (StrEqual(sDifficulty, "expert", false))
		SetConVarString(FindConVar("z_difficulty"), "impossible");
	else
		SetConVarString(FindConVar("z_difficulty"), sDifficulty);
	
	sDifficulty[0] = CharToUpper(sDifficulty[0]);
	PrintToChatAll("%s%N has set the difficulty to: %s", PLUGIN_TAG, client, sDifficulty);
	
	return Plugin_Handled;
}