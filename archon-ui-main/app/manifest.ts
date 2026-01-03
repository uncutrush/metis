import type { MetadataRoute } from 'next'

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'Metis',
    short_name: 'Metis',
    description: 'Command center for AI coding assistants',
    start_url: '/',
    display: 'standalone',
    background_color: '#000000',
    theme_color: '#000000',
    icons: [
      { src: '/favicon.png', sizes: 'any', type: 'image/png' },
      { src: '/logo-neon.png', sizes: 'any', type: 'image/png' },
    ],
  }
}


