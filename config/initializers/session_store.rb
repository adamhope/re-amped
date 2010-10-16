# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_re-amped_session',
  :secret      => '760d7a73216467895d95bfa9cdc85af9366a4774356ca186bcfbfebfdf1ebe250fc701a0e4856fa61c2eab8a7d81980b259a3b8eef229d83adb6c5491721c4dc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
