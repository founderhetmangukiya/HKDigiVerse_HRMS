import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/app_colors.dart';
import '../models/leave_model.dart';

class LeaveController extends GetxController {
  // =========================================================
  // DATE FORMAT
  // =========================================================

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  // =========================================================
  // LEAVE TYPES
  // =========================================================

  final List<LeaveTypeModel> leaveTypes = [
    const LeaveTypeModel(
      id: 'monthly',
      name: 'Monthly Leave',
      icon: Icons.sunny,
      overallAllowance: 1,
      freeAllowance: 1,
      isPaid: true,
    ),

    const LeaveTypeModel(
      id: 'sick',
      name: 'Sick Leave',
      icon: Icons.thermostat_outlined,
      overallAllowance: 2,
      isPaid: true,
    ),

    const LeaveTypeModel(
      id: 'casual',
      name: 'Casual Leave',
      icon: Icons.business_center_outlined,
      overallAllowance: 4,
      isPaid: true,
    ),

    const LeaveTypeModel(
      id: 'unpaid',
      name: 'Unpaid Leave',
      icon: Icons.schedule_outlined,
      overallAllowance: 0,
      isPaid: false,
    ),

    const LeaveTypeModel(
      id: 'other',
      name: 'Other Leave',
      icon: Icons.calendar_month_outlined,
      overallAllowance: 0,
      isPaid: false,
    ),
  ];

  // =========================================================
  // SUMMARY
  // =========================================================

  final RxList<LeaveSummaryModel> summaries =
      <LeaveSummaryModel>[].obs;

  // =========================================================
  // REQUESTS
  // =========================================================

  final RxList<LeaveRequestModel> allRequests =
      <LeaveRequestModel>[].obs;

  final RxList<LeaveRequestModel> filteredRequests =
      <LeaveRequestModel>[].obs;

  // =========================================================
  // FILTERS
  // =========================================================

  final RxString selectedLeaveFilter = 'All Leave Types'.obs;

  final RxString selectedStatusFilter = 'Pending'.obs;

  final Rx<DateTime?> filterStartDate = Rx<DateTime?>(null);

  final Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);

  // =========================================================
  // REQUEST FORM
  // =========================================================

  final RxString selectedRequestLeaveType =
      'Monthly Leave'.obs;

  final Rx<DateTime> requestStartDate =
      DateTime.now().obs;

  final Rx<DateTime> requestEndDate =
      DateTime.now().obs;

  final Rx<LeaveDayType> selectedDayType =
      LeaveDayType.fullDay.obs;

  final TextEditingController reasonController =
  TextEditingController();

  final RxString proofFileName = ''.obs;

  // =========================================================
  // LOADING
  // =========================================================

  final RxBool isLoading = false.obs;

  final RxBool isSubmitting = false.obs;

  // =========================================================
  // MONTH
  // =========================================================

  String get currentMonth {
    return DateFormat('MMMM').format(DateTime.now());
  }

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    loadLeaveData();
  }

  // =========================================================
  // LOAD DATA
  // =========================================================

  Future<void> loadLeaveData() async {
    isLoading.value = true;

    try {
      // =====================================================
      // FUTURE API
      // =====================================================
      //
      // final response = await api.getLeaveDashboard();
      //
      // summaries.assignAll(
      //   response.summaries,
      // );
      //
      // allRequests.assignAll(
      //   response.requests,
      // );
      //
      // =====================================================

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      _loadDemoData();

      applyFilters();
    } catch (e) {
      showError(
        'Unable to Load',
        'Unable to load leave data.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // DEMO DATA
  // =========================================================

  void _loadDemoData() {
    summaries.assignAll([
      LeaveSummaryModel(
        leaveTypeId: 'monthly',
        leaveType: 'Monthly Leave',
        icon: Icons.sunny,
        daysTaken: 0,
        pendingDays: 0,
        overallAllowance: 1,
        freeAllowance: 1,
        unpaidDays: 0,
      ),

      LeaveSummaryModel(
        leaveTypeId: 'sick',
        leaveType: 'Sick Leave',
        icon: Icons.thermostat_outlined,
        daysTaken: 0,
        pendingDays: 0,
        overallAllowance: 2,
      ),

      LeaveSummaryModel(
        leaveTypeId: 'casual',
        leaveType: 'Casual Leave',
        icon: Icons.business_center_outlined,
        daysTaken: 0,
        pendingDays: 0,
        overallAllowance: 4,
      ),

      LeaveSummaryModel(
        leaveTypeId: 'unpaid',
        leaveType: 'Unpaid Leave',
        icon: Icons.schedule_outlined,
        daysTaken: 0,
        pendingDays: 0,
        overallAllowance: 0,
      ),

      LeaveSummaryModel(
        leaveTypeId: 'other',
        leaveType: 'Other Leave',
        icon: Icons.calendar_month_outlined,
        daysTaken: 0,
        pendingDays: 0,
        overallAllowance: 0,
      ),
    ]);

    final now = DateTime.now();

    allRequests.assignAll([
      LeaveRequestModel(
        id: 'LR001',
        leaveTypeId: 'sick',
        leaveType: 'Sick Leave',
        dayType: LeaveDayType.fullDay,
        startDate: DateTime(now.year, 10, 3),
        endDate: DateTime(now.year, 10, 3),
        numberOfDays: 1,
        reason: 'Health is not well',
        status: LeaveStatus.approved,
        approvedByName: 'Het R. Mangukiya',
        approvedByRole: 'Admin',
        createdAt: DateTime(now.year, 10, 2),
      ),

      LeaveRequestModel(
        id: 'LR002',
        leaveTypeId: 'casual',
        leaveType: 'Casual Leave',
        dayType: LeaveDayType.secondHalf,
        startDate: DateTime(now.year, 9, 9),
        endDate: DateTime(now.year, 9, 9),
        numberOfDays: 0.5,
        reason: 'Personal work',
        status: LeaveStatus.approved,
        approvedByName: 'Tanvi Nareshbhai Rakholiya',
        approvedByRole: 'Employee',
        createdAt: DateTime(now.year, 9, 8),
      ),

      LeaveRequestModel(
        id: 'LR003',
        leaveTypeId: 'casual',
        leaveType: 'Casual Leave',
        dayType: LeaveDayType.fullDay,
        startDate: DateTime(now.year, 8, 8),
        endDate: DateTime(now.year, 8, 8),
        numberOfDays: 1,
        reason: 'Personal work',
        status: LeaveStatus.approved,
        approvedByName: 'Tanvi Nareshbhai Rakholiya',
        approvedByRole: 'Employee',
        createdAt: DateTime(now.year, 8, 7),
      ),

      LeaveRequestModel(
        id: 'LR004',
        leaveTypeId: 'monthly',
        leaveType: 'Monthly Leave',
        dayType: LeaveDayType.fullDay,
        startDate: DateTime(now.year, 7, 7),
        endDate: DateTime(now.year, 7, 7),
        numberOfDays: 1,
        reason: 'Family work',
        status: LeaveStatus.approved,
        approvedByName: 'Tanvi Nareshbhai Rakholiya',
        approvedByRole: 'Employee',
        createdAt: DateTime(now.year, 7, 6),
      ),

      LeaveRequestModel(
        id: 'LR005',
        leaveTypeId: 'monthly',
        leaveType: 'Monthly Leave',
        dayType: LeaveDayType.fullDay,
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day),
        numberOfDays: 1,
        reason: 'Personal reason',
        status: LeaveStatus.pending,
        approvedByName: 'Pending',
        approvedByRole: '',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  // =========================================================
  // FILTER
  // =========================================================

  void applyFilters() {
    Iterable<LeaveRequestModel> result =
        allRequests;

    if (selectedLeaveFilter.value !=
        'All Leave Types') {
      result = result.where(
            (request) =>
        request.leaveType ==
            selectedLeaveFilter.value,
      );
    }

    if (selectedStatusFilter.value !=
        'All Status') {
      final status =
      _statusFromString(selectedStatusFilter.value);

      result = result.where(
            (request) => request.status == status,
      );
    }

    if (filterStartDate.value != null) {
      result = result.where(
            (request) =>
        !request.startDate.isBefore(
          filterStartDate.value!,
        ),
      );
    }

    if (filterEndDate.value != null) {
      result = result.where(
            (request) =>
        !request.endDate.isAfter(
          filterEndDate.value!,
        ),
      );
    }

    filteredRequests.assignAll(result);
  }

  void resetFilters() {
    selectedLeaveFilter.value =
    'All Leave Types';

    selectedStatusFilter.value =
    'Pending';

    filterStartDate.value = null;

    filterEndDate.value = null;

    applyFilters();
  }

  LeaveStatus _statusFromString(String value) {
    switch (value) {
      case 'Approved':
        return LeaveStatus.approved;

      case 'Rejected':
        return LeaveStatus.rejected;

      default:
        return LeaveStatus.pending;
    }
  }

  // =========================================================
  // REQUEST LEAVE
  // =========================================================

  void openRequestLeave() {
    resetRequestForm();

    Get.dialog(
      _requestLeaveDialog(),
      barrierDismissible: false,
    );
  }

  // =========================================================
  // REQUEST FORM RESET
  // =========================================================

  void resetRequestForm() {
    selectedRequestLeaveType.value =
    'Monthly Leave';

    requestStartDate.value =
        DateTime.now();

    requestEndDate.value =
        DateTime.now();

    selectedDayType.value =
        LeaveDayType.fullDay;

    reasonController.clear();

    proofFileName.value = '';
  }

  // =========================================================
  // REQUEST LEAVE TYPE
  // =========================================================

  LeaveTypeModel get selectedLeaveType {
    return leaveTypes.firstWhere(
          (item) =>
      item.name ==
          selectedRequestLeaveType.value,
      orElse: () => leaveTypes.first,
    );
  }

  // =========================================================
  // REQUESTED DAYS
  // =========================================================

  double get requestedDays {
    final difference =
        requestEndDate.value
            .difference(requestStartDate.value)
            .inDays +
            1;

    if (selectedDayType.value ==
        LeaveDayType.firstHalf ||
        selectedDayType.value ==
            LeaveDayType.secondHalf) {
      return difference * 0.5;
    }

    return difference.toDouble();
  }

  // =========================================================
  // REMAINING ALLOWANCE
  // =========================================================

  double get remainingAllowance {
    final summary = summaries.firstWhere(
          (item) =>
      item.leaveTypeId ==
          selectedLeaveType.id,
      orElse: () => LeaveSummaryModel(
        leaveTypeId: selectedLeaveType.id,
        leaveType: selectedLeaveType.name,
        icon: selectedLeaveType.icon,
        overallAllowance:
        selectedLeaveType.overallAllowance,
        freeAllowance:
        selectedLeaveType.freeAllowance,
      ),
    );

    return summary.remainingDays;
  }

  // =========================================================
  // DATE PICKER - REQUEST
  // =========================================================

  Future<void> selectRequestStartDate(
      BuildContext context,
      ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: requestStartDate.value,
      firstDate: DateTime(
        DateTime.now().year - 1,
      ),
      lastDate: DateTime(
        DateTime.now().year + 2,
      ),
    );

    if (picked == null) return;

    requestStartDate.value = picked;

    if (requestEndDate.value.isBefore(picked)) {
      requestEndDate.value = picked;
    }
  }

  Future<void> selectRequestEndDate(
      BuildContext context,
      ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: requestEndDate.value,
      firstDate: requestStartDate.value,
      lastDate: DateTime(
        DateTime.now().year + 2,
      ),
    );

    if (picked == null) return;

    requestEndDate.value = picked;
  }

  // =========================================================
  // FILTER DATE PICKER
  // =========================================================

  Future<void> selectFilterStartDate(
      BuildContext context,
      ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
      filterStartDate.value ??
          DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year - 2,
      ),
      lastDate: DateTime(
        DateTime.now().year + 2,
      ),
    );

    if (picked == null) return;

    filterStartDate.value = picked;
  }

  Future<void> selectFilterEndDate(
      BuildContext context,
      ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
      filterEndDate.value ??
          DateTime.now(),
      firstDate:
      filterStartDate.value ??
          DateTime(
            DateTime.now().year - 2,
          ),
      lastDate: DateTime(
        DateTime.now().year + 2,
      ),
    );

    if (picked == null) return;

    filterEndDate.value = picked;
  }

  // =========================================================
  // PROOF UPLOAD
  // =========================================================

  void selectProofFile() {
    // =====================================================
    // FUTURE FILE PICKER / API
    // =====================================================
    //
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: [
    //     'png',
    //     'jpg',
    //     'jpeg',
    //     'webp',
    //     'pdf',
    //   ],
    // );
    //
    // proofFileName.value =
    //     result.files.single.name;
    //
    // =====================================================

    proofFileName.value =
    'leave_proof.jpg';

    showSuccess(
      'Proof Selected',
      'Leave proof selected successfully.',
    );
  }

  // =========================================================
  // SUBMIT REQUEST
  // =========================================================

  Future<void> submitLeaveRequest() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final reason =
    reasonController.text.trim();

    if (reason.isEmpty) {
      showError(
        'Reason Required',
        'Please enter a reason for your leave.',
      );
      return;
    }

    if (requestEndDate.value
        .isBefore(requestStartDate.value)) {
      showError(
        'Invalid Date',
        'End date cannot be before start date.',
      );
      return;
    }

    if (requestedDays <= 0) {
      showError(
        'Invalid Leave',
        'Please select a valid leave duration.',
      );
      return;
    }

    // -------------------------------------------------------
    // ALLOWANCE CONDITION
    // -------------------------------------------------------

    if (selectedLeaveType.isPaid &&
        selectedLeaveType.id != 'unpaid' &&
        requestedDays > remainingAllowance) {
      showError(
        'Leave Limit Exceeded',
        'Only ${_formatDays(remainingAllowance)} day(s) are remaining.',
      );
      return;
    }

    if (isSubmitting.value) return;

    isSubmitting.value = true;

    try {
      // =====================================================
      // FUTURE API CALL
      // =====================================================
      //
      // final response =
      //     await leaveApi.createLeaveRequest(
      //   leaveTypeId: selectedLeaveType.id,
      //   startDate: requestStartDate.value,
      //   endDate: requestEndDate.value,
      //   dayType: selectedDayType.value,
      //   reason: reason,
      //   proof: proofFile,
      // );
      //
      // if (!response.success) {
      //   throw Exception(response.message);
      // }
      //
      // =====================================================

      await Future.delayed(
        const Duration(seconds: 1),
      );

      final newRequest =
      LeaveRequestModel(
        id: 'LR${DateTime.now().millisecondsSinceEpoch}',
        leaveTypeId: selectedLeaveType.id,
        leaveType: selectedLeaveType.name,
        dayType: selectedDayType.value,
        startDate: requestStartDate.value,
        endDate: requestEndDate.value,
        numberOfDays: requestedDays,
        reason: reason,
        proofFileName:
        proofFileName.value.isEmpty
            ? null
            : proofFileName.value,
        status: LeaveStatus.pending,
        approvedByName: 'Pending',
        approvedByRole: '',
        createdAt: DateTime.now(),
      );

      allRequests.insert(
        0,
        newRequest,
      );

      // Add pending days to summary.
      final summaryIndex =
      summaries.indexWhere(
            (item) =>
        item.leaveTypeId ==
            selectedLeaveType.id,
      );

      if (summaryIndex != -1) {
        summaries[summaryIndex].pendingDays +=
            requestedDays;

        summaries.refresh();
      }

      applyFilters();

      Get.back();

      showSuccess(
        'Leave Requested',
        'Your leave request has been submitted successfully.',
      );
    } catch (e) {
      showError(
        'Request Failed',
        'Unable to submit leave request.',
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // =========================================================
  // VIEW REQUEST
  // =========================================================

  void viewLeaveRequest(
      LeaveRequestModel request,
      ) {
    Get.dialog(
      _viewLeaveDialog(request),
      barrierDismissible: true,
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  String formatDayType(
      LeaveDayType type,
      ) {
    switch (type) {
      case LeaveDayType.firstHalf:
        return 'First Half';

      case LeaveDayType.secondHalf:
        return 'Second Half';

      case LeaveDayType.fullDay:
        return 'Full Day';
    }
  }

  String formatStatus(
      LeaveStatus status,
      ) {
    switch (status) {
      case LeaveStatus.approved:
        return 'Approved';

      case LeaveStatus.rejected:
        return 'Rejected';

      case LeaveStatus.pending:
        return 'Pending';
    }
  }

  String _formatDays(double days) {
    if (days == days.roundToDouble()) {
      return days.toInt().toString();
    }

    return days.toStringAsFixed(1);
  }

  // =========================================================
  // REQUEST DIALOG
  // =========================================================

  Widget _requestLeaveDialog() {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650,
          maxHeight: 850,
        ),
        child: Obx(
              () => Column(
            children: [
              _dialogHeader(
                title: 'Request Leave',
                onClose: () => Get.back(),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    8,
                    30,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      _dialogLabel('Leave Type'),

                      _dropdownField(
                        value:
                        selectedRequestLeaveType.value,
                        items: leaveTypes
                            .map(
                              (item) => item.name,
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedRequestLeaveType
                                .value = value;
                          }
                        },
                      ),

                      const SizedBox(height: 8),

                      _allowanceInfo(),

                      const SizedBox(height: 22),

                      _dialogLabel('Start Date'),

                      _dateField(
                        value: formatDate(
                          requestStartDate.value,
                        ),
                        onTap: () =>
                            selectRequestStartDate(
                              Get.context!,
                            ),
                      ),

                      const SizedBox(height: 20),

                      _dialogLabel('End Date'),

                      _dateField(
                        value: formatDate(
                          requestEndDate.value,
                        ),
                        onTap: () =>
                            selectRequestEndDate(
                              Get.context!,
                            ),
                      ),

                      const SizedBox(height: 20),

                      _dialogLabel('Day Type'),

                      _dropdownField(
                        value:
                        formatDayType(
                          selectedDayType.value,
                        ),
                        items: const [
                          'Full Day',
                          'First Half',
                          'Second Half',
                        ],
                        onChanged: (value) {
                          if (value == 'First Half') {
                            selectedDayType.value =
                                LeaveDayType.firstHalf;
                          } else if (value ==
                              'Second Half') {
                            selectedDayType.value =
                                LeaveDayType.secondHalf;
                          } else {
                            selectedDayType.value =
                                LeaveDayType.fullDay;
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      _dialogLabel('Reason'),

                      TextField(
                        controller: reasonController,
                        minLines: 4,
                        maxLines: 5,
                        textInputAction:
                        TextInputAction.newline,
                        decoration:
                        _inputDecoration(
                          hint:
                          'Enter reason for leave',
                        ),
                      ),

                      const SizedBox(height: 20),

                      _dialogLabel(
                        'Proof of Leave (Optional)',
                      ),

                      const SizedBox(height: 8),

                      _proofUpload(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              _dialogFooter(
                cancelText: 'Cancel',
                submitText: 'Submit Request',
                isLoading:
                isSubmitting.value,
                onCancel: () => Get.back(),
                onSubmit: submitLeaveRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // VIEW DIALOG
  // =========================================================

  Widget _viewLeaveDialog(
      LeaveRequestModel request,
      ) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650,
          maxHeight: 800,
        ),
        child: Column(
          children: [
            _dialogHeader(
              title: 'View Leave Request',
              onClose: () => Get.back(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  30,
                  8,
                  30,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _dialogLabel('Leave Type'),

                    _disabledField(
                      request.leaveType,
                    ),

                    const SizedBox(height: 20),

                    _dialogLabel('Start Date'),

                    _disabledField(
                      formatDate(
                        request.startDate,
                      ),
                      showCalendar: true,
                    ),

                    const SizedBox(height: 20),

                    _dialogLabel('End Date'),

                    _disabledField(
                      formatDate(
                        request.endDate,
                      ),
                      showCalendar: true,
                    ),

                    const SizedBox(height: 20),

                    _dialogLabel('Day Type'),

                    _disabledField(
                      formatDayType(
                        request.dayType,
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'EMPLOYEE REASON',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      request.reason,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _statusBox(request),

                    if (request.proofFileName != null) ...[
                      const SizedBox(height: 20),
                      _proofPreview(
                        request.proofFileName!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                30,
                12,
                30,
                20,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    minimumSize:
                    const Size(85, 48),
                    foregroundColor: AppColors.navy,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DIALOG HEADER
  // =========================================================

  Widget _dialogHeader({
    required String title,
    required VoidCallback onClose,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        22,
        18,
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DIALOG LABEL
  // =========================================================

  Widget _dialogLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  // =========================================================
  // DROPDOWN
  // =========================================================

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.icon,
      ),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        color: AppColors.navy,
      ),
      decoration: _inputDecoration(),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ),
      )
          .toList(),
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================

  InputDecoration _inputDecoration({
    String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.textLight,
      ),
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
      ),
    );
  }

  // =========================================================
  // DATE FIELD
  // =========================================================

  Widget _dateField({
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: _inputDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: AppColors.navy,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_month_outlined,
              size: 20,
              color: AppColors.icon,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ALLOWANCE INFO
  // =========================================================

  Widget _allowanceInfo() {
    final type = selectedLeaveType;

    if (type.id == 'monthly') {
      return Text(
        'Free Leave Allowance: ${_formatDays(type.freeAllowance)} Free Day(s) per Month '
            '(Remaining: ${_formatDays(remainingAllowance)} Day(s))',
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppColors.textLight,
        ),
      );
    }

    return Text(
      'Remaining Leave: ${_formatDays(remainingAllowance)} Day(s)',
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        color: AppColors.textLight,
      ),
    );
  }

  // =========================================================
  // PROOF UPLOAD
  // =========================================================

  Widget _proofUpload() {
    return Obx(
          () => InkWell(
        onTap: selectProofFile,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFCFE),
            borderRadius:
            BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.border,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                size: 34,
                color: AppColors.icon,
              ),

              const SizedBox(height: 8),

              Text(
                proofFileName.value.isEmpty
                    ? 'Click to upload leave proof image'
                    : proofFileName.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 3),

              const Text(
                'PNG, JPG, JPEG, WEBP up to 5MB',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PROOF PREVIEW
  // =========================================================

  Widget _proofPreview(String fileName) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.image_outlined,
            color: AppColors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DISABLED FIELD
  // =========================================================

  Widget _disabledField(
      String value, {
        bool showCalendar = false,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: AppColors.textLight,
              ),
            ),
          ),
          if (showCalendar)
            const Icon(
              Icons.calendar_month_outlined,
              size: 20,
              color: AppColors.icon,
            ),
        ],
      ),
    );
  }

  // =========================================================
  // STATUS BOX
  // =========================================================

  Widget _statusBox(
      LeaveRequestModel request,
      ) {
    if (request.status ==
        LeaveStatus.approved) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF5),
          borderRadius:
          BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFB8F1D7),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.primary,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Approved',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF007A58),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Approved by ${request.approvedByName}.',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF007A58),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (request.status ==
        LeaveStatus.rejected) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: const Text(
          'Request Rejected',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            color: Colors.orange,
          ),
          SizedBox(width: 10),
          Text(
            'Request Pending',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DIALOG FOOTER
  // =========================================================

  Widget _dialogFooter({
    required String cancelText,
    required String submitText,
    required bool isLoading,
    required VoidCallback onCancel,
    required VoidCallback onSubmit,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        30,
        12,
        30,
        20,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFF0F2F5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: isLoading
                ? null
                : onCancel,
            style: OutlinedButton.styleFrom(
              minimumSize:
              const Size(95, 48),
              foregroundColor:
              AppColors.navy,
              side: const BorderSide(
                color: AppColors.border,
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),
            child: Text(
              cancelText,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed:
              isLoading ? null : onSubmit,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.primary,
                foregroundColor:
                Colors.white,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 22,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                submitText,
                style:
                const TextStyle(
                  fontFamily:
                  'Poppins',
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUCCESS TOASTER
  // =========================================================

  void showSuccess(
      String title,
      String message,
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration:
      const Duration(seconds: 3),
      backgroundColor:
      AppColors.navy,
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.white,
      ),
      borderRadius: 14,
    );
  }

  // =========================================================
  // ERROR TOASTER
  // =========================================================

  void showError(
      String title,
      String message,
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration:
      const Duration(seconds: 3),
      backgroundColor:
      Colors.red.shade700,
      colorText: Colors.white,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      borderRadius: 14,
    );
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}