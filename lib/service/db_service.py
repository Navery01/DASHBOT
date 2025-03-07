from datetime import datetime
import mysql.connector as mysql
from mysql.connector import errorcode

from __config_parse import CONFIG

class DBService:



    def insert_user(self, guild_id, user_id, user_name):
        conn = mysql.connect(**CONFIG['MYSQL'])
        cursor = conn.cursor(buffered=True)
        try:
            print(f'[SQL] Inserting user {user_name}')
            cursor.execute("INSERT INTO DiscordUser (UserID, GuildID, UserName, DateJoined) VALUES (%s, %s, %s, %s);", (user_id, guild_id, user_name, datetime.now()))
            print('[SQL] User added')
        except mysql.Error as err:
            if err.errno == errorcode.ER_NO_SUCH_TABLE:
                print(f"Error: Table 'users' does not exist.")
            else:
                print(err.msg)
        cursor.close()
        conn.commit()
        conn.close()

    
    def insert_guild(self, guild_id, guild_name):
        conn = mysql.connect(**CONFIG['MYSQL'])
        cursor = conn.cursor(buffered=True)
        try:
            cursor.execute("INSERT INTO DiscordGuild (GuildID, GuildName) VALUES (%s, %s);", (guild_id, guild_name))
            print('[SQL] Guild added')
        except mysql.Error as err:
            if err.errno == errorcode.ER_NO_SUCH_TABLE:
                print(f"Error: Table 'guilds' does not exist.")
            else:
                print(err.msg)
        cursor.close()
        conn.commit()
        conn.close()
    
    #TODO: This method is correct. Fix the other methods to match this one.
    def insert_message(self, guild_id, user_id, message, channel_name, is_truncated, is_image):
        conn = mysql.connect(**CONFIG['MYSQL'])
        cursor = conn.cursor(buffered=True)
        try:
            cursor.execute("INSERT INTO DiscordMessageEvent (GuildID, UserID, MessageContent, ChannelName, IsTruncated, IsImage) VALUES (%s, %s, %s, %s, %s, %s);", (guild_id, user_id, message, channel_name, is_truncated, is_image))
            print('[SQL] Message added')
        except mysql.Error as err:
            if err.errno == errorcode.ER_NO_SUCH_TABLE:
                print(f"Error: Table 'messages' does not exist.")
            else:
                print(err.msg)
        cursor.close()
        conn.commit()
        conn.close()

    def insert_voice_channel_event(self, event_type, from_channel, to_channel, user_id, guild_id):
        conn = mysql.connect(**CONFIG['MYSQL'])
        cursor = conn.cursor(buffered=True)
        try:
            cursor.execute("INSERT INTO DiscordVoiceChannelEvent (EventType, FromChannelName, ToChannelName, UserID, GuildID, EventTimestamp) VALUES (%s, %s, %s, %s, %s, %s);", (event_type, from_channel, to_channel, user_id, guild_id, datetime.now()))
            print('[SQL] Channel event added')
        except mysql.Error as err:
            if err.errno == errorcode.ER_NO_SUCH_TABLE:
                print(f"Error: Table 'channel_events' does not exist.")
            else:
                print(err.msg)
        cursor.close()
        conn.commit()
        conn.close()
    
    def insert_presence_event(self, event_type, from_channel, to_channel, user_id, guild_id):
        conn = mysql.connect(**CONFIG['MYSQL'])
        cursor = conn.cursor(buffered=True)
        try:
            cursor.execute("INSERT INTO DiscordActivityEvent (EventType, EventDescr, EventText, UserID, GuildID, EventTimestamp) VALUES (%s, %s, %s, %s, %s, %s);", (event_type, from_channel, to_channel, user_id, guild_id, datetime.now()))
            print('[SQL] Presence event added')
        except mysql.Error as err:
            if err.errno == errorcode.ER_NO_SUCH_TABLE:
                print(f"Error: Table 'channel_events' does not exist.")
            else:
                print(err.msg)
        cursor.close()
        conn.commit()
        conn.close()


if __name__ == '__main__':
    db = DBService()
