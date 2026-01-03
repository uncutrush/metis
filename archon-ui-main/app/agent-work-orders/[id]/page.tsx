'use client'

import { AgentWorkOrderDetailPage } from '../../../../src/pages/AgentWorkOrderDetailPage'
import { MainLayout } from '../../../../src/components/layout/MainLayout'

export default function AgentWorkOrderDetailRoute() {
  // Route protection is handled by middleware.ts
  return (
    <MainLayout>
      <AgentWorkOrderDetailPage />
    </MainLayout>
  )
}

