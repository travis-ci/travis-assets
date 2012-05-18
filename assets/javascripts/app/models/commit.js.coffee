@Travis.Commit = Travis.Model.extend
  sha:             DS.attr('string')
  branch:          DS.attr('string')
  message:         DS.attr('string')
  compare_url:     DS.attr('string')
  author_email:    DS.attr('string')
  author_name:     DS.attr('string')
  committer_name:  DS.attr('string')
  committer_email: DS.attr('string')

  build: DS.belongsTo('Travis.Build')
