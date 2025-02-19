import discord
from discord.ext import commands

from lib.service.db_service import DBService

class EventCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @commands.Cog.listener()
    async def on_message(self, message):
        if message.author == self.bot.user:
            return
        print(f"Message from {message.author}: {message.content}")
        DBService().insert_message(message.guild.id, message.author.id, message.content, message.channel.name, False, False)

    @commands.Cog.listener()
    async def on_guild_join(self, guild):
        print(f"Joined guild {guild.name}")
        DBService().insert_guild(guild.id, guild.name)
    
    @commands.Cog.listener()
    async def on_voice_state_update(self, member, before, after):
        if before.channel is None:
            DBService().insert_voice_channel_event('JOIN', None, after.channel.name, member.id, member.guild.id)
        elif after.channel is None:
            DBService().insert_voice_channel_event('LEAVE', before.channel.name, None, member.id, member.guild.id)
        else:
            DBService().insert_voice_channel_event('MOVE', before.channel.name, after.channel.name, member.id, member.guild.id)