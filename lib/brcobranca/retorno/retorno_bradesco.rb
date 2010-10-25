require 'parseline'
module Brcobranca
  module Retorno
    # Formato de Retorno Proprio do Bradesco
    class RetornoBradesco < Base
      extend ParseLine::FixedWidth # Extendendo parseline

      attr_accessor :empresa_codigo, :empresa_razao_social, :data_gravacao_arquivo, :numero_aviso,
        :empresa_tipo, :empresa_cnpj_cpf_numero, :empresa_agencia_conta, :controle_participante, :identificacao_titulo, :rateio,
        :data_ocorrencia_banco, :numero_documento, :valor_despesa,
        :instrucao_protesto, :quantidade_titulos, :valor_total_titulos
      

      fixed_width_layout do |parse|
        parse.field :empresa_codigo,26..45
        parse.field :empresa_razao_social,46..75
        parse.field :data_gravacao_arquivo,94..99
        parse.field :numero_aviso,108..112
        parse.field :data_credito,295..300
        parse.field :sequencial,394..399
        parse.field :empresa_tipo,1..2
        parse.field :empresa_cnpj_cpf_numero,3..16
        parse.field :empresa_agencia_conta, 20..36
        parse.field :controle_participante, 37..61
        parse.field :nosso_numero, 126..145
        parse.field :identificacao_titulo, 70..81
        parse.field :rateio, 104..104
        parse.field :carteira, 107..107
        parse.field :data_ocorrencia_banco, 110..115
        parse.field :numero_documento, 116..125
        parse.field :data_vencimento, 146..151
        parse.field :valor_titulo, 152..164
        parse.field :banco_recebedor, 165..167
        parse.field :agencia_recebedora_com_dv, 168..172
        parse.field :valor_despesa, 175..187
        parse.field :outras_despesas, 188..200
        parse.field :iof, 214..226
        parse.field :valor_abatimento, 227..239
        parse.field :desconto_concedido, 240..252
        parse.field :valor_recebido, 253..265
        parse.field :juros_mora, 266..278
        parse.field :instrucao_protesto, 294..294
        parse.field :quantidade_titulos, 17..24
        parse.field :valor_total_titulos, 25..38
      end


      # Deve criar um arquivo no destino especificado no primeiro parametro
      #  destino: +String+ url do arquivo
      #  informacoes: +Hash+ informacoes para gerar arquivo de retorno como cnpj da empresa
      #  num_cobrancas: +Fixnum+ numero de cobrancas geradas
      def self.gerar_arquivo_retorno(destino,informacoes = {},num_cobrancas = 1)
        informacoes = {
          :nome_fantasia => "EMPRESA TESTE",
          :cnpj_cpf => 48962772604, # gerado a partir de http://geradorcpfcnpj.ureshino.org/
          :numero_aviso => 0,
          :identificacao_empresa => 1234,
          :agencia_recebedora_com_dv => 123,
          :banco_recebedor => 237
        }.merge(informacoes)
      
        conteudo_arquivo = ""
        
        #cabecalho
        begin
          [
            {:tamanho => 1,   :conteudo => 0}, # identificacao registro
            {:tamanho => 1,   :conteudo => 2}, # identificacao do arquivo de retorno
            {:tamanho => 7,   :conteudo => "RETORNO", :tipo => 's'}, #fixo
            {:tamanho => 2,   :conteudo => 1},# codigo do servico
            {:tamanho => 15,  :conteudo => 'COBRANCA',:tipo => 's'}, #fixo
            {:tamanho => 20,  :conteudo => informacoes[:cnpj_cpf]},# numero empresa
            {:tamanho => 30,  :conteudo => informacoes[:nome_fantasia], :tipo => 's' }, # nome fantasia
            {:tamanho => 3,   :conteudo => 237 }, # codigo do banco
            {:tamanho => 15,  :conteudo => 'BRADESCO', :tipo => 's' }, # fixo
            {:tamanho => 6,   :conteudo => Time.now.strftime("%d%m%y") }, # data gravacao arquivo
            {:tamanho => 8,   :conteudo => 0 }, # zeros
            {:tamanho => 5,   :conteudo => informacoes[:numero_aviso] }, # numero aviso
            {:tamanho => 266, :conteudo => '', :tipo => 's' }, # brancos
            {:tamanho => 6,   :conteudo => Time.now.tomorrow.strftime("%d%m%y") }, # data do credito
            {:tamanho => 9,   :conteudo => '', :tipo => 's' }, # brancos
            {:tamanho => 6,   :conteudo => 1 } # sequencial
          ].each do |pos|
            conteudo_arquivo << self.gerar_trecho(pos[:tamanho],pos[:conteudo])
          end
        rescue => msg
          raise 'Falha ao criar o cabecalho: #{msg.message}'
        end

        
        # corpo
        begin
          valor_total = 0
          1.upto(num_cobrancas).each do |i|
            conteudo_arquivo << "\n"
            valor = rand(123456)
            valor_total += valor
            [
              {:tamanho => 1,   :conteudo => 0}, # identificacao, 1
              {:tamanho => 2,   :conteudo => 2}, #tipo inscricao
              {:tamanho => 14,  :conteudo => informacoes[:cnpj_cpf]}, #cnpj
              {:tamanho => 3,   :conteudo => 0}, # zeros
              {:tamanho => 17,  :conteudo => informacoes[:identificacao_empresa]}, # carteira, agencia, conta
              {:tamanho => 25,  :conteudo => '', :tipo => 's'}, # numero de controle do participante
              {:tamanho => 8,   :conteudo => 0}, # zeros
              {:tamanho => 12,  :conteudo => i.next}, #identificacao do titulo no banco
              {:tamanho => 10,  :conteudo => '',:tipo => 's'}, # branco
              {:tamanho => 12,  :conteudo => 0}, #zero
              {:tamanho => 1,   :conteudo => 0}, # indicador de rateio
              {:tamanho => 2,   :conteudo => 0}, # zeros
              {:tamanho => 1,   :conteudo => 6}, # carteira
              {:tamanho => 2,   :conteudo => 6}, # identificacao de ocorrencia
              {:tamanho => 6,   :conteudo => Time.now.strftime("%d%m%y") }, # data ocorrencia no banco
              {:tamanho => 10,  :conteudo => cobranca.nosso_numero }, #numero documento
              {:tamanho => 20,  :conteudo => i }, # identificacao do titulo no banco
              {:tamanho => 6,   :conteudo => Time.now.tomorrow.strftime("%d%m%y") }, # data de vencimento
              {:tamanho => 13,  :conteudo => valor }, # valor do titulo
              {:tamanho => 3,   :conteudo => informacoes[:banco_recebedor] }, # codigo do banco de compensacao
              {:tamanho => 5,   :conteudo => informacoes[:agencia_recebedora_com_dv] }, # agencia do banco cobrador
              {:tamanho => 2,   :conteudo => '',:tipo => 's'}, # branco
              {:tamanho => 13,  :conteudo => 0 }, # valor despesa
              {:tamanho => 13,  :conteudo => 0 }, # valor outras despesas
              {:tamanho => 13,  :conteudo => 0 }, # juros operacao em atraso
              {:tamanho => 13,  :conteudo => 0 }, # iof
              {:tamanho => 13,  :conteudo => 0 }, # valor abatimento
              {:tamanho => 13,  :conteudo => 0 }, # valor desconto
              {:tamanho => 13,  :conteudo => valor }, # valor PAGO
              {:tamanho => 13,  :conteudo => 0 }, # juros mora
              {:tamanho => 13,  :conteudo => 0 }, # outros creditos
              {:tamanho => 2,   :conteudo => '',:tipo => 's'}, #brancos
              {:tamanho => 1,   :conteudo => '',:tipo => 's'}, # confirmacao de instrucao de protesto
              {:tamanho => 6,   :conteudo => Time.now.tomorrow.strftime("%d%m%y")}, # data credito
              {:tamanho => 17,  :conteudo => '',:tipo => 's'}, # brancos
              {:tamanho => 10,  :conteudo => 0 }, # motivo rejeicao
              {:tamanho => 66,  :conteudo => '',:tipo => 's'}, # brancos
              {:tamanho => 6,   :conteudo => i+1 } # sequencial
            ].each do |pos|
              conteudo_arquivo << self.gerar_trecho(pos[:tamanho],pos[:conteudo])
            end
          end
        
        rescue => msg
          raise 'Falha ao criar o corpo: #{msg.message}'
        end
        
        # rodape
        begin
          conteudo_arquivo << "\n"
          [
            {:tamanho => 1,   :conteudo => 9}, # identificacao registro
            {:tamanho => 1,   :conteudo => 2}, # identificacao do arquivo de retorno
            {:tamanho => 2,   :conteudo => 1}, #fixo
            {:tamanho => 3,   :conteudo => 237 }, # codigo do banco
            {:tamanho => 10,  :conteudo => '', :tipo => 's' }, # brancos
            {:tamanho => 8,   :conteudo => num_cobrancas}, # numero de titulos
            {:tamanho => 14,  :conteudo => total}, # valor total
            {:tamanho => 355, :conteudo => 0}, #fixo
            {:tamanho => 6,   :conteudo => num_cobrancas+1 } # sequencial
          ].each do |pos|
            conteudo_arquivo << self.gerar_trecho(pos[:tamanho],pos[:conteudo])
          end
        rescue => msg
          raise 'Falha ao criar o rodape: #{msg.message}'
        end
        
        begin
          File.open(destino,'w+'){|f| f.write(conteudo_arquivo)}
        rescue => msg
          raise 'Falha ao criar o arquivo: #{msg.message}'
        end
      end


      # Funcao de auxilio para gerar trechos do arquivo de retorno
      # <tt>tamanho</tt> Tamanho do campo
      # <tt>conteudo</tt> O conteudo que deve ser aplicado
      def self.gerar_trecho(tamanho,conteudo)
        tipo      = 'd'
        auxiliar  = 0
        if conteudo.is_a?(String)
          tipo = 's'
          auxiliar = ' '
        end
        sprintf("%#{auxiliar}#{tamanho}#{tipo}",conteudo).to_s
      end
    end
  end
end

