# Sample プロジェクト

## Webpack の概要
- webpack.config.js
  - Webpackの設定ファイル
  - entry: 起点となるファイル
  - output: 結合されたファイルの出力先
  - その他: CSS、画像のロードができるように設定

- ビルド(ファイルの結合)の実行
  - webpack.config.js が存在するディレクトリで下記のコマンドを実行
  - $ npm run build
  - output に指定されたディレクトリにバンドルファイルが出力される

## ESlint
- .eslintrc.json
  - eslint-config-kintone を読み込む設定
  - global に kintoneUtility を利用できるように設定
  - console.log を使ってもエラーが出ないように設定

- .eslintignore
  - eslint の対象から外すディレクトリ、ファイルを指定

- ESLint の実行
  - $ npm run lint

- エディタで利用する場合にはエディタにプラグインの設定等を行う

## kintoneUtility
- [マニュアル](https://github.com/kintone/kintoneUtility/blob/master/guides/rest_doc.md)
