# Redmine Boards/Wiki/Issues Watchers Management and Sticky Groups Plugin

## Priority for Sticky Messages

This plugin adds the ability to select priority levels for sticky messages. Messages are sorted by priority level first and modification time second.

**Please run plugin migrations before use!**

## Boards and Topics Watchers Management

The plugin allows you to add/remove watchers for project forums and their individual topics. It also enables you to assign watchers when creating a message.

The watchers management screen allows you to add group members to watchers as well as look up and quickly select watchers by typing part of their names.

### Features Added

The plugin adds the following extra links/forms:

* Extra **Watchers** button in _Settings → Forums_ tab for each board, positioned before the _Edit_ and _Delete_ buttons
* Extra **Watchers** column in the list of forums
* Extra **Watchers** column in the list of topics for each forum
* Watchers management screen for new message forms

The number of watchers is displayed in parentheses after the watchers' icon.

### Required Permissions

To enable this feature, you should have the following permissions enabled for the role:

* **Manage board watchers** (_Boards_ section of permissions dialog) - enable this to allow board watchers management
* **Manage topic watchers** (_Boards_ section of permissions dialog) - enable this to allow individual topic watchers management

## Wiki Pages Watchers Management

The plugin allows you to add/remove watchers for wiki pages.

The watchers management screen allows you to add group members to watchers as well as look up and quickly select watchers by typing part of their names.

Watchers management is accessible from Wiki's _Index by title_ page. Each page link has a watcher's icon and the number of active watchers in parentheses. Click on the number to access the watchers management screen.

### Permissions

To enable this feature, you should have the following permission enabled for the role:

* **Manage wiki watchers** (_Wiki_ section of permissions dialog) - enable this to allow wiki pages watchers management for the given role

## Watchers Management for New Issue Dialog

The plugin replaces the original list of watchers in the new issue creation dialog with a more user-friendly version. The new watchers selection box allows you to add group members to watchers as well as look up and quickly select watchers by typing part of their names.

**Note:** Starting from version 1.4.0, the ability to add non-members as watchers to issues is not supported.

## Issues Context Menu for Quick Watchers Management

This plugin incorporates features from the [context_menu_watchers](http://www.redmine.org/plugins/redmine_context_menu_watchers) plugin.

The plugin adds a 'Watchers' submenu to the issues context menu, allowing you to perform various watcher-related operations on selected issues:

* **Watch** - add the current user as a watcher to selected issues
* **Unwatch** - remove the current user from watchers of selected issues
* **Add watchers** - select users and add them as watchers to selected issues
  * **Restrictions**: Selected issues should belong to the same project and the logged user should have 'Add watchers' permission
* **Delete watchers** - select users and remove them from the list of watchers for the selected issues
  * **Restrictions**: Selected issues should belong to the same project and the logged user should have 'Delete watchers' permission

## Patches and Changed Views

### Modified Views

The following views are modified:

* `boards/index.html.erb`
* `boards/show.html.erb`
* `issues/new.html.erb`
* `messages/_form.html.erb`
* `projects/_form.html.erb`
* `projects/settings/_boards.html.erb`

### Patched Controllers/Models

The following controllers/models are patched:

* `boards_controller` (show)
* `messages_controller` (new, edit)
* `message` (sticky_priority attribute)

## Installation

1. Install the [Plugin views with revisions](http://www.redmine.org/plugins/redmine_plugin_views_revisions) plugin first, as this plugin depends on it
2. Run plugin migrations:

   ```bash
   rake db:migrate_plugins RAILS_ENV=production
   ```

3. Run rake task to compile correct views:

   ```bash
   rake redmine:plugins:process_version_change RAILS_ENV=production
   ```

**Important:** If you upgrade Redmine after installing this plugin, please run the rake tasks above after the upgrade.
