#WoWRobot
The plugin-wielding, multipurpose Telegram bot.

The public bot runs on [@WoWRobot](https://telegram.me/WoWRobot). (In Portuguese)

It's based on [otouto](https://github.com/topkecleon/otouto).

##Support

Telegram [@Murkiriel](http://telegram.me/Murkiriel)

##Setup

```bash
# Tested on Ubuntu 15.10
sudo apt-get install lua5.2 liblua5.2-dev lua-socket lua-sec

git clone https://github.com/Murkiriel/WoWRobot.git
```

You **must** have Lua (5.2+), LuaSocket, and LuaSec installed. For uploading photos and other files, you must have curl installed. The fortune.lua plugin requires that fortune is installed.

For weather.lua, lastfm.lua, and bible.lua to work, you must have API keys for [OpenWeatherMap](http://openweathermap.org), [last.fm](http://last.fm), and [Biblia.com](http://biblia.com), respectively. cats.lua uses an API key (via [The Cat API](http://thecatapi.com)) to get more results, though it is not required.

**Before you do anything, open config.lua in a text editor and make the following changes:**

> • Set bot_api_key to the authentication token you received from the Botfather.
>
> • Use [@GO_Robot](https://telegram.me/GO_Robot) to find your telegram ID and add it to admin list.
>
> • Set admin as your Telegram ID.

You may also want to set your time_offset (a positive or negative number, in seconds, representing your computer's difference from UTC), your lang (lowercase, two-letter code representing your language), and modify your about_text. Some plugins will not be enabled by default, as they are for specific uses. If you want to use them, add them to the plugins table.

To start the bot, run `./launch.sh`. To stop the bot, press Ctrl+c twice.

You may also start the bot with `lua bot.lua`, but then it will not restart automatically.


* * *

![Lua](http://www.lua.org/images/powered-by-lua.gif)