module BwAssetHelpers
  PLUGIN_NAME = File.expand_path('../*', __dir__).match(%r{.*/(.*)/\*$})[1].to_sym

  def self.plugin_asset_link(asset_name, options = {})
    plugin_name = (options[:plugin] || PLUGIN_NAME)
    File.join(Redmine::Utils.relative_url_root, 'plugin_assets', plugin_name.to_s, asset_name)
  end
end
