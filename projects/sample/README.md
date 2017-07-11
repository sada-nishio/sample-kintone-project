# Sample プロジェクト

## 依存する npm ライブラリのインストール
```shell
$ npm install
```

## Webpack の概要
- webpack.config.js
  - Webpackの設定ファイル
  - entry: 起点となるファイル (./app1/js/desktop.js)
  - output: 結合されたファイルの出力先 (./dist)
  - その他: CSS、画像のロードができるように設定

- ビルド(ファイルの結合)の実行
```shell
$ npm run build
```
  - webpack.config.js が存在するディレクトリで上記のコマンドを実行
  - output に指定されたディレクトリ(./dist)にバンドルファイルが出力される

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
