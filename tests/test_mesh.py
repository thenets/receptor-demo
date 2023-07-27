import pytest


@pytest.mark.usefixtures("receptor_mesh_simple")
class TestReceptorCtlConnection:
    def test_connect_to_service(self, default_receptor_controller_unix):
        node1_controller = default_receptor_controller_unix
        node1_controller.connect_to_service("node2", "control", "")
        node1_controller.handshake()
        status = node1_controller.simple_command("status")
        node1_controller.close()
        assert status["NodeID"] == "node2"

    def test_simple_command(self, default_receptor_controller_unix):
        node1_controller = default_receptor_controller_unix
        status = node1_controller.simple_command("status")
        node1_controller.close()
        assert not (
            set(
                [
                    "Advertisements",
                    "Connections",
                    "KnownConnectionCosts",
                    "NodeID",
                    "RoutingTable",
                ]
            )
            - status.keys()
        )
