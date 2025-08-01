# -*- coding: utf-8 -*-
"""VamosJogarBancoNeo4J.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1H9Ei8olIzrgLb3KnjnCPzweNO2I7l5vC
"""

pip install neo4j

from neo4j import GraphDatabase


# Configurações de conexão
URI = "neo4j+s://2242696c.databases.neo4j.io"
AUTH = ("neo4j", "kRYNqJibxt1fM4-xlJZThK2CXEswo_VKNtU9Q-33oe8")

class VamosJogarDB:
    def __init__(self, driver):
        self.driver = driver

    # ---------- CRIAÇÃO DE NÓS ----------
    def criar_usuario(self, id, nome, email, idade, cidade, bairro, cep, nivel_experiencia, disponibilidade):
        query = """
        MERGE (u:Usuário {id: $id})
        SET u.nome = $nome,
            u.email = $email,
            u.idade = $idade,
            u.cidade = $cidade,
            u.bairro = $bairro,
            u.cep = $cep,
            u.nivel_experiencia = $nivel_experiencia,
            u.disponibilidade = $disponibilidade
        """
        with self.driver.session() as session:
            session.run(query, id=id, nome=nome, email=email, idade=idade,
                        cidade=cidade, bairro=bairro, cep=cep,
                        nivel_experiencia=nivel_experiencia,
                        disponibilidade=disponibilidade)

    def criar_esporte(self, id, nome, categoria):
        query = """
        MERGE (e:Esporte {id:$id})
        SET e.nome = $nome, e.categoria = $categoria
        """
        with self.driver.session() as session:
            session.run(query, id=id, nome=nome, categoria=categoria)

    def criar_evento(self, id, nome, data, cidade, bairro, cep, tipo):
        query = """
        MERGE (ev:Evento {id:$id})
        SET ev.nome = $nome,
            ev.data = $data,
            ev.cidade = $cidade,
            ev.bairro = $bairro,
            ev.cep = $cep,
            ev.tipo = $tipo
        """
        with self.driver.session() as session:
            session.run(query, id=id, nome=nome, data=data, cidade=cidade,
                        bairro=bairro, cep=cep, tipo=tipo)
    def limpar_banco(self):
      query = "MATCH (n) DETACH DELETE n"
      with self.driver.session() as session:
          session.run(query)
      print("Banco de dados limpo com sucesso!")


    # ---------- RELACIONAMENTOS ----------
    def relacionar_usuario_esporte(self, user_id, sport_id):
        query = """
        MATCH (u:Usuário {id:$user_id}), (e:Esporte {id:$sport_id})
        MERGE (u)-[:GOSTA_DE]->(e)
        """
        with self.driver.session() as session:
            session.run(query, user_id=user_id, sport_id=sport_id)

    def relacionar_evento_esporte(self, event_id, sport_id):
        query = """
        MATCH (ev:Evento {id:$event_id}), (e:Esporte {id:$sport_id})
        MERGE (ev)-[:RELACIONADO_A]->(e)
        """
        with self.driver.session() as session:
            session.run(query, event_id=event_id, sport_id=sport_id)

    def relacionar_usuario_evento(self, user_id, event_id):
        query = """
        MATCH (u:Usuário {id:$user_id}), (ev:Evento {id:$event_id})
        MERGE (u)-[:PARTICIPA_DE]->(ev)
        """
        with self.driver.session() as session:
            session.run(query, user_id=user_id, event_id=event_id)

    # ---------- CONSULTAS OTIMIZADAS ----------
    def listar_usuarios(self):
      query = "MATCH (u:Usuário) RETURN DISTINCT u"
      with self.driver.session() as session:
          result = session.run(query)
          seen_ids = set()
          usuarios = []
          for record in result:
              u = dict(record["u"])
              if u["id"] not in seen_ids:
                  usuarios.append(u)
                  seen_ids.add(u["id"])
          return usuarios

    def listar_eventos(self):
      query = "MATCH (ev:Evento) RETURN DISTINCT ev"
      with self.driver.session() as session:
          result = session.run(query)
          seen_ids = set()
          eventos = []
          for record in result:
              ev = dict(record["ev"])
              if ev["id"] not in seen_ids:
                  eventos.append(ev)
                  seen_ids.add(ev["id"])
          return eventos

    def listar_esportes(self):
        query = "MATCH (e:Esporte) RETURN DISTINCT e"
        with self.driver.session() as session:
            result = session.run(query)
            seen_ids = set()
            esportes = []
            for record in result:
                e = dict(record["e"])
                if e["id"] not in seen_ids:
                    esportes.append(e)
                    seen_ids.add(e["id"])
            return esportes


    def buscar_usuarios_por_esporte(self, esporte_nome):
      query = """
      MATCH (u:Usuário)-[:GOSTA_DE]->(e:Esporte {nome:$esporte_nome})
      RETURN DISTINCT u.nome AS nome, u.cidade AS cidade, u.bairro AS bairro
      """
      with self.driver.session() as session:
          result = session.run(query, esporte_nome=esporte_nome)
          nomes_vistos = set()
          usuarios_unicos = []
          for record in result:
              nome = record["nome"]
              if nome not in nomes_vistos:
                  usuarios_unicos.append(record.data())
                  nomes_vistos.add(nome)
          return usuarios_unicos

    def buscar_eventos_por_esporte(self, esporte_nome):
      query = """
      MATCH (ev:Evento)-[:RELACIONADO_A]->(e:Esporte {nome:$esporte_nome})
      RETURN DISTINCT ev.nome AS nome, ev.data AS data, ev.cidade AS cidade, ev.bairro AS bairro
      """
      with self.driver.session() as session:
          result = session.run(query, esporte_nome=esporte_nome)
          eventos_vistos = set()
          eventos_unicos = []
          for record in result:
              chave = (record["nome"], record["data"], record["cidade"], record["bairro"])
              if chave not in eventos_vistos:
                  eventos_unicos.append(record.data())
                  eventos_vistos.add(chave)
          return eventos_unicos



# ---------- SCRIPT PRINCIPAL ----------
if __name__ == "__main__":
    with GraphDatabase.driver(URI, auth=AUTH) as driver:
        driver.verify_connectivity()
        db = VamosJogarDB(driver)

        db.limpar_banco()


        # Exemplo de inserção de dados
        db.criar_usuario(
            "u1", "Aldenir", "aldenir@email.com", 24,
            "Recife", "Arruda", "04002-000",
            "intermediário", ["domingo tarde", "domingo manhã"]
        )

        db.criar_usuario(
            "u2", "Thamyres", "thamyres@email.com", 28,
            "Recife", "Peixinhos", "11111-000",
            "intermediário", ["segunda noite", "quarta noite"]
        )
        db.criar_usuario(
            "u3", "Ben", "ben@email.com", 35,
            "Recife", "Espinheiro", "58415-000",
            "intermediário", ["terca noite", "quinta noite"]
        )
        db.criar_usuario(
            "u4", "Vinicius", "vinicius@email.com", 24,
            "Recife", "Arruda", "58415-000",
            "intermediário", ["domingo tarde", "domingo manhã"]
        )

        db.criar_esporte("e1", "Futebol", "coletivo")
        db.criar_esporte("e2", "Vôlei", "coletivo")
        db.criar_esporte("e3", "Tênis", "coletivo")

        db.criar_evento(
            "v1", "Jogo no Parque", "2025-08-01",
            "Recife", "Espinheiro", "04001-000",
            "informal"
        )
        db.criar_evento(
            "v2", "Jogo no Prainha ZN", "2025-08-01",
            "Recife", "Arruda", "87456-000",
            "informal"
        )
        db.criar_evento(
            "v3", "Jogo Parque Jaqueira", "2025-08-01",
            "Recife", "Peixinhos", "24587-000",
            "informal"
        )

        db.relacionar_usuario_esporte("u1", "e2") #aldenir e vôlei
        db.relacionar_usuario_esporte("u4", "e2") #vinicius e vôlei
        db.relacionar_usuario_esporte("u3", "e1") #ben e futebol
        db.relacionar_usuario_esporte("u2", "e3") #thamyres e tênis
        db.relacionar_usuario_esporte("u2", "e2") #thamyres e vôlei
        db.relacionar_usuario_esporte("u3", "e3") #ben e tênis

        db.relacionar_evento_esporte("v1", "e1") #evento de futebol
        db.relacionar_evento_esporte("v2", "e2") #evento de vôlei
        db.relacionar_evento_esporte("v3", "e3") #evento de tênis

        db.relacionar_usuario_evento("u1", "v2") #aldenir a evento de vôlei
        db.relacionar_usuario_evento("u4", "v2") #vinicius a evento de vôlei
        db.relacionar_usuario_evento("u3", "v1") #ben a evento de vôlei
        db.relacionar_usuario_evento("u2", "v3") #aldenir a evento de vôlei


        # Visualizando dados
        print("\n--- Usuários ---")
        for u in db.listar_usuarios():
            print(u)

        print("\n--- Esportes ---")
        for e in db.listar_esportes():
            print(e)

        print("\n--- Eventos ---")
        for ev in db.listar_eventos():
            print(ev)

        print("\n--- Usuários que gostam de Futebol ---")
        for user in db.buscar_usuarios_por_esporte("Vôlei"):
            print(user)

        print("\n--- Eventos de Vôlei ---")
        for user in db.buscar_eventos_por_esporte("Tênis"):
            print(user)

import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

def visualizar_relacionamentos_agrupados(db):
    query = """
    MATCH (u:Usuário)-[:GOSTA_DE]->(e:Esporte)
    OPTIONAL MATCH (ev:Evento)-[:RELACIONADO_A]->(e)
    OPTIONAL MATCH (u)-[:PARTICIPA_DE]->(ev)
    RETURN u.nome AS usuario, e.nome AS esporte, ev.nome AS evento
    """
    with db.driver.session() as session:
        result = session.run(query)

        G = nx.Graph()

        esporte_nos = set()
        usuario_nos = []
        evento_nos = []

        for record in result:
            usuario = record["usuario"]
            esporte = record["esporte"]
            evento = record["evento"]

            # Adiciona nós
            G.add_node(f"Usuário: {usuario}", type='usuario')
            G.add_node(f"Esporte: {esporte}", type='esporte')

            G.add_edge(f"Usuário: {usuario}", f"Esporte: {esporte}", relation="GOSTA_DE")

            esporte_nos.add(esporte)
            usuario_nos.append((usuario, esporte))

            if evento:
                G.add_node(f"Evento: {evento}", type='evento')
                G.add_edge(f"Evento: {evento}", f"Esporte: {esporte}", relation="RELACIONADO_A")
                G.add_edge(f"Usuário: {usuario}", f"Evento: {evento}", relation="PARTICIPA_DE")
                evento_nos.append((evento, esporte))

        esporte_nos = list(esporte_nos)

        # Posicionar esportes fixos em círculo (aumentando distância entre eles)
        angle_step = 2 * np.pi / len(esporte_nos)
        esporte_pos = {}
        radius = 16  # Aumentado para separar os esportes
        for i, esporte in enumerate(esporte_nos):
            x = radius * np.cos(i * angle_step)
            y = radius * np.sin(i * angle_step)
            esporte_pos[f"Esporte: {esporte}"] = np.array([x, y])

        pos = {}

        # Posicionar esportes
        for esporte_node, coord in esporte_pos.items():
            pos[esporte_node] = coord

        # Posicionar usuários próximos do esporte (com mais distância)
        for usuario, esporte in usuario_nos:
            esporte_coord = esporte_pos[f"Esporte: {esporte}"]
            delta = np.random.randn(2) * 6.0  # Aumentado para espalhar mais
            pos[f"Usuário: {usuario}"] = esporte_coord + delta

        # Posicionar eventos próximos do esporte (com mais distância)
        for evento, esporte in evento_nos:
            esporte_coord = esporte_pos[f"Esporte: {esporte}"]
            delta = np.random.randn(2) * 6.0  # Aumentado para espalhar mais
            pos[f"Evento: {evento}"] = esporte_coord + delta

        # Color map
        color_map = []
        for node in G:
            if node.startswith("Usuário:"):
                color_map.append("green")
            elif node.startswith("Esporte:"):
                color_map.append("blue")
            else:
                color_map.append("orange")

        plt.figure(figsize=(15, 11))
        nx.draw(G, pos, with_labels=True, node_color=color_map,
                node_size=2600, font_size=10, font_weight="bold")

        edge_labels = nx.get_edge_attributes(G, 'relation')
        nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_color='gray')

        plt.title("Visualização agrupada por esporte (Com Espaçamento Maior)")
        plt.axis('off')
        plt.show()

visualizar_relacionamentos_agrupados(db)