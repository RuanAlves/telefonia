defmodule Prepago do
  defstruct creditos: 0, recargas: []
  @preco_minimo 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minimo * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}

        assinante =
          %Assinante{assinante | plano: plano}
          |> Chamada.registrar(data, duracao)

        {:ok, "A chamada custou #{custo}, e voce tem #{plano.creditos} de creditos"}

      true ->
        {:error, "Voce creditos para fazer a ligacao, faca uma recarga"}
    end
  end

  def imprimir_conta(mes, ano, numero) do
    Contas.imprimir(mes, ano, numero, :prepago)
  end

end
