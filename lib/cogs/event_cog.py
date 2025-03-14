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
        DBService().insert_message(message.guild.id, hash(message.author.id), len(message.content), message.channel.name, False, False)

    @commands.Cog.listener()
    async def on_guild_join(self, guild):
        members = guild.members
        print(members)
        for member in members:
            print(f'Adding user {member.name} to guild {guild.name}')
            DBService().insert_user(guild.id, hash(hash(member.id)),  hash(member.name))
        DBService().insert_guild(guild.id, guild.name)
    
    @commands.Cog.listener()
    async def on_voice_state_update(self, member, before, after):
        before_state = {'mute': before.self_mute, 'deaf': before.self_deaf, 'stream': before.self_stream}
        after_state = {'mute': after.self_mute, 'deaf': after.self_deaf, 'stream':after.self_stream}
        
        if before.channel is None:
            DBService().insert_voice_channel_event('VOICE_JOIN', None, after.channel.name, hash(member.id), member.guild.id)
        elif after.channel is None:
            DBService().insert_voice_channel_event('VOICE_LEAVE', before.channel.name, None, hash(member.id), member.guild.id)
        elif before.channel.name != after.channel.name:
            DBService().insert_voice_channel_event('CHANNEL_MOVE', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        elif before_state['mute'] == True and after_state['mute'] == False:
            DBService().insert_voice_channel_event('UNMUTE', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        elif before_state['deaf'] == True and after_state['deaf'] == False:
            DBService().insert_voice_channel_event('UNDEAF', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        elif before_state['stream'] == True and after_state['stream'] == False:
            DBService().insert_voice_channel_event('UNSTREAM', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        elif before_state['stream'] == False and after_state['stream'] == True:
            DBService().insert_voice_channel_event('STREAM', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        elif before_state['mute'] == False and after_state['mute'] == True:
            DBService().insert_voice_channel_event('MUTE', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        elif before_state['deaf'] == False and after_state['deaf'] == True:
            DBService().insert_voice_channel_event('DEAF', before.channel.name, after.channel.name, hash(member.id), member.guild.id)
        else:
            print('Unknown voice state change')
    
    @commands.Cog.listener()
    async def on_presence_update(self, before, after):
        if before.desktop_status != after.desktop_status:
            DBService().insert_presence_event(f'DESKTOP_STATUS','END' ,str(before.desktop_status), hash(before.id))
            DBService().insert_presence_event(f'DESKTOP_STATUS', 'START', str(after.desktop_status), hash(before.id))

        if before.activity != after.activity:
            if before.activity is None and after.activity is not None:
                DBService().insert_presence_event(str(after.activity.type), 'START', str(after.activity.name), hash(after.id))
            elif before.activity is not None and after.activity is None:
                DBService().insert_presence_event(str(before.activity.type), 'END', str(before.activity.name), hash(before.id))
            else:
                DBService().insert_presence_event(str(before.activity.type), 'END', str(before.activity.name), hash(before.id))
                DBService().insert_presence_event(str(after.activity.type), 'START', str(after.activity.name), hash(before.id))
        