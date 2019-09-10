const express = require("express");
const app = express();
const cors = require("cors");
const fs = require("fs");
// Imports the Google Cloud client library
const textToSpeech = require("@google-cloud/text-to-speech");
// Import other required libraries
const util = require("util");
const bodyParser = require("body-parser");
const PORT = process.env.PORT || 8080;
const dotenv = require("dotenv");

const corsOptions = {
  origin: function(origin, callback) {
    callback(null, true);
  },
  optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
};

var audioNum = 0;
app.use(cors(corsOptions));
app.use(bodyParser.json());
app.use(express.static("public"));
app.post("/readWord", async (req, res) => {
  dotenv.config();
  // Creates a client
  const client = new textToSpeech.TextToSpeechClient();

  // Construct the request
  const request = {
    input: { text: req.body.text },
    // Select the language and SSML Voice Gender (optional)
    voice: { languageCode: req.body.languageCode, ssmlGender: "NEUTRAL" },
    // Select the type of audio encoding
    audioConfig: { audioEncoding: "MP3" }
  };

  // Performs the Text-to-Speech request
  const [response] = await client.synthesizeSpeech(request);
  // res.send(JSON.stringify(response.audioContent));
  // Write the binary audio content to a local file
  const writeFile = util.promisify(fs.writeFile);
  try {
    // fs.exists("./public/output.mp3", async exists => {
    //   if (exists) {
    //     fs.unlink("./public/output.mp3", async err => {
    //       if (err) throw err;
    //       fs.writeFile(
    //         "./public/output.mp3",
    //         response.audioContent,
    //         "binary",
    //         async err => {
    //           if (err) throw err;
    //           res.send("http://localhost:8080/output.mp3");
    //         }
    //       );
    //       // await writeFile(
    //       //   `./public/output.mp3`,
    //       //   response.audioContent,
    //       //   "binary",
    //       //   async (err, data) => {}
    //       // );
    //     });
    //   } else {
    //     fs.writeFile(
    //       "./public/output.mp3",
    //       response.audioContent,
    //       "binary",
    //       async err => {
    //         if (err) throw err;
    //         res.send(`http://localhost:8080/${audioNum}.mp3`);
    //       }
    //     );
    //   }
    // });
    // var temp = audioNum + 1;
    // fs.exists(`./public/${temp % 2}.mp3`, async exists => {
    //   if (exists) {
    //     fs.unlink(`./public/${temp % 2}.mp3`, async err => {
    //       if (err) throw err;
    //       fs.writeFile(
    //         `./public/${audioNum % 2}.mp3`,
    //         response.audioContent,
    //         "binary",
    //         async err => {
    //           if (err) throw err;
    //           res.send(`http://localhost:8080/${audioNum++ % 2}.mp3`);
    //         }
    //       );
    //     });
    //   } else {
    //     fs.writeFile(
    //       `./public/${audioNum % 2}.mp3`,
    //       response.audioContent,
    //       "binary",
    //       async err => {
    //         if (err) throw err;
    //         res.send(`http://localhost:8080/${audioNum++ % 2}.mp3`);
    //       }
    //     );
    //   }
    // });
    fs.writeFile(
      `./public/${audioNum}.mp3`,
      response.audioContent,
      "binary",
      async err => {
        if (err) throw err;
        res.send(`http://localhost:8080/${audioNum++}.mp3`);
      }
    );
  } catch (err) {
    console.error(err);
  }
});

app.listen(PORT, function() {
  console.log("Running on port: " + PORT);
});

// app.get('/words', (req, res) => {
//     fs.readFile('./db.txt', 'utf8', (err, data) => {
//       let lines = data.split('\n');
//       let ret = lines.map(line => {
//         return {
//           original: line.split(',')[0],
//           translated: line.split(',')[1],
//           category: line.split(',')[2]
//         }
//       });
//       res.send(ret);
//     });
// });

// app.post('/words', (req, res) => {
//   fs.readFile('./db.txt', 'utf8', (err, data) => {
//     let lines = data + '\n';
//     lines = lines += req.body.original + ',' + req.body.translated + ',' + req.body.category;
//     fs.writeFileSync('./db.txt', lines, 'utf8');
//     fs.readFile('./categories.txt', (err, data) => {
//       let parsed = JSON.parse(data);
//       if (parsed[req.body.category]) {
//         parsed[req.body.category] = parsed[req.body.category] + 1;
//       } else {
//         parsed[req.body.category] = 1;
//       }
//       fs.writeFileSync('./categories.txt', JSON.stringify(parsed), 'utf8');
//     });
//   });
// });

// app.get('/categories', (req, res) => {
//   fs.readFile('./categories.txt', 'utf8', (err, data) => {
//     if (err) return console.log(err);
//     let parsed = JSON.parse(data);
//     res.send(parsed);
//   });
// });
