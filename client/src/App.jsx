import { useEffect, useState } from 'react'

export default function App() {
  const [status, setStatus] = useState('FastAPIに接続中...')

  useEffect(() => {
    fetch('/api/health')
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.json()
      })
      .then((data) => setStatus(data.message))
      .catch((error) => setStatus(`API connection failed: ${error.message}`))
  }, [])

  return (
    <main className="container">
      <p className="eyebrow">GitHub Codespaces</p>
      <h1>React + FastAPI</h1>
      <p>クライアントはVite/React、サーバーはPython/FastAPIです。</p>
      <div className="status">
        <strong>API:</strong> {status}
      </div>
    </main>
  )
}
