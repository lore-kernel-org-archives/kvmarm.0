From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/14] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date: Fri, 26 Jan 2018 14:28:47 +0000
Message-ID: <20180126142847.31240-15-marc.zyngier@arm.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180126142847.31240-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add the detection and runtime code for ARM_SMCCC_ARCH_WORKAROUND_1.
It is lovely. Really.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/bpi.S        | 20 ++++++++++++
 arch/arm64/kernel/cpu_errata.c | 71 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 76225c2611ea..add7e08a018d 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -17,6 +17,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/arm-smccc.h>
 
 .macro ventry target
 	.rept 31
@@ -85,3 +86,22 @@ ENTRY(__qcom_hyp_sanitize_link_stack_start)
 	.endr
 	ldp	x29, x30, [sp], #16
 ENTRY(__qcom_hyp_sanitize_link_stack_end)
+
+.macro smccc_workaround_1 inst
+	sub	sp, sp, #(8 * 4)
+	stp	x2, x3, [sp, #(16 * 0)]
+	stp	x0, x1, [sp, #(16 * 1)]
+	orr	w0, wzr, #ARM_SMCCC_ARCH_WORKAROUND_1
+	\inst	#0
+	ldp	x2, x3, [sp, #(16 * 0)]
+	ldp	x0, x1, [sp, #(16 * 1)]
+	add	sp, sp, #(8 * 4)
+.endm
+
+ENTRY(__smccc_workaround_1_smc_start)
+	smccc_workaround_1	smc
+ENTRY(__smccc_workaround_1_smc_end)
+
+ENTRY(__smccc_workaround_1_hvc_start)
+	smccc_workaround_1	hvc
+ENTRY(__smccc_workaround_1_hvc_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ed6881882231..f1501873f2e4 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -70,6 +70,10 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
 extern char __qcom_hyp_sanitize_link_stack_start[];
 extern char __qcom_hyp_sanitize_link_stack_end[];
+extern char __smccc_workaround_1_smc_start[];
+extern char __smccc_workaround_1_smc_end[];
+extern char __smccc_workaround_1_hvc_start[];
+extern char __smccc_workaround_1_hvc_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -116,6 +120,10 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 #define __psci_hyp_bp_inval_end			NULL
 #define __qcom_hyp_sanitize_link_stack_start	NULL
 #define __qcom_hyp_sanitize_link_stack_end	NULL
+#define __smccc_workaround_1_smc_start		NULL
+#define __smccc_workaround_1_smc_end		NULL
+#define __smccc_workaround_1_hvc_start		NULL
+#define __smccc_workaround_1_hvc_end		NULL
 
 static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
@@ -142,17 +150,78 @@ static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
 	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
 }
 
+#include <uapi/linux/psci.h>
+#include <linux/arm-smccc.h>
 #include <linux/psci.h>
 
+static void call_smc_arch_workaround_1(void)
+{
+	register int w0 asm("w0") = ARM_SMCCC_ARCH_WORKAROUND_1;
+	asm volatile("smc	#0\n"
+		     : "+r" (w0));
+}
+
+static void call_hvc_arch_workaround_1(void)
+{
+	register int w0 asm("w0") = ARM_SMCCC_ARCH_WORKAROUND_1;
+	asm volatile("hvc	#0\n"
+		     : "+r" (w0));
+}
+
+static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
+{
+	bp_hardening_cb_t cb;
+	void *smccc_start, *smccc_end;
+	struct arm_smccc_res res;
+
+	if (psci_ops.variant == SMCCC_VARIANT_1_0)
+		return false;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			      ARM_SMCCC_ARCH_WORKAROUND_1, 0, 0, 0, 0, 0, 0,
+			      &res);
+		if (res.a0)
+			return false;
+		cb = call_hvc_arch_workaround_1;
+		smccc_start = __smccc_workaround_1_hvc_start;
+		smccc_end = __smccc_workaround_1_hvc_end;
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			      ARM_SMCCC_ARCH_WORKAROUND_1, 0, 0, 0, 0, 0, 0,
+			      &res);
+		if (res.a0)
+			return false;
+		cb = call_smc_arch_workaround_1;
+		smccc_start = __smccc_workaround_1_smc_start;
+		smccc_end = __smccc_workaround_1_smc_end;
+		break;
+
+	default:
+		return false;
+	}
+
+	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
+
+	return true;
+}
+
 static int enable_psci_bp_hardening(void *data)
 {
 	const struct arm64_cpu_capabilities *entry = data;
 
-	if (psci_ops.get_version)
+	if (psci_ops.get_version) {
+		if (check_smccc_arch_workaround_1(entry))
+			return 0;
+
 		install_bp_hardening_cb(entry,
 				       (bp_hardening_cb_t)psci_ops.get_version,
 				       __psci_hyp_bp_inval_start,
 				       __psci_hyp_bp_inval_end);
+	}
 
 	return 0;
 }
-- 
2.14.2
