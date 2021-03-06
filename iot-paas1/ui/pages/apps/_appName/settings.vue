<template>
  <dashboard-layout title="Settings" :appName="appName" inverted-bg="true">
    <header>
      <h2>{{ appName }}</h2>
    </header>
    <nuxt-link :to="{ name: 'apps-appName', params: { name: appName } }">
      <i class="fas fa-chevron-left"></i>
      Return to Code
    </nuxt-link>

    <tabs>
      <tab name="General">
        <div class="sections">
          <section>
            <header>
              <h1>Editor Mode</h1>
            </header>
            <div class="content">
              <form @submit.prevent="saveEditorMode">
                <select v-model="editor">
                  <option v-for="(title, value) in editors" :key="value" :value="value">{{ title }}</option>
                </select>
                <input type="submit" value="Save" class="primary">
              </form>
            </div>
          </section>
        </div>
      </tab>
      <tab name="Integrations">
        <div class="sections">
          <section>
            <header>
              <h1>IFTTT</h1>
              <span class="integration-status" :class="{ activated: ifttt.activated }">
                <i class="fas" :class="[ifttt.activated ? 'fa-check' : 'fa-times']"></i>
                {{ ifttt.activated ? 'activated' : 'unconfigured' }}
              </span>
            </header>
            <div class="content">
              <p>IFTTT is a popular platform that enables you to integrate MakeStack apps and external services:
                SMS, Gmail, Google Sheets, Philips Hue, etc. To integrate with IFTTT you need
                <a href="https://ifttt.com/maker_webhooks">an IFTTT webhook key</a>.
              </p>
              <form @submit.prevent="updateIftttIntegration" v-if="!ifttt.activated">
                <input type="text" v-model="ifttt.key" placeholder="IFTTT Webhook Key">
                <input type="submit" value="Save" class="primary">
              </form>
              <div v-else>
                <p>IFTTT integration is activated. The API key is <code>{{ ifttt.key }}</code></p>
                <button @click="deleteIftttIntegration" class="danger">Delete IFTTT Integration</button>
              </div>
            </div>
          </section>
          <section>
            <header>
              <h1>ThingSpeak</h1>
              <span class="integration-status" :class="{ activated: thingSpeak.activated }">
                <i class="fas" :class="[thingSpeak.activated ? 'fa-check' : 'fa-times']"></i>
                {{ thingSpeak.activated ? 'activated' : 'unconfigured' }}
              </span>
            </header>
            <div class="content">
              <p>
                ThingSpeak is an easy-to-use IoT platform to collect and visualize data like temperature. Note that
                event name (<code>publish</code> API) must be one of <code>field1</code>, <code>field2</code>, ..., or <code>field8</code>.
              </p>
              <form @submit.prevent="updateThingSpeakIntegration" v-if="!thingSpeak.activated">
                <input type="text" v-model="thingSpeak.write_api_key" placeholder="ThingSpeak Write API Key">
                <input type="submit" value="Save" class="primary">
              </form>
              <div v-else>
                <p>ThingSpeak integration is activated. The write API key is <code>{{ thingSpeak.write_api_key }}</code></p>
                <button @click="deleteThingSpeakIntegration" class="danger">Delete ThingSpeak Integration</button>
              </div>
            </div>
          </section>
          <section>
            <header>
              <h1>Slack</h1>
              <span class="integration-status" :class="{ activated: slack.activated }">
                <i class="fas" :class="[slack.activated ? 'fa-check' : 'fa-times']"></i>
                {{ slack.activated ? 'activated' : 'unconfigured' }}
              </span>
            </header>
            <div class="content">
              <p>
                MakeStack sends events published by devices to <a href="">Slack Incoming Webhook</a>.
              </p>
              <form @submit.prevent="updateSlackIntegration" v-if="!slack.activated">
                <input type="text" v-model="slack.url" placeholder="Webhook URL (https://hooks.slack.com/services/XXXXXX/YYYYYYY)">
                <input type="submit" value="Save" class="primary">
              </form>
              <div v-else>
                <p>Slack integration is activated: The URL is <code>{{ slack.url }}</code></p>
                <button @click="deleteSlackIntegration" class="danger">Delete Slack Integration</button>
              </div>
            </div>
          </section>
          <section>
            <header>
              <h1>Outgoing Webhook</h1>
              <span class="integration-status" :class="{ activated: outgoingWebhook.activated }">
                <i class="fas" :class="[outgoingWebhook.activated ? 'fa-check' : 'fa-times']"></i>
                {{ outgoingWebhook.activated ? 'activated' : 'unconfigured' }}
              </span>
            </header>
            <div class="content">
              <p>
                MakeStack sends POST requests to the specified url when a device published an event.
              </p>
              <form @submit.prevent="updateOutgoingWebhookIntegration" v-if="!outgoingWebhook.activated">
                <input type="text" v-model="outgoingWebhook.url" placeholder="Webhook URL">
                <input type="submit" value="Save" class="primary">
              </form>
              <div v-else>
                <p>Outgoing Webhook integration is activated: The URL is <code>{{ outgoingWebhook.url }}</code></p>
                <button @click="deleteOutgoingWebhookIntegration" class="danger">Delete Outgoing Webhook Integration</button>
              </div>
            </div>
          </section>
        </div>
      </tab>
      <tab name="Config">
        <h2>Config</h2>
        <p>
          Config are synchronized with all devices that belong to {{ appName }}. To use config read
          <a href="https://makestack.org/documentation/#/api?id=config">Config API documentation</a>.
        </p>

        <table>
          <thead>
            <tr>
              <th>Key</th>
              <th>Type</th>
              <th>Value</th>
              <th class="actions-column"></th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="config in configs" :key="config.key">
              <td>{{ config.key }}</td>
              <td>
                <select v-if="config.editing" v-model="config.data_type">
                  <option value="string">String</option>
                  <option value="integer">Integer</option>
                  <option value="float">Float</option>
                  <option value="bool">Boolean</option>
                </select>
                <span v-else>{{ config.data_type }}</span>
              </td>

              <td>
                <input v-if="config.editing" type="text" v-model="config.value">
                <code v-else>{{ config.value }}</code>
              </td>

              <td class="actions">
                <button v-if="config.editing" @click="updateConfig(config)" class="btn btn-primary">
                  <i class="fa fa-check" aria-hidden="true"></i>
                  Save
                </button>

                <button v-else @click="config.editing = !config.editing" class="btn btn-default">
                  <i class="fa fa-pencil" aria-hidden="true"></i>
                  Edit
                </button>

                <button v-if="config.editing" @click="config.editing = !config.editing">
                  <i class="fa fa-ban" aria-hidden="true"></i>
                  Cancel
                </button>

                <button v-else @click="deleteConfig(config)" class="btn btn-danger">
                  <i class="fa fa-trash" aria-hidden="true"></i>
                </button>
              </td>
            </tr>
            <tr class="secondary-row">
                <td>
                  <input type="text" v-model="newConfig.key" placeholder="Key" class="small">
                </td>
                <td>
                  <select v-model="newConfig.dataType" class="small">
                    <option value="string">String</option>
                    <option value="integer">Integer</option>
                    <option value="float">Float</option>
                    <option value="bool">Boolean</option>
                  </select>
                </td>
                <td>
                  <input type="text" v-model="newConfig.value" placeholder="Value" class="small">
                </td>
                <td>
                  <button @click="createConfig" class="primary small">
                    <i class="fas fa-plus"></i>
                    Add
                  </button>
                </td>
            </tr>
          </tbody>
        </table>
      </tab>
      <tab name="Actions">
        <div class="sections">
          <section>
            <header>
              <h1>Update OS</h1>
            </header>
            <div class="content">
              <p>Sends an os update request to devices. Note that you can't downgrading. Current os version is {{ app.osVersion }}.</p>
              <form @submit.prevent="updateOS">
                <select v-model="app.os_version">
                  <option v-for="(release, version) in releases" :key="version">{{ version }}</option>
                </select>
                <input type="submit" value="Update OS" class="primary">
              </form>
            </div>
          </section>
          <section>
            <header>
              <h1>Remove app</h1>
            </header>
            <div class="content">
              <p>This action can't be reverted. Be careful!</p>
              <button class="danger simple" @click="removeApp">Remove App</button>
            </div>
          </section>
        </div>
      </tab>
    </tabs>
  </dashboard-layout>
</template>

<script>
import api from "~/assets/js/api"
import DashboardLayout from "~/components/dashboard-layout"
import Tabs from "~/components/tabs"
import Tab from "~/components/fragments/tab"
import releases from "~/../releases"

export default {
  components: { DashboardLayout, Tabs, Tab },
  data() {
    return {
      appName: this.$route.params.appName,
      releases,
      editor: '',
      editors: {
        code: 'Code Editor',
        flow: 'Flow Editor (Experimental)'
      },
      app: {},
      configs: [],
      newConfig: {
        type: 'string'
      },
      ifttt: {
        activated: false,
        key: ''
      },
      thingSpeak: {
        activated: false,
        write_api_key: ''
      },
      slack: {
        activated: false,
        url: ''
      },
      outgoingWebhook: {
        activated: false,
        url: ''
      }
    }
  },
  methods: {
    async updateOS() {
      await api.updateApp(this.appName, { os_version: this.app.os_version })
    },
    async saveEditorMode() {
      await api.updateApp(this.appName, { editor: this.editor })
    },
    async removeApp() {
      await api.deleteApp(this.appName)
    },
    async createConfig() {
      await api.updateAppConfig(
              this.appName,
              this.newConfig.key,
              this.newConfig.dataType,
              this.newConfig.value)

      await this.refreshAppConfigs()
    },
    async updateConfig(config) {
      await api.updateAppConfig(
              this.appName,
              config.key,
              config.data_type,
              config.value)
      await this.refreshAppConfigs()
    },
    async deleteConfig(config) {
      await api.deleteAppConfig(this.appName, config.key)
      await this.refreshAppConfigs()
    },
    async refreshAppConfigs() {
      this.configs = (await api.getAppConfigs(this.appName)).map(config => {
        config.editing = false
        return config
      })
    },
    async updateIftttIntegration() {
      const args = [
        this.appName,
        'ifttt',
        {
        key: this.ifttt.key
        }
      ]

      if (this.ifttt.activated) {
        await api.updateIntegration(...args)
      } else {
        await api.createIntegration(...args)
      }

      await this.refreshIntegrations()
    },
    async deleteIftttIntegration() {
      await api.deleteIntegration(this.appName, 'ifttt')
      await this.refreshIntegrations()
    },
    async updateThingSpeakIntegration() {
      const args = [
        this.appName,
        'thing_speak',
        {
          write_api_key: this.thingSpeak.write_api_key
        }
      ]

      if (this.thingSpeak.activated) {
        await api.updateIntegration(...args)
      } else {
        await api.createIntegration(...args)
      }

      await this.refreshIntegrations()
    },
    async deleteThingSpeakIntegration() {
      await api.deleteIntegration(this.appName, 'thing_speak')
      await this.refreshIntegrations()
    },
    async updateSlackIntegration() {
      const args = [
        this.appName,
        'slack',
        {
          webhook_url: this.slack.url
        }
      ]

      if (this.slack.activated) {
        await api.updateIntegration(...args)
      } else {
        await api.createIntegration(...args)
      }

      await this.refreshIntegrations()
    },
    async deleteSlackIntegration() {
      await api.deleteIntegration(this.appName, 'slack')
      await this.refreshIntegrations()
    },
    async updateOutgoingWebhookIntegration() {
      const args = [
        this.appName,
        'outgoing_webhook',
        {
          webhook_url: this.outgoingWebhook.url
        }
      ]

      if (this.outgoingWebhook.activated) {
        await api.updateIntegration(...args)
      } else {
        await api.createIntegration(...args)
      }

      await this.refreshIntegrations()
    },
    async deleteOutgoingWebhookIntegration() {
      await api.deleteIntegration(this.appName, 'outgoing_webhook')
      await this.refreshIntegrations()
    },
    async refreshIntegrations() {
      const integrations = await api.getIntegrations(this.appName)
      this.ifttt.activated = false;
      this.thingSpeak.activated = false;
      this.slack.activated = false;
      this.outgoingWebhook.activated = false;

      for (const integration of integrations) {
        const config = JSON.parse(integration.config)
        switch (integration.service) {
          case 'ifttt':
            this.ifttt.activated = true;
            this.ifttt.key = config.key;
            break;
          case 'thing_speak':
            this.thingSpeak.activated = true;
            this.thingSpeak.write_api_key = config.write_api_key;
            break;
          case 'slack':
            this.slack.activated = true;
            this.slack.url = config.webhook_url;
            break;
          case 'outgoing_webhook':
            this.outgoingWebhook.activated = true;
            this.outgoingWebhook.url = config.webhook_url;
            break;
        }
      }
    }
  },

  async mounted() {
    this.app = await api.getApp(this.appName)
    this.editor = this.app.editor
    await this.refreshAppConfigs()
    await this.refreshIntegrations()
  }
};
</script>

<style lang="scss">
.integration-status {
  font-weight: 700;
  color: var(--fg1-color);

  &.activated {
    color: var(--positive-color);
  }
}
</style>
