'use client'

import { useState, useEffect } from 'react'
import { useRouter, usePathname } from 'next/navigation'
import Link from 'next/link'
import { 
  LayoutDashboard, 
  Home, 
  Users, 
  UserCheck, 
  Calendar, 
  FileText, 
  Settings, 
  LogOut,
  Menu,
  X,
  Bell,
  ChevronDown,
  Building2,
  Shield,
  BarChart3,
  Star,
  Image,
  MapPin,
  Layers,
  MessageSquare,
  Mail,
  Globe,
  Database,
  Key
} from 'lucide-react'
import { createSupabaseClient } from '@/lib/supabase/client'
import { shouldUseMockData } from '@/lib/mock-api'
import toast from 'react-hot-toast'

const sidebarItems = [
  { name: 'Dashboard', href: '/admin', icon: LayoutDashboard },
  { name: 'Analytics', href: '/admin/analytics', icon: BarChart3 },
  { name: 'Properties', href: '/admin/properties', icon: Home },
  { name: 'Featured', href: '/admin/featured', icon: Star },
  { name: 'Users', href: '/admin/users', icon: Users },
  { name: 'Agents & Landlords', href: '/admin/agents', icon: UserCheck },
  { name: 'Bookings', href: '/admin/bookings', icon: Calendar },
  { name: 'Reviews', href: '/admin/reviews', icon: MessageSquare },
  { name: 'Reports', href: '/admin/reports', icon: FileText },
  { name: 'Banners', href: '/admin/banners', icon: Image },
  { name: 'Locations', href: '/admin/locations', icon: MapPin },
  { name: 'Categories', href: '/admin/categories', icon: Layers },
  { name: 'Notifications', href: '/admin/notifications', icon: Mail },
  { name: 'SEO', href: '/admin/seo', icon: Globe },
  { name: 'Logs & Backups', href: '/admin/logs', icon: Database },
  { name: 'Roles', href: '/admin/roles', icon: Key },
  { name: 'Settings', href: '/admin/settings', icon: Settings },
]

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const router = useRouter()
  const pathname = usePathname()
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [user, setUser] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [notificationCount, setNotificationCount] = useState(3)
  const supabase = createSupabaseClient()

  useEffect(() => {
    checkAdmin()
  }, [])

  const checkAdmin = async () => {
    // Demo mode - allow access without authentication
    if (shouldUseMockData()) {
      setUser({ 
        id: 'demo-admin', 
        email: 'admin@estato.com',
        full_name: 'Admin User',
        role: 'admin'
      })
      setLoading(false)
      return
    }

    if (!supabase) {
      // Fallback to demo mode if Supabase client not available
      setUser({ 
        id: 'demo-admin', 
        email: 'admin@estato.com',
        full_name: 'Admin User',
        role: 'admin'
      })
      setLoading(false)
      return
    }

    try {
      const { data: { user: authUser } } = await supabase.auth.getUser()
      
      // If no authenticated user, allow demo access
      if (!authUser) {
        setUser({ 
          id: 'demo-admin', 
          email: 'admin@estato.com',
          full_name: 'Demo Admin',
          role: 'admin'
        })
        setLoading(false)
        return
      }

      const { data: userData } = await supabase
        .from('users')
        .select('*')
        .eq('id', authUser.id)
        .single()

      // If user is not admin, still allow demo access for now
      if (!userData || userData?.role !== 'admin') {
        setUser({ 
          id: 'demo-admin', 
          email: 'admin@estato.com',
          full_name: 'Demo Admin',
          role: 'admin'
        })
        setLoading(false)
        return
      }

      setUser(userData)
    } catch (error) {
      console.error('Admin check failed:', error)
      // Fallback to demo mode on error
      setUser({ 
        id: 'demo-admin', 
        email: 'admin@estato.com',
        full_name: 'Demo Admin',
        role: 'admin'
      })
    }
    setLoading(false)
  }

  const handleLogout = async () => {
    if (supabase) {
      await supabase.auth.signOut()
    }
    localStorage.removeItem('access_token')
    localStorage.removeItem('user_data')
    router.push('/')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Mobile sidebar backdrop */}
      {sidebarOpen && (
        <div 
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside className={`
        fixed top-0 left-0 z-50 h-full w-64 bg-gray-900 transform transition-transform duration-300 ease-in-out
        lg:translate-x-0 ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
        {/* Logo */}
        <div className="flex items-center justify-between h-16 px-6 bg-gray-800">
          <Link href="/admin" className="flex items-center gap-2">
            <Shield className="w-8 h-8 text-primary-500" />
            <span className="text-xl font-bold text-white">Estato Admin</span>
          </Link>
          <button 
            onClick={() => setSidebarOpen(false)}
            className="lg:hidden text-gray-400 hover:text-white"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="mt-6 px-3">
          {sidebarItems.map((item) => {
            const isActive = pathname === item.href || 
              (item.href !== '/admin' && pathname.startsWith(item.href))
            return (
              <Link
                key={item.name}
                href={item.href}
                className={`
                  flex items-center gap-3 px-4 py-3 mb-1 rounded-lg transition-colors
                  ${isActive 
                    ? 'bg-primary-600 text-white' 
                    : 'text-gray-400 hover:bg-gray-800 hover:text-white'}
                `}
                onClick={() => setSidebarOpen(false)}
              >
                <item.icon className="w-5 h-5" />
                <span className="font-medium">{item.name}</span>
              </Link>
            )
          })}
        </nav>

        {/* User section at bottom */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-800">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-full bg-primary-600 flex items-center justify-center">
              <span className="text-white font-semibold">
                {user?.full_name?.charAt(0) || user?.email?.charAt(0) || 'A'}
              </span>
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-white truncate">
                {user?.full_name || 'Admin'}
              </p>
              <p className="text-xs text-gray-400 truncate">{user?.email}</p>
            </div>
          </div>
          <button
            onClick={handleLogout}
            className="flex items-center gap-2 w-full px-4 py-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span>Logout</span>
          </button>
        </div>
      </aside>

      {/* Main content */}
      <div className="lg:pl-64">
        {/* Top header */}
        <header className="sticky top-0 z-30 bg-white shadow-sm">
          <div className="flex items-center justify-between h-16 px-4 lg:px-8">
            <button
              onClick={() => setSidebarOpen(true)}
              className="lg:hidden p-2 rounded-lg hover:bg-gray-100"
            >
              <Menu className="w-6 h-6" />
            </button>

            <div className="flex-1 lg:flex-none">
              <h1 className="text-lg font-semibold text-gray-900 lg:hidden">Admin Panel</h1>
            </div>

            <div className="flex items-center gap-4">
              {/* Notifications */}
              <button className="relative p-2 rounded-lg hover:bg-gray-100">
                <Bell className="w-6 h-6 text-gray-600" />
                {notificationCount > 0 && (
                  <span className="absolute top-1 right-1 w-5 h-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">
                    {notificationCount}
                  </span>
                )}
              </button>

              {/* User dropdown */}
              <div className="hidden lg:flex items-center gap-3 pl-4 border-l border-gray-200">
                <div className="w-8 h-8 rounded-full bg-primary-600 flex items-center justify-center">
                  <span className="text-white text-sm font-semibold">
                    {user?.full_name?.charAt(0) || 'A'}
                  </span>
                </div>
                <div className="flex items-center gap-1">
                  <span className="text-sm font-medium text-gray-700">
                    {user?.full_name || 'Admin'}
                  </span>
                  <ChevronDown className="w-4 h-4 text-gray-400" />
                </div>
              </div>
            </div>
          </div>
        </header>

        {/* Page content */}
        <main className="p-4 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  )
}
