defmodule PrepagoTest do

  use ExUnit.Case
  doctest Prepago

  #Toda vez que for realizar um teste, passa no SETUP primeito
  #Assim irá criar os arquivos .txt, e no 'on_exit' irá apagar esses arquivos, depois de terminar o teste
  setup do

    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)

  end

  test "Deve testar a estrutura" do
    assert %Prepago{creditos: 0, recargas: []}.creditos == 0
  end

  describe "Funções de Ligação" do
    test "Fazer ligação" do
      Assinante.cadastrar("Ruan 01", "123", "04345429110", :prepago)
      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
        #{:ok, "A chamada custou 4.35, e voce tem 5.65 de creditos"}
        {:error, "Voce creditos para fazer a ligacao, faca uma recarga"}
    end
  end

  describe "Testes para impressao de Contas" do
    test "Deve informar valores da conta do mes" do

      Assinante.cadastrar("Ruan 01", "123", "04345429110", :prepago)
      data = DateTime.utc_now()
      data_antigo = ~U[2021-05-21 16:09:01.241846Z]

      Recarga.nova(data, 10, "123")
      Prepago.fazer_chamada("123", data, 3)

      Recarga.nova(data_antigo, 10, "123")
      Prepago.fazer_chamada("123", data_antigo, 3)

      assinante = Assinante.buscar_assinante("123", :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      assinante = Prepago.imprimir_conta(data.month, data.year, "123")

      assert assinante.numero == "123"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1

    end
  end

end
