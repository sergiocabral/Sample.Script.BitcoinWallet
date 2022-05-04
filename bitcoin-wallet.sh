# Passo A1: Instalar ferramentas: openssl base58 grep xxd

apt-get install -y openssl base58 grep xxd;

# Passo A2: Definir uma senha pessoal (Brain Wallet)

PASSWORD="my-difficult-passphrase";

# Passo A3: Passar senha por algoritmo de hash SHA256

RESULT=$(printf "$PASSWORD" | openssl sha256);

# Passo A4: Manter apenas o número hexadecimal da saída do comando

RESULT=$(printf "$RESULT" | grep -o "[0-9a-f]\+\b");

####################################################
# Neste ponto você precisa verificar se o número
# hexadecimal resultante está dentro do limite do
# secp256k1 (https://en.bitcoin.it/wiki/Secp256k1)
# Hexadecimal: FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
####################################################

# Passo A5: Verificar se a senha é válida. Do contrário aborta o processo.

MAX_HASH_VALUE="FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141";

RESULT=$(echo "ibase=16; $MAX_HASH_VALUE - $(printf $RESULT | tr a-z A-Z)" | bc | tr -d '\n\\' | [[ $(grep -o '^-') == '-' ]] && printf "" || printf "$RESULT");

ERROR=$([[ "$RESULT" == "" ]] && printf "This password results in a hash that violates the secp256k1 algorithm used in Bitcoin. Try another password.");

####################################################
# Verificação concluída.
####################################################

# Passo A6: Adicionar números mágicos de prefixo (302e0201010420) e sufixo (a00706052b8104000a) referentes a secp256k1

PREFIX="302e0201010420";
SUFFIX="a00706052b8104000a";

RESULT=$(printf "${PREFIX}${RESULT}${SUFFIX}");

# Passo A7: Converter número hexadecimal resultante em dados binários

### printf "$RESULT" | xxd -r -ps;

# Passo A8: Passar resultado como input para gerar um par de chaves de curva elíptica

KEYS=$(echo $(openssl ec -inform DER -text -noout -in <(printf "$RESULT" | xxd -r -ps) 2> /dev/null));

####################################################
# Neste ponto temos o par de chaves pública/privada
# A partir da chave...
# - pública (passos B): gerar o endereço bitcoin para receber moedas
# - privada (passos C): converter para o formato WIF que será importado nos aplicativos tipo Wallet
####################################################

# Passo B1: Extrair chave pública do Passo A8 como texto numérico hexadecimal

PUB_KEY=$(printf "$KEYS" | tr -d '\n ' | grep -o 'pub:[0-9a-f:]*' | sed -e 's/^pub//' | tr -d ':');

RESULT=$PUB_KEY;

# Passo B2: Converter número hexadecimal resultante em dados binários

### printf "$RESULT" | xxd -r -ps;

# Passo B3: Passar resultado como input de algoritmo de hash SHA256

RESULT=$(printf "$RESULT" | xxd -r -ps | openssl sha256);

# Passo B4: Manter apenas o número hexadecimal da saída do comando

RESULT=$(printf "$RESULT" | grep -o "[0-9a-f]\+\b");

# Passo B5: Converter número hexadecimal resultante em dados binários

### printf "$RESULT" | xxd -r -ps;

# Passo B6: Passar resultado como input de algoritmo de hash RIPEMD-160

RESULT=$(printf "$RESULT" | xxd -r -ps | openssl rmd160);

# Passo B7: Manter apenas o número hexadecimal da saída do comando

RESULT=$(printf "$RESULT" | grep -o "[0-9a-f]\+\b");

# Passo B8: Prefixar com "00" (0x00) que sinaliza um endereço P2PKH

PREFIX="00";

RESULT="${PREFIX}${RESULT}";

####################################################
# Neste ponto usamos um algoritmo tipo CHECKSUM
# com 2 loops
####################################################

# Checksum 1a: Converter número hexadecimal resultante em dados binários

CHECKSUM=$RESULT;

### printf "$CHECKSUM" | xxd -r -ps;

# Checksum 2a. Passar resultado como input de algoritmo de hash SHA256

CHECKSUM=$(printf "$CHECKSUM" | xxd -r -ps | openssl sha256);

# Checksum 3a. Manter apenas o número hexadecimal da saída do comando

CHECKSUM=$(printf "$CHECKSUM" | grep -o "[0-9a-f]\+\b");

# Checksum 1b: Converter número hexadecimal resultante em dados binários

### printf "$CHECKSUM" | xxd -r -ps;

# Checksum 2b. Passar resultado como input de algoritmo de hash SHA256

CHECKSUM=$(printf "$CHECKSUM" | xxd -r -ps | openssl sha256);

# Checksum 3b. Manter apenas o número hexadecimal da saída do comando

CHECKSUM=$(printf "$CHECKSUM" | grep -o "[0-9a-f]\+\b");

# Checksum Final: Extrai os primeiros 4 bytes (ou 8 caracteres) que servirão como checksum

CHECKSUM=$(printf "$CHECKSUM" | grep -o "^[0-9a-f]\{8\}");

####################################################
# Neste ponto finalizamos o CHECKSUM
####################################################

# Passo B9: Adiciona o checksum ao final do resultado do Passo B8 que havia sido prefixado com "00"

RESULT="${RESULT}${CHECKSUM}";

# Passo B10: Converter número hexadecimal resultante em dados binários

### printf "$RESULT" | xxd -r -ps;

# Passo B11: Codificar resultado como Base58

ADDRESS=$(printf "$RESULT" | xxd -r -ps | base58);

####################################################
# Neste ponto temos finalizamos os passos B tendo
# o endereço público que recebe moedas de Bitcoin.
# Continuamos com os passos C para chave privada.
####################################################

# Passo C1: Extrair chave privada do Passo A8 como texto numérico hexadecimal

PRIV_KEY=$(printf "$KEYS" | tr -d '\n ' | grep -o 'priv:[0-9a-f:]*' | sed -e 's/^priv//' | tr -d ':');

RESULT=$PRIV_KEY;

# Passo C2: Garanta o comprimento de 32 bytes (ou 64 caracteres) por acrescentar zeros à esquerda

RESULT=$(printf "0000000000000000000000000000000000000000000000000000000000000000$RESULT" | grep -o '[0-9a-f]\{64\}$');

# Passo C3: Prefixar com "80" (0x80) que sinaliza a versão da chave privada

PREFIX="80";

RESULT="${PREFIX}${RESULT}";

####################################################
# Neste ponto usamos um algoritmo tipo CHECKSUM
# com 2 loops
####################################################

# Checksum 1a: Converter número hexadecimal resultante em dados binários

CHECKSUM=$RESULT;

### printf "$CHECKSUM" | xxd -r -ps;

# Checksum 2a. Passar resultado como input de algoritmo de hash SHA256

CHECKSUM=$(printf "$CHECKSUM" | xxd -r -ps | openssl sha256);

# Checksum 3a. Manter apenas o número hexadecimal da saída do comando

CHECKSUM=$(printf "$CHECKSUM" | grep -o "[0-9a-f]\+\b");

# Checksum 1b: Converter número hexadecimal resultante em dados binários

### printf "$CHECKSUM" | xxd -r -ps;

# Checksum 2b. Passar resultado como input de algoritmo de hash SHA256

CHECKSUM=$(printf "$CHECKSUM" | xxd -r -ps | openssl sha256);

# Checksum 3b. Manter apenas o número hexadecimal da saída do comando

CHECKSUM=$(printf "$CHECKSUM" | grep -o "[0-9a-f]\+\b");

# Checksum Final: Extrai os primeiros 4 bytes (ou 8 caracteres) que servirão como checksum

CHECKSUM=$(printf "$CHECKSUM" | grep -o "^[0-9a-f]\{8\}");

####################################################
# Neste ponto finalizamos o CHECKSUM
####################################################

# Passo C11: Adiciona o checksum ao final do resultado do Passo C3 que havia sido prefixado com "80"

RESULT="${RESULT}${CHECKSUM}";

# Passo C12: Converter número hexadecimal resultante em dados binários

### printf "$RESULT" | xxd -r -ps;

# Passo C13: Codificar resultado como Base58

WIF=$(printf "$RESULT" | xxd -r -ps | base58);

####################################################
# Neste ponto temos finalizamos os passos C tendo
# o a chave privada no formato WIF para importação
# em aplicativos tipo carteira.
####################################################

printf "\nBitcoin Address Generator";
printf "\n\nPassword:\n$PASSWORD$([[ "$ERROR" != "" ]] && printf "\n\nError:\n$ERROR")";
printf "$([[ "$ERROR" == "" ]] && printf "\n\nPrivate Key:\n$PRIV_KEY")";
printf "$([[ "$ERROR" == "" ]] && printf "\n\nPrivate Key, Wallet Import Format (WIF):\n$WIF")";
printf "$([[ "$ERROR" == "" ]] && printf "\n\nPublic Key:\n$PUB_KEY")";
printf "$([[ "$ERROR" == "" ]] && printf "\n\nPublic Key, Address:\n$ADDRESS")\n\n";
