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

## Passo 4: Modelos e Rótulos

Dentro de seu projeto, crie uma pasta chamada [asserts](./project/assets/) e coloque seu modelo `.tflite` e seu arquivo `labels.txt`

**OBS**:

O arquivo labels.txt deve conter as classes ou categorias que o modelo de aprendizado de máquina pode prever. Cada linha do arquivo deve representar uma classe, e a ordem das linhas deve corresponder à ordem das saídas do modelo. EX:

```txt
Cat
Dog
Bird
Car
Tree
```

### Regras para o arquivo `labels.txt`

- Uma classe por linha: Cada linha deve conter o nome de uma classe.
- Ordem importa: A ordem das classes no arquivo deve corresponder à ordem das saídas do modelo. Por exemplo, se o modelo retorna 0 para "Cat", 1 para "Dog", e assim por diante, o arquivo deve seguir essa ordem.
- Sem números ou índices: Apenas os nomes das classes devem estar presentes, sem números ou índices adicionais.

### Configurando imports no pubspec.yaml

Em seu arquivo [pubspec.yaml](./project/pubspec.yaml) adicione uma sessão para seus assets como neste exemplo:

```yml
flutter:
  uses-material-design: true

  assets:
    - assets/labels.txt
    - assets/yolo11n_float16.tflite
    - assets/yolo11n_float32.tflite
```

## Executando o Projeto

Para executar no emulador do android studio, use `flutter run -d emulator-5554`
