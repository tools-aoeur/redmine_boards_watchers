RedmineApp::Application.routes.draw do
  match 'projects/:project_id/boards/:board_id/manage', to: 'boards_watchers#manage', via: %i[get post]
  match 'projects/:project_id/boards/:board_id/manage_topic', to: 'boards_watchers#manage_topic',
                                                              via: %i[get post]
  match 'projects/:project_id/boards/:board_id/manage_topic_remote', to: 'boards_watchers#manage_topic_remote',
                                                                     via: %i[get post]
  match 'projects/:project_id/manage_wiki/:id', to: 'boards_watchers#manage_wiki', via: %i[get post]
  match 'boards_watchers/issues_watchers_bulk', to: 'boards_watchers#issues_watchers_bulk', via: %i[get post]
  match 'boards_watchers/watch_bulk_issues', to: 'boards_watchers#watch_bulk_issues', via: %i[get post]
end
