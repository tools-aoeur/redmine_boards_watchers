#!/bin/env ruby

require 'redmine'
require_relative 'lib/bw_asset_helpers'
require_relative 'lib/boards_watchers/patches'

unless Redmine::Plugin.registered_plugins.keys.include?(BwAssetHelpers::PLUGIN_NAME)
  Redmine::Plugin.register BwAssetHelpers::PLUGIN_NAME do
    name        'Manage watchers and sticky priority levels add-on'
    author      'Vitaly Klimov, Kim Pepper, Mikołaj Milej (orig)'
    author_url  'https://github.com/tools-aoeur'
    description 'Three levels of sticky messages and allows managing watchers of forums/topics/wikis'
    url         'https://github.com/tools-aoeur/redmine_boards_watchers'
    version     '1.0.5'
    requires_redmine version_or_higher: '5.0.0'

    project_module :boards do
      permission :delete_board_watchers, { boards_watchers: [:manage] }, require: :member
      permission :delete_message_watchers_bw, { boards_watchers: %i[manage_topic manage_topic_remote] },
                 require: :member
    end

    project_module :wiki do
      permission :delete_wiki_watchers, { boards_watchers: [:manage_wiki] }, require: :member
    end

    project_module :issue_tracking do
      permission :delete_issue_watchers_bw, { boards_watchers: %i[issues_watchers_bulk watch_bulk_issues] }
    end
  end

  require_relative 'lib/boards_watchers_hooks'
end
