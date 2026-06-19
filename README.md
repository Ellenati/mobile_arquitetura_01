# Lojinha Virtual Mobile

Aplicativo Flutter de e-commerce desenvolvido para a disciplina de Desenvolvimento para Dispositivos Móveis. O projeto utiliza Clean Architecture, gerenciamento de estado reativo nativo (ValueNotifier) e integração REST com a API DummyJSON.

## Como Executar

Pré-requisitos: Flutter SDK 3.9+ (Canal Stable) e Dart 3+.

No terminal, na raiz do projeto, execute os seguintes comandos sequencialmente:

```bash
# 1. Baixar as dependencias do projeto
flutter pub get

# 2. Garantir a injecao do pacote de rede HTTP
flutter pub add http

# 3. Rodar o aplicativo 
flutter run

## Usuários de Teste (DummyJSON)

Use as credenciais abaixo para fazer login e testar o aplicativo. Todos são usuários reais da API DummyJSON.

| # | Username | Password | Nome Completo |
|---|----------|----------|---------------|
| 1 | `emilys` | `emilyspass` | Emily Sanchez |
| 2 | `johnd` | `johndpass` | John Doe |