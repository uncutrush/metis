'use client'

import { AgentWorkOrdersPage } from '../../src/pages/AgentWorkOrdersPage'
import { MainLayout } from '../../src/components/layout/MainLayout'

export default function AgentWorkOrdersRoute() {
  // Route protection is handled by middleware.ts
  return (
    <MainLayout>
      <AgentWorkOrdersPage />
    </MainLayout>
  )
}

