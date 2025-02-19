import discord
from discord.ext import commands, tasks
import os
import asyncio

from __config_parse import TOKEN
from lib.cogs.event_cog import EventCog

intents = discord.Intents.all()
bot = commands.Bot(command_prefix='!', intents=intents)



@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name}')

async def main():
    async with bot:
        await bot.add_cog(EventCog(bot))
        # await bot.add_cog(event_cog(bot))
        # await bot.add_cog(token_cog(bot))
        # await bot.add_cog(trivia_cog(bot))
        await bot.start(TOKEN)

if __name__ == '__main__':
    asyncio.run(main())