// Copy this to your config
module.exports = {
  // Twitter
  consumer_key:         'CONSUMER_KEY',
  consumer_secret:      'CONSUMER_SECRET',
  access_token:         'ACCESS_TOKEN',
  access_token_secret:  'ACCESS_TOKEN_SECRET',
  timeout_ms:           60*1000,  // optional HTTP request timeout to apply to all requests.
  strictSSL:            true,     // optional - requires SSL certificates to be valid.
  bearer_token:         'BEARER_TOKEN',
  
  // Instagram
  instagram: {
    account_main:          {
      ig_username: 'IG_USERNAME',
      ig_password: 'IG_PASSWORD',
    },
    account_sec:          {
      ig_username: 'IG_USERNAME',
      ig_password: 'IG_PASSWORD',
    },
  },
}