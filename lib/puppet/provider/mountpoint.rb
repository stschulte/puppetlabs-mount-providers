class Puppet::Provider::Mountpoint < Puppet::Provider
  def exists?
    ! entry[:name].nil?
  end

  def create
    mount_with_options(resource[:device], resource[:name])
  end

  def destroy
    unmount(resource[:name])
  end

  def device
    entry[:device]
  end

  def device=(value)
    unmount(resource[:name])
    mount_with_options(resource[:device], resource[:name])
  end

  def refresh
    remount if resource[:ensure] == :present and exists?
  end

  private

  def mount_with_options(*args)
    options = resource[:options] && resource[:options] != :absent ? ["-o", resource[:options]] : []
    mount(*(options + args))
  end

  def entry
    raise Puppet::DevError, "Mountpoint entry method must be overridden by the provider"
  end

  def remount
    if resource[:remounts] == :true
      mount_with_options "-o", "remount", resource[:name]
    else
      unmount(resource[:name])
      mount_with_options(resource[:device], resource[:name])
    end
  end
end
