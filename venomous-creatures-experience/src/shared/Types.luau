-- 型定義
-- このファイルはReplicatedStorage.Sharedに配置されます

export type CreatureType = "Snake" | "Frog" | "Scorpion" | "Mushroom" | "Jellyfish" | "Salamander"

export type PlayerData = {
	size: number,
	creatureType: CreatureType,
	itemsCollected: number,
	playersEaten: number,
}

export type ItemData = {
	id: string,
	position: Vector3,
	collected: boolean,
}

return {}

