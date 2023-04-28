console.log('The Twitter bot started');
const { TwitterApi } = require('twitter-api-v2');
var config = require('./config');
var fs = require('fs');

var exec = require('child_process').exec;
var cmd = 'processing-java --sketch=`pwd`/maxToProcessing --run';
exec(cmd, processing);
function processing() {
  console.log('finished');
}

const client = new TwitterApi({
  appKey: config.consumer_key,
  appSecret: config.consumer_secret,
  accessToken: config.access_token,
  accessSecret: config.access_token_secret,
});

// const bearer = new TwitterApi(config.bearer_token);
// const twitterBearer = bearer.readOnly;

const twitterClient = client.readWrite;

const tweet = async () => {
  try {
    // First, post all your images to Twitter
    const mediaIds = await Promise.all([
      twitterClient.v2.uploadMedia('max/recs/rec0600.jpg')
    ]);
  
    // mediaIds is a string[], can be given to .tweet
    await twitterClient.v2.tweet('My tweet text with img!', { media_ids: mediaIds });


    // await twitterClient.v2.tweet("max/recs/rec0600.jpg");
    console.log('done uploading');
  } catch (e) {
    console.log(e);
  }
};

tweet();