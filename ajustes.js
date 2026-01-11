#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const arquivo = process.argv[2];

if (!arquivo) {
  console.error("Uso: node ajustes.js <arquivo>");
  process.exit(1);
}

const filePath = path.resolve(arquivo);

if (!fs.existsSync(filePath)) {
  console.error("Arquivo não encontrado:", filePath);
  process.exit(1);
}

let conteudo = fs.readFileSync(filePath, "utf8");

/**
 * ===============================
 * AJUSTES POR REGEX (PIPELINE)
 * ===============================
 */

// (1) <a href="../2026  -->  <a href="../diario/2026
conteudo = conteudo.replace(
  /<a\s+href="\.\.\/2026/gi,
  '<a href="../diario/2026'
);

/**
 * ===============================
 * SALVA ARQUIVO
 * ===============================
 */
fs.writeFileSync(filePath, conteudo, "utf8");

console.log("Ajustes aplicados com sucesso em:", filePath);
