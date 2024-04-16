import socket

TCP_IP = '192.168.15.23'
TCP_PORTA = 10390
TAMANHO_BUFFER = 1024

# Criação de socket TCP do servidor
servidor = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
servidor.bind((TCP_IP, TCP_PORTA))
servidor.listen(1)

print("Servidor disponível na porta 10390 e escutando...")

conn, addr = servidor.accept()
print('Conectado ao endereço:', addr)

while True:
    dados = conn.recv(TAMANHO_BUFFER)
    if not dados:
        break
    
    mensagem = dados.decode('utf-8')
    print("Cliente:", mensagem)
    
    if mensagem.upper() == 'QUIT':
        break
    
    resposta = input("Você: ")
    conn.send(resposta.encode('utf-8'))

conn.close()
servidor.close()
