from flask import Blueprint, render_template, request, redirect, url_for
from werkzeug.security import generate_password_hash, check_password_hash

auth_bp = Blueprint('auth', __name__)

# Dummy users dictionary
users = {
    'admin': {'password': generate_password_hash('admin123'), 'role': 'admin'},
    'john': {'password': generate_password_hash('john123'), 'role': 'customer'}
}

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = users.get(username)

        if user and check_password_hash(user['password'], password):
            return f"Welcome, {username}! You are logged in as {user['role']}."
        return "Invalid username or password."
    
    return render_template('login.html')

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = generate_password_hash(request.form['password'])

        if username in users:
            return "User already exists."

        users[username] = {'password': password, 'role': 'customer'}
        return redirect(url_for('auth.login'))

    return render_template('register.html')
