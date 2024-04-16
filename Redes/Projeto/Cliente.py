import socket
import threading

def receive_messages(client_socket):
    while True:
        try:
            # Receber mensagens do servidor
            message = client_socket.recv(1024).decode()
            if not message:
                break
            print(message)
        except Exception as e:
            print("Erro ao receber mensagem:", e)
            break

# Função principal para o cliente
def main():
    # Endereço IP e porta do servidor
    SERVER_HOST = '192.168.15.23'
    SERVER_PORT = 5000

    # Criar o socket TCP
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    try:
        # Conectar ao servidor
        client_socket.connect((SERVER_HOST, SERVER_PORT))

        # Iniciar uma thread para receber mensagens do servidor
        receive_thread = threading.Thread(target=receive_messages, args=(client_socket,))
        receive_thread.start()

        # Loop para enviar mensagens ao servidor
        mensagem = input()
        while mensagem != '\x18':  # Enquanto a mensagem não for ^X
            client_socket.sendall(mensagem.encode())
            mensagem = input()

    except Exception as e:
        print("Erro ao conectar ao servidor:", e)

    finally:
        # Fechar o socket
        client_socket.close()

if __name__ == "__main__":
    main()
