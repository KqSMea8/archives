import * as util from "util";

function log(level: "DEBUG" |  "INFO" | "ERROR" | "WARN", ...messages: string[]) {
    const colors = {
        DEBUG: "35",
        INFO: "34",
        ERROR: "31",
        WARN: "33",
    };

    let body = "";
    for (const message of messages) {
        let fragment;
        if (typeof message === "string") {
            fragment = message;
        } else {
            fragment = util.inspect(message);
        }

        body += fragment + " ";
    }

    if (process.stdout.isTTY) {
        const time = (new Date()).toTimeString().split(" ")[0];
        const color = colors[level] || "";
        console.log(`[\x1b[1;32mruntime\x1b[0m ${time} \x1b[${color}m${level}\x1b[0m] ${body}`);
    } else {
        console.log(`[runtime] ${level}: ${body}`);
    }
}

function debug(...messages: any[]) {
    log("DEBUG", ...messages);
}

function info(...messages: any[]) {
    log("INFO", ...messages);
}

function error(...messages: any[]) {
    log("ERROR", ...messages);
}

function warn(...messages: any[]) {
    log("WARN", ...messages);
}

export const logger = {
    debug,
    info,
    error,
    warn
};
