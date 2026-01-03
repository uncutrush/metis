'use client'

import { KnowledgeViewWithBoundary } from '../src/features/knowledge'
import { MainLayout } from '../src/components/layout/MainLayout'

export default function HomePage() {
  return (
    <MainLayout>
      <KnowledgeViewWithBoundary />
    </MainLayout>
  )
}


