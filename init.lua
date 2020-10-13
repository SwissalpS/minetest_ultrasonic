-- Upgraded sonic screwdriver that operates on frequencies we cannot hear.
-- Holding special while clicking will rotate backwards.

-- safety check in case translation function does not exist
local S = technic.getter

--settings
ultrasonic = {}
ultrasonic.screwdriver_max_charge = tonumber(minetest.settings:get(
	"ultrasonic.screwdriver_max_charge") or 25252)
ultrasonic.screwdriver_charge_per_use = tonumber(minetest.settings:get(
	"ultrasonic.screwdriver_charge_per_use") or 92)

technic.register_power_tool("ultrasonic:screwdriver", ultrasonic.screwdriver_max_charge)

-- screwdriver handler code reused from minetest/minetest_game screwdriver @a9ac480
local ROTATE_FACE = 1
local ROTATE_AXIS = 2

local function next_range(x, max)
	x = x + 1
	if x > max then
		x = 0
	end
	return x
end

local function previous_range(x, max)
	x = x - 1
	if 0 > x then
		x = max
	end
	return x
end

-- Handles rotation
function ultrasonic.screwdriver_handler(itemstack, user, pointed_thing, mode)
	if "node" ~= pointed_thing.type then
		return
	end

	local pos = pointed_thing.under
	local user_name = user:get_player_name()

	if minetest.is_protected(pos, user_name) then
		minetest.record_protection_violation(pos, user_name)
		return
	end

	local node = minetest.get_node(pos)
	local ndef = minetest.registered_nodes[node.name]
	if not ndef
		or not "facedir" == ndef.paramtype2
		or ("nodebox" == ndef.drawtype
			and not "fixed" == ndef.node_box.type)
		or nil == node.param2
	then
		return
	end

	-- Contrary to the default screwdriver, do not check for can_dig, to allow
	-- rotating machines with CLU's in them.
	-- This is consistent with the previous sonic screwdriver

	-- deal with charge
	local meta_table = minetest.deserialize(itemstack:get_metadata())
	if not meta_table
		or not meta_table.charge
		or meta_table.charge < ultrasonic.screwdriver_charge_per_use
	then
		minetest.chat_send_player(user_name, S("Your tool needs to be charged."))
		return
	end
	local current_charge = meta_table.charge
	local new_charge = current_charge - ultrasonic.screwdriver_charge_per_use
	if not technic.creative_mode then
		meta_table.charge = new_charge
		itemstack:set_metadata(minetest.serialize(meta_table))
		technic.set_RE_wear(itemstack, new_charge, ultrasonic.screwdriver_max_charge)
	end

	-- Set param2
	local rotation_part = node.param2 % 32 -- get first 4 bits
	local preserve_part = node.param2 - rotation_part

	local axis_dir = math.floor(rotation_part / 4)
	local rotation = rotation_part - axis_dir * 4
	local reverse = user:get_player_control().aux1
	if mode == ROTATE_FACE then
		if reverse then
			rotation_part = axis_dir * 4 + previous_range(rotation, 3)
		else
			rotation_part = axis_dir * 4 + next_range(rotation, 3)
		end
	elseif mode == ROTATE_AXIS then
		if reverse then
			rotation_part = previous_range(axis_dir, 5) * 4
		else
			rotation_part = next_range(axis_dir, 5) * 4
		end
	end

	node.param2 = preserve_part + rotation_part
	minetest.swap_node(pos, node)

	return itemstack
end

ultrasonic.tool_definition = {
	description = S("Ultrasonic Screwdriver (left-click rotates face, right-click rotates axis)"),
	inventory_image = "technic_sonic_screwdriver.png^[colorize:orange:200",
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		ultrasonic.screwdriver_handler(itemstack, user, pointed_thing, ROTATE_FACE)
		return itemstack
	end,
	on_place = function(itemstack, user, pointed_thing)
		ultrasonic.screwdriver_handler(itemstack, user, pointed_thing, ROTATE_AXIS)
		return itemstack
	end,
}
minetest.register_tool("ultrasonic:screwdriver", ultrasonic.tool_definition)

minetest.register_craft({
	output = 'ultrasonic:screwdriver 1',
	recipe = {
		{ 'technic:rubber',           'technic:control_logic_unit', 'technic:rubber' },
		{ 'mesecons_materials:fiber', 'technic:sonic_screwdriver',  'mesecons_materials:fiber' },
		{ 'wool:orange',              'technic:battery',            'wool:orange' }
	}
}) -- register_craft
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
print('[ultrasonic] loaded')

