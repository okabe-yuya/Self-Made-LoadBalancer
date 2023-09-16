## 👷‍♂️ Self Made Simple LoadBalancer

[Rustでシンプルなロードバランサーを作成してみた](https://qiita.com/rchaser53/items/5b69b717ae07220daed9)をElixirで実装してみたやつ。  

Elixirを採用したのはActorモデルのため、サーバーのステータスを管理するのにMutexを使用する必要がなく書きなれた言語であるため。  
実装にはGenServerを使用しました。  

## Usage

LoadBalancerの起動

```elixir
iex(1)> LoadBalancer.launch
```

5秒に一度、passive health checkが実行されます。  

```elixir
iex(1)> LoadBalancer.launch
#PID<0.151.0>
:::Health check...
:::Health check...
```

サーバーへリクエストする場合、active health checkが実施されます。  
実際にリクエストは飛ばす、現在はランダムでステータスが返ってくるのみです。  

```elixir
# arguments: endpoint, header, body
iex(2)> LoadBalancer.request("/api/v1/users", {}, {})
```

サーバーのステータスを確認する。  

```elixir
iex(3)> LoadBalancer.status
{[
   %ServerState{host: "http://localhost:3000", is_active: true},
   %ServerState{host: "http://localhost:3001", is_active: false},
   %ServerState{host: "http://localhost:3002", is_active: true}
 ], 1}
```


### TODO(やるとは言ってない)

- [ ] アクティブなサーバーが存在しなくなった場合にcrashさせる
  - [ ] Supervisorによる再起動(外部サーバーのステータスは回復したという前提)
- [ ] テストコード
- [ ] GenServerのステータス更新をヘルスチェック側に持たせている。ただし、GenServerのステータスの形式にかなり依存した状態になってしまっているので実行とステータス更新を行うモジュールは分離するか、GenServerのファイルに移動させる
