From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 1/8] trace: ras: add ARM processor error information trace event
Date: Thu, 30 Mar 2017 18:31:01 +0800
Message-ID: <1490869877-118713-2-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, gengdongjiu@huawei.com, zhengqiang10@huawei.com, wuquanming@huawei.com, xiexiuqi@huawei.com, wangxiongfeng2@huawei.com, Tyler Baicar <tbaicar@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add a new trace event for ARM processor error information, so that
the user will know what error occurred. With this information the
user may take appropriate action.

These trace events are consistent with the ARM processor error
information table which defined in UEFI 2.6 spec section N.2.4.4.1.

---
v2: add trace enabled condition as Steven's suggestion.
    fix a typo.
---

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tyler Baicar <tbaicar@codeaurora.org>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/acpi/apei/ghes.c | 10 ++++++
 include/linux/cper.h     |  5 +++
 include/ras/ras_event.h  | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 81eabc6..6be0333 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -518,9 +518,19 @@ static void ghes_do_proc(struct ghes *ghes,
 		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
 			 trace_arm_event_enabled()) {
 			struct cper_sec_proc_arm *arm_err;
+			struct cper_arm_err_info *err_info;
+			int i;
 
 			arm_err = acpi_hest_generic_data_payload(gdata);
 			trace_arm_event(arm_err);
+
+			if (trace_arm_proc_err_enabled()) {
+				err_info = (struct cper_arm_err_info *)(arm_err + 1);
+				for (i = 0; i < arm_err->err_info_num; i++) {
+					trace_arm_proc_err(err_info);
+					err_info += 1;
+				}
+			}
 		} else if (trace_unknown_sec_event_enabled()) {
 			void *unknown_err = acpi_hest_generic_data_payload(gdata);
 			trace_unknown_sec_event(&sec_type,
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 85450f3..0cae900 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -270,6 +270,11 @@ enum {
 #define CPER_ARM_INFO_VALID_VIRT_ADDR		0x0008
 #define CPER_ARM_INFO_VALID_PHYSICAL_ADDR	0x0010
 
+#define CPER_ARM_INFO_TYPE_CACHE		0
+#define CPER_ARM_INFO_TYPE_TLB			1
+#define CPER_ARM_INFO_TYPE_BUS			2
+#define CPER_ARM_INFO_TYPE_UARCH		3
+
 #define CPER_ARM_INFO_FLAGS_FIRST		0x0001
 #define CPER_ARM_INFO_FLAGS_LAST		0x0002
 #define CPER_ARM_INFO_FLAGS_PROPAGATED		0x0004
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 13befad..026b094 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -206,6 +206,93 @@
 		  __entry->running_state, __entry->psci_state)
 );
 
+#define ARM_PROC_ERR_TYPE	\
+	EM ( CPER_ARM_INFO_TYPE_CACHE, "cache error" )	\
+	EM ( CPER_ARM_INFO_TYPE_TLB,  "TLB error" )	\
+	EM ( CPER_ARM_INFO_TYPE_BUS, "bus error" )	\
+	EMe ( CPER_ARM_INFO_TYPE_UARCH, "micro-architectural error" )
+
+#define ARM_PROC_ERR_FLAGS	\
+	EM ( CPER_ARM_INFO_FLAGS_FIRST, "First error captured" )	\
+	EM ( CPER_ARM_INFO_FLAGS_LAST,  "Last error captured" )	\
+	EM ( CPER_ARM_INFO_FLAGS_PROPAGATED, "Propagated" )	\
+	EMe ( CPER_ARM_INFO_FLAGS_OVERFLOW, "Overflow" )
+
+/*
+ * First define the enums in MM_ACTION_RESULT to be exported to userspace
+ * via TRACE_DEFINE_ENUM().
+ */
+#undef EM
+#undef EMe
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+ARM_PROC_ERR_TYPE
+ARM_PROC_ERR_FLAGS
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)		{ a, b },
+#define EMe(a, b)	{ a, b }
+
+TRACE_EVENT(arm_proc_err,
+
+	TP_PROTO(const struct cper_arm_err_info *err),
+
+	TP_ARGS(err),
+
+	TP_STRUCT__entry(
+		__field(u8, type)
+		__field(u16, multiple_error)
+		__field(u8, flags)
+		__field(u64, error_info)
+		__field(u64, virt_fault_addr)
+		__field(u64, physical_fault_addr)
+	),
+
+	TP_fast_assign(
+		__entry->type = err->type;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_MULTI_ERR)
+			__entry->multiple_error = err->multiple_error;
+		else
+			__entry->multiple_error = ~0;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_FLAGS)
+			__entry->flags = err->flags;
+		else
+			__entry->flags = ~0;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
+			__entry->error_info = err->error_info;
+		else
+			__entry->error_info = 0ULL;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
+			__entry->virt_fault_addr = err->virt_fault_addr;
+		else
+			__entry->virt_fault_addr = 0ULL;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
+			__entry->physical_fault_addr = err->physical_fault_addr;
+		else
+			__entry->physical_fault_addr = 0ULL;
+	),
+
+	TP_printk("ARM Processor Error: type %s; count: %u; flags: %s;"
+		  " error info: %016llx; virtual address: %016llx;"
+		  " physical address: %016llx",
+		  __print_symbolic(__entry->type, ARCH_PROC_ERR_TYPE),
+		  __entry->multiple_error,
+		  __print_symbolic(__entry->flags, ARCH_PROC_ERR_FLAGS),
+		  __entry->error_info, __entry->virt_fault_addr,
+		  __entry->physical_fault_addr)
+);
+
 /*
  * Unknown Section Report
  *
-- 
1.8.3.1
