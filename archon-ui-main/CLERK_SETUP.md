# Clerk Authentication Setup Guide

This guide explains how to set up Clerk authentication for the Metis application.

## Quick Start

1. **Create a Clerk Account**
   - Go to [clerk.com](https://clerk.com) and sign up
   - Create a new application

2. **Get API Keys**
   - Go to [Clerk Dashboard → API Keys](https://dashboard.clerk.com/last-active?path=api-keys)
   - Copy your **Publishable Key** (starts with `pk_test_` or `pk_live_`)
   - Copy your **Secret Key** (starts with `sk_test_` or `sk_live_`)

3. **Configure Environment Variables**

   Create or update `.env.local`:
   ```env
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
   CLERK_SECRET_KEY=sk_test_...
   ```

   **For Vercel**: Add these in **Project Settings → Environment Variables**

4. **Start the Application**
   ```bash
   npm run dev
   ```

## How It Works

### Route Protection

The `middleware.ts` file protects routes automatically:

- **Public Routes** (no auth required):
  - `/` - Home/Knowledge Base
  - `/sign-in` - Sign in page
  - `/sign-up` - Sign up page
  - `/onboarding` - Initial setup

- **Protected Routes** (auth required):
  - `/projects` - Project management
  - `/projects/[projectId]` - Project details
  - `/settings` - User settings
  - `/mcp` - MCP dashboard
  - `/agent-work-orders` - Agent work orders
  - `/agent-work-orders/[id]` - Work order details

Unauthenticated users trying to access protected routes are automatically redirected to `/sign-in`.

### Authentication UI

The navigation component (`src/components/layout/Navigation.tsx`) includes:
- **Sign In Button** - Shown when user is signed out
- **User Button** - Shown when user is signed in (profile menu, sign out)

### API Authentication

For authenticated API calls, use the `useAuthenticatedAPI` hook:

```tsx
import { useAuthenticatedAPI } from '@/features/shared/hooks/useAuthenticatedAPI'

function MyComponent() {
  const { callAPI } = useAuthenticatedAPI()
  
  const fetchData = async () => {
    // Automatically includes Clerk JWT token in Authorization header
    const data = await callAPI('/api/projects')
    return data
  }
}
```

The hook automatically:
- Gets the Clerk JWT token
- Adds it to the `Authorization: Bearer <token>` header
- Makes the API call through Next.js rewrites

### Server-Side Authentication

In Server Components or API routes, use Clerk's server-side API:

```tsx
import { auth, currentUser } from '@clerk/nextjs/server'

export default async function MyServerComponent() {
  const { userId } = await auth()
  
  if (!userId) {
    redirect('/sign-in')
  }
  
  const user = await currentUser()
  // Use user data...
}
```

## Customization

### Custom Sign-In/Sign-Up URLs

In `.env.local`:
```env
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/onboarding
```

### Styling

Clerk components are styled to match your Tailwind CSS 4 theme. The `ClerkProvider` in `app/layout.tsx` includes:

```tsx
<ClerkProvider
  appearance={{
    cssLayerName: 'clerk', // Required for Tailwind CSS 4
  }}
>
```

You can customize Clerk's appearance further in the Clerk Dashboard under **Customization**.

## Backend Integration

### Verifying JWT Tokens

If your backend needs to verify Clerk JWT tokens:

1. **Install Clerk Backend SDK** (Python example):
   ```bash
   pip install clerk-sdk-python
   ```

2. **Verify tokens in FastAPI**:
   ```python
   from clerk_sdk import Clerk
   
   clerk = Clerk(api_key=os.getenv("CLERK_SECRET_KEY"))
   
   @app.get("/api/protected")
   async def protected_route(request: Request):
       token = request.headers.get("Authorization", "").replace("Bearer ", "")
       try:
           user = clerk.verify_token(token)
           return {"user_id": user["sub"]}
       except Exception:
           raise HTTPException(status_code=401, detail="Invalid token")
   ```

### User ID in API Requests

The JWT token includes the user ID in the `sub` claim. Your backend can extract this to:
- Associate data with users
- Implement user-specific permissions
- Track user activity

## Troubleshooting

### "Clerk: Missing publishableKey"

**Problem**: Clerk publishable key not found.

**Solution**: 
1. Check `.env.local` has `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
2. Restart dev server after adding env vars
3. For Vercel, ensure env var is set in dashboard

### Middleware Not Protecting Routes

**Problem**: Routes accessible without authentication.

**Solution**:
1. Check `middleware.ts` exists in project root
2. Verify `matcher` config includes your routes
3. Ensure `clerkMiddleware` is called correctly

### API Calls Not Including Token

**Problem**: Backend receives requests without Authorization header.

**Solution**:
1. Use `useAuthenticatedAPI` hook instead of `callAPIWithETag` directly
2. Ensure user is signed in (check with `useAuth()` hook)
3. Verify ClerkProvider wraps your app in `app/layout.tsx`

### Sign-In Redirect Loop

**Problem**: User redirected to sign-in repeatedly.

**Solution**:
1. Check `/sign-in` is in public routes in `middleware.ts`
2. Verify Clerk environment variables are correct
3. Check browser console for Clerk errors

## Next Steps

- [ ] Set up user roles/permissions in Clerk Dashboard
- [ ] Customize Clerk UI appearance
- [ ] Add user profile page
- [ ] Implement backend JWT verification
- [ ] Set up user-specific data isolation

## Resources

- [Clerk Documentation](https://clerk.com/docs)
- [Clerk Next.js Guide](https://clerk.com/docs/quickstarts/nextjs)
- [Clerk Dashboard](https://dashboard.clerk.com)


