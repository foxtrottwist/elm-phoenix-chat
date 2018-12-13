const path = require('path')
const glob = require('glob')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const PurgecssPlugin = require('purgecss-webpack-plugin')

// Using glob to return file paths for Purecss to check https://www.purgecss.com/with-webpack
const PATHS = {
  elm: `${path.join(__dirname, 'elm')}/src/**/*.elm`,
  templates: path.resolve('../', '*/*/templates/*/**/*.eex'),
}

module.exports = (env, options) => ({
  entry: './ts/main.ts',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, '../priv/static/js'),
  },
  module: {
    rules: [
      // Babel/Webpack/Typescript configuration
      // https://medium.com/@francesco.agnoletto/how-to-set-up-typescript-with-babel-and-webpack-6fba1b6e72d5
      // https://iamturns.com/typescript-babel/
      // https://webpack.js.org/loaders/babel-loader/
      {
        test: /\.ts$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/typescript', ['@babel/env', { modules: false }]],
            plugins: [
              '@babel/proposal-class-properties',
              '@babel/proposal-object-rest-spread',
            ],
          },
        },
      },
      // CSS configuration
      // https://github.com/webpack-contrib/mini-css-extract-plugin
      // https://github.com/csstools/postcss-preset-env
      {
        test: /\.css$/,
        use: [
          options.mode === 'development'
            ? 'style-loader'
            : MiniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: () => [
                require('tailwindcss')('./tailwind.js'),
                require('postcss-preset-env')({
                  autoprefixer: {
                    flexbox: 'no-2009',
                  },
                  stage: 3,
                }),
              ],
            },
          },
        ],
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            cwd: path.resolve(__dirname, 'elm'),
            pathToElm: path.resolve(__dirname, 'node_modules/.bin/elm'),
            debug: options.mode === 'development',
            verbose: options.mode === 'development',
            optimize: options.mode !== 'development',
          },
        },
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/main.css' }),
    new PurgecssPlugin({
      paths: glob.sync(PATHS.elm).concat(glob.sync(PATHS.templates)),
    }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
  ],
  optimization: {
    minimizer: [
      // Options borrowed from the Elm SPA example:
      // https://github.com/rtfeldman/elm-spa-example/tree/54e3facfac9e208efe9ce02ad817d444c3411ca9#step-2
      // Webpack config taken from:
      // https://github.com/levelhq/level/blob/master/assets/webpack.config.js
      new UglifyJsPlugin({
        uglifyOptions: {
          compress: {
            pure_funcs: [
              'F2',
              'F3',
              'F4',
              'F5',
              'F6',
              'F7',
              'F8',
              'F9',
              'A2',
              'A3',
              'A4',
              'A5',
              'A6',
              'A7',
              'A8',
              'A9',
            ],
            pure_getters: true,
            keep_fargs: false,
            unsafe_comps: true,
            unsafe: true,
            passes: 2,
          },
          mangle: true,
        },
      }),
      new OptimizeCSSAssetsPlugin({}),
    ],
  },
})
