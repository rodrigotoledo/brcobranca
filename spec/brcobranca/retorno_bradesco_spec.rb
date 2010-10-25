# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Brcobranca::Retorno::RetornoBradesco do

  before(:each) do
    @arquivo = File.join(File.dirname(__FILE__),'..','arquivos','EXEMPLO_RETORNO_BRADESCO.RET')
  end
  
  
  
  it "Transforma arquivo de retorno em objetos de retorno" do
    pagamentos = Brcobranca::Retorno::RetornoCbr643.load_lines(@arquivo)
#    pagamentos.first.sequencial.should eql("000001")
#    pagamentos.first.agencia_com_dv.should eql("CA")
#    pagamentos.first.cedente_com_dv.should eql("33251")
#    pagamentos.first.convenio.should eql("0002893")
#    pagamentos.first.data_liquidacao.should eql("")
#    pagamentos.first.data_credito.should eql("")
#    pagamentos.first.valor_recebido.should eql("")
#    pagamentos.first.nosso_numero.should eql("OSSENSE DO AL001B")
  end

  it "Transforma arquivo de retorno em objetos de retorno excluindo a primeira linha com a opção :except" do
    
  end

  it "Transforma arquivo de retorno em objetos de retorno excluindo a primeira linha com a opção :except e :length" do
    
  end

  it "Transforma arquivo de retorno em objetos de retorno excluindo a primeira linha com a opção :except em regex" do
    
  end

  it "Transforma arquivo de retorno em objetos de retorno excluindo a primeira linha com a opção :except em regex e :length" do
    
  end
  
  it "Retorna um trecho formatado como string" do
  end
  
  it "Retorna um trecho formatado como inteiro" do
  end
  
  it "Retorna um erro ao nao informar corretamente informacoes para a geracao de trecho" do
  end
  
  it "Deve criar um arquivo de retorno sem passar parametros" do
  end
  
  it "Deve criar um arquivo de retorno passando parametros" do
  end
  
  it "Deve retornar uma excessao na geracao de arquivo de retorno por parametros incorretos" do
  end
end
