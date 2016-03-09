From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 17/95] ARM: KVM: Add the new world switch implementation
Date: Wed,  9 Mar 2016 07:30:11 +0000
Message-ID: <1457508689-19672-18-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The new world switch implementation is modeled after the arm64 one,
calling the various save/restore functions in turn, and having as
little state as possible.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile |   1 +
 arch/arm/kvm/hyp/hyp.h    |   7 +++
 arch/arm/kvm/hyp/switch.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/switch.c

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index c779690..cfab402 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
 obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
+obj-$(CONFIG_KVM_ARM_HOST) += switch.o
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index b3f6ed2..ef582c9 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -60,11 +60,16 @@
 #define CNTV_CVAL	__ACCESS_CP15_64(3, c14)
 #define CNTVOFF		__ACCESS_CP15_64(4, c14)
 
+#define MIDR		__ACCESS_CP15(c0, 0, c0, 0)
 #define CSSELR		__ACCESS_CP15(c0, 2, c0, 0)
+#define VPIDR		__ACCESS_CP15(c0, 4, c0, 0)
 #define VMPIDR		__ACCESS_CP15(c0, 4, c0, 5)
 #define SCTLR		__ACCESS_CP15(c1, 0, c0, 0)
 #define CPACR		__ACCESS_CP15(c1, 0, c0, 2)
+#define HCR		__ACCESS_CP15(c1, 4, c1, 0)
+#define HDCR		__ACCESS_CP15(c1, 4, c1, 1)
 #define HCPTR		__ACCESS_CP15(c1, 4, c1, 2)
+#define HSTR		__ACCESS_CP15(c1, 4, c1, 3)
 #define TTBCR		__ACCESS_CP15(c2, 0, c0, 2)
 #define DACR		__ACCESS_CP15(c3, 0, c0, 0)
 #define DFSR		__ACCESS_CP15(c5, 0, c0, 0)
@@ -73,6 +78,7 @@
 #define AIFSR		__ACCESS_CP15(c5, 0, c1, 1)
 #define DFAR		__ACCESS_CP15(c6, 0, c0, 0)
 #define IFAR		__ACCESS_CP15(c6, 0, c0, 2)
+#define HDFAR		__ACCESS_CP15(c6, 4, c0, 0)
 #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
 #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
 #define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
@@ -85,6 +91,7 @@
 #define TID_URW		__ACCESS_CP15(c13, 0, c0, 2)
 #define TID_URO		__ACCESS_CP15(c13, 0, c0, 3)
 #define TID_PRIV	__ACCESS_CP15(c13, 0, c0, 4)
+#define HTPIDR		__ACCESS_CP15(c13, 4, c0, 2)
 #define CNTKCTL		__ACCESS_CP15(c14, 0, c1, 0)
 #define CNTV_CTL	__ACCESS_CP15(c14, 0, c3, 1)
 #define CNTHCTL		__ACCESS_CP15(c14, 4, c1, 0)
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
new file mode 100644
index 0000000..a1f3c1c
--- /dev/null
+++ b/arch/arm/kvm/hyp/switch.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (C) 2015 - ARM Ltd
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
+#include <asm/kvm_asm.h>
+#include "hyp.h"
+
+__asm__(".arch_extension     virt");
+
+/*
+ * Activate the traps, saving the host's fpexc register before
+ * overwriting it. We'll restore it on VM exit.
+ */
+static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu, u32 *fpexc_host)
+{
+	u32 val;
+
+	/*
+	 * We are about to set HCPTR.TCP10/11 to trap all floating point
+	 * register accesses to HYP, however, the ARM ARM clearly states that
+	 * traps are only taken to HYP if the operation would not otherwise
+	 * trap to SVC.  Therefore, always make sure that for 32-bit guests,
+	 * we set FPEXC.EN to prevent traps to SVC, when setting the TCP bits.
+	 */
+	val = read_sysreg(VFP_FPEXC);
+	*fpexc_host = val;
+	if (!(val & FPEXC_EN)) {
+		write_sysreg(val | FPEXC_EN, VFP_FPEXC);
+		isb();
+	}
+
+	write_sysreg(vcpu->arch.hcr | vcpu->arch.irq_lines, HCR);
+	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
+	write_sysreg(HSTR_T(15), HSTR);
+	write_sysreg(HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11), HCPTR);
+	val = read_sysreg(HDCR);
+	write_sysreg(val | HDCR_TPM | HDCR_TPMCR, HDCR);
+}
+
+static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
+{
+	u32 val;
+
+	write_sysreg(0, HCR);
+	write_sysreg(0, HSTR);
+	val = read_sysreg(HDCR);
+	write_sysreg(val & ~(HDCR_TPM | HDCR_TPMCR), HDCR);
+	write_sysreg(0, HCPTR);
+}
+
+static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	write_sysreg(kvm->arch.vttbr, VTTBR);
+	write_sysreg(vcpu->arch.midr, VPIDR);
+}
+
+static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
+{
+	write_sysreg(0, VTTBR);
+	write_sysreg(read_sysreg(MIDR), VPIDR);
+}
+
+static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
+{
+	__vgic_v2_save_state(vcpu);
+}
+
+static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
+{
+	__vgic_v2_restore_state(vcpu);
+}
+
+static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	bool fp_enabled;
+	u64 exit_code;
+	u32 fpexc;
+
+	vcpu = kern_hyp_va(vcpu);
+	write_sysreg(vcpu, HTPIDR);
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__sysreg_save_state(host_ctxt);
+	__banked_save_state(host_ctxt);
+
+	__activate_traps(vcpu, &fpexc);
+	__activate_vm(vcpu);
+
+	__vgic_restore_state(vcpu);
+	__timer_restore_state(vcpu);
+
+	__sysreg_restore_state(guest_ctxt);
+	__banked_restore_state(guest_ctxt);
+
+	/* Jump in the fire! */
+	exit_code = __guest_enter(vcpu, host_ctxt);
+	/* And we're baaack! */
+
+	fp_enabled = __vfp_enabled();
+
+	__banked_save_state(guest_ctxt);
+	__sysreg_save_state(guest_ctxt);
+	__timer_save_state(vcpu);
+	__vgic_save_state(vcpu);
+
+	__deactivate_traps(vcpu);
+	__deactivate_vm(vcpu);
+
+	__banked_restore_state(host_ctxt);
+	__sysreg_restore_state(host_ctxt);
+
+	if (fp_enabled) {
+		__vfp_save_state(&guest_ctxt->vfp);
+		__vfp_restore_state(&host_ctxt->vfp);
+	}
+
+	write_sysreg(fpexc, VFP_FPEXC);
+
+	return exit_code;
+}
+
+__alias(__guest_run) int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
-- 
2.1.4

