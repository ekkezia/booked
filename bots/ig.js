const { IgApiClient } = require('instagram-private-api');
const { readFile } = require('fs');
const { promisify } = require('util');
var readFileAsync = promisify(readFile);
var config = require("./config");
var igConfig = config.instagram;
var ig = new IgApiClient();
var frameInterval = 800; // the same as canvaswidth in processing
var numberOfFiles = 4;

const login = async (acc) => {
  console.log('Logging in to', acc);
  if (acc === 'main') {
    ig.state.generateDevice(igConfig.account_main.ig_username);
    await ig.account.login(igConfig.account_main.ig_username, igConfig.account_main.ig_password);
  } else {
    ig.state.generateDevice(igConfig.account_sec.ig_username);
    await ig.account.login(igConfig.account_sec.ig_username, igConfig.account_sec.ig_password);
  }
};

const logout = async (acc) => {
  console.log('Logging out from', acc);
  if (acc === 'main') {
    ig.state.generateDevice(igConfig.account_main.ig_username);
    await ig.account.logout(igConfig.account_main.ig_username, igConfig.account_main.ig_password);
  } else {
    ig.state.generateDevice(igConfig.account_sec.ig_username);
    await ig.account.logout(igConfig.account_sec.ig_username, igConfig.account_sec.ig_password);
  }
};

async function postToFeeds(fileNo) {
  await login('main');

  for (let fileNo = numberOfFiles; fileNo > 0; fileNo--) {
    console.log('posting file no ', fileNo * frameInterval);
    var path = `./max/recs/rec-${fileNo * frameInterval}.jpg`;
    var date = new Date();

    await ig.publish.photo({
      file: await readFileAsync(path),
      caption: `Filepath: <<${path}>>. Released on ${date}. Distributing a fragment of graphic recording obtained from Bad Times Disco party at Booked 2023 in Tai Kwun, Hong Kong, on 28th April 2023.`,
    });
  }

  console.log('finish posting', path);
  await logout('main');
  console.log('finish logging out');
}

async function shareToStory(fileNo) {
  await login('main');

  for (let fileNo = 0; fileNo < numberOfFiles; fileNo++) {
    console.log('sharing story with file no ,', fileNo);
    var path = `./max/recs/rec-${fileNo * frameInterval}.jpg`;
    var file = await readFileAsync(path);
    await ig.publish.story({
      file,
    });
  };

  console.log('finish sharing');
  await logout('main');
  console.log('finish logging out');
}

// Calculation of which pic to upload
var length = 6;
length -= (length % 3); // always ensure length is dividable by 3
var row = Math.floor(length / 3); // ig standard
var col = 3; // ig standard
var num = [];

var r = row;

async function calculate() {
  while (r > 0) {
    r -= 1;
    for (let c = 0; c < col; c++) {
      num.push((length - r) - (row * c));
    }
  }
  console.log('order', num);
}

async function order() {
  for (let i = 0; i < length; i++) {
    num.push((length - r) - (row * c));
  }
  console.log('order', num);
}


// Run script every 3s
var CronJob = require('cron').CronJob;
var jobNo = 0;
var lenOfRecs = 6;
const cronInsta = new CronJob("3 * * * * *", async () => {
  // var current = num[jobNo - 1];
  console.log('Start Cron Job', jobNo, 'with file no: ', lenOfRecs - jobNo + 1);
  // postToFeeds(num[jobNo - 1]);
  postToFeeds(lenOfRecs - jobNo + 1);
  // shareToStory(jobNo);
  // shareToStory(num[jobNo - 1]);
  console.log('End Cron Job', jobNo);
});
// calculate().then(() => cronInsta.start());
// cronInsta.start();

// Run Scripts without CRONJOBS
postToFeeds(0);
