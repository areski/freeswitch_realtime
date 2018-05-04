
File.exists?(Path.expand("~/.iex.exs")) && import_file("~/.iex.exs")

{:ok, db} = Sqlitex.open('/home/areski/private/bitbucket/newfies-dialer/playground/channels/coredb.sqlite')

Sqlitex.query(db,
                 "SELECT count(*) as count, campaign_id, leg_type " <>
                 "FROM channels WHERE leg_type > 0 GROUP BY campaign_id, leg_type;")

# :debugger.start()
# :int.ni(Campaign.Starter)
# :int.break(Campaign.Starter, 54)
