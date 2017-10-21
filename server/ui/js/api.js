import 'whatwg-fetch'

export default new class {
  constructor() {
    let dummyUser = { name: '', email: '' }
    this.user = JSON.parse(localStorage.getItem('user')) || dummyUser
    this.credentials = JSON.parse(localStorage.getItem('credentials'))
  }

  invoke(method, path, body, requiresCredentials = true) {
    let reqHeaders = Object.assign({}, this.credentials)

    if (requiresCredentials && (!this.user || !this.credentials)) {
      this.forceLogin()
    }

    if (typeof body !== 'string' && !(body instanceof FormData)) {
      body = JSON.stringify(body)
      Object.assign(reqHeaders, {
        'Content-Type': 'application/json'
      })
    }

    return new Promise((resolve, reject) => {
      let status
      let headers
      fetch(`/api/v1${path}`, {
        method,
        headers: reqHeaders,
        body
      }).then((response) => {
        status = response.status
        headers = response.headers
        return response
      }).then((response) => {
        if (response.status === 401 && app.$router.currentRoute.name !== 'login') {
          this.forceLogin((app.$router.currentRoute.name === 'home') ? null : 'Login first.')
        }
        return response
      }).then((response) => {
        return response.json()
      }).catch(error => {
        reject(new Error(`server returned ${status}" ${error}`))
      }).then((json) => {
        if (status >= 200 && status <= 299) {
          resolve({ status, headers, json })
        } else {
          reject(new Error(`server returned ${status}" ${json}`))
        }
      })
    })
  }

  logout() {
    localStorage.removeItem('user')
    localStorage.removeItem('credentials')
  }

  login(username, password) {
    return this.invoke('POST', '/auth/sign_in', {
      username: username,
      password: password
    }, false).then(r => {
      this.user = {
        username: username,
        email: r.json['data']['email']
      }

      this.credentials = {
        uid: r.headers.get('uid'),
        'access-token': r.headers.get('access-token'),
        'access-token-secret': r.headers.get('access-token-secret')
      }

      localStorage.setItem('credentials', JSON.stringify(this.credentials))
      localStorage.setItem('user', JSON.stringify(this.user))
    })
  }

  forceLogin(errmsg) {
    this.logout()
    app.$router.push({name: 'login'})
  }

  signup(username, email, password) {
    return this.invoke('POST', '/auth', {
      name: username,
      email: email,
      password: password
    }, false)
  }

  deleteUser(username) {
    return this.invoke('DELETE', '/auth', {
      name: username
    }, false)
  }

  resetPassword(email) {
    return this.invoke('POST', '/auth/password', {
      email: email,
      redirect_url: '/home'
    }, false)
  }

  getApps() {
    return this.invoke('GET', `/apps`)
  }

  getApp(appName) {
    return this.invoke('GET', `/apps/${appName}`)
  }

  getAppLog(appName, since = 0) {
    return this.invoke('GET', `/apps/${appName}/log?since=${since}`)
  }

  updateApp(appName, attrs) {
    return this.invoke('PUT', `/apps/${appName}`, attrs)
  }

  deleteApp(appName) {
    return this.invoke('DELETE', `/apps/${appName}`)
  }

  getIntegrations(appName) {
    return this.invoke('GET', `/apps/${appName}/integrations`)
  }

  createIntegration(appName, service, config, comment) {
    return this.invoke('POST', `/apps/${appName}/integrations`,
      { service, config, comment })
  }

  updateIntegration(appName, service, config, comment) {
    return this.invoke('PUT', `/apps/${appName}/integrations/${service}`,
      { service, config, comment })
  }

  deleteIntegration(appName, service) {
    return this.invoke('DELETE', `/apps/${appName}/integrations/${service}`)
  }

  getDevices() {
    return this.invoke('GET', `/devices`)
  }

  getDevice(deviceName) {
    return this.invoke('GET', `/devices/${deviceName}`)
  }

  getDeviceLog(deviceName) {
    return this.invoke('GET', `/devices/${deviceName}/log`)
  }

  getDeviceStores(deviceName) {
    return this.invoke('GET', `/devices/${deviceName}/stores`)
  }

  updateDeviceStore(deviceName, key, value) {
    return this.invoke('PUT', `/devices/${deviceName}/stores/${key}`,
      { value })
  }

  associateDeviceToApp(deviceName, appName) {
    return this.invoke('PATCH', `/devices/${deviceName}`, { device: { app_name: appName } })
  }

  deleteDevice(deviceName) {
    return this.invoke('DELETE', `/devices/${deviceName}`)
  }

  getDeployments(appName) {
    return this.invoke('GET', `/apps/${appName}/deployments`)
  }

  getDeployment(appName, version) {
    return this.invoke('GET', `/apps/${appName}/deployments/${version}`)
  }

  deploy(appName, image, debug, comment, tag) {
    let form = new FormData()
    form.set('deployment[image]', image, 'app.zip')

    if (debug) {
      form.set('deployment[debug]', debug)
    }

    if (comment) {
      form.set('deployment[comment]', comment)
    }

    if (tag) {
      form.set('deployment[tag]', tag)
    }

    return this.invoke('POST', `/apps/${appName}/deployments`, form)
  }

  createApp(appName, api) {
    return this.invoke('POST', `/apps`, {
      app: { name: appName, api: api }
    })
  }

  getFiles(appName) {
    return this.invoke('GET', `/apps/${appName}/files`)
  }

  saveFile(appName, path, body) {
    return this.invoke('PUT', `/apps/${appName}/files/${path}`, { body })
  }

  getAppStores(appName) {
    return this.invoke('GET', `/apps/${appName}/stores`)
  }

  createAppStore(appName, key, type, value) {
    return this.invoke('POST', `/apps/${appName}/stores`, {
      store: { key, data_type: type, value }
    })
  }

  updateAppStore(appName, key, value) {
    return this.invoke('PUT', `/apps/${appName}/stores/${key}`,
      { store: { value } })
  }
}()
