module Potato
  class Device #(CAR)

    attr_reader :adb_device_arg, :automation_engine # (DieselEngine/ PetrolEngine)

    def initialize(adb_device_arg, automation_engine)
      @adb_device_arg = adb_device_arg
      @automation_engine = automation_engine
    end

    def uninstall_apps(packages)
      packages.each do |package|
        `#{adb_command} uninstall #{package}` if app_installed?(package)
      end
    end

    def reinstall_apps(packages, paths)
      uninstall_apps(packages)
      install_apps(paths)
    end

    def app_installed?(package_name)
      matching_packages = `#{adb_command} shell pm list packages | grep #{package_name}`.split
      res = matching_packages.include?("package:#{package_name}")
      res
    end

    def adb_command
      "adb -s #{@adb_device_arg}"
    end

    def reserve_port
      `#{adb_command} forward tcp:0 tcp:6790`.strip
    end

    def install_apps(paths)
      paths.each do |path|
        `#{adb_command} install #{path}`
      end
    end

    def start_aut
      @automation_engine.start
    end

    def stop_aut
      @automation_engine.stop
    end
  end
end