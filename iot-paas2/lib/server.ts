import { Request, Response } from "express";
import { Device } from "./device";

export type HTTPCallback = (req: Request, res: Response) => void;
export type BootCallback = (device: Device) => void;
export type HeartbeatCallback = (device: Device) => void;
export type EventCallback = (device: Device, value: any) => void;

export const endpoints: { [name: string]: HTTPCallback } = {};
export const callbacks = {
    boot: [] as BootCallback[],
    heartbeat: [] as HeartbeatCallback[],
    event: {} as { [event: string]: EventCallback },
};

export const http = {
    get(name: string, callback: HTTPCallback): void {
        endpoints[name] = callback;
    },
};

export const device = {
    onBoot(callback: HeartbeatCallback): void {
        callbacks.boot.push(callback);
    },

    onHeartbeat(callback: HeartbeatCallback): void {
        callbacks.heartbeat.push(callback);
    },

    onEvent(event: string, callback: EventCallback): void {
        callbacks.event[event] = callback;
    },
};
