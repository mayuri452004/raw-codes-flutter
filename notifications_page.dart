import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationsPage extends StatefulWidget {
  final int userId;

  const NotificationsPage({
    super.key,
    required this.userId,
  });

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final String baseUrl = "http://10.0.2.2:8080";

  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(
          "$baseUrl/api/notifications/user/${widget.userId}",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        "Unable to connect to server",
        Colors.red,
      );
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "$baseUrl/api/notifications/$id",
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        setState(() {
          notifications.removeWhere(
            (notification) =>
                notification["id"] == id,
          );
        });

        showMessage(
          "Notification deleted",
          Colors.green,
        );
      }
    } catch (e) {
      showMessage(
        "Failed to delete notification",
        Colors.red,
      );
    }
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  notifications.clear();
                });
              },
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.red,
              ),
            ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff4F46E5),
              ),
            )
          : notifications.isEmpty
              ? _emptyNotifications()
              : RefreshIndicator(
                  onRefresh: fetchNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          notifications[index];

                      return _notificationCard(
                        notification,
                      );
                    },
                  ),
                ),
    );
  }

  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    final bool isRead =
        notification["read"] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead
            ? Colors.white
            : const Color(0xffEEF2FF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),

        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xffE0E7FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Color(0xff4F46E5),
          ),
        ),

        title: Text(
          notification["title"] ?? "Notification",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            notification["message"] ?? "",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),

        trailing: IconButton(
          onPressed: () {
            deleteNotification(
              notification["id"],
            );
          },
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _emptyNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xffEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 60,
              color: Color(0xff4F46E5),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "No Notifications",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "You're all caught up!",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}