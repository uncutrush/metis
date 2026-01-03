'use client'

import { ProjectsViewWithBoundary } from '../../../../src/features/projects'
import { MainLayout } from '../../../../src/components/layout/MainLayout'

export default function ProjectDetailPage() {
  // Route protection is handled by middleware.ts
  return (
    <MainLayout>
      <ProjectsViewWithBoundary />
    </MainLayout>
  )
}

