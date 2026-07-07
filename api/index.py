"""Vercel Serverless Function Entry Point for Agriculture Bot.

This module wraps the Flask application for Vercel's serverless environment.
Vercel expects a function handler that processes requests.
"""

import sys
import os

# Add parent directory to path so we can import the app module
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import create_app

# Create the Flask app instance
app = create_app()

# Vercel serverless handler
def handler(request, context):
    """Vercel serverless function handler.
    
    Args:
        request: Vercel request object
        context: Vercel context object
        
    Returns:
        Flask response
    """
    return app(request.environ, context)


# For Vercel, we also need to expose the app directly
# Vercel's Python runtime will use this
application = app
