# Telefonia

**TODO: projeto executado no curso de elixir e phoenix da Elxpro**
Esse projeto foi construindo no modulo 1 do curso `ElxPro`. Projeto que ensina muito de elixir,
manipulação de arquivos, estruturas de dados, criar documentação, criar testes, ultilizar TDD, refatoração de código, ultilizar Enum's de forma eficiente e muitas outras coisas.

# Informacoes Tecnicas

- Ecossistema elixir

## Iniciando localmente

**1.** Clone o projeto:

 * ssh
```sh
Aplique o comando no terminal: $ git@github.com:RuanAlves/telefonia.git
```

 * https
```sh
Aplique o comando no terminal: git clone https://github.com/RuanAlves/telefonia.git
```

**2.** Acesse a pasta do projeto pelo terminal:

```sh
$ cd telefonia
```

**3.** Instale as dependências:

```sh
$ mix deps.get
```

**4.** Acessando o Terminal para inserir as "Chamadas":

```sh
$ iex -S mix
```

# Comandos para Testes da Aplicação

Para gerar o percentual de teste da aplicação
```sh
$ mix test --cover
```

Para gerar teste da aplicação
```sh
$ mix test
```
Para gerar teste da aplicação com 'Watch' -> https://github.com/lpil/mix-test.watch
```sh
$ mix test.watch
```

Para gerar teste de module especifíco da aplicação com 'Watch' -> https://github.com/lpil/mix-test.watch
```sh
mix test.watch test/assinante_test.exs
```

Para gerar teste de module especifíco por linha, da aplicação com 'Watch' -> https://github.com/lpil/mix-test.watch
```sh
mix test.watch test/assinante_test.exs:23
```

# Gerar documentação da aplicação

Para gerar a documentação da aplicação só excutar o comando:
```sh
$ mix docs
```
A documentação ira guiar você de forma certa para utilizar o sistema.

# Breve tutorial

## Gerar arquivos para armazenar os dados
```Elixir
    iex> Telefonia.start
```

## Cadastrar um assinante
```Elixir
    iex> Telefonia.cadastrar_assinante "Fulano", "123", "123456", :prepago
    iex> Telefonia.cadastrar_assinante "Ciclano", "1234", "123456", :pospago
```

## Listar assinantes
```Elixir
    iex> Telefonia.listar_assinantes()
```

## Fazer uma recarga
```Elixir
    iex> Telefonia.recarga("123", DateTime.utc_now, 20)
```

## Fazer uma chamada
```Elixir
    iex> Telefonia.fazer_chamada("123", :prepago, DateTime.utc_now, 3)
```

## Imprimir um relatório dos assinantes
```Elixir
    iex> Telefonia.imprimir_contas(01, 2021)
```


