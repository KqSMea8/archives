FactoryGirl.define do
  factory :device do
    user
    name { FFaker::InternetSE.slug.gsub(".", "-") }
    device_id        { Digest::SHA256.hexdigest(FFaker::Internet.email)[0, Device::DEVICE_ID_LEN] }
    device_id_prefix { device_id[0, Device::DEVICE_ID_PREFIX_LEN] }
    device_secret    { Digest::SHA256.hexdigest(FFaker::Internet.email) }
    device_type "mock"
    status "new"
  end
end
