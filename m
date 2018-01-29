From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 16/16] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening
 support
Date: Mon, 29 Jan 2018 17:45:59 +0000
Message-ID: <20180129174559.1866-17-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9918649DFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jan 2018 12:43:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BklRPQBW+67i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jan 2018 12:42:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3868049E0D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jan 2018 12:41:15 -0500 (EST)
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Robin Murphy <robin.murphy@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add the detection and runtime code for ARM_SMCCC_ARCH_WORKAROUND_1.
It is lovely. Really.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_psci.h | 63 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/bpi.S           | 20 ++++++++++++
 arch/arm64/kernel/cpu_errata.c    | 68 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_psci.h

diff --git a/arch/arm64/include/asm/kvm_psci.h b/arch/arm64/include/asm/kvm_psci.h
new file mode 100644
index 000000000000..f553e3795a4e
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_psci.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __ARM64_KVM_PSCI_H__
+#define __ARM64_KVM_PSCI_H__
+
+#include <linux/kvm_host.h>
+
+#define PSCI_VERSION(x,y)	((((x) & 0x7fff) << 16) | ((y) & 0xffff))
+#define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
+#define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
+#define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
+
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
+
+/*
+ * We need the KVM pointer independently from the vcpu as we can call
+ * this from HYP, and need to apply kern_hyp_va on it...
+ */
+static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+	/*
+	 * Our PSCI implementation stays the same across versions from
+	 * v0.2 onward, only adding the few mandatory functions (such
+	 * as FEATURES with 1.0) that are required by newer
+	 * revisions. It is thus safe to return the latest, unless
+	 * userspace has instructed us otherwise.
+	 */
+	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
+		if (kvm->arch.psci_version)
+			return kvm->arch.psci_version;
+
+		return KVM_ARM_PSCI_LATEST;
+	}
+
+	return KVM_ARM_PSCI_0_1;
+}
+
+
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+
+struct kvm_one_reg;
+
+int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
+int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
+int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+
+#endif /* __ARM64_KVM_PSCI_H__ */
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 76225c2611ea..fdeed629f2c6 100644
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
+	stp	x2, x3, [sp, #(8 * 0)]
+	stp	x0, x1, [sp, #(8 * 2)]
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
+	\inst	#0
+	ldp	x2, x3, [sp, #(8 * 0)]
+	ldp	x0, x1, [sp, #(8 * 2)]
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
index ed6881882231..36cff870d5d7 100644
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
@@ -142,17 +150,75 @@ static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
 	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
 }
 
+#include <uapi/linux/psci.h>
+#include <linux/arm-smccc.h>
 #include <linux/psci.h>
 
+static void call_smc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
+static void call_hvc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
+static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
+{
+	bp_hardening_cb_t cb;
+	void *smccc_start, *smccc_end;
+	struct arm_smccc_res res;
+
+	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
+		return false;
+
+	if (psci_ops.variant == SMCCC_VARIANT_1_0)
+		return false;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+		if (res.a0)
+			return false;
+		cb = call_hvc_arch_workaround_1;
+		smccc_start = __smccc_workaround_1_hvc_start;
+		smccc_end = __smccc_workaround_1_hvc_end;
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
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
