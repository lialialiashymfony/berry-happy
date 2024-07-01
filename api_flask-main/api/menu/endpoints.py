"""Routes for module menu"""
import os
from flask import Blueprint, jsonify, request
from helper.db_helper import get_connection
from helper.form_validation import get_form_data

menu_endpoints = Blueprint('menu', __name__)
UPLOAD_FOLDER = "img"




@menu_endpoints.route('/read', methods=['GET'])
def read():
    try:
        # Ambil parameter page dan search dari query string
        page = int(request.args.get('page', 1))
        search = request.args.get('search', '')
        per_page = 5  # Tetapkan jumlah item per halaman

        # Hitung offset
        offset = (page - 1) * per_page

        connection = get_connection()
        cursor = connection.cursor(dictionary=True)

        if search:
            # Jika ada parameter search, tambahkan kondisi WHERE dengan LIKE
            search_param = f"%{search}%"
            count_query = """
                SELECT COUNT(*) AS total 
                FROM menu
                WHERE nama_menu LIKE %s
            """
            cursor.execute(count_query, (search_param,))
            total_items = cursor.fetchone()['total']

            query = """
                SELECT *
                FROM menu
                WHERE nama_menu LIKE %s
                LIMIT %s OFFSET %s
            """
            cursor.execute(query, (search_param, per_page, offset))
        else:
            # Jika tidak ada parameter search, ambil semua data tanpa kondisi WHERE
            count_query = "SELECT COUNT(*) AS total FROM menu"
            cursor.execute(count_query)
            total_items = cursor.fetchone()['total']

            query = """
                SELECT *
                FROM menu
                LIMIT %s OFFSET %s
            """
            cursor.execute(query, (per_page, offset))

        results = cursor.fetchall()

        cursor.close()
        connection.close()

        total_pages = (total_items + per_page - 1) // per_page  # Hitung total halaman

        return jsonify({
            "message": "OK",
            "datas": results,
            "pagination": {
                "total_items": total_items,
                "total_pages": total_pages,
                "current_page": page,
                "per_page": per_page
            }
        }), 200
    except Exception as e:
        return jsonify({
            "message": "Failed to fetch data",
            "error": str(e)
        }), 500


@menu_endpoints.route('/create', methods=['POST'])
def create():
    """Routes for module create a menu"""
    nama_menu = request.form['nama_menu']
    deskripsi_menu = request.form['desc_menu']
    harga_menu = request.form['harga_menu']
    kategori = request.form['kategori']


    uploaded_file = request.files['img']
    if uploaded_file.filename != '':
        file_path = os.path.join(UPLOAD_FOLDER, uploaded_file.filename)
        uploaded_file.save(file_path)

        connection = get_connection()
        cursor = connection.cursor()
        insert_query = "INSERT INTO menu (nama_menu, desc_menu, harga_menu, kategori, img) VALUES (%s, %s, %s, %s, %s)"
        request_insert = (nama_menu, deskripsi_menu, harga_menu, kategori, uploaded_file.filename)
        cursor.execute(insert_query, request_insert)
        connection.commit()  # Commit changes to the database
        cursor.close()
        new_id = cursor.lastrowid  # Get the newly inserted menu's ID\
        if new_id:
            return jsonify({"title": nama_menu, "message": "Inserted", "id_menu": new_id}), 201
        return jsonify({"message": "Cant Insert Data"}), 500


@menu_endpoints.route('/update/<id_menu>', methods=['POST'])
def update(id_menu):
    """Routes for module update a book"""
    nama_menu = request.form['nama_menu']
    deskripsi_menu = request.form['desc_menu']
    harga_menu = request.form['harga_menu']
    kategori = request.form['kategori']

    uploaded_file = request.files['img']
    if uploaded_file.filename != '':
        file_path = os.path.join(UPLOAD_FOLDER, uploaded_file.filename)
        uploaded_file.save(file_path)

        connection = get_connection()
        cursor = connection.cursor()

        update_query = "UPDATE menu SET nama_menu=%s,desc_menu=%s, harga_menu=%s, kategori=%s, img=%s WHERE id_menu=%s"
        update_request = (nama_menu, deskripsi_menu, harga_menu, kategori, uploaded_file.filename, id_menu)
        cursor.execute(update_query, update_request)
        connection.commit()
        cursor.close()
        data = {"message": "updated", "id_menu": id_menu}
        return jsonify(data), 200


@menu_endpoints.route('/delete/<id_menu>', methods=['DELETE'])
def delete(id_menu):
    connection = get_connection()
    cursor = connection.cursor()
    delete_query = "DELETE FROM menu WHERE id_menu=%s"
    delete_id = (id_menu,)
    cursor.execute(delete_query, delete_id)
    connection.commit()
    cursor.close()
    return jsonify({
        "message": "Deleted"}), 200

