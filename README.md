# Flutter + Machine Learning = IA APP

Um modelo simples de projeto em flutter para embarcar modelos de classificação `.tflite` em dispositivos móveis.

Irei mostrar o passo a passo que fiz para configurar o projeto e deixarei os resultados salvos em [project](./project/) a titulo de exemplo.

O esboço da ideia e o material adicional se encontra nos [documentos do projeto](./docs/)

## Passo 1: Ambiente

Tenha o ambiente flutter configurado em sua maquina. (Flutter, Emulador, Gerenciador de Pacotes, etc)

Estarei usando a versão 3.29 do flutter.

Caso precise de ajuda, pode seguir [este guia](https://github.com/mauriciobenjamin700/flutter-learning).

## Passo 2: Criando o Projeto

Use o comando `flutter create project` para criar o projeto.

Navegue para a pasta do projeto usando `cd project` e remova todas as pastas desnecessárias como `Windows`, `Linux`, `Mac`, `Web`.

## Passo 3: Dependências

Para este projeto, usaremos as seguintes dependências:

```yml
image_picker: ^1.0.4
tflite_flutter: ^0.11.0
image: ^4.1.3
camera: ^0.10.5+5
```

Adicione as em seu arquivo `pubspec.yaml` e use o comando `flutter pub get` para as instalar.

Após as instalar, você provavelmente vai se deparar com este erro:

```bash
Launching lib/main.dart on sdk gphone64 x86 64 in debug mode...
Your project is configured with Android NDK 26.3.11579264, but the following plugin(s) depend on a different Android NDK version:

camera_android requires Android NDK 27.0.12077973

flutter_plugin_android_lifecycle requires Android NDK 27.0.12077973

image_picker_android requires Android NDK 27.0.12077973

tflite_flutter requires Android NDK 27.0.12077973
Fix this issue by using the highest Android NDK version (they are backward compatible).
Add the following to /home/mauricio-benjamin/projects/my/templates/template-flutter-ml-app/project/android/app/build.gradle.kts:

android {
ndkVersion = "27.0.12077973"
```

Para corrigir isto, você deve seguir estes passos:

- Passo 1: Navegue até o arquivo build.gradle.kts no seu projeto seguindo esta rota: `android/app/build.gradle.kts`
- Passo 2: Abra o arquivo build.gradle.kts
- Passo 3: Altere o valor de `ndkVersion` para `ndkVersion = "27.0.12077973"`
- Passo 4: Sincronize as dependências usando `flutter pub get`
- Passo 5: Limpe o Cache usando `flutter clean`
- Pronto, o projeto está pronto para ser executado.

## Executando o Projeto

Para executar no emulador do android studio, use `flutter run -d emulator-5554`
