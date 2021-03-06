import * as addDeviceCommand from "./commands/add_device";
import * as appCommand from "./commands/app";
import * as configCommand from "./commands/config";
import * as deployCommand from "./commands/deploy";
import * as deployImageCommand from "./commands/deploy_image";
import * as deviceCommand from "./commands/device";
import * as deviceConfigCommand from "./commands/device_config";
import * as installCommand from "./commands/install";
import * as listDrivesCommand from "./commands/list_drives";
import * as loginCommand from "./commands/login";
import * as newCommand from "./commands/new";
import * as addPluginCommand from "./commands/add_plugin";
import * as newPluginCommand from "./commands/new_plugin";
import * as replCommand from "./commands/repl";
import * as runCommand from "./commands/run";
import * as registerCommand from "./commands/register";
import { api } from "./api";
import * as fs from "fs";
import * as path from "path";
const program = require("caporal");

program
.version(
    JSON.parse(fs.readFileSync(
        path.resolve(__dirname, '../package.json'), { encoding: 'utf-8' }
    )).version,
)
.description('A MakeStack CLI Developer Tools.');

program
.command("login", "Get an access credential for an MakeStack Server account.")
.action(loginCommand.main);

program
.command("app list", "List apps.")
.action(appCommand.list);

program
.command("app create", "Create an app.")
.argument("name", "The app name.")
.option("--api <api>", "The API.", /^nodejs$/, 'nodejs')
.action(appCommand.create);

program
.command("app delete", "Delete an app.")
.argument("name", "The app name.")
.action(appCommand.delete_);

program
.command("config list", "List app configs.")
.option("--app-dir <app-dir>", "The app directory.", null, process.cwd())
.action(configCommand.list);

program
.command("config set", "Create/Update an app config.")
.argument("name", "The config name.")
.argument("value", "The value.")
.option("--type <type>", "The value data type. (string, integer, float, or bool)", /string|integer|float|bool/, null, true)
.option("--app-dir <app-dir>", "The app directory.", null, process.cwd())
.action(configCommand.set);

program
.command("config delete", "Delete an app config.")
.argument("name", "The config name.")
.option("--app-dir <app-dir>", "The app directory.", null, process.cwd())
.action(configCommand.delete_);

program
.command("device list", "List devices.")
.action(deviceCommand.list);

program
.command("device delete", "Delete an device.")
.argument("name", "The device name.")
.action(deviceCommand.delete_);

program
.command("device-config list", "List device-local configs.")
.argument("--device-name <device-name>", "The device name.")
.action(deviceConfigCommand.list);

program
.command("device-config set", "Create/Update an device-local config.")
.option("--device-name <device-name>", "The device name.", null, null, true)
.option("--type <type>", "The value data type. (string, integer, float, or bool)", /string|integer|float|bool/, null, true)
.argument("name", "The config name.")
.argument("value", "The value.")
.action(deviceConfigCommand.set);

program
.command("device-config delete", "Delete an device-local config.")
.argument("--device-name <device-name>", "The device name.")
.argument("name", "The config name.")
.action(deviceConfigCommand.delete_);

program
.command("deploy", "Deploy the app.")
.option("--app-dir <app-dir>", "The app directory.", null, process.cwd())
.action(deployCommand.main);

program
.command("deploy-image", "Deploy the app with a prebuilt image.")
.option("--app <app>", "The app name.", null, process.cwd())
.argument("image", "The prebuilt image.")
.action(deployImageCommand.main);

program
.command("add-device", "Add an device to the app.")
.argument("name", "The device name.")
.option("--app <app>", "The app name.", null, path.basename(process.cwd()))
.action(addDeviceCommand.main);

program
.command("register", "Register as a device.")
.option("--server <server>", "The server URL (starts with http:// or https://)",
    /^https?:\/\//, null, true)
.option("--username <username>", "The user name.", null, null, true)
.option("--app <app>", "The app name.", null, null, true)
.option("--name <app>", "The device name.", null, null, true)
.action(registerCommand.main);

program
.command("run", "Run as a device.")
.option("--adapter <adapter>", "The network adapter.", /^http|sakuraio$/, "http")
.option("--heartbeat-interval <seconds>", "The interval of heartbeats.", null, 5)
.action(runCommand.main);

program
.command("repl", "A Read-Eval-Print-Loop (REPL) console.")
.argument("name", "The device name.")
.action(replCommand.main);

program
.command("list-drives", "List available drives to install MakeStack OS/Linux.")
.action(listDrivesCommand.main);

const countryCodes = [
    "AF", "AX", "AL", "DZ", "AS", "AD", "AO", "AI", "AQ", "AG", "AR", "AM", "AW", "AU", "AT", "AZ", "BS", "BH", "BD",
    "BB", "BY", "BE", "BZ", "BJ", "BM", "BT", "BA", "BW", "BV", "BR", "IO", "BN", "BG", "BF", "BI", "KH", "CM", "CA",
    "CV", "KY", "CF", "TD", "CL", "CN", "CX", "CC", "CO", "KM", "CG", "CK", "CR", "CI", "HR", "CU", "CW", "CY", "CZ",
    "DK", "DJ", "DM", "DO", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FO", "FJ", "FI", "FR", "GF", "PF", "TF",
    "GA", "GM", "GE", "DE", "GH", "GI", "GR", "GL", "GD", "GP", "GU", "GT", "GG", "GN", "GW", "GY", "HT", "HM", "VA",
    "HN", "HK", "HU", "IS", "IN", "ID", "IQ", "IE", "IM", "IL", "IT", "JM", "JP", "JE", "JO", "KZ", "KE", "KI", "KW",
    "KG", "LA", "LV", "LB", "LS", "LR", "LY", "LI", "LT", "LU", "MO", "MG", "MW", "MY", "MV", "ML", "MT", "MH", "MQ",
    "MR", "MU", "YT", "MX", "MC", "MN", "ME", "MS", "MA", "MZ", "MM", "NA", "NR", "NP", "NL", "NC", "NZ", "NI", "NE",
    "NG", "NU", "NF", "MP", "NO", "OM", "PK", "PW", "PA", "PG", "PY", "PE", "PH", "PN", "PL", "PT", "PR", "QA", "RE",
    "RO", "RU", "RW", "BL", "KN", "LC", "MF", "PM", "VC", "WS", "SM", "ST", "SA", "SN", "RS", "SC", "SL", "SG", "SX",
    "SK", "SI", "SB", "SO", "ZA", "GS", "SS", "ES", "LK", "SD", "SR", "SJ", "SZ", "SE", "CH", "SY", "TJ", "TH", "TL",
    "TG", "TK", "TO", "TT", "TN", "TR", "TM", "TC", "TV", "UG", "UA", "AE", "GB", "US", "UM", "UY", "UZ", "VU", "VN",
    "WF", "EH", "YE", "ZM", "ZW", "BO", "BQ", "CD", "IR", "KP", "KR", "MK", "FM", "MD", "PS", "SH", "TW", "TZ", "VE",
    "VG", "VI",
];

function wifiCountryNameValidator(code: string) {
    if(!(countryCodes.includes)) {
        throw new Error(`Invalid country code: \`${code}'`);
    }

    return code;
}

program
.command("install", "Install MakeStack OS/Linux to the device.")
.option("--name <name>", "The device name.", null, null, true)
.option("--app <name>", "The app name.")
.option("--type <type>", "The device type.", /^raspberrypi3|esp32$/, null, true)
.option("--drive <drive>", "The drive. Use `list-drives' command.", null, null, true)
.option("--adapter <adapter>", "The network adapter.", /^http|sakuraio$/, "http")
.option("--wifi-ssid <wifi-ssid>", "The Wi-Fi SSID.")
.option("--wifi-password <wifi-password>", "The Wi-Fi password. (WPA/WPA2 Personal)")
.option("--wifi-country <wifi-country>", "The Wi-Fii country code. (ISO/IEC alpha2 country code)", wifiCountryNameValidator)
.option("--image <image>", "The path to disk image.")
.option("--url <url>", "The server URL.", null, api.serverURL)
.action(installCommand.main);

program
.command("new", "Create an app directory with template files.")
.argument("dir", "The plugin directory.")
.option("--register", "Register the app on server.")
.option("--api <api>", "The API.", /^nodejs$/, 'nodejs')
.action(newCommand.main);

program
.command("add-plugin", "Add a plugin.")
.argument("plugin", "The plugin name.")
.option("--app-dir <app-dir>", "The app directory.", null, process.cwd())
.action(addPluginCommand.main);

program
.command("new-plugin", "Create a plugin directory with template files.")
.argument("dir", "The plugin directory.")
.option("--lang <lang>", "The programming language.", /^typescript|javascript$/, "typescript")
.action(newPluginCommand.main);

export async function run(argv: string[]): Promise<{}> {
    return new Promise((resolve, reject) => {
        program.fatalError = reject;
        program.parse(argv).then(resolve);
    });
}
