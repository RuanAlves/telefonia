defmodule RecargaTest do

  use ExUnit.Case
  ##doctest Recarga

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

  test "Deve realizar uma recarga" do
    Assinante.cadastrar("Ruan 01", "123", "04345429110", :prepago)

    {:ok, msg} = Recarga.nova(DateTime.utc_now(), 30, "123")
    assert msg == "Recarga realizada com sucesso!"

    assinante = Assinante.buscar_assinante("123", :prepago)
    assert assinante.plano.creditos == 30
    assert Enum.count(assinante.plano.recargas) == 1

  end

end
