redis = Redis.new(
  url: ENV["REDIS_URL"],
  ssl: true,
  ssl_params: {
    verify_mode: OpenSSL::SSL::VERIFY_PEER # Ensure this is set to verify the SSL cert properly
  }
)
