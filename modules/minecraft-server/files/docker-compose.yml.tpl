version: "3"

services:
  minecraft:
    image: itzg/minecraft-server:${minecraft_version}
    ports:
      - ${minecraft_port}:25565
    environment:
      ENABLE_RCON: "${minecraft_enable_rcon}"
      EULA: "${minecraft_eula}"
      INIT_MEMORY: "${minecraft_init_memory}"
      MAX_MEMORY: "${minecraft_max_memory}"
      MOTD: "${minecraft_motd}"
      OPS: "${minecraft_ops}"
      OVERRIDE_SERVER_PROPERTIES: "${minecraft_override}"
    restart: always
    volumes:
      - ${minecraft_mount}:/data
