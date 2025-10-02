const path = require('path');

const CopyPlugin = require("copy-webpack-plugin");


module.exports = {
  mode: 'development',
  entry: {},
  output: {
    filename: 'template.js',
    path: path.resolve(__dirname, 'theme/itlusions/login/resources')
  },
  devtool: 'source-map',
  plugins: [
    new CopyPlugin({
        patterns: [
          // ITlusions theme assets - add any custom assets here if needed
          // { from: "assets/itlusions", to: "assets" },
        ],
    })
  ]
};
