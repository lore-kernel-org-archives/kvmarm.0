From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/21] arm64: KVM: Implement the core world switch
Date: Mon, 16 Nov 2015 13:11:49 +0000
Message-ID: <1447679519-17888-12-git-send-email-marc.zyngier@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE855498E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:12:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pGPgtwTNjIuI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 08:12:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BC594969A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:12:01 -0500 (EST)
In-Reply-To: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Implement the core of the world switch in C. Not everything is there
yet, and there is nothing to re-enter the world switch either.

But this already outlines the code structure well enough.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile |   1 +
 arch/arm64/kvm/hyp/switch.c | 134 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/switch.c

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 1e1ff06..9c11b0f 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
+obj-$(CONFIG_KVM_ARM_HOST) += switch.o
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
new file mode 100644
index 0000000..a3af81a
--- /dev/null
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -0,0 +1,134 @@
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
+#include "hyp.h"
+
+static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	/*
+	 * We are about to set CPTR_EL2.TFP to trap all floating point
+	 * register accesses to EL2, however, the ARM ARM clearly states that
+	 * traps are only taken to EL2 if the operation would not otherwise
+	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
+	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
+	 */
+	val = vcpu->arch.hcr_el2;
+	if (val & HCR_RW) {
+		write_sysreg(1 << 30, fpexc32_el2);
+		isb();
+	}
+	write_sysreg(val, hcr_el2);
+	write_sysreg(1 << 15, hstr_el2);
+	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
+	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+}
+
+static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
+{
+	write_sysreg(HCR_RW, hcr_el2);
+	write_sysreg(0, hstr_el2);
+	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
+	write_sysreg(0, cptr_el2);
+}
+
+static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+}
+
+static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
+{
+	write_sysreg(0, vttbr_el2);
+}
+
+static hyp_alternate_select(__vgic_call_save_state,
+			    __vgic_v2_save_state, __vgic_v3_save_state,
+			    ARM64_HAS_SYSREG_GIC_CPUIF);
+
+static hyp_alternate_select(__vgic_call_restore_state,
+			    __vgic_v2_restore_state, __vgic_v3_restore_state,
+			    ARM64_HAS_SYSREG_GIC_CPUIF);
+
+static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
+{
+	__vgic_call_save_state()(vcpu);
+	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
+}
+
+static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	val = read_sysreg(hcr_el2);
+	val |= 	HCR_INT_OVERRIDE;
+	val |= vcpu->arch.irq_lines;
+	write_sysreg(val, hcr_el2);
+
+	__vgic_call_restore_state()(vcpu);
+}
+
+int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	u64 exit_code;
+
+	vcpu = kern_hyp_va(vcpu);
+	write_sysreg(vcpu, tpidr_el2);
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__sysreg_save_state(host_ctxt);
+	__debug_cond_save_state(vcpu, &vcpu->arch.host_debug_state, host_ctxt);
+
+	__activate_traps(vcpu);
+	__activate_vm(vcpu);
+
+	__vgic_restore_state(vcpu);
+	__timer_restore_state(vcpu);
+
+	/*
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to Cortex-A57 erratum #852523.
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_state(guest_ctxt);
+	__debug_restore_state(vcpu, &vcpu->arch.vcpu_debug_state, guest_ctxt);
+
+	/* Jump in the fire! */
+	exit_code = __guest_enter(vcpu, host_ctxt);
+	/* And we're baaack! */
+
+	__sysreg_save_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+	__timer_save_state(vcpu);
+	__vgic_save_state(vcpu);
+
+	__deactivate_traps(vcpu);
+	__deactivate_vm(vcpu);
+
+	__sysreg_restore_state(host_ctxt);
+
+	__debug_save_state(vcpu, &vcpu->arch.vcpu_debug_state, guest_ctxt);
+	__debug_clear_restore_state(vcpu, &vcpu->arch.host_debug_state, host_ctxt);
+
+	return exit_code;
+}
-- 
2.1.4
