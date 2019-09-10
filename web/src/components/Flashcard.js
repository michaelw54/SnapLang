import React, { useState, useEffect } from "react";
import { Card, Button, Icon, Label } from "semantic-ui-react";
import ReactCountryFlag from "react-country-flag";
import axios from "axios";
// const textToSpeech = require("@google-cloud/text-to-speech");

async function getTTS(text) {
  console.log("inside getTTS");
  axios
    .post("http://localhost:8080/readWord", {
      text: text,
      languageCode: "en-US"
    })
    .then(result => {
      console.log(result.data);
      const audio = new Audio(result.data);
      audio.play();
    });
  // const client = new textToSpeech.TextToSpeechClient();
  // const request = {
  //   input: { text: text },
  //   // Select the language and SSML Voice Gender (optional)
  //   voice: { languageCode: "en-US", ssmlGender: "NEUTRAL" },
  //   // Select the type of audio encoding
  //   audioConfig: { audioEncoding: "MP3" }
  // };

  // const [response] = await client.synthesizeSpeech(request);
  // console.log(typeof response);
  // const audio = new Audio(response);
  // audio.play();
}

export const Flashcard = ({
  word,
  translated,
  language,
  category,
  flag,
  color
}) => {
  const [translatedView, setTranslatedView] = useState(false);
  const handleClick = e => {
    stopBubbling(e);
    setTranslatedView(!translatedView);
  };

  const buttonClick = async e => {
    stopBubbling(e);
    if (translatedView) {
      await getTTS(translated);
    } else {
      await getTTS(word);
    }
  };

  const stopBubbling = e => {
    e.stopPropagation();
    e.cancelBubble = true;
  };
  return (
    <Card style={{ backgroundColor: color }}>
      <Card.Content onClick={handleClick}>
        <Card.Header>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            <div>
              {translatedView ? translated : word}
              <Label
                size="big"
                style={{
                  marginLeft: "10px",
                  backgroundColor: color,
                  bottom: "3px",
                  padding: "0px",
                  "line-height": 0
                }}
              >
                <ReactCountryFlag code={flag} svg />
              </Label>
            </div>
            <Button icon size="mini" id="but" onClick={buttonClick}>
              <Icon style={{ zIndex: 1 }} name="microphone" size="large" />
            </Button>
          </div>
        </Card.Header>
        <Card.Meta>{language}</Card.Meta>
        <Card.Description>{category}</Card.Description>
      </Card.Content>
    </Card>
  );
};
