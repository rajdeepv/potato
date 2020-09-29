module Potato
  class Keystore
    attr_reader :keystore_location, :keystore_password, :keystore_alias

    def initialize(calabash_settings_path)
      details = JSON.parse(File.read(calabash_settings_path))
      @keystore_alias = details["keystore_alias"]
      @keystore_password = details["keystore_password"]
      @keystore_location = File.expand_path(details["keystore_location"])
    end
  end
end