json.extract! device, :name, :device_id, :device_secret, :tag, :device_type, :status, :created_at, :last_heartbeated_at, :updated_at
json.app device.app.try(:name) || nil
json.url device_url(device, format: :json)
