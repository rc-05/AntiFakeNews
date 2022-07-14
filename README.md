# Anti Fake News Telegram Bot

This bot checks for fake news sites posted on a Telegram chat,
deletes the message and warns the user who posted said message.

It can be hosted on your machine, provided that you supply your
own bot token and black list file.

## Build Requirements

- [Haxe](https://haxe.org)
- [Neko](https://nekovm.com)

## Build Instructions

Simply run either `haxe debug.hxml` or `haxe release.hxml` to create
a debug or release binary respectively.

Run the __release build__ without arguments to see the command line args.

## Debugging

- Open the project directory in VSCode/VSCodium (make sure that the Haxe and HXCPP debugger extensions are installed).
- Run the build task `haxe: debug.hxml` or choose the `debug.hxml` configuration and run `haxe: active configuration` task.
- Run the HXCPP debugger via the graphical menu or with the `F5` key.

The debug build expects to find the `config.json` and `black_list.txt` files
inside the `extra/` folder.

## Configuration

The bot requires two files to work: a `config.json` which contains the locale and
the bot token and a `black_list.txt` file which contains all the fake news sites that
need to be handled.

These two files must be passed to the command line to be read, as said
earlier, as parameters to cmd line arguments.

### Supported Languages

- English (`en`)
- Italiano (`it`)

If the locale is not specified the bot will fallback to the English language.

## License

This project is licensed with the [GPL v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

## Credits

- butac.it and the [following repo](https://github.com/flodd/butac_black_list) for supplying the
black_list.json file where the black_list.txt file was created from.
