# Vercel Deployment Guide

This guide walks you through deploying the Metis frontend to Vercel with a backend hosted on a separate cloud service (Railway, Render, etc.).

## Prerequisites

- Vercel account (free tier works)
- Backend deployed and accessible via HTTPS
- Backend URLs for all services:
  - Main API Server (FastAPI)
  - MCP Server
  - Agent Work Orders Service (if enabled)

## Step 1: Framework Selection in Vercel

When importing your project to Vercel:

1. **Framework Preset**: Select **"Next.js"** (Vercel will auto-detect this)
2. **Root Directory**: Set to `archon-ui-main` (or the directory containing your Next.js app)
3. **Build Command**: `npm run build` (or `next build`)
4. **Output Directory**: Leave empty (Next.js handles this automatically)
5. **Install Command**: `npm ci` (or `npm install`)

Vercel should auto-detect Next.js from your `package.json`, but if it doesn't:
- Ensure `next` is in your `dependencies` (not `devDependencies`)
- Ensure `package.json` has a `build` script that runs `next build`

## Step 2: Environment Variables

Configure these environment variables in the Vercel dashboard:

### Required Variables

Go to **Project Settings → Environment Variables** and add:

#### Backend Service URLs

```
BACKEND_URL=https://your-backend-api.example.com
```

**Example values:**
- Railway: `https://your-app-name.railway.app`
- Render: `https://your-app-name.onrender.com`
- Custom domain: `https://api.yourdomain.com`

```
MCP_URL=https://your-mcp-server.example.com
```

**Note**: If MCP is on the same server as the main API, use the same URL.

```
AGENT_WORK_ORDERS_URL=https://your-agent-work-orders.example.com
```

**Note**: Only required if Agent Work Orders feature is enabled.

#### Client-Side Variables (Optional)

```
NEXT_PUBLIC_API_URL=
```

**Important**: Leave this **empty** to use relative URLs (`/api/*`). The Next.js rewrites will handle proxying to your backend.

```
NEXT_PUBLIC_SHOW_DEVTOOLS=false
```

Set to `true` only for development/staging environments.

#### Clerk Authentication (Required)

```
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
```

Get this from [Clerk Dashboard](https://dashboard.clerk.com/last-active?path=api-keys). This is safe to expose in client-side code.

```
CLERK_SECRET_KEY=sk_test_...
```

Get this from [Clerk Dashboard](https://dashboard.clerk.com/last-active?path=api-keys). **Never expose this in client-side code** - it's server-side only.

**Optional Clerk URLs** (customize if needed):

```
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding
```

### Environment-Specific Variables

You can set different values for:
- **Production**: Production deployments
- **Preview**: Pull request previews
- **Development**: Local development (via Vercel CLI)

**Recommendation**: Use different backend URLs for preview environments if you have staging backends.

## Step 3: Build Configuration

### Automatic Detection

Vercel will automatically:
- Detect Next.js framework
- Use `npm run build` as the build command
- Configure output directory correctly
- Handle Next.js optimizations

### Manual Override (if needed)

If auto-detection fails, in **Project Settings → General → Build & Development Settings**:

- **Framework Preset**: Next.js
- **Build Command**: `npm run build`
- **Output Directory**: (leave empty)
- **Install Command**: `npm ci`
- **Node.js Version**: 18.x or 20.x (recommended)

## Step 4: Deploy

1. **Connect Repository**: Link your GitHub/GitLab/Bitbucket repository
2. **Import Project**: Vercel will detect Next.js automatically
3. **Configure Environment Variables**: Add the variables from Step 2
4. **Deploy**: Click "Deploy"

## Step 5: Verify Deployment

After deployment, verify:

1. **Homepage loads**: Visit your Vercel URL (e.g., `https://your-app.vercel.app`)
2. **API calls work**: Check browser DevTools Network tab for `/api/*` requests
3. **SSE works**: If using Agent Work Orders, verify real-time updates work
4. **PWA installs**: Check if the app can be installed as a PWA

### Troubleshooting

#### API Calls Fail (404 or CORS errors)

**Problem**: Backend URLs not configured correctly.

**Solution**:
1. Verify `BACKEND_URL`, `MCP_URL`, and `AGENT_WORK_ORDERS_URL` are set in Vercel
2. Ensure URLs use `https://` (not `http://`)
3. Check backend CORS settings allow your Vercel domain

#### Build Fails

**Problem**: Missing dependencies or build errors.

**Solution**:
1. Check build logs in Vercel dashboard
2. Ensure `package.json` has all required dependencies
3. Verify Node.js version (18.x or 20.x recommended)
4. Check for TypeScript errors: `npm run build` locally first

#### Framework Not Detected

**Problem**: Vercel shows "Other" instead of "Next.js".

**Solution**:
1. Ensure `next` is in `dependencies` (not `devDependencies`)
2. Verify `package.json` has `"build": "next build"` script
3. Manually set Framework Preset to "Next.js" in project settings

#### PWA Not Working

**Problem**: Service worker not registering or PWA not installable.

**Solution**:
1. PWA plugin only works in production builds
2. Ensure `NODE_ENV=production` (Vercel sets this automatically)
3. Check browser console for service worker errors
4. Verify `app/manifest.ts` exists and is correct

## Architecture Overview

```
┌─────────────────┐         ┌──────────────────┐
│   Vercel        │         │  Cloud Backend    │
│   (Frontend)    │────────▶│  (FastAPI)        │
│                 │ HTTPS   │                   │
│  Next.js App    │         │  - Main API       │
│  - App Router   │         │  - MCP Server     │
│  - Rewrites     │         │  - Agent Work     │
│  - PWA          │         │    Orders         │
└─────────────────┘         └──────────────────┘
```

### How Rewrites Work

1. Browser requests: `https://your-app.vercel.app/api/projects`
2. Next.js rewrites to: `https://your-backend.example.com/api/projects`
3. Backend responds
4. Next.js proxies response back to browser

**Benefits**:
- No CORS issues (same-origin from browser's perspective)
- Works with SSE/EventSource
- Automatic HTTPS
- No backend changes needed

## Environment Variables Reference

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `BACKEND_URL` | ✅ Yes | Main FastAPI server URL | `https://api.example.com` |
| `MCP_URL` | ✅ Yes | MCP server URL | `https://mcp.example.com` |
| `AGENT_WORK_ORDERS_URL` | ⚠️ Conditional | Agent Work Orders service URL | `https://awo.example.com` |
| `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` | ✅ Yes | Clerk publishable key | `pk_test_...` |
| `CLERK_SECRET_KEY` | ✅ Yes | Clerk secret key | `sk_test_...` |
| `NEXT_PUBLIC_API_URL` | ❌ No | Leave empty for relative URLs | (empty) |
| `NEXT_PUBLIC_SHOW_DEVTOOLS` | ❌ No | Show React Query DevTools | `false` |

## Next Steps

After successful deployment:

1. **Custom Domain**: Configure a custom domain in Vercel
2. **Analytics**: Enable Vercel Analytics (optional)
3. **Monitoring**: Set up error tracking (Sentry, etc.)
4. **CI/CD**: Configure automatic deployments from main branch

## Rollback

If deployment fails:

1. **Previous Deployment**: Use Vercel's deployment history to rollback
2. **Environment Variables**: Check variable values are correct
3. **Local Build**: Test `npm run build` locally first
4. **Vite Fallback**: You can still use `npm run dev:vite` locally if needed

## Support

For issues:
1. Check Vercel build logs
2. Verify environment variables
3. Test backend URLs are accessible
4. Review Next.js documentation: https://nextjs.org/docs

