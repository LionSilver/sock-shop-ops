# Runbook (lab local)

Incidentes que este lab deve sobreviver. Ampliar na Fase 5.

## 1. Front não abre em http://localhost:80

**Sintomas:** browser não carrega; `curl` falha.

**Hipóteses:**
1. Stack ainda subindo (imagens grandes na 1ª vez).
2. Porta 80 ocupada no host.
3. `edge-router` ou `front-end` em restart loop.

**Comandos:**
```bash
make ps
make logs
docker compose -f deploy/compose/docker-compose.yml logs edge-router front-end --tail=50
```

**Mitigação:** `make down && make up`; se porta 80 ocupada, altere o mapeamento no Compose temporariamente.

## 2. Catálogo vazio / erro ao listar produtos

**Hipóteses:** `catalogue-db` não pronto; `catalogue` crashou.

```bash
docker compose -f deploy/compose/docker-compose.yml logs catalogue catalogue-db --tail=80
```

## 3. Checkout falha (orders / payment / shipping)

**Hipóteses:** Mongo de orders fora; RabbitMQ down; Java OOM.

```bash
docker compose -f deploy/compose/docker-compose.yml ps
docker compose -f deploy/compose/docker-compose.yml logs orders payment shipping rabbitmq --tail=80
```

## 4. Máquina sem memória

**Sintomas:** containers Killed; Docker lento.

**Mitigação:** feche outros apps; `make down`; suba só o essencial depois (editar Compose). Sock Shop completo pede ~3–4 GB RAM.
