# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_neurinia_session',
  :secret      => '5f18908e89afacceff238061afbf72af68a9e76c02a40e490d6d9664743dd6b16a6ffe85dd60a5460e0c23db7a6ef17ff06b387bf8e546826486a781b25c0f7a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
