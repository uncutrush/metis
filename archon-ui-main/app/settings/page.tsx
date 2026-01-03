'use client'

import { SettingsPage } from '../../src/pages/SettingsPage'
import { MainLayout } from '../../src/components/layout/MainLayout'

export default function SettingsRoute() {
  // Route protection is handled by middleware.ts
  return (
    <MainLayout>
      <SettingsPage />
    </MainLayout>
  )
}

