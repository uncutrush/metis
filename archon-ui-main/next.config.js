/**
 * Next.js Configuration
 * 
 * API Proxy Strategy: Rewrites vs Route Handlers
 * 
 * Using rewrites because:
 * - Simpler, fewer edge cases
 * - Better performance (no Node.js overhead)
 * - SSE/EventSource works automatically
 * 
 * Use route handlers only if you need:
 * - Header manipulation
 * - Auth injection
 * - Custom request transformation
 */

const withPWA = require('@ducanh2912/next-pwa').default({
  dest: 'public',
  cacheOnFrontEndNav: true,
  aggressiveFrontEndNavCaching: true,
  reloadOnOnline: true,
  swcMinify: true,
  workboxOptions: {
    disableDevLogs: true,
  },
  // Cache only static assets, NOT API responses
  // TanStack Query handles API caching
  runtimeCaching: [
    {
      urlPattern: /^https?.*\.(?:png|jpg|jpeg|svg|gif|webp|ico)/,
      handler: 'CacheFirst',
    },
    {
      urlPattern: /^https?.*\.(?:woff|woff2|ttf|otf)/,
      handler: 'CacheFirst',
    },
  ],
})

/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable standalone output for Docker only (not needed for Vercel)
  // Vercel automatically sets VERCEL=1, so we only use standalone for Docker builds
  ...(process.env.VERCEL ? {} : { output: 'standalone' }),

  // Transpile packages if needed
  transpilePackages: [],

  // Environment variables
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || '',
  },

  // API rewrites for proxying to FastAPI backend
  // Works for both Docker (internal URLs) and Vercel (external URLs)
  async rewrites() {
    // Vercel: Use environment variables set in Vercel dashboard
    // Docker: Use internal service names or localhost defaults
    const backendUrl = process.env.BACKEND_URL || 'http://localhost:8181'
    const mcpUrl = process.env.MCP_URL || 'http://localhost:8051'
    const agentWorkOrdersUrl = process.env.AGENT_WORK_ORDERS_URL || 'http://localhost:8053'

    return [
      // Agent Work Orders API (must come before general /api)
      {
        source: '/api/agent-work-orders/:path*',
        destination: `${agentWorkOrdersUrl}/api/agent-work-orders/:path*`,
      },
      // General API proxy
      {
        source: '/api/:path*',
        destination: `${backendUrl}/api/:path*`,
      },
    ]
  },

  // Webpack configuration (if needed for PWA)
  webpack: (config, { isServer }) => {
    // Add any custom webpack config here
    return config
  },
}

// Apply PWA plugin only in production
module.exports = process.env.NODE_ENV === 'production' ? withPWA(nextConfig) : nextConfig

