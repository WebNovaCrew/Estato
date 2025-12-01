// Real Backend API Client for Admin Panel
// Connects to the deployed backend at https://champ-y6eg.onrender.com

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'https://champ-y6eg.onrender.com/api';

interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  count?: number;
}

class ApiClient {
  private token: string | null = null;

  setToken(token: string) {
    this.token = token;
    if (typeof window !== 'undefined') {
      localStorage.setItem('admin_token', token);
    }
  }

  getToken(): string | null {
    if (this.token) return this.token;
    if (typeof window !== 'undefined') {
      return localStorage.getItem('admin_token');
    }
    return null;
  }

  clearToken() {
    this.token = null;
    if (typeof window !== 'undefined') {
      localStorage.removeItem('admin_token');
    }
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> {
    const token = this.getToken();
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      ...options.headers,
    };

    if (token) {
      (headers as Record<string, string>)['Authorization'] = `Bearer ${token}`;
    }

    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        ...options,
        headers,
      });

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('API request failed:', error);
      return {
        success: false,
        error: 'Network error. Please try again.',
      };
    }
  }

  // Auth
  async login(email: string, password: string) {
    const response = await this.request<{ token: string; user: any }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
    
    if (response.success && response.data?.token) {
      this.setToken(response.data.token);
    }
    
    return response;
  }

  async logout() {
    this.clearToken();
    return { success: true };
  }

  async getMe() {
    return this.request('/auth/me');
  }

  // Dashboard Stats
  async getDashboardStats() {
    return this.request('/admin/stats');
  }

  async getDashboard() {
    return this.request('/admin/dashboard');
  }

  // Properties
  async getProperties(status?: string) {
    const query = status ? `?status=${status}` : '';
    return this.request(`/admin/properties${query}`);
  }

  async getProperty(id: string) {
    return this.request(`/properties/${id}`);
  }

  async approveProperty(id: string) {
    return this.request(`/admin/properties/${id}/approve`, {
      method: 'PUT',
    });
  }

  async rejectProperty(id: string, reason?: string) {
    return this.request(`/admin/properties/${id}/reject`, {
      method: 'PUT',
      body: JSON.stringify({ reason }),
    });
  }

  async addPropertyComment(id: string, comment: string, status?: string) {
    return this.request(`/admin/properties/${id}/comment`, {
      method: 'PUT',
      body: JSON.stringify({ comment, status }),
    });
  }

  async updatePropertyStatus(id: string, status: string) {
    return this.request(`/admin/properties/${id}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status }),
    });
  }

  async deleteProperty(id: string) {
    return this.request(`/admin/properties/${id}`, {
      method: 'DELETE',
    });
  }

  // Users
  async getUsers() {
    return this.request('/admin/users');
  }

  async verifyUser(id: string) {
    return this.request(`/admin/users/${id}/verify`, {
      method: 'PUT',
    });
  }

  async suspendUser(id: string) {
    return this.request(`/admin/users/${id}/suspend`, {
      method: 'PUT',
    });
  }

  async activateUser(id: string) {
    return this.request(`/admin/users/${id}/activate`, {
      method: 'PUT',
    });
  }

  async updateUserRole(id: string, role: string) {
    return this.request(`/admin/users/${id}/role`, {
      method: 'PUT',
      body: JSON.stringify({ role }),
    });
  }

  async deleteUser(id: string) {
    return this.request(`/admin/users/${id}`, {
      method: 'DELETE',
    });
  }

  // Agents
  async getAgents() {
    return this.request('/admin/agents');
  }

  async approveAgent(id: string) {
    return this.request(`/admin/agents/${id}/approve`, {
      method: 'PUT',
    });
  }

  async rejectAgent(id: string, reason?: string) {
    return this.request(`/admin/agents/${id}/reject`, {
      method: 'PUT',
      body: JSON.stringify({ reason }),
    });
  }

  // Bookings
  async getBookings(status?: string) {
    const query = status ? `?status=${status}` : '';
    return this.request(`/admin/bookings${query}`);
  }

  async updateBookingStatus(id: string, status: string) {
    return this.request(`/admin/bookings/${id}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status }),
    });
  }

  // Reports
  async getReports() {
    return this.request('/admin/reports');
  }

  async resolveReport(id: string, notes?: string) {
    return this.request(`/admin/reports/${id}/resolve`, {
      method: 'PUT',
      body: JSON.stringify({ resolution_notes: notes }),
    });
  }

  async dismissReport(id: string, notes?: string) {
    return this.request(`/admin/reports/${id}/dismiss`, {
      method: 'PUT',
      body: JSON.stringify({ resolution_notes: notes }),
    });
  }

  // Public Properties (no auth required)
  async getPublicProperties(filters?: Record<string, string>) {
    const params = new URLSearchParams(filters);
    return this.request(`/properties?${params.toString()}`);
  }

  async getFeaturedProperties() {
    return this.request('/properties/featured');
  }
}

export const apiClient = new ApiClient();
export default apiClient;
