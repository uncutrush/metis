/**
 * Hook to get authenticated API client function
 * Automatically includes Clerk auth token in requests
 */

import { useAuth } from "@clerk/nextjs";
import { callAPIWithETag } from "../api/apiClient";
import type { RequestInit } from "react";

/**
 * Hook that provides an authenticated version of callAPIWithETag
 * Automatically includes Clerk JWT token in Authorization header
 * 
 * @example
 * ```tsx
 * const { callAPI } = useAuthenticatedAPI();
 * const data = await callAPI('/api/projects');
 * ```
 */
export function useAuthenticatedAPI() {
  const { getToken } = useAuth();

  const callAPI = async <T = unknown>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> => {
    // Get Clerk token
    const token = await getToken();

    // Add token to headers if available
    const headers: Record<string, string> = {
      ...((options.headers as Record<string, string>) || {}),
    };

    if (token) {
      headers["Authorization"] = `Bearer ${token}`;
    }

    // Call API with updated headers
    return callAPIWithETag<T>(endpoint, {
      ...options,
      headers,
    });
  };

  return { callAPI };
}


