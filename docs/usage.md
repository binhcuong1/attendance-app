attendance_app/
│
├── lib/
│   ├── main.dart
│   ├── app.dart                     # Khởi tạo MaterialApp, routes
│   │
│   ├── core/                        # Lõi hệ thống
│   │   ├── api/                     # API client, interceptor
│   │   │   └── api_client.dart
│   │   ├── config/                  # Cấu hình, constants
│   │   │   ├── app_env.dart
│   │   │   └── app_routes.dart
│   │   ├── utils/                   # Hàm tiện ích (format, datetime)
│   │   │   └── date_utils.dart
│   │   └── widgets/                 # Widget dùng chung (button, dialog)
│   │       └── custom_button.dart
│   │
│   ├── data/                        # Dữ liệu, model, services
│   │   ├── models/                  # Lớp dữ liệu (User, Ca, Lịch, Công,…)
│   │   │   ├── user_model.dart
│   │   │   ├── shift_model.dart
│   │   │   ├── schedule_model.dart
│   │   │   ├── attendance_event.dart
│   │   │   └── timesheet_model.dart
│   │   ├── services/                # Gọi API đến backend
│   │   │   ├── auth_service.dart
│   │   │   ├── attendance_service.dart
│   │   │   ├── schedule_service.dart
│   │   │   ├── payroll_service.dart
│   │   │   └── report_service.dart
│   │   └── storage/                 # Lưu dữ liệu cục bộ (token, user info)
│   │       └── local_storage.dart
│   │
│   ├── features/                    # Mỗi module tính năng riêng
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   └── profile_page.dart
│   │   ├── home/
│   │   │   ├── home_page.dart       # Màn chính, nút "Chấm công"
│   │   │   └── clock_widget.dart
│   │   ├── attendance/
│   │   │   ├── attendance_history_page.dart
│   │   │   └── attendance_detail_page.dart
│   │   ├── schedule/
│   │   │   ├── schedule_list_page.dart
│   │   │   └── schedule_form_page.dart
│   │   ├── payroll/
│   │   │   ├── payroll_summary_page.dart
│   │   │   └── payroll_detail_page.dart
│   │   └── report/
│   │       ├── report_page.dart
│   │       └── report_filter_widget.dart
│   │
│   ├── providers/                   # State management (Riverpod / Provider)
│   │   ├── auth_provider.dart
│   │   ├── attendance_provider.dart
│   │   ├── schedule_provider.dart
│   │   ├── payroll_provider.dart
│   │   └── report_provider.dart
│   │
│   └── theme/                       # Màu sắc, text style
│       ├── app_colors.dart
│       └── app_text.dart
│
├── assets/
│   ├── icons/
│   ├── images/
│   └── fonts/
│
├── .env                             # BASE_URL, API_KEY
├── pubspec.yaml
└── README.md
