## 👷‍♂️ Self Made Simple Load Balancer

[Rustでシンプルなロードバランサーを作成してみた](https://qiita.com/rchaser53/items/5b69b717ae07220daed9)をElixirで実装してみたやつ。  

Elixirを採用したのはActorモデルのため、サーバーのステータスを管理するのにMutexを使用する必要がなく書きなれた言語であるため。  
実装にはGenServerを使用しました。  

### TODO

- [ ] アクティブなサーバーが存在しなくなった場合にcrashさせる
  - [ ] Supervisorによる再起動(外部サーバーのステータスは回復したという前提)
- [ ] テストコード
- [ ] GenServerのステータス更新をヘルスチェック側に持たせている。ただし、GenServerのステータスの形式にかなり依存した状態になってしまっているので実行とステータス更新を行うモジュールは分離するか、GenServerのファイルに移動させる
