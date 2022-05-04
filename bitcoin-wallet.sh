# Passo A1: Instalar ferramentas: openssl base58 grep xxd

# Passo A2: Definir uma senha pessoal (Brain Wallet)

# Passo A3: Passar senha por algoritmo de hash SHA256

# Passo A4: Manter apenas o número hexadecimal da saída do comando

####################################################
# Neste ponto você precisa verificar se o número
# hexadecimal resultante está dentro do limite do
# secp256k1 (https://en.bitcoin.it/wiki/Secp256k1)
# Hexadecimal: FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
####################################################

# Passo A5: Verificar se a senha é válida. Do contrário aborta o processo.

####################################################
# Verificação concluída.
####################################################

# Passo A6: Adicionar números mágicos de prefixo (302e0201010420) e sufixo (a00706052b8104000a) referentes a secp256k1

# Passo A7: Converter número hexadecimal resultante em dados binários

# Passo A8: Passar resultado como input para gerar um par de chaves de curva elíptica

####################################################
# Neste ponto temos o par de chaves pública/privada
# A partir da chave...
# - pública (passos B): gerar o endereço bitcoin para receber moedas
# - privada (passos C): converter para o formato WIF que será importado nos aplicativos tipo Wallet
####################################################

# Passo B1: Extrair chave pública do Passo A8 como texto numérico hexadecimal

# Passo B2: Converter número hexadecimal resultante em dados binários

# Passo B3: Passar resultado como input de algoritmo de hash SHA256

# Passo B4: Manter apenas o número hexadecimal da saída do comando

# Passo B5: Converter número hexadecimal resultante em dados binários

# Passo B6: Passar resultado como input de algoritmo de hash RIPEMD-160

# Passo B7: Manter apenas o número hexadecimal da saída do comando

# Passo B8: Prefixar com "00" (0x00) que sinaliza um endereço P2PKH

####################################################
# Neste ponto usamos um algoritmo tipo CHECKSUM
# com 2 loops
####################################################

# Checksum 1a: Converter número hexadecimal resultante em dados binários

# Checksum 2a. Passar resultado como input de algoritmo de hash SHA256

# Checksum 3a. Manter apenas o número hexadecimal da saída do comando

# Checksum 1b: Converter número hexadecimal resultante em dados binários

# Checksum 2b. Passar resultado como input de algoritmo de hash SHA256

# Checksum 3b. Manter apenas o número hexadecimal da saída do comando

# Checksum Final: Extrai os primeiros 4 bytes (ou 8 caracteres) que servirão como checksum

####################################################
# Neste ponto finalizamos o CHECKSUM
####################################################

# Passo B9: Adiciona o checksum ao final do resultado do Passo B8 que havia sido prefixado com "00"

# Passo B10: Converter número hexadecimal resultante em dados binários

# Passo B11: Codificar resultado como Base58

####################################################
# Neste ponto temos finalizamos os passos B tendo
# o endereço público que recebe moedas de Bitcoin.
# Continuamos com os passos C para chave privada.
####################################################

# Passo C1: Extrair chave privada do Passo A8 como texto numérico hexadecimal

# Passo C2: Garanta o comprimento de 32 bytes (ou 64 caracteres) por acrescentar zeros à esquerda

# Passo C3: Prefixar com "80" (0x80) que sinaliza a versão da chave privada

####################################################
# Neste ponto usamos um algoritmo tipo CHECKSUM
# com 2 loops
####################################################

# Checksum 1a: Converter número hexadecimal resultante em dados binários

# Checksum 2a. Passar resultado como input de algoritmo de hash SHA256

# Checksum 3a. Manter apenas o número hexadecimal da saída do comando

# Checksum 1b: Converter número hexadecimal resultante em dados binários

# Checksum 2b. Passar resultado como input de algoritmo de hash SHA256

# Checksum 3b. Manter apenas o número hexadecimal da saída do comando

# Checksum Final: Extrai os primeiros 4 bytes (ou 8 caracteres) que servirão como checksum

####################################################
# Neste ponto finalizamos o CHECKSUM
####################################################

# Passo C11: Adiciona o checksum ao final do resultado do Passo C3 que havia sido prefixado com "80"

# Passo C12: Converter número hexadecimal resultante em dados binários

# Passo C13: Codificar resultado como Base58

####################################################
# Neste ponto temos finalizamos os passos C tendo
# o a chave privada no formato WIF para importação
# em aplicativos tipo carteira.
####################################################
