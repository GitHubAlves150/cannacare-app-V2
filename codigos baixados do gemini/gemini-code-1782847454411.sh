cat > src/app/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { apiFetch } from '@/services/api';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccessMessage(null);
    setLoading(true);

    try {
      // Como o nosso backend já tem a rota de criação de usuários pronta,
      // usaremos temporariamente este formulário para testar a comunicação direta.
      // Em sistemas reais, aqui bateria em um endpoint de "/auth/login".
      const response = await apiFetch<any>('/users', {
        method: 'POST',
        body: {
          association_id: "61a72d3e-d4f9-4b34-b37a-6b0c26ede728", // Sua associação padrão de teste
          name: "Usuário Conectado via Web",
          email,
          password,
          role: "admin"
        }
      });

      setSuccessMessage(`Conectado com sucesso! ID do Usuário: ${response.id}`);
    } catch (err: any) {
      setError(err.message || 'Falha ao realizar a autenticação.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-900 px-4">
      <div className="w-full max-w-md rounded-2xl bg-slate-800 p-8 shadow-xl border border-slate-700">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-emerald-400 tracking-tight">Cannacare V2</h1>
          <p className="text-slate-400 mt-2 text-sm">Controle Clínico e de Estoque Multi-Tenant</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {error && (
            <div className="rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400 text-center">
              ⚠️ {error}
            </div>
          )}

          {successMessage && (
            <div className="rounded-lg bg-emerald-500/10 border border-emerald-500/20 p-3 text-sm text-emerald-400 text-center">
              🚀 {successMessage}
            </div>
          )}

          <div>
            <label className="block text-sm font-medium text-slate-300 mb-1.5">E-mail Corporativo</label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="exemplo@email.com"
              className="w-full rounded-lg bg-slate-950 border border-slate-700 p-2.5 text-slate-100 placeholder-slate-500 outline-none focus:border-emerald-500 transition-colors"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-300 mb-1.5">Senha de Acesso</label>
            <input
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full rounded-lg bg-slate-950 border border-slate-700 p-2.5 text-slate-100 placeholder-slate-500 outline-none focus:border-emerald-500 transition-colors"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full rounded-lg bg-emerald-500 p-3 font-semibold text-slate-950 hover:bg-emerald-400 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? 'Processando Autenticação...' : 'Entrar no Sistema'}
          </button>
        </form>
      </div>
    </main>
  );
}
EOF