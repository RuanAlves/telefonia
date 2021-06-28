defmodule PospagoTest do

  use ExUnit.Case
  doctest Pospago

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
    assert %Pospago{valor: 10}.valor == 10
  end

  test "Deve fazer uma ligação pospago" do

    Assinante.cadastrar("Usuario", "123", "123", :pospago)

    assert Pospago.fazer_chamada("123", DateTime.utc_now(), 5) ==
      {:ok, "Chamada feita com sucesso! duracao: 5 minutos"}

  end

  test "Deve imprimir a conta do assinante" do

    Assinante.cadastrar("Usuario", "123", "123", :pospago)

    data = DateTime.utc_now()
    data_antiga = ~U[2021-05-21 16:09:01.241846Z]

    Pospago.fazer_chamada("123", data, 3)
    Pospago.fazer_chamada("123", data_antiga, 3)
    Pospago.fazer_chamada("123", data, 3)
    Pospago.fazer_chamada("123", data, 3)

    assinante = Assinante.buscar_assinante("123", :pospago)
    assert Enum.count(assinante.chamadas) == 4

    assinante = Pospago.imprimir_conta(data.month, data.year, "123")
    assert assinante.numero == "123"
    assert Enum.count(assinante.chamadas) == 3
    assert assinante.plano.valor == 12.599999999999998

  end

end
