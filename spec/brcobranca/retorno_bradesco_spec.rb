# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brcobranca::Retorno::RetornoBradesco do

  before(:each) do
    @arquivo = File.join(File.dirname(__FILE__),'..','arquivos','EXEMPLO_RETORNO_BRADESCO.RET')
  end
  
  
  
  it "Confere informacoes do cabecalho" do
    pagamentos = Brcobranca::Retorno::RetornoBradesco.load_lines(@arquivo)
    cabecalho = pagamentos.first
    cabecalho.sequencial.should eql("000001")
    cabecalho.empresa_codigo.should eql("00000000000004244564")
    cabecalho.data_credito.should eql("")
  end

  it "Transforma arquivo de retorno em objetos com apenas titulos e rodape usando :except" do
    pagamentos = Brcobranca::Retorno::RetornoBradesco.load_lines(@arquivo, {:except=> [1]})
    titulo = pagamentos.first
    titulo.sequencial.should eql("000002")
    rodape = pagamentos.last
    rodape.sequencial.to_i.should eql(pagamentos.size+1)
  end

  it "Confere valores recebidos de acordo com o valor exposto no rodape" do
    pagamentos = Brcobranca::Retorno::RetornoBradesco.load_lines(@arquivo, {:except=> [1]})
    pagamentos.last.valor_total_titulos.to_i.should eql(2838288)
  end
end
