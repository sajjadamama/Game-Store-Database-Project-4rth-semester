from flask import Flask, request, jsonify, render_template, session, redirect, url_for
from dbconfig import get_db_connection

app = Flask(__name__)
app.secret_key = 'your_secret_key'

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Users (username, email, password, role) VALUES (?, ?, ?, 'Customer')",
                   data['username'], data['email'], data['password'])
    conn.commit()
    return jsonify({"message": "User registered successfully"})

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Users WHERE username=? AND password=?", data['username'], data['password'])
    user = cursor.fetchone()
    if user:
        session['user_id'] = user[0]
        session['role'] = user[4]
        return jsonify({"message": "Login successful", "role": user[4]})
    return jsonify({"message": "Invalid credentials"}), 401

@app.route('/games', methods=['GET'])
def get_games():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Games")
    games = cursor.fetchall()
    result = []
    for row in games:
        result.append({
            'id': row[0],
            'title': row[1],
            'description': row[2],
            'price': row[3],
            'genre': row[4],
            'platform': row[5]
        })
    return jsonify(result)

@app.route('/add-game', methods=['POST'])
def add_game():
    if session.get('role') != 'Admin':
        return jsonify({"error": "Access denied"}), 403
    data = request.get_json()
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Games (title, description, price, genre, platform) VALUES (?, ?, ?, ?, ?)",
                   data['title'], data['description'], data['price'], data['genre'], data['platform'])
    conn.commit()
    return jsonify({"message": "Game added successfully"})

if __name__ == '__main__':
    app.run(debug=True)
