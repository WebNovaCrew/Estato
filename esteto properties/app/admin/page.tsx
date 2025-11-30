'use client'

import { useState, useEffect } from 'react'
import { 
  Users, 
  Home, 
  TrendingUp, 
  Clock,
  DollarSign,
  UserCheck,
  Calendar,
  AlertTriangle,
  ArrowUpRight,
  ArrowDownRight,
  Eye,
  Check,
  X,
  Building2,
  Activity
} from 'lucide-react'
import { Property } from '@/lib/supabase/types'
import { createSupabaseClient } from '@/lib/supabase/client'
import { shouldUseMockData, mockProperties, mockUsers } from '@/lib/mock-api'
import Button from '@/components/ui/Button'
import Link from 'next/link'
import toast from 'react-hot-toast'

export default function AdminDashboardPage() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalProperties: 0,
    activeListings: 0,
    pendingListings: 0,
    totalRevenue: 0,
    pendingAgents: 0,
    todayBookings: 0,
    openReports: 0,
  })
  const [recentProperties, setRecentProperties] = useState<Property[]>([])
  const [recentActivities, setRecentActivities] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createSupabaseClient()

  useEffect(() => {
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    if (shouldUseMockData()) {
      const activeListings = mockProperties.filter(p => p.status === 'active').length
      const pendingListings = mockProperties.filter(p => p.status === 'pending').length
      
      setStats({
        totalUsers: mockUsers.length + 25,
        totalProperties: mockProperties.length + 15,
        activeListings,
        pendingListings: pendingListings + 8,
        totalRevenue: 1250000,
        pendingAgents: 5,
        todayBookings: 12,
        openReports: 3,
      })

      // Add pending properties for demo
      const pendingProps = mockProperties.slice(0, 3).map((p, i) => ({
        ...p,
        id: `pending-${i}`,
        status: 'pending' as const,
        title: `Pending: ${p.title}`,
      }))

      setRecentProperties([...pendingProps, ...mockProperties.slice(0, 5)])
      
      setRecentActivities([
        { id: 1, type: 'user', message: 'New user registered: Rahul Sharma', time: '5 min ago' },
        { id: 2, type: 'property', message: 'New property listed: Luxury Villa in Gomti Nagar', time: '15 min ago' },
        { id: 3, type: 'booking', message: 'New booking for 3BHK Apartment', time: '30 min ago' },
        { id: 4, type: 'agent', message: 'Agent verification request: Priya Singh', time: '1 hour ago' },
        { id: 5, type: 'report', message: 'New report submitted for property listing', time: '2 hours ago' },
      ])
      
      setLoading(false)
      return
    }

    if (!supabase) {
      setLoading(false)
      return
    }

    try {
      const [usersResult, propertiesResult, activeResult, pendingResult] = await Promise.all([
        supabase.from('users').select('id', { count: 'exact', head: true }),
        supabase.from('properties').select('id', { count: 'exact', head: true }),
        supabase.from('properties').select('id', { count: 'exact', head: true }).eq('status', 'active'),
        supabase.from('properties').select('id', { count: 'exact', head: true }).eq('status', 'pending'),
      ])

      setStats({
        totalUsers: usersResult.count || 0,
        totalProperties: propertiesResult.count || 0,
        activeListings: activeResult.count || 0,
        pendingListings: pendingResult.count || 0,
        totalRevenue: 0,
        pendingAgents: 0,
        todayBookings: 0,
        openReports: 0,
      })

      const { data: properties } = await supabase
        .from('properties')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(8)

      setRecentProperties(properties || [])
    } catch (error) {
      console.warn('Failed to fetch dashboard data:', error)
    }
    setLoading(false)
  }

  const handleQuickAction = async (propertyId: string, action: 'approve' | 'reject') => {
    if (shouldUseMockData()) {
      setRecentProperties(prev => prev.map(p => 
        p.id === propertyId 
          ? { ...p, status: action === 'approve' ? 'active' : 'rejected' } as Property
          : p
      ))
      toast.success(`Property ${action === 'approve' ? 'approved' : 'rejected'}`)
      return
    }

    try {
      const newStatus = action === 'approve' ? 'active' : 'rejected'
      const { error } = await supabase!
        .from('properties')
        .update({ status: newStatus })
        .eq('id', propertyId)

      if (error) throw error
      
      setRecentProperties(prev => prev.map(p => 
        p.id === propertyId ? { ...p, status: newStatus } as Property : p
      ))
      toast.success(`Property ${action === 'approve' ? 'approved' : 'rejected'}`)
    } catch (error) {
      toast.error('Failed to update property')
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  const pendingProperties = recentProperties.filter(p => p.status === 'pending')

  return (
    <div>
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">Dashboard Overview</h1>
        <p className="text-gray-600 mt-1">Welcome back! Here's what's happening with your platform.</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
              <Users className="w-5 h-5 text-blue-600" />
            </div>
            <span className="flex items-center text-green-600 text-sm font-medium">
              <ArrowUpRight className="w-4 h-4" />
              12%
            </span>
          </div>
          <p className="text-2xl font-bold text-gray-900">{stats.totalUsers}</p>
          <p className="text-sm text-gray-600">Total Users</p>
        </div>

        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
              <Home className="w-5 h-5 text-green-600" />
            </div>
            <span className="flex items-center text-green-600 text-sm font-medium">
              <ArrowUpRight className="w-4 h-4" />
              8%
            </span>
          </div>
          <p className="text-2xl font-bold text-gray-900">{stats.totalProperties}</p>
          <p className="text-sm text-gray-600">Total Properties</p>
        </div>

        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 rounded-lg bg-yellow-100 flex items-center justify-center">
              <Clock className="w-5 h-5 text-yellow-600" />
            </div>
            {stats.pendingListings > 0 && (
              <span className="px-2 py-1 bg-yellow-100 text-yellow-700 text-xs font-medium rounded-full">
                Action Required
              </span>
            )}
          </div>
          <p className="text-2xl font-bold text-gray-900">{stats.pendingListings}</p>
          <p className="text-sm text-gray-600">Pending Approval</p>
        </div>

        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 rounded-lg bg-purple-100 flex items-center justify-center">
              <DollarSign className="w-5 h-5 text-purple-600" />
            </div>
            <span className="flex items-center text-green-600 text-sm font-medium">
              <ArrowUpRight className="w-4 h-4" />
              24%
            </span>
          </div>
          <p className="text-2xl font-bold text-gray-900">₹{(stats.totalRevenue / 100000).toFixed(1)}L</p>
          <p className="text-sm text-gray-600">Total Revenue</p>
        </div>
      </div>

      {/* Secondary Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <Link href="/admin/properties" className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-emerald-100 flex items-center justify-center">
              <TrendingUp className="w-4 h-4 text-emerald-600" />
            </div>
            <div>
              <p className="text-lg font-bold text-gray-900">{stats.activeListings}</p>
              <p className="text-xs text-gray-600">Active Listings</p>
            </div>
          </div>
        </Link>

        <Link href="/admin/agents" className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-indigo-100 flex items-center justify-center">
              <UserCheck className="w-4 h-4 text-indigo-600" />
            </div>
            <div>
              <p className="text-lg font-bold text-gray-900">{stats.pendingAgents}</p>
              <p className="text-xs text-gray-600">Pending Agents</p>
            </div>
          </div>
        </Link>

        <Link href="/admin/bookings" className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-cyan-100 flex items-center justify-center">
              <Calendar className="w-4 h-4 text-cyan-600" />
            </div>
            <div>
              <p className="text-lg font-bold text-gray-900">{stats.todayBookings}</p>
              <p className="text-xs text-gray-600">Today's Bookings</p>
            </div>
          </div>
        </Link>

        <Link href="/admin/reports" className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-red-100 flex items-center justify-center">
              <AlertTriangle className="w-4 h-4 text-red-600" />
            </div>
            <div>
              <p className="text-lg font-bold text-gray-900">{stats.openReports}</p>
              <p className="text-xs text-gray-600">Open Reports</p>
            </div>
          </div>
        </Link>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Pending Approvals */}
        <div className="lg:col-span-2 bg-white rounded-xl shadow-sm border border-gray-100">
          <div className="p-4 border-b border-gray-100 flex items-center justify-between">
            <div>
              <h2 className="font-semibold text-gray-900">Pending Approvals</h2>
              <p className="text-sm text-gray-500">Properties waiting for review</p>
            </div>
            <Link href="/admin/properties?status=pending">
              <Button variant="outline" size="sm">View All</Button>
            </Link>
          </div>
          <div className="divide-y divide-gray-100">
            {pendingProperties.length > 0 ? (
              pendingProperties.slice(0, 5).map((property) => (
                <div key={property.id} className="p-4 flex items-center justify-between hover:bg-gray-50">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-lg bg-gray-100 overflow-hidden flex-shrink-0">
                      {property.images?.[0] ? (
                        <img 
                          src={property.images[0]} 
                          alt={property.title}
                          className="w-full h-full object-cover"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center">
                          <Building2 className="w-6 h-6 text-gray-400" />
                        </div>
                      )}
                    </div>
                    <div>
                      <p className="font-medium text-gray-900 line-clamp-1">{property.title}</p>
                      <p className="text-sm text-gray-500">{property.location}</p>
                      <p className="text-xs text-gray-400">
                        {new Date(property.created_at).toLocaleDateString()}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Link href={`/properties/${property.id}`}>
                      <button className="p-2 hover:bg-gray-100 rounded-lg" title="View">
                        <Eye className="w-4 h-4 text-gray-600" />
                      </button>
                    </Link>
                    <button 
                      onClick={() => handleQuickAction(property.id, 'approve')}
                      className="p-2 hover:bg-green-100 rounded-lg" 
                      title="Approve"
                    >
                      <Check className="w-4 h-4 text-green-600" />
                    </button>
                    <button 
                      onClick={() => handleQuickAction(property.id, 'reject')}
                      className="p-2 hover:bg-red-100 rounded-lg" 
                      title="Reject"
                    >
                      <X className="w-4 h-4 text-red-600" />
                    </button>
                  </div>
                </div>
              ))
            ) : (
              <div className="p-8 text-center">
                <Check className="w-12 h-12 text-green-500 mx-auto mb-2" />
                <p className="text-gray-500">All caught up! No pending approvals.</p>
              </div>
            )}
          </div>
        </div>

        {/* Recent Activity */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100">
          <div className="p-4 border-b border-gray-100">
            <h2 className="font-semibold text-gray-900">Recent Activity</h2>
            <p className="text-sm text-gray-500">Latest platform activities</p>
          </div>
          <div className="divide-y divide-gray-100">
            {recentActivities.map((activity) => (
              <div key={activity.id} className="p-4 flex items-start gap-3">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                  activity.type === 'user' ? 'bg-blue-100' :
                  activity.type === 'property' ? 'bg-green-100' :
                  activity.type === 'booking' ? 'bg-purple-100' :
                  activity.type === 'agent' ? 'bg-indigo-100' :
                  'bg-red-100'
                }`}>
                  <Activity className={`w-4 h-4 ${
                    activity.type === 'user' ? 'text-blue-600' :
                    activity.type === 'property' ? 'text-green-600' :
                    activity.type === 'booking' ? 'text-purple-600' :
                    activity.type === 'agent' ? 'text-indigo-600' :
                    'text-red-600'
                  }`} />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-gray-900 line-clamp-2">{activity.message}</p>
                  <p className="text-xs text-gray-500 mt-1">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="mt-6">
        <h2 className="font-semibold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <Link href="/admin/properties">
            <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow cursor-pointer">
              <Home className="w-8 h-8 text-primary-600 mb-2" />
              <h3 className="font-medium text-gray-900">Manage Properties</h3>
              <p className="text-sm text-gray-500">View and manage all listings</p>
            </div>
          </Link>
          <Link href="/admin/users">
            <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow cursor-pointer">
              <Users className="w-8 h-8 text-primary-600 mb-2" />
              <h3 className="font-medium text-gray-900">Manage Users</h3>
              <p className="text-sm text-gray-500">View and manage all users</p>
            </div>
          </Link>
          <Link href="/admin/agents">
            <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow cursor-pointer">
              <UserCheck className="w-8 h-8 text-primary-600 mb-2" />
              <h3 className="font-medium text-gray-900">Verify Agents</h3>
              <p className="text-sm text-gray-500">Approve agent applications</p>
            </div>
          </Link>
          <Link href="/admin/settings">
            <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow cursor-pointer">
              <Activity className="w-8 h-8 text-primary-600 mb-2" />
              <h3 className="font-medium text-gray-900">Settings</h3>
              <p className="text-sm text-gray-500">Configure platform settings</p>
            </div>
          </Link>
        </div>
      </div>
    </div>
  )
}
