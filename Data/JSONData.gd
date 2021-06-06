extends Node

var item_data: Dictionary
var quest_data: Dictionary
var merchant_shop_data: Dictionary
var blacksmith_shop_data: Dictionary
var alchemist_shop_data: Dictionary
var skill_data: Dictionary

var shield_shop_data: Dictionary
var armor_shop_data: Dictionary
#var shoes_shop_data: Dictionary
var helmet_shop_data: Dictionary
var accessories_shop_data: Dictionary

func _ready():
#	item_data = load_data("res://Data/ItemData.json")
	
	# temp 
	# Item Weapon , Item Armor , Item Shoes , Item Shield , Item Helmet , Item Accessories
	# Item Consumable , Item Resource
	item_data = {
		
		# ------------------------------ Item Weapon --------------------------------
		"Short Wooden Sword": {
			"Description": "Wooden Sword For Beginner Hunter", 
			"Damage": 5, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 70,
			"SellPrice": 50
		},
		"Iron Sword": {
			"Description": "Sowrdddddd", 
			"Damage": 20, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 250,
			"SellPrice": 100
		},
		"Falken Sword": {
			"Description": "Falken Sword", 
			"Damage": 70, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 700,
			"SellPrice": 350
		},
		"Yara ves sword": {
			"Description": "Yara ves sword", 
			"Damage": 40, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 540,
			"SellPrice": 250
		},
		"Bigboo sword": {
			"Description": "Bigboo sword", 
			"Damage": 50, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 600,
			"SellPrice": 300
		},
		"Barrey Sword": {
			"Description": "Iron Axe", 
			"Damage": 30, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Rouge sword": {
			"Description": "Rouge sword", 
			"Damage": 30, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Fennis sword": {
			"Description": "Fennis sword", 
			"Damage": 100, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1000,
			"SellPrice": 500
		},
		"Goldres sword": {
			"Description": "Fennis sword", 
			"Damage": 80, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 800,
			"SellPrice": 400
		},
		"Naris sword": {
			"Description": "Naris sword", 
			"Damage": 10, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 100,
			"SellPrice": 50
		},
		"Iron Spear": {
			"Description": "Iron Axe", 
			"Damage": 20, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 250,
			"SellPrice": 100
		},
		"Heriken spear": {
			"Description": "Iron Axe", 
			"Damage": 20, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 250,
			"SellPrice": 100
		},
		"Bigboo spear": {
			"Description": "Bigboo spear", 
			"Damage": 30, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Red rope spear": {
			"Description": "red rope spear", 
			"Damage": 20, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 250,
			"SellPrice": 100
		},
		"Iron Axe": {
			"Description": "Iron Axe", 
			"Damage": 20, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 250,
			"SellPrice": 100
		},
		"Venhander axe": {
			"Description": "Venhander axe", 
			"Damage": 20, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 250,
			"SellPrice": 100
		},
		"Two head axe": {
			"Description": "Iron Axe", 
			"Damage": 30, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Pakeya axe": {
			"Description": "Iron Axe", 
			"Damage": 10, 
			"ItemCatagory": "Weapon", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 100,
			"SellPrice": 50
		},
		
		# ------------------------------ Item Armor ---------------------------------
		"Orange Armor": {
			"Description": "Orange Armor", 
			"Defend": 10, 
			"ItemCatagory": "Armor", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 100,
			"SellPrice": 50
		},
		"Iron Armor": {
			"Description": "Orange Armor", 
			"Defend": 30, 
			"ItemCatagory": "Armor", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 300,
			"SellPrice": 150
		},
		"Chain Armor": {
			"Description": "Orange Armor", 
			"Defend": 20, 
			"ItemCatagory": "Armor", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"King Of Armor": {
			"Description": "Orange Armor", 
			"Defend": 50, 
			"ItemCatagory": "Armor", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1000,
			"SellPrice": 500
		},
		"Ninja Suit": {
			"Description": "Orange Armor", 
			"Defend": 10, 
			"ItemCatagory": "Armor", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 100,
			"SellPrice": 50
		},
		"Bister Armor": {
			"Description": "Orange Armor", 
			"Defend": 20, 
			"ItemCatagory": "Armor", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		
		
		# ----------------------------- Item Shoes ----------------------------------
		"Leather Shoes": {
			"Description": "Wooden Shoes Lv1", 
			"Defend": 5, 
			#"Speed": 20,
			"ItemCatagory": "Shoes", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 500,
			"SellPrice": 250
		},
		"Iron Shoes": {
			"Description": "Wooden Shoes Lv1", 
			"Defend": 10, 
			#"Speed": 20,
			"ItemCatagory": "Shoes", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1000,
			"SellPrice": 500
		},
		"Golden Shoes": {
			"Description": "Wooden Shoes Lv1", 
			"Defend": 20, 
			#"Speed": 20,
			"ItemCatagory": "Shoes", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 2000,
			"SellPrice": 1000
		},
		
		# ----------------------------- Item Shield ---------------------------------
		"Wooden Shield": {
			"Description": "Wooden Shield", 
			"Defend": 10, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 100,
			"SellPrice": 50
		},
		"Broken Shield": {
			"Description": "Broken Shield", 
			"Defend": 5, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 50,
			"SellPrice": 25
		},
		"Iron Shield": {
			"Description": "Iron Shield", 
			"Defend": 30, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 300,
			"SellPrice": 150
		},
		"Golden Shield": {
			"Description": "Iron Shield", 
			"Defend": 20, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Leather Shield": {
			"Description": "Iron Shield", 
			"Defend": 40, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"King Shield": {
			"Description": "Iron Shield", 
			"Defend": 50, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 500,
			"SellPrice": 250
		},
		"Warrior Shield": {
			"Description": "Iron Shield", 
			"Defend": 20, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Shield Of Crystal": {
			"Description": "Shield Of Crystal", 
			"Defend": 30, 
			"ItemCatagory": "Shield", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 300,
			"SellPrice": 150
		},
		
		# ----------------------------- Item Helmet --------------------------------
		"King Of Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 200, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Taekwondo Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 100, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Viking Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 300, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 600,
			"SellPrice": 300
		},
		"Wizard Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 100, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Witch Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 200, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Arthur Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 200, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Spata Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 300, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 600,
			"SellPrice": 300
		},
		"Rogue Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 50, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 100,
			"SellPrice": 50
		},
		"Iron Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 100, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Knight Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 100, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Red King Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 250, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 500,
			"SellPrice": 250
		},
		"Barron Helmet": {
			"Description": "Wooden Helmet Lv1", 
			"HP": 200, 
			"ItemCatagory": "Helmet", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 500,
			"SellPrice": 250
		},
		
		
		# ----------------------------- Item Accessories ---------------------------
		"King Of Ring": {
			"Description": "King Of Ring", 
			"CriticalDamage": 3, 
			"CriticalRate": 2,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 10,
			"SellPrice": 5
		},
		"Necklace Of Leaf": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 9, 
			"CriticalRate": 9,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 900,
			"SellPrice": 450
		},
		"Crystal Of Necklace": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 20, 
			"CriticalRate": 20,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 2000,
			"SellPrice": 1000
		},
		"Flaster": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 15, 
			"CriticalRate": 15,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1500,
			"SellPrice": 750
		},
		"Golden Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 10, 
			"CriticalRate": 10,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1000,
			"SellPrice": 500
		},
		"Star Of The Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 10, 
			"CriticalRate": 10,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1000,
			"SellPrice": 500
		},
		"Skull Of The Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 5, 
			"CriticalRate": 5,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 500,
			"SellPrice": 250
		},
		"Tooth Of The Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 2, 
			"CriticalRate": 2,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Dragon Of The Necklace": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 20, 
			"CriticalRate": 20,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 2000,
			"SellPrice": 1000
		},
		"Spend Of Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 4, 
			"CriticalRate": 4,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 400,
			"SellPrice": 200
		},
		"Crystal Blue Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 5, 
			"CriticalRate": 5,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 500,
			"SellPrice": 250
		},
		"Ruby Of Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 7, 
			"CriticalRate": 7,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 700,
			"SellPrice": 350
		},
		"Forest Of Ring": {
			"Description": "Necklace Of Leaf", 
			"CriticalDamage": 10, 
			"CriticalRate": 10,
			"ItemCatagory": "Accessories", 
			"StackSize": 1,
			"ItemLevel": 1,
			"BuyPrice": 1000,
			"SellPrice": 500
		},
		
		
		# -------------------------------- Item Consumable --------------------------
#		"Slime Potion": {
#			"AddEnergy": 32, 
#			"AddHealth": 5, 
#			"Description": "Slime Potion", 
#			"ItemCatagory": "Consumable", 
#			"StackSize": 99,
#			"BuyPrice": 10,
#			"SellPrice": 5
#		}, 
#		"Meat": {
#			"AddEnergy": 1, 
#			"AddHealth": 1, 
#			"Description": "Slime Potion", 
#			"ItemCatagory": "Consumable", 
#			"StackSize": 99,
#			"BuyPrice": 10,
#			"SellPrice": 5
#		}, 
		"Lv1 Green Potion": {
			"HP": 10,
			"SP": 10, 
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 20,
			"SellPrice": 10
		}, 
		"Lv1 Health Potion": {
			"HP": 20,
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 20,
			"SellPrice": 10
		}, 
		"Lv1 Mp Potion": {
			"SP": 20, 
			"Description": "Mp Potion", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 20,
			"SellPrice": 10
		}, 
		"Lv2 Green Potion": {
			"HP": 25, 
			"SP": 25, 
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 50,
			"SellPrice": 25
		}, 
		"Lv2 Health Potion": {
			"HP": 50, 
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 50,
			"SellPrice": 25
		}, 
		"Lv2 Mp Potion": {
			"SP": 50, 
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 50,
			"SellPrice": 25
		}, 
		"Lv3 Green Potion": {
			"SP": 50, 
			"HP": 50, 
			"Description": "Mp Potion", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 100,
			"SellPrice": 50
		}, 
		"Lv3 Health Potion": {
			"HP": 100, 
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 100,
			"SellPrice": 50
		}, 
		"Lv3 Mp Potion": {
			"SP": 100, 
			"Description": "Mp Potion", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 100,
			"SellPrice": 50
		}, 
		"Lv4 Green Potion": {
			"HP": 100,
			"SP": 100, 
			"Description": "Mp Potion", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Lv4 Health Potion": {
			"HP": 200, 
			"Description": "Health", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Lv4 Mp Potion": {
			"SP": 200, 
			"Description": "Mp Potion", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
#		"Cake": {
#			"AddEnergy": 32, 
#			"AddHealth": 20, 
#			"Description": "Mp Potion", 
#			"ItemCatagory": "Consumable", 
#			"StackSize": 99,
#			"BuyPrice": 10,
#			"SellPrice": 5
#		}, 
		# -- Herb
		"Mint Leaf": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Mint Leaf", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Basil Leaf": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Basil Leaf", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Aloe Vera Leaf": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Aloe Vera Leaf", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		},
		"Cissus Quadrangularis": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Cissus Quadrangularis", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Garlic": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Garlic", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Ginger": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Ginger", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Lavender": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Lavender", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Lemon Grass": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Lemon Grass", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Red Onion": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Red Onion", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		"Turmeric": {
			"HP": 100, 
			"SP": 100, 
			"Description": "Turmeric", 
			"ItemCatagory": "Consumable", 
			"StackSize": 99,
			"BuyPrice": 200,
			"SellPrice": 100
		}, 
		
		# ----------------------------- Item Resource ------------------------------
		"Lv1 Empty Potion": {
			"AddEnergy": 32, 
			"AddHealth": 20, 
			"Description": "Health", 
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 10,
			"SellPrice": 5
		}, 
		"Lv2 Empty Potion": {
			"AddEnergy": 32, 
			"AddHealth": 20, 
			"Description": "Health", 
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 10,
			"SellPrice": 5
		}, 
		"Lv3 Empty Potion": {
			"AddEnergy": 32, 
			"AddHealth": 20, 
			"Description": "Health", 
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 10,
			"SellPrice": 5
		}, 
		"Tree Branch": {
			"Description": "Tree Branch hhhhhhhhhhhh",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 70,
			"SellPrice": 50
		},
		"Mushroom": {
			"Description": "Mushroom",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 80
		},
		"Coal": {
			"Description": "Coal",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 60,
			"SellPrice": 30
		},
		"Diamon": {
			"Description": "Diamon",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 300,
			"SellPrice": 150
		},
		"Red Gem": {
			"Description": "Red Gem",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 50
		},
		"Green Gem": {
			"Description": "Green Gem",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 50
		},
		"Blue Gem": {
			"Description": "Blue Gem",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 50
		},
		"Yellow Gem": {
			"Description": "Yellow Gem",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 50
		},
		"Rock": {
			"Description": "Rock",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 50,
			"SellPrice": 20
		},
		"Slime Meat": {
			"Description": "Rock",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 10,
			"SellPrice": 5
		},
		"Bat Wing": {
			"Description": "Bat Wing",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 90,
			"SellPrice": 40
		},
		"Wing": {
			"Description": "Wing",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 10,
			"SellPrice": 5
		},
		"Insect Feet": {
			"Description": "Insect Feet",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 70,
			"SellPrice": 50
		},
		"Iron Ore": {
			"Description": "Iron Ore",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 50
		},
		"Nail": {
			"Description": "Nail",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 100,
			"SellPrice": 70
		},
		"Fur": {
			"Description": "Fur",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 60,
			"SellPrice": 30
		},
		"Empty Grinding Cup": {
			"Description": "Empty Grinding Cup",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 10,
			"SellPrice": 5
		}, 
		"Blank Paper": {
			"Description": "Empty Grinding Cup",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 80,
			"SellPrice": 50
		}, 
		"Heart": {
			"Description": "Empty Grinding Cup",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 90,
			"SellPrice": 70
		}, 
		"Evil Wing": {
			"Description": "Empty Grinding Cup",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 180,
			"SellPrice": 60
		}, 
		"Clover leaf fragments": {
			"Description": "Empty Grinding Cup",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 30,
			"SellPrice": 10
		},
		"Bone": {
			"Description": "Empty Grinding Cup",  
			"ItemCatagory": "Resource", 
			"StackSize": 99,
			"BuyPrice": 150,
			"SellPrice": 80
		},
		
	}
	
	quest_data = {
		0: {
			"quest_name": "Find the first herb !!!!",
			"npc": "Jack",
			"description": "Go to Map Green Veta Dungeon 1 to find the herbs you want.",
			"position": "Green veta dungeon 1",
			"exp_reward": 200,
			"coin_reward": 1000,
			"item_reward": {
				0: "Lv2 Health Potion",
				1: "Blank Paper"
			},
			"item_require": {
				0: { "item_id":"Aloe Vera Leaf" },
				1: { "item_id":"Mint Leaf" },
			},
			"dialogue": {
				0:"Hello !!! My Name is Jack, I need help",
				1:"I would like the peppermint herb and aloe vera leaf.",
				2:"It will be in green veta dungeon 1.",
				3:"Good Luck !!!"
			}
		},
		1: {
			"quest_name": "quest 2",
			"npc": "Jacob",
			"description": "Go to Map Green Veta Dungeon 2 to find the herbs you want.",
			"position": "Green veta dungeon 2",
			"exp_reward": 400,
			"coin_reward": 2000,
			"item_reward": {
				0: "Yellow Gem",
			},
			"item_require": {
				0: { "item_id":"Ginger" },
				1: { "item_id":"Turmeric" },
			},
			"dialogue": {
				0:"Hello !!! My Name is Jacob, I need help",
				1:"I would like the ginger and turmeric.",
				2:"It will be in green veta dungeon 2.",
				3:"Good Luck !!!"
			}
		},
		2: {
			"quest_name": "quest 3",
			"npc": "Victoria",
			"description": "Go to Map Green Veta Dungeon 3 to find the herbs you want.",
			"position": "Green veta dungeon 3",
			"exp_reward": 600,
			"coin_reward": 3000,
			"item_reward": {
				0: "Yellow Gem",
			},
			"item_require": {
				0: { "item_id":"Basil Leaf" },
				1: { "item_id":"Red Onion" },
			},
			"dialogue": {
				0:"Hello !!! My Name is Victoria, I need help",
				1:"I would like the basil leaf and red onion.",
				2:"It will be in green veta dungeon 3.",
				3:"Good Luck !!!"
			}
		},
		3: {
			"quest_name": "quest 4",
			"npc": "Jelly",
			"description": "Go to Map Green Veta Dungeon 4 to find the herbs you want.",
			"position": "Green veta dungeon 4",
			"exp_reward": 800,
			"coin_reward": 4000,
			"item_reward": {
				0: "Yellow Gem",
			},
			"item_require": {
				0: { "item_id":"Garlic" },
				1: { "item_id":"Lemon Grass" },
			},
			"dialogue": {
				0:"Hello !!! My Name is Jelly, I need help",
				1:"I would like the garlic and lemon grass.",
				2:"It will be in green veta dungeon 4.",
				3:"Good Luck !!!"
			}
		},
		4: {
			"quest_name": "quest 5",
			"npc": "Lucien",
			"description": "Go to Map Green Veta Dungeon 5 to find the herbs you want.",
			"position": "Green veta dungeon 5",
			"exp_reward": 1000,
			"coin_reward": 5000,
			"item_reward": {
				0: "Yellow Gem",
			},
			"item_require": {
				0: { "item_id":"Lavender" },
				1: { "item_id":"Cissus Quadrangularis" },
			},
			"dialogue": {
				0:"Hello !!! My Name is Lucien, I need help",
				1:"I would like the lavender and cissus quadrangularis.",
				2:"It will be in green veta dungeon 5.",
				3:"Good Luck !!!"
			}
		},
	}
	
	merchant_shop_data = {
		0: {"item_id": "Tree Branch"},
		1: {"item_id": "Blank Paper"},
		2: {"item_id": "Red Gem"},
		3: {"item_id": "Iron Ore"},
		4: {"item_id": "Nail"},
		5: {"item_id": "Mushroom"},
		6: {"item_id": "Coal"},
		7: {"item_id": "Rock"}
	}
	
#	blacksmith_shop_data = {
#		0:{ "item_id": "Short Wooden Sword", "price": 0 },
#		1:{ "item_id": "Tree Branch", "price": 1111 },
#		2:{ "item_id": "Coal", "price": 2222 },
#		3:{ "item_id": "Diamon", "price": 333333333 }
#	}
	
	shield_shop_data = {
		0: { "item_id": "Wooden Shield" },
		1: { "item_id": "Broken Shield"},
		2: { "item_id": "Iron Shield" },
		3: { "item_id": "Golden Shield" },
		4: { "item_id": "Leather Shield" },
		5: { "item_id": "King Shield" },
		6: { "item_id": "Warrior Shield" },
		7: { "item_id": "Shield Of Crystal" }
	}
	
	armor_shop_data = {
		# armor
		0: { "item_id": "Orange Armor"},
		1: { "item_id": "Iron Armor"},
		2: { "item_id": "Chain Armor"},
		3: { "item_id": "King Of Armor"},
		4: { "item_id": "Ninja Suit"},
		5: { "item_id": "Bister Armor"},
		
		# helmet
		6: { "item_id": "King Of Helmet"},
		7: { "item_id": "Taekwondo Helmet"},
		8: { "item_id": "Viking Helmet"},
		9: { "item_id": "Wizard Helmet"},
		10: { "item_id": "Witch Helmet"},
		11: { "item_id": "Arthur Helmet"},
		12: { "item_id": "Spata Helmet"},
		13: { "item_id": "Rogue Helmet"},
		14: { "item_id": "Iron Helmet"},
		15: { "item_id": "Knight Helmet"},
		16: { "item_id": "Red King Helmet"},
		17: { "item_id": "Barron Helmet"},
		
		# shoes
		18: { "item_id": "Leather Shoes"},
		19: { "item_id": "Iron Shoes"},
		20: { "item_id": "Golden Shoes"},
		
		
	}
	
	
	accessories_shop_data = {
		0: { "item_id": "King Of Ring"},
		1: { "item_id": "Necklace Of Leaf"},
		2: { "item_id": "Crystal Of Necklace"},
		3: { "item_id": "Flaster"},
		4: { "item_id": "Golden Ring"},
		5: { "item_id": "Star Of The Ring"},
		6: { "item_id": "Skull Of The Ring"},
		7: { "item_id": "Tooth Of The Ring"},
		8: { "item_id": "Dragon Of The Necklace"},
		9: { "item_id": "Spend Of Ring"},
		10: { "item_id": "Crystal Blue Ring"},
		11: { "item_id": "Ruby Of Ring"},
		12: { "item_id": "Forest Of Ring"},
	}
	
	
	alchemist_shop_data = {
		0:{"item_id": "Lv1 Green Potion"},
		1:{"item_id": "Lv1 Health Potion"},
		2:{"item_id": "Lv1 Mp Potion"},
		3:{"item_id": "Lv2 Green Potion"},
		4:{"item_id": "Lv2 Health Potion"},
		5:{"item_id": "Lv2 Mp Potion"},
		6:{"item_id": "Lv3 Green Potion"},
		7:{"item_id": "Lv3 Health Potion"},
		8:{"item_id": "Lv3 Mp Potion"},
		9:{"item_id": "Lv4 Green Potion"},
		10:{"item_id": "Lv4 Health Potion"},
		11:{"item_id": "Lv4 Mp Potion"},
	}
	
	skill_data = {
		0: null,
		1: null,
		2: null,
		3: null,
		4: null,
		5: null
	}
	
	
func load_data(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	
	return json_data.result
