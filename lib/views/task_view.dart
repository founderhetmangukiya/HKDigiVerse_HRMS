import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/app_colors.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  // ===========================================================================
  // CONTROLLERS
  // ===========================================================================

  final TextEditingController _searchController =
  TextEditingController();

  // ===========================================================================
  // PAGE STATE
  // ===========================================================================

  TaskScope _scope = TaskScope.myTasks;

  String _teamFilter = 'All Team Tasks';

  String _priorityFilter = 'All';
  String _categoryFilter = 'All';
  String _departmentFilter = 'All';
  String _personFilter = 'All Members';

  // ===========================================================================
  // DEMO DATA
  // Replace with Controller/API later.
  // ===========================================================================

  final List<TaskModel> _tasks = [
    TaskModel(
      id: 'T-001',
      title: 'Complete client report',
      description:
      'Prepare and submit the final client performance report.',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      dueDate: DateTime(2026, 10, 4),
      assignedTo: 'Parth Devani',
      assignedBy: 'Het Mangukiya',
      department: 'Sales',
      category: 'Client Work',
      recurrence: 'One-time Task',
      completed: false,
      createdAt: DateTime(2026, 10, 1, 10, 2),
      activities: [
        TaskActivity(
          actor: 'Parth Devani',
          action: 'CREATED',
          description: 'Task created',
          dateTime: DateTime(2026, 10, 1, 10, 2),
          type: ActivityType.created,
        ),
        TaskActivity(
          actor: 'Management',
          action: 'STATUS CHANGED',
          description:
          "Status updated from 'None' to 'In Progress'",
          dateTime: DateTime(2026, 10, 1, 10, 56),
          type: ActivityType.status,
        ),
      ],
    ),
    TaskModel(
      id: 'T-002',
      title: 'Prepare team meeting notes',
      description:
      'Prepare notes and discussion points for the weekly team meeting.',
      status: TaskStatus.pending,
      priority: TaskPriority.medium,
      dueDate: DateTime(2026, 10, 5),
      assignedTo: 'Parth Devani',
      assignedBy: 'Het Mangukiya',
      department: 'Sales',
      category: 'Internal',
      recurrence: 'Weekly',
      completed: false,
      createdAt: DateTime(2026, 10, 3, 11, 30),
      activities: [
        TaskActivity(
          actor: 'Het Mangukiya',
          action: 'CREATED',
          description: 'Task created',
          dateTime: DateTime(2026, 10, 3, 11, 30),
          type: ActivityType.created,
        ),
      ],
    ),
    TaskModel(
      id: 'T-003',
      title: 'Update project progress',
      description:
      'Update the current project progress and client status.',
      status: TaskStatus.completed,
      priority: TaskPriority.low,
      dueDate: DateTime(2026, 10, 3),
      assignedTo: 'Prince Gajera',
      assignedBy: 'Parth Devani',
      department: 'Development',
      category: 'Project',
      recurrence: 'One-time Task',
      completed: true,
      createdAt: DateTime(2026, 10, 1, 9, 15),
      activities: [
        TaskActivity(
          actor: 'Parth Devani',
          action: 'CREATED',
          description: 'Task created',
          dateTime: DateTime(2026, 10, 1, 9, 15),
          type: ActivityType.created,
        ),
        TaskActivity(
          actor: 'Prince Gajera',
          action: 'COMPLETED',
          description: 'Task marked as completed',
          dateTime: DateTime(2026, 10, 3, 17, 20),
          type: ActivityType.completed,
        ),
      ],
    ),
    TaskModel(
      id: 'T-004',
      title: 'Create social media creatives',
      description:
      'Design social media creatives for the upcoming campaign.',
      status: TaskStatus.pending,
      priority: TaskPriority.high,
      dueDate: DateTime(2026, 10, 6),
      assignedTo: 'Krisha Shah',
      assignedBy: 'Het Mangukiya',
      department: 'Digital Marketing',
      category: 'Marketing',
      recurrence: 'One-time Task',
      completed: false,
      createdAt: DateTime(2026, 10, 4, 9, 10),
      activities: [
        TaskActivity(
          actor: 'Het Mangukiya',
          action: 'CREATED',
          description: 'Task created',
          dateTime: DateTime(2026, 10, 4, 9, 10),
          type: ActivityType.created,
        ),
      ],
    ),
  ];

  final List<TransferRequest> _transferRequests = [
    TransferRequest(
      id: 'TR-001',
      taskId: 'T-001',
      taskTitle: 'Complete client report',
      fromPerson: 'Parth Devani',
      toPerson: 'Prince Gajera',
      reason: 'Workload balancing and client requirement.',
      status: TransferStatus.pending,
      createdAt: DateTime(2026, 10, 4, 10, 15),
    ),
  ];

  // ===========================================================================
  // FILTERED DATA
  // ===========================================================================

  List<TaskModel> get _visibleTasks {
    final search = _searchController.text.trim().toLowerCase();

    return _tasks.where((task) {
      // My Tasks
      if (_scope == TaskScope.myTasks) {
        if (task.assignedTo != 'Parth Devani') {
          return false;
        }
      }

      // All Tasks
      if (_scope == TaskScope.allTasks) {
        if (_teamFilter == 'Assigned by Me' &&
            task.assignedBy != 'Parth Devani') {
          return false;
        }
      }

      final matchesSearch =
          search.isEmpty ||
              task.title.toLowerCase().contains(search) ||
              task.description.toLowerCase().contains(search) ||
              task.assignedTo.toLowerCase().contains(search) ||
              task.assignedBy.toLowerCase().contains(search);

      final matchesPriority =
          _priorityFilter == 'All' ||
              _priorityText(task.priority) == _priorityFilter;

      final matchesCategory =
          _categoryFilter == 'All' ||
              task.category == _categoryFilter;

      final matchesDepartment =
          _departmentFilter == 'All' ||
              task.department == _departmentFilter;

      final matchesPerson =
          _personFilter == 'All Members' ||
              task.assignedTo == _personFilter;

      return matchesSearch &&
          matchesPriority &&
          matchesCategory &&
          matchesDepartment &&
          matchesPerson;
    }).toList();
  }

  // ===========================================================================
  // KPI
  // ===========================================================================

  int get _totalTasks {
    return _visibleScopeTasks.length;
  }

  int get _todayWork {
    final today = DateTime.now();

    return _visibleScopeTasks.where((task) {
      return task.dueDate.year == today.year &&
          task.dueDate.month == today.month &&
          task.dueDate.day == today.day;
    }).length;
  }

  int get _clientIssues {
    return _visibleScopeTasks
        .where((task) => task.category == 'Client Issue')
        .length;
  }

  int get _upcomingWork {
    final today = DateTime.now();

    return _visibleScopeTasks.where((task) {
      return task.dueDate.isAfter(
        DateTime(today.year, today.month, today.day),
      );
    }).length;
  }

  int get _inReview {
    return _visibleScopeTasks
        .where((task) => task.status == TaskStatus.inReview)
        .length;
  }

  int get _completed {
    return _visibleScopeTasks
        .where((task) => task.status == TaskStatus.completed)
        .length;
  }

  List<TaskModel> get _visibleScopeTasks {
    if (_scope == TaskScope.myTasks) {
      return _tasks
          .where(
            (task) => task.assignedTo == 'Parth Devani',
      )
          .toList();
    }

    if (_teamFilter == 'Assigned by Me') {
      return _tasks
          .where(
            (task) => task.assignedBy == 'Parth Devani',
      )
          .toList();
    }

    return List<TaskModel>.from(_tasks);
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool mobile = width < 650;
        final bool tablet = width >= 650 && width < 1100;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              mobile
                  ? 16
                  : tablet
                  ? 24
                  : 32,
              mobile ? 18 : 28,
              mobile
                  ? 16
                  : tablet
                  ? 24
                  : 32,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  mobile: mobile,
                  tablet: tablet,
                ),

                const SizedBox(height: 20),

                _buildKpis(
                  mobile: mobile,
                  tablet: tablet,
                ),

                const SizedBox(height: 20),

                _buildControls(
                  mobile: mobile,
                  tablet: tablet,
                ),

                const SizedBox(height: 18),

                _buildTaskContent(
                  mobile: mobile,
                  tablet: tablet,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader({
    required bool mobile,
    required bool tablet,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (mobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 14),
              _buildHeaderButtons(compact: true),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildTitle(),
            ),
            const SizedBox(width: 18),
            _buildHeaderButtons(compact: false),
          ],
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 5,
          children: [
            const Text(
              'Task Management',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.08,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: 0.25,
                  ),
                ),
              ),
              child: const Text(
                'REDIS LIVE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Unified all-in-one task hub with approvals, transfers, and real-time synchronization.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButtons({
    required bool compact,
  }) {
    if (compact) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildNewTaskButton(),
          _buildQuickAssignButton(),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 280,
          child: _buildSearchField(),
        ),
        const SizedBox(width: 8),
        _buildRefreshButton(),
        const SizedBox(width: 8),
        _buildQuickAssignButton(),
        const SizedBox(width: 8),
        _buildNewTaskButton(),
      ],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.5,
        ),
        decoration: InputDecoration(
          hintText: 'Search tasks, assignees...',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.5,
            color: AppColors.textLight,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.icon,
          ),
          filled: true,
          fillColor: const Color(0xFFF9FBFA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return _smallIconButton(
      Icons.refresh_rounded,
          () => setState(() {}),
    );
  }

  Widget _buildQuickAssignButton() {
    return OutlinedButton.icon(
      onPressed: _showQuickAssign,
      icon: const Icon(
        Icons.bolt_rounded,
        size: 19,
        color: Color(0xFFFF9800),
      ),
      label: const Text(
        'Quick Assign',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        side: const BorderSide(
          color: AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildNewTaskButton() {
    return ElevatedButton.icon(
      onPressed: _showCreateTask,
      icon: const Icon(
        Icons.add_rounded,
        size: 20,
      ),
      label: const Text(
        'New Task',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _smallIconButton(
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  // ===========================================================================
  // KPI
  // ===========================================================================

  Widget _buildKpis({
    required bool mobile,
    required bool tablet,
  }) {
    final items = [
      _KpiData(
        'TOTAL TASKS',
        _totalTasks,
        Icons.local_fire_department_outlined,
        const Color(0xFF2457D6),
      ),
      _KpiData(
        "TODAY'S WORK",
        _todayWork,
        Icons.calendar_today_outlined,
        const Color(0xFF3298B0),
      ),
      _KpiData(
        'CLIENT ISSUE',
        _clientIssues,
        Icons.error_outline_rounded,
        const Color(0xFFD82F55),
      ),
      _KpiData(
        'UPCOMING WORK',
        _upcomingWork,
        Icons.access_time_rounded,
        const Color(0xFF665BEA),
      ),
      _KpiData(
        'IN REVIEW',
        _inReview,
        Icons.hourglass_empty_rounded,
        const Color(0xFF9A36DD),
      ),
      _KpiData(
        'COMPLETED',
        _completed,
        Icons.check_circle_outline_rounded,
        const Color(0xFF299B77),
      ),
    ];

    if (mobile) {
      return SizedBox(
        height: 105,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) =>
          const SizedBox(width: 10),
          itemBuilder: (_, index) {
            return SizedBox(
              width: 170,
              child: _buildKpiCard(items[index]),
            );
          },
        ),
      );
    }

    if (tablet) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((item) {
          return SizedBox(
            width: 180,
            child: _buildKpiCard(item),
          );
        }).toList(),
      );
    }

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: item == items.last ? 0 : 12,
            ),
            child: _buildKpiCard(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKpiCard(_KpiData item) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.color.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: item.color,
                ),
              ),
              const Spacer(),
              Icon(
                item.icon,
                size: 18,
                color: item.color.withValues(
                  alpha: 0.7,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${item.value}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CONTROLS
  // ===========================================================================

  Widget _buildControls({
    required bool mobile,
    required bool tablet,
  }) {
    return Container(
      padding: EdgeInsets.all(
        mobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          // ---------------------------------------------------------------
          // TOP TABS
          // ---------------------------------------------------------------

          LayoutBuilder(
            builder: (context, constraints) {
              if (mobile) {
                return Column(
                  children: [
                    _buildScopeTabs(),
                    if (_scope == TaskScope.allTasks) ...[
                      const SizedBox(height: 10),
                      _buildTeamTabs(),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  _buildScopeTabs(),
                  const Spacer(),
                  if (_scope == TaskScope.allTasks)
                    _buildTeamTabs(),
                ],
              );
            },
          ),

          const SizedBox(height: 14),

          // ---------------------------------------------------------------
          // FILTERS
          // ---------------------------------------------------------------

          _buildFilters(
            mobile: mobile,
          ),
        ],
      ),
    );
  }

  Widget _buildScopeTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            title: 'My Tasks',
            icon: Icons.person_outline_rounded,
            selected: _scope == TaskScope.myTasks,
            onTap: () {
              setState(() {
                _scope = TaskScope.myTasks;
                _resetFilters();
              });
            },
          ),
          _buildTab(
            title: 'All Tasks',
            icon: Icons.groups_outlined,
            selected: _scope == TaskScope.allTasks,
            onTap: () {
              setState(() {
                _scope = TaskScope.allTasks;
                _resetFilters();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.04,
              ),
              blurRadius: 7,
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamTabs() {
    return Wrap(
      spacing: 4,
      children: [
        _buildTeamTab('All Team Tasks'),
        _buildTeamTab('Assigned by Me'),
        _buildTeamTab('Transfers'),
      ],
    );
  }

  Widget _buildTeamTab(String title) {
    final selected = _teamFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          _teamFilter = title;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: selected
                ? Colors.white
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters({
    required bool mobile,
  }) {
    if (mobile) {
      return Column(
        children: [
          if (_scope == TaskScope.allTasks) ...[
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'DEPT',
                    value: _departmentFilter,
                    items: const [
                      'All',
                      'Sales',
                      'Development',
                      'Digital Marketing',
                      'HR',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _departmentFilter = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    label: 'PERSON',
                    value: _personFilter,
                    items: const [
                      'All Members',
                      'Parth Devani',
                      'Prince Gajera',
                      'Krisha Shah',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _personFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'PRIORITY',
                  value: _priorityFilter,
                  items: const [
                    'All',
                    'High',
                    'Medium',
                    'Low',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _priorityFilter = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: 'CATEGORY',
                  value: _categoryFilter,
                  items: const [
                    'All',
                    'Client Work',
                    'Client Issue',
                    'Internal',
                    'Marketing',
                    'Project',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _categoryFilter = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (_scope == TaskScope.allTasks)
          _buildDropdown(
            label: 'DEPT',
            value: _departmentFilter,
            items: const [
              'All',
              'Sales',
              'Development',
              'Digital Marketing',
              'HR',
            ],
            onChanged: (value) {
              setState(() {
                _departmentFilter = value;
              });
            },
          ),
        if (_scope == TaskScope.allTasks)
          _buildDropdown(
            label: 'PERSON',
            value: _personFilter,
            items: const [
              'All Members',
              'Parth Devani',
              'Prince Gajera',
              'Krisha Shah',
            ],
            onChanged: (value) {
              setState(() {
                _personFilter = value;
              });
            },
          ),
        _buildDropdown(
          label: 'PRIORITY',
          value: _priorityFilter,
          items: const [
            'All',
            'High',
            'Medium',
            'Low',
          ],
          onChanged: (value) {
            setState(() {
              _priorityFilter = value;
            });
          },
        ),
        _buildDropdown(
          label: 'CATEGORY',
          value: _categoryFilter,
          items: const [
            'All',
            'Client Work',
            'Client Issue',
            'Internal',
            'Marketing',
            'Project',
          ],
          onChanged: (value) {
            setState(() {
              _categoryFilter = value;
            });
          },
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _resetFilters();
            });
          },
          child: const Text(
            'Reset Filters',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 155,
      height: 45,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 11,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================================
  // TASK CONTENT
  // ===========================================================================

  Widget _buildTaskContent({
    required bool mobile,
    required bool tablet,
  }) {
    if (_scope == TaskScope.allTasks &&
        _teamFilter == 'Transfers') {
      return _buildTransferRequests(
        mobile: mobile,
      );
    }

    final tasks = _visibleTasks;

    if (mobile) {
      return _buildMobileTaskList(tasks);
    }

    return _buildDesktopTable(tasks);
  }

  // ===========================================================================
  // MOBILE TASK LIST
  // ===========================================================================

  Widget _buildMobileTaskList(
      List<TaskModel> tasks,
      ) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: tasks.map((task) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: _buildMobileTaskCard(task),
        );
      }).toList(),
    );
  }

  Widget _buildMobileTaskCard(
      TaskModel task,
      ) {
    final overdue = _isOverdue(task);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: overdue
            ? const Color(0xFFFFF7F8)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: overdue
              ? const Color(0xFFFFCDD2)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.018,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildPriorityBadge(task.priority),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSmallInfo(
                Icons.person_outline_rounded,
                task.assignedTo,
              ),
              _buildSmallInfo(
                Icons.calendar_today_outlined,
                DateFormat('dd MMM yyyy')
                    .format(task.dueDate),
                danger: overdue,
              ),
              _buildSmallInfo(
                Icons.category_outlined,
                task.category,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildStatusDropdown(
                  task,
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.swap_horiz_rounded,
                'Transfer',
                    () => _showTransferDialog(task),
              ),
              const SizedBox(width: 6),
              _buildActionButton(
                Icons.history_rounded,
                'History',
                    () => _showHistory(task),
              ),
              const SizedBox(width: 6),
              _buildMoreButton(task),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfo(
      IconData icon,
      String text, {
        bool danger = false,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: danger
            ? const Color(0xFFFFEEF0)
            : const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: danger
                ? const Color(0xFFE53935)
                : AppColors.icon,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: danger
                  ? const Color(0xFFE53935)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DESKTOP TABLE
  // ===========================================================================

  Widget _buildDesktopTable(
      List<TaskModel> tasks,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.02,
            ),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 1050,
            ),
            child: Column(
              children: [
                _buildTableHeader(),
                if (tasks.isEmpty)
                  _buildTableEmpty()
                else
                  ...tasks.map(
                        (task) => _buildTableRow(task),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 55,
      color: const Color(0xFFFAFBFC),
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: Row(
        children: [
          _tableHeader(
            'TASK DETAILS',
            width: 260,
          ),
          _tableHeader(
            'STATUS',
            width: 180,
          ),
          _tableHeader(
            'PRIORITY',
            width: 150,
          ),
          _tableHeader(
            'DUE DATE',
            width: 210,
          ),
          _tableHeader(
            'ASSIGNED TO',
            width: 190,
          ),
          _tableHeader(
            'ASSIGNED BY',
            width: 180,
          ),
          _tableHeader(
            'ACTIONS',
            width: 150,
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(
      String title, {
        required double width,
      }) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTableRow(TaskModel task) {
    final overdue = _isOverdue(task);

    return Container(
      constraints: const BoxConstraints(
        minHeight: 82,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: overdue
            ? const Color(0xFFFFF7F8)
            : Colors.white,
        border: const Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 260,
            child: _buildTaskDetails(task),
          ),
          SizedBox(
            width: 180,
            child: _buildStatusDropdown(task),
          ),
          SizedBox(
            width: 150,
            child: _buildPriorityBadge(task.priority),
          ),
          SizedBox(
            width: 210,
            child: _buildDueDate(task),
          ),
          SizedBox(
            width: 190,
            child: _buildPerson(task.assignedTo),
          ),
          SizedBox(
            width: 180,
            child: _buildPerson(task.assignedBy),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                _buildIconAction(
                  Icons.swap_horiz_rounded,
                  'Transfer',
                      () => _showTransferDialog(task),
                ),
                _buildIconAction(
                  Icons.history_rounded,
                  'History',
                      () => _showHistory(task),
                ),
                _buildIconAction(
                  Icons.more_horiz_rounded,
                  'More',
                      () => _showMoreMenu(task),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails(TaskModel task) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPerson(String name) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.08,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            name.isEmpty
                ? '?'
                : name[0].toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDate(TaskModel task) {
    final overdue = _isOverdue(task);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: overdue
            ? const Color(0xFFFFEAF0)
            : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: overdue
              ? const Color(0xFFFFA5BA)
              : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            overdue
                ? Icons.error_outline_rounded
                : Icons.calendar_today_outlined,
            size: 15,
            color: overdue
                ? const Color(0xFFE53935)
                : AppColors.icon,
          ),
          const SizedBox(width: 6),
          Text(
            DateFormat('dd MMM yyyy')
                .format(task.dueDate),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: overdue
                  ? const Color(0xFFE53935)
                  : AppColors.textSecondary,
            ),
          ),
          if (overdue) ...[
            const SizedBox(width: 4),
            const Text(
              '(Overdue)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE53935),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableEmpty() {
    return SizedBox(
      width: 1050,
      height: 300,
      child: _buildEmptyState(),
    );
  }

  // ===========================================================================
  // STATUS
  // ===========================================================================

  Widget _buildStatusDropdown(
      TaskModel task,
      ) {
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<String>(
        initialValue: _statusText(task.status),
        isExpanded: true,
        onChanged: (value) {
          if (value == null) return;

          _changeStatus(
            task,
            value,
          );
        },
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 'Pending',
            child: Text('Pending'),
          ),
          DropdownMenuItem(
            value: 'In Progress',
            child: Text('In Progress'),
          ),
          DropdownMenuItem(
            value: 'In Review',
            child: Text('In Review'),
          ),
          DropdownMenuItem(
            value: 'Completed',
            child: Text('Completed'),
          ),
        ],
      ),
    );
  }

  void _changeStatus(
      TaskModel task,
      String value,
      ) {
    final oldStatus = _statusText(task.status);

    TaskStatus newStatus;

    switch (value) {
      case 'In Progress':
        newStatus = TaskStatus.inProgress;
        break;
      case 'In Review':
        newStatus = TaskStatus.inReview;
        break;
      case 'Completed':
        newStatus = TaskStatus.completed;
        break;
      default:
        newStatus = TaskStatus.pending;
    }

    setState(() {
      task.status = newStatus;
      task.completed =
          newStatus == TaskStatus.completed;

      task.activities.add(
        TaskActivity(
          actor: 'Parth Devani',
          action: 'STATUS CHANGED',
          description:
          "Status updated from '$oldStatus' to '$value'",
          dateTime: DateTime.now(),
          type: ActivityType.status,
        ),
      );
    });
  }

  // ===========================================================================
  // PRIORITY
  // ===========================================================================

  Widget _buildPriorityBadge(
      TaskPriority priority,
      ) {
    final Color color;

    switch (priority) {
      case TaskPriority.high:
        color = const Color(0xFFE53935);
        break;
      case TaskPriority.medium:
        color = const Color(0xFFFF8A00);
        break;
      case TaskPriority.low:
        color = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        _priorityText(priority).toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  Widget _buildIconAction(
      IconData icon,
      String tooltip,
      VoidCallback onTap,
      ) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 19,
          color: AppColors.textSecondary,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 38,
          minHeight: 38,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon,
      String tooltip,
      VoidCallback onTap,
      ) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 38,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreButton(TaskModel task) {
    return PopupMenuButton<String>(
      tooltip: 'More',
      onSelected: (value) {
        if (value == 'history') {
          _showHistory(task);
        } else if (value == 'transfer') {
          _showTransferDialog(task);
        } else if (value == 'delete') {
          _deleteTask(task);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'history',
          child: Text('History'),
        ),
        PopupMenuItem(
          value: 'transfer',
          child: Text('Transfer'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
      child: const Icon(
        Icons.more_horiz_rounded,
        color: AppColors.textSecondary,
      ),
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 44,
            color: AppColors.icon,
          ),
          SizedBox(height: 12),
          Text(
            'No tasks found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Try changing your search or filters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CREATE TASK
  // ===========================================================================

  void _showCreateTask({
    bool saveAndNew = false,
  }) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    TaskPriority priority = TaskPriority.medium;
    DateTime? dueDate;
    String assignedTo = 'Parth Devani';
    String recurrence = 'One-time Task';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return _ResponsiveDialog(
              title: 'Create New Task',
              subtitle: 'Fill in the task details below.',
              icon: Icons.add_task_rounded,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _dialogLabel('TASK TITLE *'),
                  _dialogTextField(
                    controller: titleController,
                    hint: 'e.g. Design Marketing Creatives',
                  ),

                  const SizedBox(height: 18),

                  _dialogLabel('DESCRIPTION'),
                  _dialogTextField(
                    controller: descriptionController,
                    hint: 'Task details and instructions...',
                    maxLines: 4,
                  ),

                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 500) {
                        return Column(
                          children: [
                            _dialogDropdown(
                              label: 'PRIORITY',
                              value:
                              _priorityText(priority),
                              items: const [
                                'Low',
                                'Medium',
                                'High',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  priority =
                                      _priorityFromText(
                                        value,
                                      );
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _dialogDate(
                              label: 'DUE DATE',
                              value: dueDate,
                              onTap: () async {
                                final date =
                                await _pickDate(
                                  context,
                                  dueDate ??
                                      DateTime.now(),
                                );

                                if (date != null) {
                                  setDialogState(() {
                                    dueDate = date;
                                  });
                                }
                              },
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _dialogDropdown(
                              label: 'PRIORITY',
                              value:
                              _priorityText(priority),
                              items: const [
                                'Low',
                                'Medium',
                                'High',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  priority =
                                      _priorityFromText(
                                        value,
                                      );
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dialogDate(
                              label: 'DUE DATE',
                              value: dueDate,
                              onTap: () async {
                                final date =
                                await _pickDate(
                                  context,
                                  dueDate ??
                                      DateTime.now(),
                                );

                                if (date != null) {
                                  setDialogState(() {
                                    dueDate = date;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 500) {
                        return Column(
                          children: [
                            _dialogDropdown(
                              label: 'ASSIGN TO *',
                              value: assignedTo,
                              items: const [
                                'Parth Devani',
                                'Prince Gajera',
                                'Krisha Shah',
                                'Dev Patel',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  assignedTo = value;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _dialogDropdown(
                              label: 'RECURRENCE',
                              value: recurrence,
                              items: const [
                                'One-time Task',
                                'Daily',
                                'Weekly',
                                'Monthly',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  recurrence = value;
                                });
                              },
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _dialogDropdown(
                              label: 'ASSIGN TO *',
                              value: assignedTo,
                              items: const [
                                'Parth Devani',
                                'Prince Gajera',
                                'Krisha Shah',
                                'Dev Patel',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  assignedTo = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dialogDropdown(
                              label: 'RECURRENCE',
                              value: recurrence,
                              items: const [
                                'One-time Task',
                                'Daily',
                                'Weekly',
                                'Monthly',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  recurrence = value;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 26),

                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _dialogOutlinedButton(
                        'Cancel',
                            () => Navigator.pop(
                          dialogContext,
                        ),
                      ),
                      _dialogOutlinedButton(
                        'Save & New',
                            () {
                          final created =
                          _createTaskObject(
                            titleController.text,
                            descriptionController.text,
                            priority,
                            dueDate,
                            assignedTo,
                            recurrence,
                          );

                          if (created == null) {
                            return;
                          }

                          setState(() {
                            _tasks.insert(
                              0,
                              created,
                            );
                          });

                          titleController.clear();
                          descriptionController.clear();

                          setDialogState(() {
                            dueDate = null;
                            priority =
                                TaskPriority.medium;
                            assignedTo =
                            'Parth Devani';
                            recurrence =
                            'One-time Task';
                          });

                          _showMessage(
                            'Task created. Ready for another task.',
                          );
                        },
                        green: true,
                      ),
                      _dialogPrimaryButton(
                        'Create Task',
                            () {
                          final created =
                          _createTaskObject(
                            titleController.text,
                            descriptionController.text,
                            priority,
                            dueDate,
                            assignedTo,
                            recurrence,
                          );

                          if (created == null) {
                            return;
                          }

                          setState(() {
                            _tasks.insert(
                              0,
                              created,
                            );
                          });

                          Navigator.pop(
                            dialogContext,
                          );

                          _showMessage(
                            'Task created successfully.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  TaskModel? _createTaskObject(
      String title,
      String description,
      TaskPriority priority,
      DateTime? dueDate,
      String assignedTo,
      String recurrence,
      ) {
    if (title.trim().isEmpty) {
      _showMessage(
        'Task title is required.',
        error: true,
      );
      return null;
    }

    if (dueDate == null) {
      _showMessage(
        'Please select a due date.',
        error: true,
      );
      return null;
    }

    final task = TaskModel(
      id: 'T-${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      description: description.trim().isEmpty
          ? 'No description provided.'
          : description.trim(),
      status: TaskStatus.pending,
      priority: priority,
      dueDate: dueDate,
      assignedTo: assignedTo,
      assignedBy: 'Parth Devani',
      department: 'Sales',
      category: 'Internal',
      recurrence: recurrence,
      completed: false,
      createdAt: DateTime.now(),
      activities: [
        TaskActivity(
          actor: 'Parth Devani',
          action: 'CREATED',
          description: 'Task created',
          dateTime: DateTime.now(),
          type: ActivityType.created,
        ),
      ],
    );

    return task;
  }

  // ===========================================================================
  // QUICK ASSIGN
  // ===========================================================================

  void _showQuickAssign() {
    final titleController = TextEditingController();
    String person = 'Prince Gajera';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _ResponsiveDialog(
              title: 'Quick Assign',
              subtitle:
              'Assign a task to a team member quickly.',
              icon: Icons.bolt_rounded,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _dialogLabel('TASK'),
                  _dialogTextField(
                    controller: titleController,
                    hint: 'Enter task title...',
                  ),
                  const SizedBox(height: 16),
                  _dialogLabel('ASSIGN TO'),
                  _dialogDropdown(
                    label: 'TEAM MEMBER',
                    value: person,
                    items: const [
                      'Prince Gajera',
                      'Krisha Shah',
                      'Dev Patel',
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        person = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [
                      _dialogOutlinedButton(
                        'Cancel',
                            () => Navigator.pop(
                          dialogContext,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _dialogPrimaryButton(
                        'Assign',
                            () {
                          if (titleController
                              .text
                              .trim()
                              .isEmpty) {
                            _showMessage(
                              'Enter a task title.',
                              error: true,
                            );
                            return;
                          }

                          Navigator.pop(
                            dialogContext,
                          );

                          _showMessage(
                            'Task assigned to $person.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // TRANSFER
  // ===========================================================================

  void _showTransferDialog(
      TaskModel task,
      ) {
    String selectedPerson = 'Prince Gajera';
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _ResponsiveDialog(
              title: 'Transfer Task',
              subtitle: task.title,
              icon: Icons.swap_horiz_rounded,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _dialogLabel(
                    'TRANSFER TO COLLEAGUE *',
                  ),
                  _dialogDropdown(
                    label: 'TEAM MEMBER',
                    value: selectedPerson,
                    items: const [
                      'Prince Gajera',
                      'Krisha Shah',
                      'Dev Patel',
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPerson = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  _dialogLabel(
                    'REASON FOR TRANSFER',
                  ),
                  _dialogTextField(
                    controller: reasonController,
                    hint:
                    'Why is this task being transferred? (e.g. workload balancing, domain expertise)',
                    maxLines: 4,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [
                      _dialogOutlinedButton(
                        'Cancel',
                            () => Navigator.pop(
                          dialogContext,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _dialogPrimaryButton(
                        'Send Request',
                            () {
                          _transferRequests.add(
                            TransferRequest(
                              id:
                              'TR-${DateTime.now().millisecondsSinceEpoch}',
                              taskId: task.id,
                              taskTitle: task.title,
                              fromPerson:
                              'Parth Devani',
                              toPerson:
                              selectedPerson,
                              reason: reasonController
                                  .text
                                  .trim()
                                  .isEmpty
                                  ? 'Task transfer requested.'
                                  : reasonController.text
                                  .trim(),
                              status:
                              TransferStatus.pending,
                              createdAt:
                              DateTime.now(),
                            ),
                          );

                          task.activities.add(
                            TaskActivity(
                              actor: 'Parth Devani',
                              action:
                              'TRANSFER REQUESTED',
                              description:
                              'Transfer requested to $selectedPerson',
                              dateTime:
                              DateTime.now(),
                              type:
                              ActivityType.transfer,
                            ),
                          );

                          Navigator.pop(
                            dialogContext,
                          );

                          _showMessage(
                            'Transfer request sent to $selectedPerson. They must accept before the task is assigned.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // TRANSFER REQUESTS
  // ===========================================================================

  Widget _buildTransferRequests({
    required bool mobile,
  }) {
    if (_transferRequests.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: _transferRequests.map((request) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: _buildTransferCard(
            request,
            mobile,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTransferCard(
      TransferRequest request,
      bool mobile,
      ) {
    final pending =
        request.status == TransferStatus.pending;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: pending
              ? const Color(0xFFFFD180)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment:
            WrapCrossAlignment.center,
            children: [
              const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.primary,
              ),
              Text(
                request.taskTitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              _buildTransferStatus(
                request.status,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            '${request.fromPerson}  →  ${request.toPerson}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            request.reason,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          if (pending) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _dialogOutlinedButton(
                  'Reject',
                      () {
                    setState(() {
                      request.status =
                          TransferStatus.rejected;
                    });
                  },
                ),
                _dialogPrimaryButton(
                  'Accept Transfer',
                      () {
                    _acceptTransfer(request);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransferStatus(
      TransferStatus status,
      ) {
    Color color;

    switch (status) {
      case TransferStatus.pending:
        color = const Color(0xFFFF9800);
        break;
      case TransferStatus.accepted:
        color = AppColors.primary;
        break;
      case TransferStatus.rejected:
        color = const Color(0xFFE53935);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _transferStatusText(status),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  void _acceptTransfer(
      TransferRequest request,
      ) {
    final taskIndex = _tasks.indexWhere(
          (task) => task.id == request.taskId,
    );

    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];

    setState(() {
      request.status = TransferStatus.accepted;

      task.assignedTo = request.toPerson;

      task.activities.add(
        TaskActivity(
          actor: request.toPerson,
          action: 'TRANSFER ACCEPTED',
          description:
          'Task accepted by ${request.toPerson}',
          dateTime: DateTime.now(),
          type: ActivityType.transfer,
        ),
      );
    });

    _showMessage(
      'Transfer accepted. Task is now assigned to ${request.toPerson}.',
    );
  }

  // ===========================================================================
  // HISTORY
  // ===========================================================================

  void _showHistory(
      TaskModel task,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return _ResponsiveDialog(
          title: 'Task History & Activity Trail',
          subtitle: task.title,
          icon: Icons.history_rounded,
          maxWidth: 750,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 18,
                runSpacing: 12,
                children: [
                  _historySummary(
                    'STATUS',
                    _statusText(task.status),
                  ),
                  _historySummary(
                    'ASSIGNED BY',
                    task.assignedBy,
                  ),
                  _historySummary(
                    'ASSIGNED TO',
                    task.assignedTo,
                  ),
                  _historySummary(
                    'RECURRENCE',
                    task.recurrence,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'ACTIVITY AUDIT TRAIL',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 14),

              ...task.activities.reversed.map(
                    (activity) {
                  return _buildActivity(
                    activity,
                  );
                },
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: _dialogPrimaryButton(
                  'Close',
                      () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _historySummary(
      String label,
      String value,
      ) {
    return SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity(
      TaskActivity activity,
      ) {
    Color color;

    switch (activity.type) {
      case ActivityType.created:
        color = const Color(0xFF3478F6);
        break;
      case ActivityType.status:
        color = const Color(0xFFFF9800);
        break;
      case ActivityType.transfer:
        color = AppColors.primary;
        break;
      case ActivityType.completed:
        color = const Color(0xFF299B77);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 55,
                color: color.withValues(
                  alpha: 0.15,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 5,
                    children: [
                      Text(
                        activity.actor,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                          color.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                        child: Text(
                          activity.action,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w800,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat(
                      'dd MMM yyyy, hh:mm a',
                    ).format(activity.dateTime),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9.5,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MORE MENU
  // ===========================================================================

  void _showMoreMenu(
      TaskModel task,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.history_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'View History',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showHistory(task);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.swap_horiz_rounded,
                  ),
                  title: const Text(
                    'Transfer Task',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showTransferDialog(task);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Delete Task',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteTask(task);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteTask(
      TaskModel task,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Task?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${task.title}"?',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.remove(task);
                });

                Navigator.pop(context);

                _showMessage(
                  'Task deleted.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  void _resetFilters() {
    _priorityFilter = 'All';
    _categoryFilter = 'All';
    _departmentFilter = 'All';
    _personFilter = 'All Members';
    _teamFilter = 'All Team Tasks';
  }

  bool _isOverdue(
      TaskModel task,
      ) {
    if (task.completed) {
      return false;
    }

    final today = DateTime.now();

    return task.dueDate.isBefore(
      DateTime(
        today.year,
        today.month,
        today.day,
      ),
    );
  }

  String _priorityText(
      TaskPriority priority,
      ) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  TaskPriority _priorityFromText(
      String value,
      ) {
    switch (value) {
      case 'High':
        return TaskPriority.high;
      case 'Low':
        return TaskPriority.low;
      default:
        return TaskPriority.medium;
    }
  }

  String _statusText(
      TaskStatus status,
      ) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.inReview:
        return 'In Review';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  String _transferStatusText(
      TransferStatus status,
      ) {
    switch (status) {
      case TransferStatus.pending:
        return 'Waiting for Acceptance';
      case TransferStatus.accepted:
        return 'Accepted';
      case TransferStatus.rejected:
        return 'Rejected';
    }
  }

  Future<DateTime?> _pickDate(
      BuildContext context,
      DateTime initial,
      ) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _showMessage(
      String message, {
        bool error = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
          backgroundColor:
          error ? Colors.red : AppColors.navy,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ===========================================================================
  // DIALOG HELPERS
  // ===========================================================================

  Widget _dialogLabel(
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _dialogTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.textLight,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFBFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _dialogDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 9.5,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFBFA),
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  Widget _dialogDate({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.icon,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    value == null
                        ? 'Select due date'
                        : DateFormat(
                      'dd MMM yyyy',
                    ).format(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogOutlinedButton(
      String text,
      VoidCallback onPressed, {
        bool green = false,
      }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        foregroundColor: green
            ? AppColors.primary
            : AppColors.navy,
        side: BorderSide(
          color: green
              ? AppColors.primary.withValues(
            alpha: 0.35,
          )
              : AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _dialogPrimaryButton(
      String text,
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// =============================================================================
// RESPONSIVE DIALOG
// =============================================================================

class _ResponsiveDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final double maxWidth;

  const _ResponsiveDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.maxWidth = 680,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding =
    width < 500 ? 18.0 : 30.0;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: width < 500 ? 12 : 24,
        vertical: 18,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight:
          MediaQuery.sizeOf(context).height - 36,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            22,
            horizontalPadding,
            22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                      AppColors.primary.withValues(
                        alpha: 0.08,
                      ),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.5,
                            color:
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const Divider(
                color: AppColors.border,
              ),

              const SizedBox(height: 20),

              child,
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MODELS
// =============================================================================

enum TaskScope {
  myTasks,
  allTasks,
}

enum TaskStatus {
  pending,
  inProgress,
  inReview,
  completed,
}

enum TaskPriority {
  low,
  medium,
  high,
}

enum ActivityType {
  created,
  status,
  transfer,
  completed,
}

enum TransferStatus {
  pending,
  accepted,
  rejected,
}

class TaskModel {
  final String id;
  final String title;
  final String description;

  TaskStatus status;
  TaskPriority priority;

  DateTime dueDate;

  String assignedTo;
  final String assignedBy;

  final String department;
  final String category;
  final String recurrence;

  bool completed;

  final DateTime createdAt;

  final List<TaskActivity> activities;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.assignedTo,
    required this.assignedBy,
    required this.department,
    required this.category,
    required this.recurrence,
    required this.completed,
    required this.createdAt,
    required this.activities,
  });
}

class TaskActivity {
  final String actor;
  final String action;
  final String description;
  final DateTime dateTime;
  final ActivityType type;

  const TaskActivity({
    required this.actor,
    required this.action,
    required this.description,
    required this.dateTime,
    required this.type,
  });
}

class TransferRequest {
  final String id;
  final String taskId;
  final String taskTitle;
  final String fromPerson;
  final String toPerson;
  final String reason;

  TransferStatus status;

  final DateTime createdAt;

  TransferRequest({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.fromPerson,
    required this.toPerson,
    required this.reason,
    required this.status,
    required this.createdAt,
  });
}

class _KpiData {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _KpiData(
      this.title,
      this.value,
      this.icon,
      this.color,
      );
}