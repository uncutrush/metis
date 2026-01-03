'use client'

/**
 * QueryClientProvider for Next.js App Router
 * 
 * Why this pattern:
 * - Creates new QueryClient per server request (SSR-safe)
 * - Reuses single client in browser (hydration-safe)
 * - Prevents state sharing between requests
 * 
 * Reference: TanStack Query Next.js SSR guide
 */

import { ReactNode } from 'react'
import { QueryClient, QueryClientProvider, isServer } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { createRetryLogic, STALE_TIMES } from '../src/features/shared/config/queryPatterns'
import { ThemeProvider } from '../src/contexts/ThemeContext'
import { ToastProvider } from '../src/features/ui/components/ToastProvider'
import { SettingsProvider } from '../src/contexts/SettingsContext'
import { TooltipProvider } from '../src/features/ui/primitives/tooltip'

function makeQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: {
        // Default stale time - most data is considered fresh for 30 seconds
        staleTime: STALE_TIMES.normal,

        // Keep unused data in cache for 10 minutes
        gcTime: 10 * 60 * 1000,

        // Smart retry logic - don't retry on 4xx errors or aborts
        retry: createRetryLogic(2),

        // Exponential backoff for retries
        retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),

        // Disable aggressive refetching to reduce API calls
        refetchOnWindowFocus: false,
        refetchOnReconnect: false,
        refetchOnMount: true,

        // Network behavior
        networkMode: "online",

        // Enable structural sharing for efficient re-renders
        structuralSharing: true,
      },

      mutations: {
        // No retries for mutations - let user explicitly retry
        retry: false,

        // Network behavior
        networkMode: "online",
      },
    },
  })
}

let browserQueryClient: QueryClient | undefined = undefined

function getQueryClient() {
  if (isServer) {
    // Server: always make a new query client
    return makeQueryClient()
  } else {
    // Browser: make a new query client if we don't already have one
    // This is very important, so we don't re-make a new client if React
    // suspends during the initial render. This may not be needed if we
    // have a suspense boundary BELOW the creation of the query client
    if (!browserQueryClient) browserQueryClient = makeQueryClient()
    return browserQueryClient
  }
}

interface ProvidersProps {
  children: ReactNode
}

export default function Providers({ children }: ProvidersProps) {
  // NOTE: Avoid useState when initializing the query client if you don't
  //       have a suspense boundary between this and the code that may
  //       suspend because React will throw away the client on the initial
  //       render if it suspends and there is no boundary
  const queryClient = getQueryClient()

  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <ToastProvider>
          <TooltipProvider>
            <SettingsProvider>
              {children}
            </SettingsProvider>
          </TooltipProvider>
        </ToastProvider>
      </ThemeProvider>
      {process.env.NODE_ENV === 'development' && process.env.NEXT_PUBLIC_SHOW_DEVTOOLS === 'true' && (
        <ReactQueryDevtools initialIsOpen={false} />
      )}
    </QueryClientProvider>
  )
}

