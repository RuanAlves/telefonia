defmodule Assinante do
  ## __MODULE__ -> Retorna o nome do módulo atual como um átomo ou de nil outra forma

  ## MAP   -> %{} = estrutura de chave valor, ex.: %{"chave" => "valor"} ou %{chave: "valor"}
  ## LIST  -> []  = lista (array) de valores usada com tamanho indefinido/dinamico, podendo adicionar e remover elementos e pode ter tipos diferentes entre os elementos. ex.: [1, "string", :atom, 26.89, %{"mapa" => "valor"}]
  ## TUPLA -> {}  = funciona praticamente igual uma lista, mas é utilizada quando se tem um tamanho definido. muito recorrente ver o uso no retorno das funções no padrão {:ok, resultado} e {:error, mensagem}

  ## LIST -> [{}, {}]  uma lista com elementos tuplas
  ## TUPLA -> {[], []} uma tupla com elementos lista

  ## Para imprirmir informações: IO.inspect("Seu Texto Aqui")

  @moduledoc """
    Módulo de assinante para cadastro de tipos de assinantes como `prepago` e `pospago`

    A função mais utilizada é a função `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []
  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  @doc """
  Buscar por assinante

  ## Parametros

  - numero: passe o numero somente
  - key: se nao passar nada sera `:all`
  """
  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_postpago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  # defp filtro(lista, numero), do: Enum.find(lista, fn assinante -> assinante.numero end) => Foi trocado por uma função: Anonino function end

  @doc """
  Buscar todos assinantes
  """
  def assinantes(), do: read(:prepago) ++ read(:pospago)

  @doc """
  Buscar todos assinantes prepago
  """
  def assinantes_prepago(), do: read(:prepago)

  @doc """
  Buscar todos assinantes pospago
  """
  def assinantes_postpago(), do: read(:pospago)

  @doc """
  Função para cadastrar assinante, seja ele `prepago` e `pospago`

  ##  Parametros da Função

  - nome: parametro do nome do assinante
  - numero: numero unico e caso exista pode retornar um erro
  - cpf: parametro de assinante
  - plano: opcional e caso nao seja informado sera cadastrado um assinante `prepago`

  ## Informacoes Adicionais

  - caso o numero ja exista ele exibira uma mensagem de erro

  ## Exemplo

      iex> Assinante.cadastrar("Joao", "123123", "123123", :prepago)
      {:ok, "Assinante Joao cadastrado com sucesso!"}

  """
  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinateAdd = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pega_plano(assinateAdd)) ++ [assinateAdd])
        |> :erlang.term_to_binary()
        |> white(pega_plano(assinateAdd))

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinante ->
        {:error, "Assinante com este numero Cadastrado!"}
    end
  end

  defp pega_plano(assinante) do
    case assinante.plano.__struct__ == Prepago do
      true -> :prepago
      false -> :pospago
    end
  end

  @doc """
  Funcao para atualizar assinante, e obrigatorio manter o plano

  ##  Parametros da Funcao

  - numero: numero unico e caso exista pode retornar um erro
  - assinante: sempre e necessario passar o assinante
  """
  def atualizar(numero, assinante) do
    {assinante_antigo, nova_lista} = deletar_item(numero)

    case assinante.plano.__struct__ == assinante_antigo.plano.__struct__ do
       true ->
        (nova_lista ++ [assinante])
        |> :erlang.term_to_binary()
        |> white(pega_plano(assinante))

       false ->
        {:erro, "Assinante não pode alterar o plano"}

    end
  end

  defp white(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      # listResult -> Resultado da operação: File.read(@assinantes[plano])
      {:ok, listResult} ->
        listResult
        |> :erlang.binary_to_term()

      {:error, :enoent} ->
        {:error, "Arquivo invalido"}
    end
  end

  @doc """
    Funcao para deletar assinante

    ##  Parametros da Funcao

    - numero: numero unico e caso exista pode retornar um erro
  """
  def deletar(numero) do

    {assinanteFilter, nova_lista} = deletar_item(numero)
    plano = assinanteFilter.plano

    nova_lista
      |> :erlang.term_to_binary()
      |> white(plano)

    {:ok, "Assinante #{assinanteFilter.nome} deletado!"}

  end

  defp deletar_item(numero) do

    assinante = buscar_assinante(numero)

    nova_lista = read(pega_plano(assinante))
      |> List.delete(assinante)

    {assinante, nova_lista}

  end

end
