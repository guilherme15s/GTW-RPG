--[[
********************************************************************************
	Project owner:		GTWGames												
	Project name:		GTW-RPG	
	Developers:			GTWCode
	
	Source code:		https://github.com/GTWCode/GTW-RPG/
	Bugtracker:			http://forum.albonius.com/bug-reports/
	Suggestions:		http://forum.albonius.com/mta-servers-development/
	
	Version:			Open source
	License:			GPL v.3 or later
	Status:				Stable release
********************************************************************************
]]--

--[[ List of rights ]]--
local acl_table = {
	is_staff 		= { },
	is_admin 		= { },
	is_developer 	= { },
	is_moderator 	= { },
	is_supporter 	= { },
}

--[[ Install the rights into the table ]]--
function install_user_acls(plr, pAcc)
	-- Check for any administrative duties
	if pAcc and (isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Admin")) or
        isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Developer")) or
        isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Moderator")) or
        isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Supporter"))) then
		acl_table.is_staff[plr] = true
	end
	
	-- Check individual rights
	if pAcc and isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Admin")) then
		acl_table.is_admin[plr] = true
	end
	if pAcc and isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Developer")) then
		acl_table.is_developer[plr] = true
	end
	if pAcc and isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Moderator")) then
		acl_table.is_moderator[plr] = true
	end
	if pAcc and isObjectInACLGroup("user."..getAccountName(pAcc), aclGetGroup("Supporter")) then
		acl_table.is_supporter[plr] = true
	end
	
	-- Pass the the data to the client
	setTimer(triggerClientEvent, 5000, 1, plr, "GTWstaff.sendToClient", plr, acl_table.is_staff[plr],
		acl_table.is_admin[plr], acl_table.is_developer[plr], 
		acl_table.is_moderator[plr], acl_table.is_supporter[plr])
end
function assign_rights(_, pAcc)
	install_user_acls(source, pAcc)
end
addEventHandler("onPlayerLogin", root, assign_rights)
function assign_rights_to_all( )
	for k,v in ipairs(getElementsByType("player")) do
		local pAcc = getPlayerAccount(v)
		if pAcc then install_user_acls(v, pAcc) end
	end
end
addEventHandler( "onResourceStart", resourceRoot, assign_rights_to_all)

--[[ Return true if any of the administrative ACLs is assigned ]]--
function isStaff(plr)
	return acl_table.is_staff[plr] or false
end

--[[ Return true if a specific administrative ACL is assigned ]]--
function isAdmin(plr)
	return acl_table.is_admin[plr] or false
end
function isDeveloper(plr)
	return acl_table.is_developer[plr] or false
end
function isModerator(plr)
	return acl_table.is_moderator[plr] or false
end
function isSupporter(plr)
	return acl_table.is_supporter[plr] or false
end