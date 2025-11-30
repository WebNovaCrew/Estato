'use client'

import { useState, useEffect } from 'react'
import { 
  TrendingUp, 
  Users, 
  Home, 
  Eye,
  DollarSign,
  Calendar,
  ArrowUpRight,
  ArrowDownRight,
  BarChart3,
  PieChart,
  Activity
} from 'lucide-react'
import { shouldUseMockData } from '@/lib/mock-api'

export default function AdminAnalyticsPage() {
  const [timeRange, setTimeRange] = useState('30d')
  const [loading, setLoading] = useState(true)

  const [stats, setStats] = useState({
    totalViews: 45230,
    totalUsers: 1250,
    totalProperties: 342,
    totalBookings: 89,
    revenue: 2450000,
    conversionRate: 3.2,
  })

  const [chartData, setChartData] = useState({
    userGrowth: [
      { month: 'Jan', users: 120 },
      { month: 'Feb', users: 180 },
      { month: 'Mar', users: 250 },
      { month: 'Apr', users: 320 },
      { month: 'May', users: 410 },
      { month: 'Jun', users: 520 },
      { month: 'Jul', users: 680 },
      { month: 'Aug', users: 820 },
      { month: 'Sep', users: 950 },
      { month: 'Oct', users: 1100 },
      { month: 'Nov', users: 1250 },
    ],
    propertyViews: [
      { day: 'Mon', views: 1200 },
      { day: 'Tue', views: 1450 },
      { day: 'Wed', views: 1380 },
      { day: 'Thu', views: 1520 },
      { day: 'Fri', views: 1680 },
      { day: 'Sat', views: 2100 },
      { day: 'Sun', views: 1900 },
    ],
    propertyTypes: [
      { type: 'Flat', count: 145, percentage: 42 },
      { type: 'House', count: 89, percentage: 26 },
      { type: 'Villa', count: 52, percentage: 15 },
      { type: 'Plot', count: 38, percentage: 11 },
      { type: 'Commercial', count: 18, percentage: 6 },
    ],
    topLocations: [
      { location: 'Gomti Nagar', properties: 78, views: 12500 },
      { location: 'Hazratganj', properties: 45, views: 8900 },
      { location: 'Aliganj', properties: 38, views: 6700 },
      { location: 'Indira Nagar', properties: 32, views: 5400 },
      { location: 'Mahanagar', properties: 28, views: 4200 },
    ],
    recentActivity: [
      { type: 'booking', message: 'New booking for 3BHK in Gomti Nagar', time: '5 min ago' },
      { type: 'user', message: 'New user registered: Rahul S.', time: '12 min ago' },
      { type: 'property', message: 'Property listed: Villa in Hazratganj', time: '25 min ago' },
      { type: 'review', message: 'New review on Modern Apartment', time: '1 hour ago' },
      { type: 'booking', message: 'Booking confirmed for Plot in Aliganj', time: '2 hours ago' },
    ],
  })

  useEffect(() => {
    // Simulate loading
    setTimeout(() => setLoading(false), 500)
  }, [])

  const StatCard = ({ title, value, change, icon: Icon, color }: any) => (
    <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
      <div className="flex items-center justify-between mb-3">
        <div className={`w-10 h-10 rounded-lg ${color} flex items-center justify-center`}>
          <Icon className="w-5 h-5 text-white" />
        </div>
        {change && (
          <span className={`flex items-center text-sm font-medium ${change > 0 ? 'text-green-600' : 'text-red-600'}`}>
            {change > 0 ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownRight className="w-4 h-4" />}
            {Math.abs(change)}%
          </span>
        )}
      </div>
      <p className="text-2xl font-bold text-gray-900">{value}</p>
      <p className="text-sm text-gray-600">{title}</p>
    </div>
  )

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  return (
    <div>
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Analytics Dashboard</h1>
          <p className="text-gray-600 mt-1">Track your platform performance</p>
        </div>
        <select
          value={timeRange}
          onChange={(e) => setTimeRange(e.target.value)}
          className="px-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500"
        >
          <option value="7d">Last 7 days</option>
          <option value="30d">Last 30 days</option>
          <option value="90d">Last 90 days</option>
          <option value="1y">Last year</option>
        </select>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4 mb-6">
        <StatCard title="Total Views" value={stats.totalViews.toLocaleString()} change={12} icon={Eye} color="bg-blue-500" />
        <StatCard title="Total Users" value={stats.totalUsers.toLocaleString()} change={8} icon={Users} color="bg-green-500" />
        <StatCard title="Properties" value={stats.totalProperties} change={5} icon={Home} color="bg-purple-500" />
        <StatCard title="Bookings" value={stats.totalBookings} change={15} icon={Calendar} color="bg-orange-500" />
        <StatCard title="Revenue" value={`₹${(stats.revenue / 100000).toFixed(1)}L`} change={24} icon={DollarSign} color="bg-emerald-500" />
        <StatCard title="Conversion" value={`${stats.conversionRate}%`} change={-2} icon={TrendingUp} color="bg-pink-500" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        {/* User Growth Chart */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-gray-900">User Growth</h2>
            <BarChart3 className="w-5 h-5 text-gray-400" />
          </div>
          <div className="h-64 flex items-end justify-between gap-2">
            {chartData.userGrowth.map((item, index) => (
              <div key={item.month} className="flex-1 flex flex-col items-center">
                <div 
                  className="w-full bg-primary-500 rounded-t-sm transition-all hover:bg-primary-600"
                  style={{ height: `${(item.users / 1250) * 200}px` }}
                ></div>
                <span className="text-xs text-gray-500 mt-2">{item.month}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Property Views Chart */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-gray-900">Weekly Property Views</h2>
            <Activity className="w-5 h-5 text-gray-400" />
          </div>
          <div className="h-64 flex items-end justify-between gap-4">
            {chartData.propertyViews.map((item) => (
              <div key={item.day} className="flex-1 flex flex-col items-center">
                <div 
                  className="w-full bg-green-500 rounded-t-sm transition-all hover:bg-green-600"
                  style={{ height: `${(item.views / 2100) * 200}px` }}
                ></div>
                <span className="text-xs text-gray-500 mt-2">{item.day}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Property Types Distribution */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-gray-900">Property Types</h2>
            <PieChart className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-4">
            {chartData.propertyTypes.map((item, index) => {
              const colors = ['bg-blue-500', 'bg-green-500', 'bg-purple-500', 'bg-orange-500', 'bg-pink-500']
              return (
                <div key={item.type}>
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-sm text-gray-700">{item.type}</span>
                    <span className="text-sm font-medium text-gray-900">{item.count} ({item.percentage}%)</span>
                  </div>
                  <div className="w-full bg-gray-100 rounded-full h-2">
                    <div 
                      className={`${colors[index]} h-2 rounded-full transition-all`}
                      style={{ width: `${item.percentage}%` }}
                    ></div>
                  </div>
                </div>
              )
            })}
          </div>
        </div>

        {/* Top Locations */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-gray-900">Top Locations</h2>
          </div>
          <div className="space-y-3">
            {chartData.topLocations.map((item, index) => (
              <div key={item.location} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center gap-3">
                  <span className="w-6 h-6 rounded-full bg-primary-100 text-primary-600 flex items-center justify-center text-sm font-medium">
                    {index + 1}
                  </span>
                  <div>
                    <p className="font-medium text-gray-900">{item.location}</p>
                    <p className="text-xs text-gray-500">{item.properties} properties</p>
                  </div>
                </div>
                <span className="text-sm text-gray-600">{(item.views / 1000).toFixed(1)}k views</span>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Activity */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-gray-900">Recent Activity</h2>
          </div>
          <div className="space-y-3">
            {chartData.recentActivity.map((item, index) => (
              <div key={index} className="flex items-start gap-3 p-3 hover:bg-gray-50 rounded-lg">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                  item.type === 'booking' ? 'bg-green-100' :
                  item.type === 'user' ? 'bg-blue-100' :
                  item.type === 'property' ? 'bg-purple-100' :
                  'bg-yellow-100'
                }`}>
                  <Activity className={`w-4 h-4 ${
                    item.type === 'booking' ? 'text-green-600' :
                    item.type === 'user' ? 'text-blue-600' :
                    item.type === 'property' ? 'text-purple-600' :
                    'text-yellow-600'
                  }`} />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-gray-900 line-clamp-1">{item.message}</p>
                  <p className="text-xs text-gray-500">{item.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
