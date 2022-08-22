import os

from flask import Flask, request
from flask.wrappers import Response
from flask_restful import Resource, Api
from wireviz.wireviz import parse

def create_app():
    app = Flask(__name__)
    api.init_app(app)
    return app

api = Api()

class Graph(Resource):
    def post(self, filetype="svg"):
        types = {"svg": "image/svg+xml", "png": "image/png"}
        if filetype in types:
            config = request.get_data(cache=False, as_text=True, parse_form_data=False)
            graph = parse(yaml_input=config, return_types=filetype)
            return Response(graph, mimetype=types[filetype])

# api.add_resource(Graph, '/')
api.add_resource(Graph, "/", "/<string:filetype>")

def serve():
    env_debug = bool(os.environ.get('DEBUG'))
    app = create_app()
    return app.run(debug=env_debug, port=8010)

if __name__ == "__main__":
    serve()
