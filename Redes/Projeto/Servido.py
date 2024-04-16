import socket
import _thread

HOST = '192.168.15.23'  # Endereço IP do Servidor
PORT = 5000  # Porta que o Servidor está

# Lista para armazenar todas as conexões dos clientes
conexoes = []

# Função chamada quando uma nova thread for iniciada
def handle_client(con, cliente):
    print('\nCliente conectado:', cliente)
    
    # Adicionando a conexão à lista global de conexões
    conexoes.append(con)

    while True:
        try:
            # Recebendo a mensagem do cliente
            msg = con.recv(1024)
            if not msg:
                break
            print('\nCliente:', cliente)
            print('Mensagem:', msg.decode())
            
            # Enviando a mensagem para todos os outros clientes conectados
            for conexao in conexoes:
                if conexao != con:
                    conexao.sendall(msg)
        except Exception as e:
            print("Erro:", e)
            break

    # Removendo a conexão da lista após a desconexão do cliente
    conexoes.remove(con)
    con.close()
    print('\nFinalizando conexão do cliente', cliente)

# Criando o socket TCP
tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
orig = (HOST, PORT)

# Colocando um endereço IP e uma porta no Socket
tcp.bind(orig)
# Colocando o Socket em modo passivo
tcp.listen(10)  # Defina um número máximo de conexões pendentes

print('\nServidor TCP concorrente iniciado no IP', HOST, 'na porta', PORT)

while True:
    # Aceitando uma nova conexão
    con, cliente = tcp.accept()
    print('\nNova conexão de', cliente)
    
    # Abrindo uma thread para a conexão
    _thread.start_new_thread(handle_client, tuple([con, cliente]))

# Fechando a conexão com o Socket
tcp.close()
