from kroki_wireviz import __version__, api as module_api
from pathlib import Path
import pytest

@pytest.fixture
def api():
    app = module_api.create_app()
    yield app

@pytest.fixture
def client(api):
    return api.test_client()

@pytest.fixture
def input_yaml():
    working_dir = str(Path(__file__).parent.resolve())
    return Path(working_dir + '/input_example1.yaml').read_text()

@pytest.fixture
def output_png():
    working_dir = str(Path(__file__).parent.resolve())
    return Path(working_dir + '/input_example1.png').read_bytes()

@pytest.fixture
def output_svg():
    working_dir = str(Path(__file__).parent.resolve())
    return Path(working_dir + '/input_example1.svg').read_bytes()

class TestE2E:
    def test_png(self, client, input_yaml, output_png):
        response = client.post('/png', data=input_yaml)
        assert response.status_code == 200
        assert len(response.data) > 0
        assert response.data == output_png

    def test_svg(self, client, input_yaml, output_svg):
        response = client.post('/svg', data=input_yaml)
        assert response.status_code == 200
        assert len(response.data) > 0
        assert response.data == output_svg

