require_dependency 'application_helper' if ENV['RAILS_ENV'] == 'production'
require 'message'

module BoardsWatchers::Patches
  module StickyPriorityMessagePatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        safe_attributes 'sticky_priority',
                        if: ->(message, user) { user.allowed_to?(:edit_messages, message.project) }
      end
    end

    module InstanceMethods
      def sticky_priority=(arg)
        if sticky?
          new_priority = arg.to_i
          new_priority = 1 if new_priority == 0
          write_attribute :sticky_priority, new_priority
        else
          write_attribute :sticky_priority, 0
        end
      end

      def sticky_priority
        sp = read_attribute(:sticky_priority) || 0
        sp = 1 if sp == 0 && sticky?
        sp
      end
    end
  end

  module ApplicationHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        alias_method :render_page_hierarchy_without_watchers, :render_page_hierarchy
        alias_method :render_page_hierarchy, :render_page_hierarchy_with_watchers
      end
    end

    module InstanceMethods
      def render_page_hierarchy_with_watchers(pages, node = nil, options = {})
        content = ''
        if pages[node]
          content << "<ul class=\"pages-hierarchy\">\n"
          pages[node].each do |page|
            content << '<li>'
            content << link_to(h(page.pretty_title), { controller: 'wiki', action: 'show', project_id: page.project, id: page.title },
                               title: (options[:timestamp] && page.updated_on ? l(:label_updated_time, distance_of_time_in_words(Time.now, page.updated_on)) : nil))
            if authorize_for('boards_watchers', 'manage_wiki')
              content << link_to("(#{page.watcher_users.size})",
                                 { controller: 'boards_watchers', action: 'manage_wiki', project_id: @project, id: page.title }, class: (page.watcher_users.size > 0 ? 'icon icon-fav' : 'icon icon-fav-off'))
            end
            content << "\n" + render_page_hierarchy(pages, page.id, options) if pages[page.id]
            content << "</li>\n"
          end
          content << "</ul>\n"
        end
        content.html_safe
      end

      def reorder_links(name, url, method = :post)
        # TODO: why it has been remove from https://github.com/redmine/redmine/commit/4f10dc20e6600b907f97a0beada77b9193250bde

        ActiveSupport::Deprecation.warn 'Application#reorder_links will be removed in Redmine 4.'

        link_to(l(:label_sort_highest),
                url.merge({ "#{name}[move_to]" => 'highest' }), method: method,
                                                                title: l(:label_sort_highest), class: 'icon-only icon-move-top') +
          link_to(l(:label_sort_higher),
                  url.merge({ "#{name}[move_to]" => 'higher' }), method: method,
                                                                 title: l(:label_sort_higher), class: 'icon-only icon-move-up') +
          link_to(l(:label_sort_lower),
                  url.merge({ "#{name}[move_to]" => 'lower' }), method: method,
                                                                title: l(:label_sort_lower), class: 'icon-only icon-move-down') +
          link_to(l(:label_sort_lowest),
                  url.merge({ "#{name}[move_to]" => 'lowest' }), method: method,
                                                                 title: l(:label_sort_lowest), class: 'icon-only icon-move-bottom')
      end
    end
  end

  if Redmine::VERSION::MAJOR >= 5
    module MessagesControllerPatch
      def self.included(base) # :nodoc:
        base.send(:include, BoardsWatchers::MessagesActions)
        base.class_eval do
          unloadable
          alias_method :new_without_watchers, :new
          alias_method :new, :new_with_watchers

          alias_method :edit_without_watchers, :edit
          alias_method :edit, :edit_with_watchers

          alias_method :reply_without_watchers, :reply
          alias_method :reply, :reply_with_watchers
        end
      end
    end
  end
end

unless Message.included_modules.include? BoardsWatchers::Patches::StickyPriorityMessagePatch
  Message.include BoardsWatchers::Patches::StickyPriorityMessagePatch
end

if Rails.env.production? && !(ApplicationHelper.included_modules.include? BoardsWatchers::Patches::ApplicationHelperPatch)
  ApplicationHelper.include BoardsWatchers::Patches::ApplicationHelperPatch
end

unless MessagesController.included_modules.include? BoardsWatchers::Patches::MessagesControllerPatch
  MessagesController.include BoardsWatchers::Patches::MessagesControllerPatch
end
