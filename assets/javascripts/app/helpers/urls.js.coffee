@Travis.Urls =
  repository: (repo) ->
    '#!/%@'.fmt repo.get('slug')

  builds: (repo) ->
    '#!/%@/builds'.fmt repo.get('slug')

  branches: (repo) ->
    '#!/%@/branches'.fmt repo.get('slug')

  pullRequests: (repo) ->
    '#!/%@/pull_requests'.fmt repo.get('slug')

  lastBuild: (repo) ->
    '#!/%@/builds/%@'.fmt repo.get('slug'), repo.get('last_build_id')

  build: (repo, build) ->
    '%@/builds/%@'.fmt @repository(repo), build.get('id')

  job: (repo, job) ->
    '%@/jobs/%@'.fmt @repository(repo), job.get('id')

  author: (commit) ->
    'mailto:%@'.fmt commit.get('author_email')

  committer: (commit) ->
    'mailto:%@'.fmt commit.get('committer_email')

  github: (repo) ->
    'http://github.com/%@'.fmt repo.get('slug')

  githubWatchers: (repo) ->
    'http://github.com/%@/watchers'.fmt repo.get('slug')

  githubNetwork: (repo) ->
    'http://github.com/%@/network'.fmt repo.get('slug')

  githubAdmin: (repo) ->
    'http://github.com/%@/admin/hooks#travis_minibucket'.fmt repo.get('slug')

  githubCommit: (repo, commit) ->
    'http://github.com/%@/commit/%@'.fmt repo.get('slug'), commit.get('sha')

  statusImage: (repo) ->
    '%@.png'.fmt repo.get('slug')
