# Architecture

## Por que local-first

- Zero custo de cloud no desenvolvimento diário
- Mesmo modelo de serviços que em K8s/ECS
- Tags pinadas evitam surpresas do upstream arquivado
- EKS fica opcional para demos curtas (~US$ 1–2 / algumas horas)

## Fluxo de um pedido (simplificado)

```
Browser
  → edge-router (:80)
    → front-end
      → catalogue (+ catalogue-db / MySQL)     # listar produtos
      → user (+ user-db / Mongo)              # login / registro
      → carts (+ carts-db / Mongo)            # carrinho
      → orders (+ orders-db / Mongo)          # criar pedido
          → payment                           # autorizar
          → shipping → rabbitmq ← queue-master
```

## Serviços e imagens (pinadas)

| Serviço | Imagem |
|---------|--------|
| edge-router | `weaveworksdemos/edge-router:0.1.1` |
| front-end | `weaveworksdemos/front-end:0.3.12` |
| catalogue | `weaveworksdemos/catalogue:0.3.5` |
| catalogue-db | `weaveworksdemos/catalogue-db:0.3.0` |
| carts | `weaveworksdemos/carts:0.4.8` |
| carts-db | `mongo:3.4` |
| orders | `weaveworksdemos/orders:0.4.7` |
| orders-db | `mongo:3.4` |
| user | `weaveworksdemos/user:0.4.4` |
| user-db | `weaveworksdemos/user-db:0.4.0` |
| payment | `weaveworksdemos/payment:0.4.3` |
| shipping | `weaveworksdemos/shipping:0.4.8` |
| queue-master | `weaveworksdemos/queue-master:0.3.1` |
| rabbitmq | `rabbitmq:3.6.8` |

## Decisões de lab

- **Sem load-test** no Compose padrão (menos CPU/RAM)
- **queue-master** monta `docker.sock` — herança do demo legado; **não** é padrão de produção
- Java services com heap baixo (`-Xmx128m`) para caber em laptop
- Harden parcial: `cap_drop: all`, `read_only` onde o demo original permitia

## Próximo passo (Fase 2)

Os mesmos serviços em **Kustomize** + cluster local (kind/k3d), com namespace `sock-shop` e resource limits.
