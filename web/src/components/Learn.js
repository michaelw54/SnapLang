import React, { useEffect, useState } from "react";
import { Flashcard } from "./Flashcard";
import ReactWordcloud from "react-wordcloud";
import { Resizable, Label } from "re-resizable";
import {
  Segment,
  Grid,
  GridColumn,
  Header,
  Divider,
  Sticky,
  Rail,
  Loader,
  Statistic
} from "semantic-ui-react";
import axios from "axios";
import { objectTypeSpreadProperty } from "@babel/types";

const ngrok = "http://d0362c51.ngrok.io/";

export const Learn = () => {
  const [words, setWords] = useState([]);
  const [categories, setCategories] = useState([]);
  const [isLoaded, setIsLoaded] = useState(false);
  const [flags, setFlags] = useState({});
  const [totalWords, setTotalWords] = useState(0);
  const [countByLanguage, setCountByLanguage] = useState({});
  const [countByCategory, setCountByCategory] = useState({});
  const [colorCodeByLanguage, setColorCodeByLanguage] = useState({});
  const [colorCodes, setColorCodes] = useState({
    0: "#008B8B",
    1: "#FF6347",
    2: "#DDA0DD",
    3: "#D2691E",
    4: "#87CEFA",
    5: "#7B68EE",
    6: "#DEB887",
    7: "#00FF7F",
    8: "#5F9EA0",
    9: "#7FFF00",
    10: "#FF7F50",
    11: "#6495ED",
    12: "#FFD700",
    13: "#228B22",
    14: "#DA70D6",
    15: "#9ACD32",
    16: "#FFA07A",
    17: "#AFEEEE"
  });
  let processedFlags = 0;
  let processedWords = 0;
  let flagsCopy = {};

  const languageNameToCode = (wordDef, languageName) => {
    const languageCode = languageDict[languageName];
    var flag;
    var dataArr;
    axios
      .get("https://restcountries.eu/rest/v2/lang/" + languageCode)
      .then(result => {
        dataArr = result.data;
        dataArr.sort(function(a, b) {
          return b.population - a.population;
        });
        flag = dataArr[0].alpha2Code.toString();
        console.log("Flag code: " + flag);
        flagsCopy[wordDef] = flag;
        processedFlags++;
        console.log(processedFlags, words.length, flagsCopy);
        if (processedFlags === processedWords) {
          setFlags(flagsCopy);
          setIsLoaded(true);
        }
      });
  };

  useEffect(() => {
    axios
      .get(`${ngrok}/api/v1/images/`)
      .then(response => {
        console.log("words:", response.data);
        processedWords = response.data.length;
        setWords(response.data);
        axios
          .get(`${ngrok}/api/v1/category/`)
          .then(res => {
            console.log("categories:", res.data);
            setCategories(res.data);
            response.data.forEach(word => {
              languageNameToCode(
                word.foreign_definition,
                word.foreign_language
              );
            });
            setTotalWords(response.data.length);
            let countLanguage = {};
            let colorCodeLanguage = {};
            var arr = [];
            while (arr.length < 18) {
              var r = Math.floor(Math.random() * 18);
              if (arr.indexOf(r) === -1) arr.push(r);
            }
            let count = 0;
            response.data.forEach(word => {
              if (
                !Object.keys(colorCodeLanguage).includes(word.foreign_language)
              ) {
                colorCodeLanguage[word.foreign_language] = arr[count];
                count++;
                console.log(count);
              }
              if (Object.keys(countLanguage).includes(word.foreign_language)) {
                countLanguage[word.foreign_language] =
                  countLanguage[word.foreign_language] + 1;
              } else {
                countLanguage[word.foreign_language] = 1;
              }
            });
            setColorCodeByLanguage(colorCodeLanguage);
            setCountByLanguage(countLanguage);
            let countCategory = {};
            response.data.forEach(word => {
              if (Object.keys(countCategory).includes(word.category)) {
                countCategory[word.category] = countCategory[word.category] + 1;
              } else {
                countCategory[word.category] = 1;
              }
            });
            setCountByCategory(countCategory);
          })
          .catch(err => {
            console.error(err);
          });
      })
      .catch(err => {
        console.error(err);
      });
  }, []);

  const ret = words.map(card => (
    <Flashcard
      color={colorCodes[colorCodeByLanguage[card.foreign_language]]}
      word={card.english_definition}
      translated={card.foreign_definition}
      key={card.id}
      language={card.foreign_language}
      category={card.category}
      flag={flags[card.foreign_definition]}
    />
  ));

  const resizeStyle = {
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
    border: "solid 1px #ddd",
    background: "#f0f0f0"
  };

  return (
    <Segment style={{ height: "90vh" }}>
      <Grid columns={2} relaxed="very" divided style={{ height: "100%" }}>
        <GridColumn width={3} style={{ height: "100%", overflowY: "scroll" }}>
          <Header size="large">History</Header>
          {isLoaded ? ret : <Loader active />}
        </GridColumn>
        <GridColumn width={13}>
          <Header size="large">Analytics</Header>
          <div style={{ display: "flex" }}>
            <Resizable
              defaultSize={{
                width: 600,
                height: 600
              }}
              style={resizeStyle}
            >
              <ReactWordcloud
                style={{ float: "left" }}
                words={categories.map(category => {
                  return {
                    text: category.name,
                    value: category.count
                  };
                })}
              />
            </Resizable>
            <div
              style={{
                flexDirection: "row",
                paddingLeft: "30px",
                alignItems: "center",
                justifyContent: "center",
                border: "solid 1px #ddd"
              }}
            >
              <Grid style={{ margin: "10px" }}>
                <Grid.Row width={16}>
                  <Statistic>
                    <Statistic.Value>{totalWords}</Statistic.Value>
                    <Statistic.Label>Total Words</Statistic.Label>
                  </Statistic>
                </Grid.Row>
                <Grid.Column width={8}>
                  <Grid>
                    <Grid.Row width={3}>
                      <Header>Languages</Header>
                    </Grid.Row>
                    {Object.keys(countByLanguage).map(language => {
                      return (
                        <Grid.Row width={3}>
                          <Statistic horizontal size="tiny">
                            <Statistic.Value>
                              {countByLanguage[language]}
                            </Statistic.Value>
                            <Statistic.Label
                              style={{
                                color: colorCodes[colorCodeByLanguage[language]]
                              }}
                            >
                              {language}
                            </Statistic.Label>
                          </Statistic>
                        </Grid.Row>
                      );
                    })}
                  </Grid>
                </Grid.Column>
                <Grid.Column width={8}>
                  <Grid>
                    <Grid.Row width={3}>
                      <Header>Categories</Header>
                    </Grid.Row>
                    {Object.keys(countByCategory).map(category => {
                      return (
                        <Grid.Row width={3}>
                          <Statistic horizontal size="tiny">
                            <Statistic.Value>
                              {countByCategory[category]}
                            </Statistic.Value>
                            <Statistic.Label>{category}</Statistic.Label>
                          </Statistic>
                        </Grid.Row>
                      );
                    })}
                  </Grid>
                </Grid.Column>
              </Grid>
            </div>
          </div>
        </GridColumn>
      </Grid>
    </Segment>
  );
};

const languageDict = {
  Afrikaans: "af",
  Albanian: "sq",
  Amharic: "am",
  Arabic: "ar",
  Armenian: "hy",
  Azerbaijani: "az",
  Basque: "eu",
  Belarusian: "be",
  Bengali: "bn",
  Bosnian: "bs",
  Bulgarian: "bg",
  Catalan: "ca",
  Cebuano: "ceb",
  "Chinese (Simplified)": "zh",
  "Chinese (Traditional)": "zh",
  Corsican: "co",
  Croatian: "hr",
  Czech: "cs",
  Danish: "da",
  Dutch: "nl",
  English: "en",
  Esperanto: "eo",
  Estonian: "et",
  Finnish: "fi",
  French: "fr",
  Frisian: "fy",
  Galician: "gl",
  Georgian: "ka",
  German: "de",
  Greek: "el",
  Gujarati: "gu",
  "Haitian Creole": "ht",
  Hausa: "ha",
  Hawaiian: "en",
  Hebrew: "he",
  Hindi: "hi",
  Hmong: "hmn",
  Hungarian: "hu",
  Icelandic: "is",
  Igbo: "ig",
  Indonesian: "id",
  Irish: "ga",
  Italian: "it",
  Japanese: "ja",
  Javanese: "jw",
  Kannada: "kn",
  Kazakh: "kk",
  Khmer: "km",
  Korean: "ko",
  Kurdish: "ku",
  Kyrgyz: "ky",
  Lao: "lo",
  Latin: "la",
  Latvian: "lv",
  Lithuanian: "lt",
  Luxembourgish: "lb",
  Macedonian: "mk",
  Malagasy: "mg",
  Malay: "ms",
  Malayalam: "ml",
  Maltese: "mt",
  Maori: "mi",
  Marathi: "mr",
  Mongolian: "mn",
  "Myanmar (Burmese)": "my",
  Nepali: "ne",
  Norwegian: "no",
  "Nyanja (Chichewa)": "ny",
  Pashto: "ps",
  Persian: "fa",
  Polish: "pl",
  "Portuguese (Portugal, Brazil)": "pt",
  Punjabi: "pa",
  Romanian: "ro",
  Russian: "ru",
  Samoan: "sm",
  "Scots Gaelic": "gd",
  Serbian: "sr",
  Sesotho: "st",
  Shona: "sn",
  Sindhi: "sd",
  "Sinhala (Sinhalese)": "si",
  Slovak: "sk",
  Slovenian: "sl",
  Somali: "so",
  Spanish: "es",
  Sundanese: "su",
  Swahili: "sw",
  Swedish: "sv",
  "Tagalog (Filipino)": "tl",
  Tajik: "tg",
  Tamil: "ta",
  Telugu: "te",
  Thai: "th",
  Turkish: "tr",
  Ukrainian: "uk",
  Urdu: "ur",
  Uzbek: "uz",
  Vietnamese: "vi",
  Welsh: "cy",
  Xhosa: "xh",
  Yiddish: "yi",
  Yoruba: "yo",
  Zulu: "zu"
};
