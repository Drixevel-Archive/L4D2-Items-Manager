//Pragma
#pragma semicolon 1
#pragma newdecls required

//Sourcemod Includes
#include <sourcemod>
#include <sourcemod-misc>

//ConVars
ConVar convar_Status;

public Plugin myinfo =
{
	name = "[L4D2] Items Manager",
	author = "Keith Warren (Shaders Allen)",
	description = "Allows for the management of items to spawn or limit them.",
	version = "1.0.0",
	url = "https://www.shadersallen.com/"
};

public void OnPluginStart()
{
	convar_Status = CreateConVar("sm_itemsmanager_status", "1", "Status of the plugin.\n(1 = on, 0 = off)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	AutoExecConfig();

	RegAdminCmd("sm_items", Command_Items, ADMFLAG_SLAY);

	//HookEvent("item_pickup", Event_OnItemPickup);
}

public void OnMapStart()
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

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
	{
		return Plugin_Handled;
	}

	if (IsClientConsole(client))
	{
		return Plugin_Handled;
	}

	OpenCategoriesMenu(client);
	return Plugin_Handled;
}

void OpenCategoriesMenu(int client)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

	Menu menu = new Menu(MenuHandler_Items);
	menu.SetTitle("Items Manager\n \nSelect a category:");

	menu.AddItem("primary", "Primary Weapons");
	menu.AddItem("secondary", "Secondary Weapons");
	menu.AddItem("items", "Items");
	menu.AddItem("carryables", "Carryables");

	menu.Display(client, 30);
}

public int MenuHandler_Items(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
			{
				return;
			}

			char sInfo[32];
			menu.GetItem(param2, sInfo, sizeof(sInfo));

			if (StrEqual(sInfo, "primary"))
			{
				OpenPrimaryMenu(param1);
			}
			else if (StrEqual(sInfo, "secondary"))
			{
				OpenSecondaryMenu(param1);
			}
			else if (StrEqual(sInfo, "items"))
			{
				OpenItemsMenu(param1);
			}
			else if (StrEqual(sInfo, "carryables"))
			{
				OpenCarryablesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

void OpenPrimaryMenu(int client)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

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

	PushMenuCell(menu, "type", 1);

	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

void OpenSecondaryMenu(int client)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

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

	PushMenuCell(menu, "type", 2);

	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

void OpenItemsMenu(int client)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

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

	PushMenuCell(menu, "type", 3);

	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

void OpenCarryablesMenu(int client)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

	Menu menu = new Menu(MenuHandler_PickAnItem);
	menu.SetTitle("Items Manager\n \nManage an item:");

	menu.AddItem("weapon_oxygentank", "Oxygen Tank");
	menu.AddItem("weapon_propanetank", "Propane Tank");
	menu.AddItem("weapon_cola_bottles", "Cola Bottles");
	menu.AddItem("weapon_fireworkcrate", "Fireworks Crate");
	menu.AddItem("weapon_gascan", "Gascan");
	menu.AddItem("weapon_gnome", GetRandomInt(0, 10000) <= 9999 ? "Gnome" : "Keemstar");	//Keemstar

	PushMenuCell(menu, "type", 4);

	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

public int MenuHandler_PickAnItem(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
			{
				return;
			}

			char sEntity[64]; char sName[MAX_NAME_LENGTH];
			menu.GetItem(param2, sEntity, sizeof(sEntity), _, sName, sizeof(sName));

			int type = GetMenuCell(menu, "type");

			OpenItemManagementMenu(param1, type, sName, sEntity);
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				OpenCategoriesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

void OpenItemManagementMenu(int client, int type, const char[] name, const char[] entity)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

	Menu menu = new Menu(MenuHandler_ManageItem);
	menu.SetTitle("Items Manager\n \nManage the %s:", name);

	menu.AddItem("spawn", "Spawn this item");
	//menu.AddItem("limit", "Set this items limit");

	PushMenuCell(menu, "type", type);
	PushMenuString(menu, "name", name);
	PushMenuString(menu, "entity", entity);

	menu.ExitBackButton = true;
	menu.Display(client, 30);
}

public int MenuHandler_ManageItem(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			if (!convar_Status.BoolValue)
			{
				return;
			}

			char sInfo[32];
			menu.GetItem(param2, sInfo, sizeof(sInfo));

			int type = GetMenuCell(menu, "type");

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
					}
				}

				OpenItemManagementMenu(param1, type, sName, sEntity);
			}
			else if (StrEqual(sInfo, "limit"))
			{
				OpenItemManagementMenu(param1, type, sName, sEntity);
			}
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				switch (GetMenuCell(menu, "type"))
				{
					case 1: OpenPrimaryMenu(param1);
					case 2: OpenSecondaryMenu(param1);
					case 3: OpenItemsMenu(param1);
					case 4: OpenCarryablesMenu(param1);
				}
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

//Apparently, this doesn't work with every weapon. (like ak47)
/* public void Event_OnItemPickup(Event event, const char[] name, bool dontBroadcast)
{
	if (!convar_Status.BoolValue)
	{
		return;
	}

	int client = GetClientOfUserId(event.GetInt("userid"));

	char sItem[64];
	event.GetString("item", sItem, sizeof(sItem));

	PrintToChatAll("Item picked up by %N: %s", client, sItem);
} */
