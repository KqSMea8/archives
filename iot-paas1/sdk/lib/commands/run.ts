import * as os from "os";
import * as path from "path";
import { Supervisor } from "@makestack/supervisor";
import { FatalError } from "../types";
import { loadDeviceConfig } from "../config";

export async function main(args: any, opts: any, logger: any) {
    const device = loadDeviceConfig();
    if (!device) {
        throw new FatalError(`Run register command first!`)
    }

    console.log(`Launching as ${device.name}...`)

    let appNodePath = path.resolve(__dirname, '../../..')
    if (path.basename(appNodePath) !== 'node_modules') {
        // We're in the makestack git repo. Use <repo>/sdk/node_modules
        appNodePath = path.resolve(__dirname, '../../node_modules')
    }

    const supervisor = new Supervisor({
        mode: 'production',
        appDir: path.resolve(os.homedir(), ".makestack/app"),
        adapter: {
            name: opts.adapter,
            url: device.serverURL,
        },
        osVersion: 0,
        deviceId: device.device_id,
        deviceSecret: device.device_secret,
        heartbeatInterval: opts.heartbeatInterval,
        appNodePath
    });

    supervisor.start();
}
