import type { Metadata } from 'next'
import { ClerkProvider } from '@clerk/nextjs'
import Providers from './providers'
import './globals.css'

export const metadata: Metadata = {
  title: 'Metis - Command Center for AI Coding Assistants',
  description: 'Power up your AI coding assistants with your own custom knowledge base and task management',
  viewport: 'width=device-width, initial-scale=1, maximum-scale=1',
  themeColor: '#000000',
  manifest: '/manifest.json',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <ClerkProvider
      appearance={{
        cssLayerName: 'clerk', // Required for Tailwind CSS 4 compatibility
      }}
    >
      <html lang="en" suppressHydrationWarning>
        <body>
          <Providers>{children}</Providers>
        </body>
      </html>
    </ClerkProvider>
  )
}

