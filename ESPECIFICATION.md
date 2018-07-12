PNET Especificação de Linguagem
===============================

## Abstract

A Petri Net Transpile (PNET) tem a premissa de facilitar a modelagem de Redes de Petri como uma linguagem declarativa de rápida assimilação dos comandos.

Aqui está um ambiente de execução da PNET no [repl.it](https://repl.it/@eunaka/PNet)


## Construção

A PNET foi desenvolvida para construir código reconhecido pelo sistema [PetriNet Playground](https://petri-net-web.herokuapp.com/). O resultado da compilação é um arquivo JSON com as configurações necessárias para o sistema montar a Rede de Petri graficamente e gerenciar todos os seus estados.


##  Scopes

Todo código fonte em PNET deve estar entre '{' e '}', como a seguir:

```
{
  place1 := Place(3:start)
  place2 := Place(3:end)
  transition := Transition(timer)
  Arc(place1:transiton:1)
  Arc(transition1:place2:2)
}
```
* ```Scopes``` são sequências de ```commands```, que são separados por espaços ou quebras de linha 
* Só deve existir apenas um ```scope```

## Declarations

Declarations em PNET são compostas de um ID, ':=' e uma Function

```
ID := Function([param[: param[: ... param]]])

place1 := Place(2:write)
```

Declarations instanciam Functions e adicionam ao contexto global

## Functions

Functions em PNET são instanciadores de elementos de Redes de Petri

As Functions da PNET são:

### Place
```
place := Place([tokens [: label]])
```

- tokens é a quantidade de tokens que o place terá no estado inicial
- label é o nome do place para facilitar a identificação do elemento graficamente

### Transition
```
transition := Transition([label])
```

- label é o nome da Transition para facilitar a identificação do elemento graficamente

## Arc

Arcs é uma Function anônima que não instancia nenhum elemento, as define uma relação entre places e transitions

```
Arc([sourceId [: targetId [: weight]]])

place1 := Place(3:start)
transition := Transition(timer)
Arc(place1:transiton:1)
```

- sourceId é o ID de uma Declaration
- targetId é o ID de uma Declaration
- weight é o peso do Arc

Restrições:
1. Um Arc não pode relacionar dois Places ou dois Transitions
2. Um Arc não pode relacionar um elemento com ele mesmo

## Métodos

> Scope :: check()

Imprime o estado de contexto da PNET

> Scope :: compile()

Calcula todo o grafo Petri Net

> Scope :: exe()

Retorna o grafo Petri Net