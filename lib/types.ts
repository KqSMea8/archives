export interface DeviceData { [key: string]: any; }

export interface InstallConfig {
    wifiSsid?: string;
    wifiPassword?: string;
    serverUrl: string;
    deviceName: string;
    serial?: string;
    adapter: "wifi";
}

export abstract class Platform {
    public abstract async getDeviceData(deviceName: string): Promise<DeviceData>;
    public abstract async setDeviceData(deviceName: string, data: DeviceData): Promise<void>;
}

export abstract class Board {
    public abstract async build(repoDir: string, appDir: string): Promise<void>;
    public abstract async install(repoDir: string, appDir: string, config: InstallConfig): Promise<void>;
}

export interface DeployOptions {
    firebaseProject?: string;
}
