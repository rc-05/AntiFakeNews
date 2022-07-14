/*
	Anti Fake News Telegram Bot
	Copyright (C) 2022 rc-05

	This program is free software: you can redistribute it and/or modify it under
	the terms of the GNU General Public License as published by the Free Software Foundation,
	either version 3 of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with this program.
	If not, see <https://www.gnu.org/licenses/>.
 */

import telegram.types.Core.User;
import haxe.Log;
#if !debug
import hxargs.Args;
#end
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import telegram.Bot;
import telegram.types.Core.Message;

typedef ConfigFile = {
	token:String,
	locale:String
}

class AntiFakeNews extends Bot {
	var config:ConfigFile;
	var blackList:Array<String>;

	public function new() {
		#if debug
		var content = File.getContent("../extra/config.json");
		config = Json.parse(content);
		blackList = File.getContent("../extra/black_list.txt").split("\n");
		#else
		parseCmdLine();
		#end

		super(config.token);
	}

	#if !debug
	function parseCmdLine() {
		var cmdArgsHandler = Args.generate([@doc("JSON config file path")
			["-json"] => function(arg:String) {
				if (FileSystem.exists(arg)) {
					var content = File.getContent(arg);
					config = Json.parse(content);
				}
			}, @doc("Black list file path")
			["-blacklist"] => function(arg:String) {
				if (FileSystem.exists(arg)) {
					blackList = File.getContent(arg).split("\n");
				}
			}
		]);

		var cmdArgs = Sys.args();
		if (cmdArgs.length == 0) {
			Sys.println(cmdArgsHandler.getDoc());
			Sys.exit(0);
		} else {
			cmdArgsHandler.parse(cmdArgs);
		}
	}
	#end

	override public function onMessageEvent(message:Message) {
		// Taken from https://ihateregex.io/expr/url/
		final urlRegex = ~/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/;

		trace('${message.chat.id}');

		if (message.chat.type == "group" || message.chat.type == "supergroup") {
			if (urlRegex.match(message.text)) {
				searchFakeNews(message, urlRegex.matched(0));
			}
		}
	}

	function searchFakeNews(message:Message, url:String) {
		for (entryUrl in blackList) {
			if (entryUrl == url) {
				deleteMessage(message.chat.id, message.message_id);
				switch (config.locale) {
					case "en":
						sendMessage(message.chat.id, 'Fake news site detected, don\'t try it anymore @${message.from.username}');
					case "it":
						sendMessage(message.chat.id, 'Sito di bufale individuato, non ci provare più @${message.from.username}');
					default:
						// Fall back to english locale if not explicitly set.
						sendMessage(message.chat.id, 'Fake news site detected, don\'t try it anymore @${message.from.username}');
				}
				logFoundSite(url, message.from);
			}
		}
	}

	function logFoundSite(url:String, from:User) {
		Sys.println('[${Date.now().toString()}] Found fake news site $url posted by @${from.username}');
	}

	static function main() {
		var bot = new AntiFakeNews();
		bot.start();
	}
}
