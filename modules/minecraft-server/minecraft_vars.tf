variable "minecraft_enable_rcon" {
  type = string
  default = "true"
}

variable "minecraft_init_memory" {
  type = string
  default = "3G"
}

variable "minecraft_max_memory" {
  type = string
  default = "3G"
}

variable "minecraft_motd" {
  type = string
  default = "It's-a me, Minecraft!"
}

variable "minecraft_ops" {
  type = string
  default = ""
}

variable "minecraft_port" {
  type = string
  default = "25565"
}

variable "minecraft_version" {
  type = string
  default = "latest"
}
