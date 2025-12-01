const express = require('express');
const router = express.Router();
const { authenticate, requireAdmin } = require('../middleware/auth');
const { supabase, supabaseAdmin } = require('../config/supabase');

// Use admin client for all operations to bypass RLS
const getDbClient = () => supabaseAdmin || supabase;

/**
 * @route   GET /api/admin/dashboard
 * @desc    Get admin dashboard stats
 * @access  Private (Admin only)
 */
router.get('/dashboard', authenticate, requireAdmin, async (req, res) => {
  try {
    // Get total users
    const { count: totalUsers } = await supabase
      .from('users')
      .select('*', { count: 'exact', head: true });

    // Get total properties
    const { count: totalProperties } = await supabase
      .from('properties')
      .select('*', { count: 'exact', head: true });

    // Get pending properties
    const { count: pendingProperties } = await supabase
      .from('properties')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'pending');

    // Get total revenue
    const { data: payments } = await supabase
      .from('payments')
      .select('amount')
      .eq('status', 'completed');

    const totalRevenue = payments?.reduce((sum, p) => sum + parseFloat(p.amount || 0), 0) || 0;

    res.json({
      success: true,
      data: {
        totalUsers: totalUsers || 0,
        totalProperties: totalProperties || 0,
        pendingProperties: pendingProperties || 0,
        totalRevenue: totalRevenue,
      },
    });
  } catch (error) {
    console.error('Get admin dashboard error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   GET /api/admin/users
 * @desc    Get all users
 * @access  Private (Admin only)
 */
router.get('/users', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data: users, error } = await supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      data: users,
      count: users.length,
    });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   GET /api/admin/properties
 * @desc    Get all properties (with filters)
 * @access  Private (Admin only)
 */
router.get('/properties', authenticate, requireAdmin, async (req, res) => {
  try {
    let query = supabase.from('properties').select('*');

    if (req.query.status) {
      query = query.eq('status', req.query.status);
    }

    const { data: properties, error } = await query.order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      data: properties,
      count: properties.length,
    });
  } catch (error) {
    console.error('Get properties error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/properties/:id/approve
 * @desc    Approve property listing
 * @access  Private (Admin only)
 */
router.put('/properties/:id/approve', authenticate, requireAdmin, async (req, res) => {
  try {
    const dbClient = getDbClient();
    
    const { data, error } = await dbClient
      .from('properties')
      .update({
        status: 'approved',
        admin_comment: null,
        reviewed_by: req.userId,
        reviewed_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Property approved successfully',
      data: data && data.length > 0 ? data[0] : null,
    });
  } catch (error) {
    console.error('Approve property error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/properties/:id/reject
 * @desc    Reject property listing
 * @access  Private (Admin only)
 */
router.put('/properties/:id/reject', authenticate, requireAdmin, async (req, res) => {
  try {
    const { reason } = req.body;
    const dbClient = getDbClient();
    
    const { data, error } = await dbClient
      .from('properties')
      .update({
        status: 'rejected',
        admin_comment: reason || null,
        reviewed_by: req.userId,
        reviewed_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Property rejected',
      data: data && data.length > 0 ? data[0] : null,
    });
  } catch (error) {
    console.error('Reject property error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/properties/:id/comment
 * @desc    Add admin comment/feedback for improvement
 * @access  Private (Admin only)
 */
router.put('/properties/:id/comment', authenticate, requireAdmin, async (req, res) => {
  try {
    const { comment, status } = req.body;
    const dbClient = getDbClient();
    
    const updateData = {
      admin_comment: comment,
      reviewed_by: req.userId,
      reviewed_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };
    
    // Optionally update status (e.g., 'needs_revision')
    if (status) {
      updateData.status = status;
    }
    
    const { data, error } = await dbClient
      .from('properties')
      .update(updateData)
      .eq('id', req.params.id)
      .select();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Comment added successfully',
      data: data && data.length > 0 ? data[0] : null,
    });
  } catch (error) {
    console.error('Add comment error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   GET /api/admin/agents
 * @desc    Get all agents (pending approval)
 * @access  Private (Admin only)
 */
router.get('/agents', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data: agents, error } = await supabase
      .from('users')
      .select('*')
      .in('user_type', ['agent', 'landlord', 'owner'])
      .eq('verified', false)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      data: agents,
      count: agents.length,
    });
  } catch (error) {
    console.error('Get agents error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/users/:id/verify
 * @desc    Verify user
 * @access  Private (Admin only)
 */
router.put('/users/:id/verify', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .update({
        verified: true,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'User verified successfully',
      data,
    });
  } catch (error) {
    console.error('Verify user error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/agents/:id/approve
 * @desc    Approve agent
 * @access  Private (Admin only)
 */
router.put('/agents/:id/approve', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .update({
        verified: true,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Agent approved successfully',
      data,
    });
  } catch (error) {
    console.error('Approve agent error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   GET /api/admin/reports
 * @desc    Get all reports
 * @access  Private (Admin only)
 */
router.get('/reports', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data: reports, error } = await supabase
      .from('reports')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      data: reports,
      count: reports.length,
    });
  } catch (error) {
    console.error('Get reports error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/reports/:id/resolve
 * @desc    Resolve report
 * @access  Private (Admin only)
 */
router.put('/reports/:id/resolve', authenticate, requireAdmin, async (req, res) => {
  try {
    const { resolution_notes } = req.body;
    const { data, error } = await supabase
      .from('reports')
      .update({
        status: 'resolved',
        resolution_notes: resolution_notes || null,
        resolved_at: new Date().toISOString(),
        resolved_by: req.userId,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Report resolved successfully',
      data,
    });
  } catch (error) {
    console.error('Resolve report error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/reports/:id/dismiss
 * @desc    Dismiss report
 * @access  Private (Admin only)
 */
router.put('/reports/:id/dismiss', authenticate, requireAdmin, async (req, res) => {
  try {
    const { resolution_notes } = req.body;
    const { data, error } = await supabase
      .from('reports')
      .update({
        status: 'dismissed',
        resolution_notes: resolution_notes || null,
        resolved_at: new Date().toISOString(),
        resolved_by: req.userId,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Report dismissed',
      data,
    });
  } catch (error) {
    console.error('Dismiss report error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   GET /api/admin/bookings
 * @desc    Get all bookings
 * @access  Private (Admin only)
 */
router.get('/bookings', authenticate, requireAdmin, async (req, res) => {
  try {
    let query = supabase.from('bookings').select('*');

    if (req.query.status) {
      query = query.eq('status', req.query.status);
    }

    const { data: bookings, error } = await query.order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      data: bookings,
      count: bookings.length,
    });
  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/bookings/:id/status
 * @desc    Update booking status
 * @access  Private (Admin only)
 */
router.put('/bookings/:id/status', authenticate, requireAdmin, async (req, res) => {
  try {
    const { status } = req.body;
    const validStatuses = ['pending', 'confirmed', 'completed', 'cancelled'];
    
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid status',
      });
    }

    const { data, error } = await supabase
      .from('bookings')
      .update({
        status,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: `Booking ${status}`,
      data,
    });
  } catch (error) {
    console.error('Update booking status error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/users/:id/suspend
 * @desc    Suspend user
 * @access  Private (Admin only)
 */
router.put('/users/:id/suspend', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .update({
        status: 'suspended',
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'User suspended',
      data,
    });
  } catch (error) {
    console.error('Suspend user error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/users/:id/activate
 * @desc    Activate user
 * @access  Private (Admin only)
 */
router.put('/users/:id/activate', authenticate, requireAdmin, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .update({
        status: 'active',
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'User activated',
      data,
    });
  } catch (error) {
    console.error('Activate user error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/users/:id/role
 * @desc    Update user role
 * @access  Private (Admin only)
 */
router.put('/users/:id/role', authenticate, requireAdmin, async (req, res) => {
  try {
    const { role } = req.body;
    const validRoles = ['user', 'admin', 'agent', 'landlord', 'owner'];
    
    if (!validRoles.includes(role)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid role',
      });
    }

    const { data, error } = await supabase
      .from('users')
      .update({
        role,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: `User role updated to ${role}`,
      data,
    });
  } catch (error) {
    console.error('Update user role error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   DELETE /api/admin/users/:id
 * @desc    Delete user
 * @access  Private (Admin only)
 */
router.delete('/users/:id', authenticate, requireAdmin, async (req, res) => {
  try {
    const { error } = await supabase
      .from('users')
      .delete()
      .eq('id', req.params.id);

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'User deleted successfully',
    });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   DELETE /api/admin/properties/:id
 * @desc    Delete property
 * @access  Private (Admin only)
 */
router.delete('/properties/:id', authenticate, requireAdmin, async (req, res) => {
  try {
    const { error } = await supabase
      .from('properties')
      .delete()
      .eq('id', req.params.id);

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Property deleted successfully',
    });
  } catch (error) {
    console.error('Delete property error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/properties/:id/status
 * @desc    Update property status
 * @access  Private (Admin only)
 */
router.put('/properties/:id/status', authenticate, requireAdmin, async (req, res) => {
  try {
    const { status } = req.body;
    const validStatuses = ['pending', 'approved', 'active', 'rejected', 'sold', 'rented'];
    
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid status',
      });
    }

    const { data, error } = await supabase
      .from('properties')
      .update({
        status,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: `Property status updated to ${status}`,
      data,
    });
  } catch (error) {
    console.error('Update property status error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   GET /api/admin/stats
 * @desc    Get comprehensive admin stats
 * @access  Private (Admin only)
 */
router.get('/stats', authenticate, requireAdmin, async (req, res) => {
  try {
    // Get all counts in parallel
    const [
      usersCount,
      propertiesCount,
      pendingPropertiesCount,
      activePropertiesCount,
      agentsCount,
      pendingAgentsCount,
      bookingsCount,
      todayBookingsCount,
      reportsCount,
      openReportsCount,
      paymentsData,
    ] = await Promise.all([
      supabase.from('users').select('*', { count: 'exact', head: true }),
      supabase.from('properties').select('*', { count: 'exact', head: true }),
      supabase.from('properties').select('*', { count: 'exact', head: true }).eq('status', 'pending'),
      supabase.from('properties').select('*', { count: 'exact', head: true }).in('status', ['active', 'approved']),
      supabase.from('users').select('*', { count: 'exact', head: true }).in('user_type', ['agent', 'landlord', 'owner']),
      supabase.from('users').select('*', { count: 'exact', head: true }).in('user_type', ['agent', 'landlord', 'owner']).eq('verified', false),
      supabase.from('bookings').select('*', { count: 'exact', head: true }),
      supabase.from('bookings').select('*', { count: 'exact', head: true }).gte('created_at', new Date().toISOString().split('T')[0]),
      supabase.from('reports').select('*', { count: 'exact', head: true }),
      supabase.from('reports').select('*', { count: 'exact', head: true }).in('status', ['pending', 'investigating']),
      supabase.from('payments').select('amount').eq('status', 'completed'),
    ]);

    const totalRevenue = paymentsData.data?.reduce((sum, p) => sum + parseFloat(p.amount || 0), 0) || 0;

    res.json({
      success: true,
      data: {
        totalUsers: usersCount.count || 0,
        totalProperties: propertiesCount.count || 0,
        pendingProperties: pendingPropertiesCount.count || 0,
        activeProperties: activePropertiesCount.count || 0,
        totalAgents: agentsCount.count || 0,
        pendingAgents: pendingAgentsCount.count || 0,
        totalBookings: bookingsCount.count || 0,
        todayBookings: todayBookingsCount.count || 0,
        totalReports: reportsCount.count || 0,
        openReports: openReportsCount.count || 0,
        totalRevenue,
      },
    });
  } catch (error) {
    console.error('Get admin stats error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/admin/agents/:id/reject
 * @desc    Reject agent
 * @access  Private (Admin only)
 */
router.put('/agents/:id/reject', authenticate, requireAdmin, async (req, res) => {
  try {
    const { reason } = req.body;
    const { data, error } = await supabase
      .from('users')
      .update({
        status: 'rejected',
        rejection_reason: reason || null,
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Agent rejected',
      data,
    });
  } catch (error) {
    console.error('Reject agent error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

module.exports = router;

