"""
Mini serveur local pour Background Remover.
Sert le fichier index.html avec les en-tetes COOP/COEP necessaires
pour faire fonctionner le moteur IA (ONNX/WASM) dans le navigateur.
"""
import http.server
import socketserver
import webbrowser
import os
import sys
from pathlib import Path

PORT = 8765


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        '.wasm': 'application/wasm',
        '.js': 'application/javascript',
        '.mjs': 'application/javascript',
        '.json': 'application/json',
    }

    def end_headers(self):
        # Cross-Origin Isolation pour SharedArrayBuffer / WebAssembly threads
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Resource-Policy', 'cross-origin')
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

    def log_message(self, format, *args):
        # Silence des logs verbeux
        return


def main():
    os.chdir(Path(__file__).resolve().parent)

    try:
        with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
            url = f'http://localhost:{PORT}/index.html'
            print('')
            print('  +-----------------------------------+')
            print('  |   Background Remover              |')
            print('  +-----------------------------------+')
            print(f'  Serveur actif : {url}')
            print('  Pour arreter  : Ctrl+C')
            print('')
            print('  L\'application va s\'ouvrir dans votre navigateur...')
            print('')
            webbrowser.open(url)
            httpd.serve_forever()
    except KeyboardInterrupt:
        print('\nServeur arrete.')
    except OSError as e:
        # Port deja utilise -> on suppose qu'une autre instance tourne
        if getattr(e, 'errno', None) in (48, 98, 10048) or 'in use' in str(e).lower():
            url = f'http://localhost:{PORT}/index.html'
            print(f'Le port {PORT} est deja utilise.')
            print(f'Ouverture directe de : {url}')
            webbrowser.open(url)
            input('Appuyez sur Entree pour quitter...')
        else:
            raise


if __name__ == '__main__':
    main()
