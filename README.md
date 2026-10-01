# sock-shop-ops

Portfólio DevOps **local-first** em cima do [Sock Shop](https://github.com/microservices-demo/microservices-demo) (Weaveworks).

> Upstream arquivado desde 2023. Usamos **imagens com tag fixa** e focamos em Compose, Kubernetes local e operação — sem custo de cloud no dia a dia.

**Stack:** Docker Compose · Kubernetes (kind/k3d) · Kustomize · GitHub Actions · Runbook

Relacionado: [uptime-ops](https://github.com/LionSilver/uptime-ops) (ECS + Terraform na AWS).

---

## Objetivo

Demonstrar práticas DevOps em um app de **~14 microserviços** sem depender de AWS para desenvolver:

| Prática | Como aparece aqui |
|---------|-------------------|
| Multi-serviço | front-end, catalogue, carts, orders, user, payment, shipping, filas… |
| Imagens imutáveis | Tags pinadas (nunca `:latest`) |
| Local = próximo de prod | Compose + depois kind/k3d |
| CI | Validação de manifests |
| Operação | RUNBOOK com incidentes típicos |

---

## Pré-requisitos

- Docker Desktop (ou Docker Engine + Compose v2)
- ~4 GB RAM livres para o stack completo
- (Fase K8s) [kind](https://kind.sigs.k8s.io/) ou [k3d](https://k3d.io/) + `kubectl`

---

## Subir local (Compose)

```bash
make up          # sobe o Sock Shop
make ps          # status
make logs        # logs (Ctrl+C para sair)

# Abrir no browser
open http://localhost:80
# ou: http://localhost:8080
```

Login de teste (quando o front estiver pronto):

- Usuário: registre um novo, ou use fluxos do front-end

Parar e limpar:

```bash
make down
```

Primeira subida pode demorar (várias imagens antigas do Docker Hub).

---

## Arquitetura (resumo)

```
Browser
   │
   ▼
edge-router :80
   │
   ▼
front-end
   ├── catalogue ── catalogue-db (MySQL)
   ├── carts ────── carts-db (Mongo)
   ├── orders ───── orders-db (Mongo)
   ├── user ─────── user-db (Mongo)
   ├── payment
   └── shipping ─── queue-master ── rabbitmq
```

Detalhes: [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## Roadmap do repo

- [x] Fase 0 — Repo + estrutura
- [x] Fase 1 — Compose com tags pinadas
- [ ] Fase 2 — Manifests Kustomize + kind/k3d
- [ ] Fase 4 — CI (kubeconform / kustomize build)
- [ ] Fase 5 — Runbook + observabilidade leve
- [ ] Fase 6 — Polimento do README

**AWS / EKS:** opcional e só para demo pontual (~US$ 1–2 por algumas horas). O padrão deste projeto é **local**.

---

## Estrutura

```
.
├── deploy/
│   ├── compose/           # Docker Compose (lab local)
│   └── kubernetes/             # Kustomize (em breve)
├── .github/workflows/     # CI (em breve)
├── ARCHITECTURE.md
├── RUNBOOK.md
├── Makefile
└── README.md
```

---

## Aviso sobre o upstream

O repositório oficial `microservices-demo/microservices-demo` está **archived**. Imagens `weaveworksdemos/*` ainda existem no Docker Hub, mas podem sumir no futuro. Por isso:

1. Tags estão **fixadas** no Compose
2. O valor do portfólio está no **deploy, CI e operação**, não no código Java/Go/Node legado

---

## Licença

Código de deploy deste repo: MIT (ou conforme LICENSE).
Sock Shop original: Apache-2.0 (Weaveworks / microservices-demo).
