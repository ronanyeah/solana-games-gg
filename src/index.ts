const { Elm } = require("./Main.elm");

const games = require("../content/games.json");
const tokens = require("../content/tokens.json");
const icons = require("../content/icons.json");

const _app = Elm.Main.init({
  node: document.getElementById("app"),
  flags: {
    games,
    tokens,
    icons,
    screen: {
      width: window.innerWidth,
      height: window.innerHeight,
    },
    time: Date.now(),
  },
});

//app.ports.log.subscribe((txt: string) => console.log(txt));
