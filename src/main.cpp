#include <std_srvs/srv/trigger.hpp>
#include <memory>
#include <rclcpp/rclcpp.hpp>

void doChecks(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
              std::shared_ptr<std_srvs::srv::Trigger::Response> response) {

  // Prepare response
  response->success = true;
  response->message = "";
  RCLCPP_INFO(rclcpp::get_logger("rclcpp"),
              "Received request to check motors...");

  // Iterate over all motors (e.g. 5) to perform the check
  for (int i = 0; i < 5; i++) {
    RCLCPP_INFO(rclcpp::get_logger("rclcpp"), "Checking motor %i", i);
    // auto res = moveMotorToMinAndMax(i);
    // If something fails, change response `success` to false and add info to
    // the `message`
    // if (!res) {
    //   response->success = false;
    //   response->message += "Motor" + std::to_string(i) + " Failed";
    // }
  }

  RCLCPP_INFO(rclcpp::get_logger("rclcpp"), "Sending back response...");
}

int main(int argc, char** argv) {
  rclcpp::init(argc, argv);

  std::shared_ptr<rclcpp::Node> node = rclcpp::Node::make_shared("control_node");
  rclcpp::Service<std_srvs::srv::Trigger>::SharedPtr service = node->create_service<std_srvs::srv::Trigger>("system_checks", &doChecks);

  RCLCPP_INFO(rclcpp::get_logger("rclcpp"), "Ready to check motors");

  // Spin the node until it's terminated
  rclcpp::spin(node);
  rclcpp::shutdown();
}