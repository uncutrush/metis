'use client'

import { MCPPage } from '../../src/pages/MCPPage'
import { MainLayout } from '../../src/components/layout/MainLayout'

export default function MCPRoute() {
  // Route protection is handled by middleware.ts
  return (
    <MainLayout>
      <MCPPage />
    </MainLayout>
  )
}

