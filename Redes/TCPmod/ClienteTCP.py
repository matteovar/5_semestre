import socket

TCP_IP = '192.168.15.23'
TCP_PORTA = 10390
TAMANHO_BUFFER = 1024

# Criação de socket TCP do cliente
cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cliente.connect((TCP_IP, TCP_PORTA))

print("Conectado ao servidor. Digite 'QUIT' para sair.")

while True:
    mensagem = input("Você: ")
    cliente.send(mensagem.encode('utf-8'))
    
    if mensagem.upper() == 'QUIT':
        break
    
    dados = cliente.recv(TAMANHO_BUFFER)
    print("Servidor:", dados.decode('utf-8'))

cliente.close()
