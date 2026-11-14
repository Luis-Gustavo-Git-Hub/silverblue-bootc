# silverblue-bootc

Projeto pessoal derivado da imagem Fedora Silverblue, mantendo o desktop GNOME, removendo Firefox, GNOME Tour, GNOME Maps, GNOME Weather (Clima) e o aplicativo Controle Parental (`malcontent-control`) e adicionando Brave Origin estável. Não é uma edição oficial do Fedora.

## Brave Origin

O Containerfile adiciona o repositório RPM oficial do Brave e instala `brave-origin` durante o build usando `rpm-ostree`, que suporta a composição de imagens derivadas do Silverblue. Isso corresponde à edição selecionada pelo comando `curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh`. O build verifica a presença do pacote antes de validar a imagem. A instalação e a abertura do navegador ainda precisam ser testadas no primeiro build e em VM.

As atualizações do navegador entram nos novos builds da imagem, publicados pelo workflow diário. Para recebê-las no sistema, será necessário atualizar a imagem do sistema.

Instruções oficiais: https://brave.com/origin/linux/

Base configurada: `quay.io/fedora-ostree-desktops/silverblue:45`.
O projeto não usa a imagem genérica `fedora-bootc`.

## Estado

Estrutura inicial preparada. O manifesto da base e o build não foram validados neste ambiente: não há acesso de rede pelo terminal nem Podman instalado. O primeiro build no Actions deve confirmar a disponibilidade da tag e executar `bootc container lint`. Ainda não houve teste de inicialização em VM.

## GitHub

1. Crie um repositório vazio chamado `silverblue-bootc`, com a branch `main`.
2. Envie todos os arquivos desta pasta, incluindo `.github/workflows/build.yml`.
3. Na aba Actions, acompanhe o workflow **Build Silverblue**.

O workflow constrói para x86_64 e publica em `ghcr.io/<conta>/silverblue-bootc:latest`, com o nome da conta em minúsculas. Também publica uma tag por commit. Pull requests apenas constroem; não publicam.

O `GITHUB_TOKEN` do Actions fornece a autenticação, sem token pessoal. Se a organização restringir publicação de pacotes, ajuste a política correspondente. Para consumo anônimo, configure a visibilidade do pacote GHCR como pública após a primeira publicação.

## Build local

Em uma máquina com Podman:

```bash
sudo podman build --pull=always --format oci -t localhost/silverblue-bootc:latest -f Containerfile .
```

## Próximos passos

Após o primeiro build bem-sucedido, testar a imagem em VM e definir assinatura, instalação e atualizações antes de usá-la no computador principal. Este projeto ainda não gera ISO e não contém instruções para alterar o sistema instalado.

## Referências

- https://quay.io/repository/fedora-ostree-desktops/silverblue
- https://docs.fedoraproject.org/en-US/bootc/
- https://fedoraproject.org/atomic-desktops/silverblue/

## Multimídia e miniaturas

Inclui RPM Fusion Free, libavcodec-freeworld, plugins GStreamer, ffmpegthumbnailer, glycin-loaders e libheif-tools/libheif-freeworld para ampliar reprodução e miniaturas de vídeos e imagens, incluindo HEIF/HEIC e AVIF. A disponibilidade de cada codec depende do aplicativo; aplicativos Flatpak usam seus próprios runtimes. Aceleração de vídeo por GPU não foi personalizada. As miniaturas seguem as preferências do Arquivos, inclusive para arquivos remotos e limites de tamanho. Validação visual e de reprodução em VM pendente.
