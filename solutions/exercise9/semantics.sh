#!/bin/bash
# Creates the semantic entities with their properties and links the contracts to them
# (requires the Semantics feature to be enabled).
set -e
cd "$(dirname "$0")"
if [ -f ../../.env ]; then set -a; . ../../.env; set +a; fi

printf 'name: Main\n' | entropy-data semantics namespaces put main --file -

cat <<EOF | entropy-data semantics concepts put main order --file -
name: Order
kind: entity
description: A customer order in the e-commerce platform
properties:
- id: order_id
  name: Order ID
  kind: property
  description: Unique identifier of an order (UUID)
  data_type: string
  required: true
  unique: true
- id: order_total
  name: Order Total
  kind: property
  description: Total amount of an order in cents, never negative
  data_type: integer
EOF

cat <<EOF | entropy-data semantics concepts put main article --file -
name: Article
kind: entity
description: A product that can be bought in the e-commerce platform
properties:
- id: sku
  name: SKU
  kind: property
  description: Stock keeping unit, the unique identifier of an article
  data_type: string
  required: true
  unique: true
EOF

cat <<EOF | entropy-data semantics relationships put main order-contains-article --file -
type: relatedTo
name: contains
description: An order contains one or more articles
roles:
- concept: order
- concept: article
verbalizes:
- "{Order} contains {Article}"
EOF

# link the concepts from the data contracts via authoritativeDefinitions (type: semantics)
# and re-publish them; duplicated text descriptions are removed - the definition lives in the concept
datacontract lint orders_v1.with-semantics.odcs.yaml
datacontract lint orders_v2.with-semantics.odcs.yaml
datacontract lint sku_sales_per_year.with-semantics.odcs.yaml
entropy-data datacontracts put orders_v1 --file orders_v1.with-semantics.odcs.yaml
entropy-data datacontracts put orders_v2 --file orders_v2.with-semantics.odcs.yaml
entropy-data datacontracts put sku_sales_per_year --file sku_sales_per_year.with-semantics.odcs.yaml
