# 1. Cria a pasta da rota do dashboard
mkdir -p src/app/dashboard

# 2. Cria a página do painel principal
cat > src/app/dashboard/page.tsx << 'EOF'
'use client';

import { useState } from 'react';

export default function DashboardPage() {
  // Estados para simular alguns números gerais do sistema
  const [stats] = useState([
    { name: 'Pacientes Ativos', value: '24', color: 'border-blue-500 text-blue-400' },
    { name: 'Prescrições Válidas', value: '18', color: 'border-purple-500 text-purple-400' },
    { name: 'Itens em Estoque', value: '8', color: 'border-emerald-500 text-emerald-400' },
  ]);

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 flex">
      {/* Sidebar - Menu Lateral */}
      <aside className="w-64 bg-slate-800 border-r border-slate-700 p-6 flex flex-col justify-between">
        <div>
          <div className="mb-8">
            <h2 className="text-xl font-bold text-emerald-400 tracking-tight">Cannacare V2</h2>
            <p className="text-xs text-slate-500">Painel de Controle</p>
          </div>
          
          <nav className="space-y-2">
            <a href="/dashboard" className="block px-4 py-2.5 rounded-lg bg-slate-700 text-emerald-400 font-medium transition-colors">
              📊 Visão Geral
            </a>
            <a href="/dashboard/patients" className="block px-4 py-2.5 rounded-lg text-slate-400 hover:bg-slate-700/50 hover:text-slate-200 transition-colors">
              👥 Pacientes
            </a>
            <a href="/dashboard/prescriptions" className="block px-4 py-2.5 rounded-lg text-slate-400 hover:bg-slate-700/50 hover:text-slate-200 transition-colors">
              📄 Prescrições
            </a>
            <a href="/dashboard/stock" className="block px-4 py-2.5 rounded-lg text-slate-400 hover:bg-slate-700/50 hover:text-slate-200 transition-colors">
              📦 Estoque & Vendas
            </a>
          </nav>
        </div>

        <div className="border-t border-slate-700 pt-4">
          <p className="text-xs text-slate-500">Associação Parceira</p>
          <p className="text-sm font-medium text-slate-300 truncate">61a72d3e-d4f9-b37a...</p>
          <a href="/" className="block mt-4 text-xs text-red-400 hover:underline">Sair do sistema</a>
        </div>
      </aside>

      {/* Main Content - Área Central */}
      <main className="flex-1 p-8">
        <header className="mb-8 flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold tracking-tight">Visão Geral</h1>
            <p className="text-slate-400 text-sm mt-1">Bem-vindo ao centro de gerenciamento da sua associação.</p>
          </div>
          <div className="bg-slate-800 border border-slate-700 px-4 py-2 rounded-lg text-sm text-slate-300">
            📅 Junho, 2026
          </div>
        </header>

        {/* Grid de Cards de Estatísticas */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {stats.map((stat, index) => (
            <div key={index} className={`bg-slate-800 p-6 rounded-xl border-l-4 ${stat.color} shadow-lg`}>
              <p className="text-sm font-medium text-slate-400 dynamic-text">{stat.name}</p>
              <p className="text-3xl font-bold mt-2 tracking-tight">{stat.value}</p>
            </div>
          ))}
        </div>

        {/* Seção Informativa de Atalhos Rápidos */}
        <div className="bg-slate-800 rounded-xl p-6 border border-slate-700">
          <h3 className="text-lg font-semibold mb-3">Ações Rápidas do Sistema</h3>
          <p className="text-slate-400 text-sm mb-4">Utilize o menu lateral para gerenciar os módulos operacionais. Toda ação realizada aqui respeita as travas de segurança e isolamento do banco de dados.</p>
          <div className="flex gap-4">
            <button className="px-4 py-2 rounded-lg bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-medium text-sm transition-colors">
              + Cadastrar Novo Paciente
            </button>
            <button className="px-4 py-2 rounded-lg bg-slate-700 hover:bg-slate-600 text-slate-200 font-medium text-sm transition-colors">
              Nova Dispensação de Óleo
            </button>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF