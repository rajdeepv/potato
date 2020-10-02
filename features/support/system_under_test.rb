class SystemUnderTest
  class << self
    attr_accessor :device

    def connected_devices
      lines = `adb devices`.split("\n")
      start_index = lines.index { |x| x =~ /List of devices attached/ } + 1
      lines[start_index..-1].collect { |l| l.split("\t").first }
    end


    def adb_device_arg
      ENV.fetch('ADB_DEVICE_ARG',connected_devices.first)
    end

    def automation_engine
      ENV.fetch('AUTOMATION_TYPE')
    end

    def automation_type_appium?
      automation_engine == 'appium'
    end

    def automation_type_calab?
      automation_engine == 'calabash'
    end
  end
end