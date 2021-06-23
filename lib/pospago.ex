defmodule Pospago do

  defstruct valor: 0
  @custo_minimo 1.40

  @doc """
    Registra a chamada
  """
  def fazer_chamada(numero, data, duracao) do

    Assinante.buscar_assinante(numero)
    |> Chamada.registrar(data, duracao)

    {:ok, "Chamada feita com sucesso! duracao: #{duracao} minutos"}

  end

  @doc """
    Imprime a fatura do assinante, alterando os dados do assinante no mes
  """
  def imprimir_conta(mes, ano, numero) do

    assinante = Contas.imprimir(mes, ano, numero, :pospago)

    valor_total =
      assinante.chamadas
      |> Enum.map(&(&1.duracao * @custo_minimo))
      |> Enum.sum()

    %Assinante{assinante | plano: %__MODULE__{valor: valor_total}}

  end

end
