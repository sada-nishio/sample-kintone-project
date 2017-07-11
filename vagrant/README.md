# Vagrant サンプル

## Vagrant サンプルVM 作成手順

1. 次のアプリケーションをインストールする
   - VirtualBox
   - Vagrant

2. コンソールでvagrantディレクトリを開く

```shell
$ cd {path_to_sample-kintone-project}/vagrant/
```

3. Vagrantプラグイン(vagrant-vbguest)をインストールする

```shell
$ vagrant plugin install vagrant-vbguest
```

4. Vagrantfile をコピーする

```shell
$ cp Vagrantfile.default Vagrantfile
```

5. Vagrant でVMの作成を開始する

```shell
$ vagrant up
```

6. 下記のように出力されれば完了

```shell
==> default: ALMOST DONE!
==> default: Project URL: https://localhost:10443/projects/
```

7. 6で出力されたリンクにアクセスすると、projects フォルダ以下が公開されている

8. JSファイルを開きURLをコピー、kintoneのカスタマイズ画面で適用する


## VMを削除する場合

```shell
$ vagrant destroy
```
