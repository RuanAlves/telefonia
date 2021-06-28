defmodule Assinante_test do
  use ExUnit.Case
  doctest Assinante

  # Usamos o assert macro para testar se a expressão é verdadeira.
  # Usamos para teste: mix test.watch test/assinante_test.exs

  # Toda vez que for realizar um teste, passa no SETUP primeito
  # Assim irá criar os arquivos .txt, e no 'on_exit' irá apagar esses arquivos, depois de terminar o teste

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end


  # Método que agrupa todos os testes relacionados a descrição
  describe "testes responsaveis para cadastro de assinantes" do
    test "deve retornar estrutura de assinante" do
      assert %Assinante{nome: "teste", numero: "teste", cpf: "teste", plano: "plano"}.nome ==
               "teste"
    end

    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Ruan 01", "123", "04345429110", :pospago) ==
               {:ok, "Assinante Ruan 01 cadastrado com sucesso!"}
    end

    test "deve retornar erro dizendo que assinante ja esta cadastrado" do
      Assinante.cadastrar("Ruan 01", "123", "04345429110", :pospago)

      assert Assinante.cadastrar("Ruan 01", "123", "04345429110", :pospago) ==
               {:error, "Assinante com este numero Cadastrado!"}
    end
  end

  describe "testes responsaveis por busca de assinantes" do
    test "busca pospago" do
      Assinante.cadastrar("Ruan 01", "123", "04345429110", :pospago)
      assert Assinante.buscar_assinante("123", :pospago).nome == "Ruan 01"
    end

    test "busca prepago" do
      Assinante.cadastrar("Ruan 01", "123", "04345429110", :prepago)
      assert Assinante.buscar_assinante("123", :prepago).nome == "Ruan 01"
    end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("Ruan 01", "123", "04345429110", :pospago)
      assert Assinante.deletar("123") == {:ok, "Assinante Ruan 01 deletado!"}
    end
  end
end
