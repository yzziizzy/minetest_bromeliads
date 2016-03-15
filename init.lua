

local modpath = minetest.get_modpath("bromeliads")

-- Add everything:
local modname = "bromeliads"


local regBrom = function(color, capColor) 

	minetest.register_node("bromeliads:bromeliad_"..color, {
		description = capColor .. " Bromeliad",
		drawtype = "plantlike",
		waving = 1,
		visual_scale = 1.0,
		tiles = {"bromeliads_"..color..".png"},
		inventory_image = "bromeliads_"..color..".png",
		wield_image = "bromeliads_"..color..".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1, bromeliad = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
	})
end

regBrom("blue", "Blue")
regBrom("orange", "Orange")
regBrom("red", "Red")
regBrom("violet", "Violet")
regBrom("yellow", "Yellow")


local growaction = function(pos, node)
	pos.y = pos.y + 1
	local over = minetest.get_node(pos)
	if over.name ~= "air" then
		return
	end
	
	pos.y = pos.y - 1

	local light = minetest.get_node_light(pos)
	if not light or light < 4 then
		return
	end


	local r = 15
	local pos0 = {x = pos.x - r, y = pos.y - r, z = pos.z - r}
	local pos1 = {x = pos.x + r, y = pos.y + r, z = pos.z + r}
	if #minetest.find_nodes_in_area(pos0, pos1, "group:bromeliad") > 0 then
		return
	end
	
	local r = math.random(1, 100)
	
	if r == 1 then
		if pos.y > 60 then
			minetest.set_node(pos, {name="bromeliads:bromeliad_blue"})
		else
			minetest.set_node(pos, {name="bromeliads:bromeliad_violet"})
		end
	elseif r <= 10 then
		minetest.set_node(pos, {name="bromeliads:bromeliad_yellow"})
	elseif r <= 25 then
		minetest.set_node(pos, {name="bromeliads:bromeliad_orange"})
	else
		minetest.set_node(pos, {name="bromeliads:bromeliad_red"})
	end
end



minetest.register_abm({
	nodenames = {"default:jungleleaves"},
	interval = 60,
	chance = 10,
	catch_up = true,
	action = growaction,
})


