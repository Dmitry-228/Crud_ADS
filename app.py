from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2.sql import SQL, Literal
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.json.ensure_ascii = False

connection = psycopg2.connect(
    host=os.getenv('POSTGRES_HOST') if os.getenv('DEBUG_MODE') == 'false' else 'localhost',
    port=os.getenv('POSTGRES_PORT'),
    database=os.getenv('POSTGRES_DB'),
    user=os.getenv('POSTGRES_USER'),
    password=os.getenv('POSTGRES_PASSWORD'),
    cursor_factory=RealDictCursor
)
connection.autocommit = True


@app.get("/advertisements")
def get_advertisements():
    query = """
        SELECT ads.id, ads.name, ads.description, ads.publish_date, 
               json_agg(json_build_object('id', sites.id, 'name', sites.name, 'url', sites.url, 'rating', sites.rating)) AS platforms
        FROM advertisements_data.ads ads
        LEFT JOIN advertisements_data.ads_to_sites ats ON ads.id = ats.ad_id
        LEFT JOIN advertisements_data.sites sites ON ats.sites_id = sites.id
        GROUP BY ads.id;
    """
    with connection.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchall()

    return jsonify(result)


@app.post('/advertisements/create')
def create_advertisement():
    body = request.json

    name = body['name']
    description = body['description']
    publish_date = body['publish_date']
    author_id = body['author_id']
    sites_ids = body['sites_ids']

    query = SQL("""
        INSERT INTO advertisements_data.ads(name, description, publish_date, author_id)
        VALUES ({name}, {description}, {publish_date}, {author_id})
        RETURNING id;
    """).format(name=Literal(name), description=Literal(description), publish_date=Literal(publish_date), author_id=Literal(author_id))

    with connection.cursor() as cursor:
        cursor.execute(query)
        advertisement_id = cursor.fetchone()['id']

        for site_id in sites_ids:
            cursor.execute("""
                INSERT INTO advertisements_data.ads_to_sites(ad_id, sites_id)
                VALUES (%s, %s);
            """, (advertisement_id, site_id))

    return jsonify({'id': advertisement_id})


@app.put('/advertisements/update/<uuid:advertisement_id>')
def update_advertisement(advertisement_id):
    body = request.json

    name = body['name']
    description = body['description']

    query = SQL("""
        UPDATE advertisements_data.ads
        SET name = {name}, description = {description}
        WHERE id = {advertisement_id}
        RETURNING id;
    """).format(name=Literal(name), description=Literal(description), advertisement_id=Literal(advertisement_id))

    with connection.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchall()

    if len(result) == 0:
        return '', 404

    return '', 204


@app.delete('/advertisements/delete/<uuid:advertisement_id>')
def delete_advertisement(advertisement_id):
    with connection.cursor() as cursor:
        cursor.execute("""
            DELETE FROM advertisements_data.ads_to_sites
            WHERE ad_id = %s;
        """, (advertisement_id,))
        cursor.execute("""
            DELETE FROM advertisements_data.ads
            WHERE id = %s;
        """, (advertisement_id,))
        result = cursor.rowcount

    if result == 0:
        return '', 404

    return '', 204


if __name__ == '__main__':
    app.run(port=os.getenv('FLASK_PORT'))
