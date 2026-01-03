-- =====================================================
-- Rename all archon_* tables and functions to metis_*
-- =====================================================
-- This migration renames all database objects from archon_* to metis_*
-- to complete the rebranding from Archon to Metis.
--
-- Tables renamed:
-- - archon_sources → metis_sources
-- - archon_crawled_pages → metis_crawled_pages
-- - archon_code_examples → metis_code_examples
-- - archon_projects → metis_projects
-- - archon_tasks → metis_tasks
-- - archon_documents → metis_documents
-- - archon_document_versions → metis_document_versions
-- - archon_project_sources → metis_project_sources
-- - archon_page_metadata → metis_page_metadata
-- - archon_prompts → metis_prompts
-- - archon_migrations → metis_migrations
-- - archon_configured_repositories → metis_configured_repositories
--
-- Functions renamed:
-- - match_archon_crawled_pages → match_metis_crawled_pages
-- - match_archon_code_examples → match_metis_code_examples
-- - hybrid_search_archon_crawled_pages → hybrid_search_metis_crawled_pages
-- - hybrid_search_archon_code_examples → hybrid_search_metis_code_examples
-- - match_archon_crawled_pages_multi → match_metis_crawled_pages_multi
-- - match_archon_code_examples_multi → match_metis_code_examples_multi
-- - hybrid_search_archon_crawled_pages_multi → hybrid_search_metis_crawled_pages_multi
-- - hybrid_search_archon_code_examples_multi → hybrid_search_metis_code_examples_multi
-- =====================================================

-- Rename tables
ALTER TABLE IF EXISTS archon_sources RENAME TO metis_sources;
ALTER TABLE IF EXISTS archon_crawled_pages RENAME TO metis_crawled_pages;
ALTER TABLE IF EXISTS archon_code_examples RENAME TO metis_code_examples;
ALTER TABLE IF EXISTS archon_projects RENAME TO metis_projects;
ALTER TABLE IF EXISTS archon_tasks RENAME TO metis_tasks;
ALTER TABLE IF EXISTS archon_documents RENAME TO metis_documents;
ALTER TABLE IF EXISTS archon_document_versions RENAME TO metis_document_versions;
ALTER TABLE IF EXISTS archon_project_sources RENAME TO metis_project_sources;
ALTER TABLE IF EXISTS archon_page_metadata RENAME TO metis_page_metadata;
ALTER TABLE IF EXISTS archon_prompts RENAME TO metis_prompts;
ALTER TABLE IF EXISTS archon_migrations RENAME TO metis_migrations;
ALTER TABLE IF EXISTS archon_configured_repositories RENAME TO metis_configured_repositories;

-- Update foreign key constraints that reference old table names
-- Note: PostgreSQL automatically updates foreign key constraints when tables are renamed,
-- but we need to update constraint names and any explicit references

-- Update constraint names for metis_sources
ALTER TABLE IF EXISTS metis_crawled_pages 
    DROP CONSTRAINT IF EXISTS archon_crawled_pages_source_fk,
    ADD CONSTRAINT metis_crawled_pages_source_fk FOREIGN KEY (source_id) 
        REFERENCES metis_sources(source_id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS metis_code_examples 
    DROP CONSTRAINT IF EXISTS archon_code_examples_source_fk,
    ADD CONSTRAINT metis_code_examples_source_fk FOREIGN KEY (source_id) 
        REFERENCES metis_sources(source_id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS metis_page_metadata 
    DROP CONSTRAINT IF EXISTS archon_page_metadata_source_fk,
    ADD CONSTRAINT metis_page_metadata_source_fk FOREIGN KEY (source_id) 
        REFERENCES metis_sources(source_id) ON DELETE CASCADE;

-- Update constraint names for metis_projects
ALTER TABLE IF EXISTS metis_tasks 
    DROP CONSTRAINT IF EXISTS archon_tasks_project_fk,
    ADD CONSTRAINT metis_tasks_project_fk FOREIGN KEY (project_id) 
        REFERENCES metis_projects(id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS metis_documents 
    DROP CONSTRAINT IF EXISTS archon_documents_project_fk,
    ADD CONSTRAINT metis_documents_project_fk FOREIGN KEY (project_id) 
        REFERENCES metis_projects(id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS metis_project_sources 
    DROP CONSTRAINT IF EXISTS archon_project_sources_project_fk,
    DROP CONSTRAINT IF EXISTS archon_project_sources_source_fk,
    ADD CONSTRAINT metis_project_sources_project_fk FOREIGN KEY (project_id) 
        REFERENCES metis_projects(id) ON DELETE CASCADE,
    ADD CONSTRAINT metis_project_sources_source_fk FOREIGN KEY (source_id) 
        REFERENCES metis_sources(source_id) ON DELETE CASCADE;

-- Update constraint names for metis_documents
ALTER TABLE IF EXISTS metis_document_versions 
    DROP CONSTRAINT IF EXISTS archon_document_versions_document_fk,
    ADD CONSTRAINT metis_document_versions_document_fk FOREIGN KEY (document_id) 
        REFERENCES metis_documents(id) ON DELETE CASCADE;

-- Update constraint names for metis_page_metadata
ALTER TABLE IF EXISTS metis_crawled_pages 
    DROP CONSTRAINT IF EXISTS archon_crawled_pages_page_fk,
    ADD CONSTRAINT metis_crawled_pages_page_fk FOREIGN KEY (page_id) 
        REFERENCES metis_page_metadata(id) ON DELETE SET NULL;

-- Update unique constraint names
ALTER TABLE IF EXISTS metis_sources 
    DROP CONSTRAINT IF EXISTS archon_sources_source_id_unique,
    ADD CONSTRAINT metis_sources_source_id_unique UNIQUE(source_id);

ALTER TABLE IF EXISTS metis_page_metadata 
    DROP CONSTRAINT IF EXISTS archon_page_metadata_url_unique,
    ADD CONSTRAINT metis_page_metadata_url_unique UNIQUE(url);

-- Rename indexes
ALTER INDEX IF EXISTS idx_archon_sources_source_id RENAME TO idx_metis_sources_source_id;
ALTER INDEX IF EXISTS idx_archon_crawled_pages_source_id RENAME TO idx_metis_crawled_pages_source_id;
ALTER INDEX IF EXISTS idx_archon_crawled_pages_url RENAME TO idx_metis_crawled_pages_url;
ALTER INDEX IF EXISTS idx_archon_crawled_pages_embedding RENAME TO idx_metis_crawled_pages_embedding;
ALTER INDEX IF EXISTS idx_archon_code_examples_source_id RENAME TO idx_metis_code_examples_source_id;
ALTER INDEX IF EXISTS idx_archon_code_examples_url RENAME TO idx_metis_code_examples_url;
ALTER INDEX IF EXISTS idx_archon_code_examples_embedding RENAME TO idx_metis_code_examples_embedding;
ALTER INDEX IF EXISTS idx_archon_projects_id RENAME TO idx_metis_projects_id;
ALTER INDEX IF EXISTS idx_archon_tasks_project_id RENAME TO idx_metis_tasks_project_id;
ALTER INDEX IF EXISTS idx_archon_tasks_status RENAME TO idx_metis_tasks_status;
ALTER INDEX IF EXISTS idx_archon_documents_project_id RENAME TO idx_metis_documents_project_id;
ALTER INDEX IF EXISTS idx_archon_document_versions_document_id RENAME TO idx_metis_document_versions_document_id;
ALTER INDEX IF EXISTS idx_archon_page_metadata_source_id RENAME TO idx_metis_page_metadata_source_id;
ALTER INDEX IF EXISTS idx_archon_page_metadata_url RENAME TO idx_metis_page_metadata_url;
ALTER INDEX IF EXISTS idx_archon_page_metadata_section RENAME TO idx_metis_page_metadata_section;
ALTER INDEX IF EXISTS idx_archon_page_metadata_created_at RENAME TO idx_metis_page_metadata_created_at;
ALTER INDEX IF EXISTS idx_archon_page_metadata_metadata RENAME TO idx_metis_page_metadata_metadata;
ALTER INDEX IF EXISTS idx_archon_crawled_pages_page_id RENAME TO idx_metis_crawled_pages_page_id;

-- Rename RPC functions
-- Note: We need to drop and recreate functions with new names since PostgreSQL
-- doesn't support renaming functions directly in all cases

-- Drop old functions first (they will be recreated by subsequent migrations if needed)
DROP FUNCTION IF EXISTS match_archon_crawled_pages(vector, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS match_archon_code_examples(vector, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS match_archon_crawled_pages_multi(vector, int, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS match_archon_code_examples_multi(vector, int, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS hybrid_search_archon_crawled_pages(vector, text, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS hybrid_search_archon_code_examples(vector, text, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS hybrid_search_archon_crawled_pages_multi(vector, int, text, int, jsonb, text) CASCADE;
DROP FUNCTION IF EXISTS hybrid_search_archon_code_examples_multi(vector, int, text, int, jsonb, text) CASCADE;

-- Recreate functions with new names (these will be created by running the setup scripts again)
-- The functions reference the renamed tables, so they will automatically use the new table names

-- Update comments on tables
COMMENT ON TABLE metis_sources IS 'Stores knowledge sources (websites, documents)';
COMMENT ON TABLE metis_crawled_pages IS 'Stores crawled page content with embeddings';
COMMENT ON TABLE metis_code_examples IS 'Stores extracted code examples with embeddings';
COMMENT ON TABLE metis_projects IS 'Stores project information';
COMMENT ON TABLE metis_tasks IS 'Stores task information linked to projects';
COMMENT ON TABLE metis_documents IS 'Stores document information linked to projects';
COMMENT ON TABLE metis_document_versions IS 'Stores version history for documents';
COMMENT ON TABLE metis_project_sources IS 'Junction table linking projects to sources';
COMMENT ON TABLE metis_page_metadata IS 'Stores complete documentation pages for agent retrieval';
COMMENT ON TABLE metis_prompts IS 'Stores prompt templates';
COMMENT ON TABLE metis_migrations IS 'Tracks applied database migrations';
COMMENT ON TABLE metis_configured_repositories IS 'Stores configured repositories for agent work orders';

-- Record migration application for tracking
-- Note: This inserts into the renamed table
INSERT INTO metis_migrations (version, migration_name)
VALUES ('0.1.0', '012_rename_tables_archon_to_metis')
ON CONFLICT (version, migration_name) DO NOTHING;

-- =====================================================
-- MIGRATION COMPLETE
-- =====================================================
-- After running this migration, you must:
-- 1. Re-run the function creation scripts (005_ollama_create_functions.sql and 002_add_hybrid_search_tsvector.sql)
--    to recreate the functions with new names referencing the renamed tables
-- 2. Update all application code to use the new table and function names
-- =====================================================

