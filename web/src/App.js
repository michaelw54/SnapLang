import React from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import { Learn } from "./components/Learn";
const baseStyle = {
padding: "20px",
};
function App() {
  return (
    <BrowserRouter>
      <div style={baseStyle}>
        <Switch>
          <Route exact path="/" component={Learn} />
        </Switch>
      </div>
    </BrowserRouter>
  );
}

export default App;
