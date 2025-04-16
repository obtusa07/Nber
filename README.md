# Nber

## プロジェクト概要

Nberは、RIBsアーキテクチャをベースに設計されたiOSのデモアプリです。スケーラビリティ（Scalability）と保守性（Maintainability）を意識したモジュール構成（モジュール化設計）を軸に開発されました。機能はシンプルで、一部はダミー実装となっていますが、実際のサービス開発において直面し得る課題に対して、どのように柔軟かつ体系的にアプローチするかをコードレベルで示すことを目的としています。


## 使用技術スタック

- ModernRIBs
	- Uberが開発したRIBsをベースにし、Rxの代わりにCombineを使用
- CombineExt
	- Combineの機能を拡張するライブラリ
- Swift Package Manager


## アーキテクチャ & 設計

### RIBsベースのドメイン分割

- Home / Transport / Finance / Profile / Platform の5つのドメインに分けてモジュール化
- 各ドメイン内では、Protocol / Implementation / Entity / Repositoryといった役割ごとに依存関係を分離
- 各機能の責務を明確にし、階層間の依存を最小限に抑えることで、スケーラビリティ（Scalability）と保守性（Maintainability）を意識して設計
- Platformモジュールは、ネットワーク抽象化層、UIコンポーネント、ユーティリティなどを集約し、ドメイン間の重複を抑えるとともに、再利用性を意識した構造とする設計。


### Loose Coupling

- モジュール間の依存関係を明示的に分離し、テストのしやすさと保守性を向上
- Runtime DependencyとCompile-time Dependencyを分離し、Volatile Dependencyは依存性注入（Dependency Injection）によって柔軟に管理


## プロジェクト構成

![dependency-tree](https://github.com/user-attachments/assets/1bd164e9-df09-4133-8024-243d44b06be1)
