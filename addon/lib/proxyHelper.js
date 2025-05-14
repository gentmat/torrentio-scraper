/**
 * Utility functions for MediaFlow Proxy Light integration
 */

/**
 * Format a stream URL to be proxied through MediaFlow Proxy Light
 * @param {string} originalUrl - The original stream URL
 * @param {Object} config - The proxy configuration
 * @returns {string} The proxied URL
 */
export function proxyStreamUrl(originalUrl, config) {
  if (!config || !config.proxyEnabled || !config.proxyUrl) {
    return originalUrl;
  }

  const proxyBaseUrl = config.proxyUrl.endsWith('/') 
    ? config.proxyUrl.slice(0, -1) 
    : config.proxyUrl;
  
  let proxyUrl = `${proxyBaseUrl}/proxy/stream?d=${encodeURIComponent(originalUrl)}`;
  
  // Add API password if provided
  if (config.proxyApiPassword) {
    proxyUrl += `&api_password=${encodeURIComponent(config.proxyApiPassword)}`;
  }
  
  // Add custom headers if needed
  if (config.proxyHeaders) {
    for (const [key, value] of Object.entries(config.proxyHeaders)) {
      proxyUrl += `&h_${key}=${encodeURIComponent(value)}`;
    }
  }
  
  return proxyUrl;
}

/**
 * Check if MediaFlow Proxy Light is properly configured
 * @param {Object} config - The proxy configuration
 * @returns {boolean} True if proxy is properly configured
 */
export function isProxyConfigured(config) {
  return config && config.proxyEnabled && config.proxyUrl;
} 