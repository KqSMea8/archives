const path = require('path')
const { DefinePlugin } = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const config = require('./config')

module.exports = {
  entry: {
    app: ['babel-polyfill', './main.js'],
    vendor: ['vue', 'vue-router', 'vue-head', 'vue-progressbar']
  },
  output: {
    path: path.resolve('../public'),
    publicPath: '/',
    filename: '[name].[chunkhash].js'
  },
  resolve: {
    extensions: ['.js', '.vue'],
    alias: {
      js: path.resolve('js'),
      components: path.resolve('components'),
      layouts: path.resolve('layouts'),
      vue: 'vue/dist/vue.js'
    }
  },
  module: {
    loaders: [
      {
        test: /.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            js: ['babel-loader']
          }
        }
      },
      {
        test: /.html$/,
        loader: 'html-loader'
      },
      {
        test: /\.scss$/,
        use: [
          'style-loader',
          'css-loader',
          'postcss-loader',
          {
            loader: 'sass-loader',
            options: {
              includePaths: [path.resolve(__dirname, 'css')]
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new DefinePlugin({
      ROUTER_MODE: JSON.stringify(config.ROUTER_MODE),
      RECAPTCHA_SITEKEY: JSON.stringify(config.RECAPTCHA_SITEKEY)
    }),
    new HtmlWebpackPlugin({
      template: './index.html',
      inject: true
    })
  ],
  devServer: {
    contentBase: 'public',
    host: '0.0.0.0',
    port: 8080,
    historyApiFallback: true,
    inline: true,
    proxy: {
      '/api/*': 'http://localhost:3000',
      '/repo/*': 'http://localhost:8100',
      '/documentation': {
        target: 'http://localhost:4000',
        pathRewrite: { '^/documentation': '' }
      }
    }
  }
}
