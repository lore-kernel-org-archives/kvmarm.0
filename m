From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 20/31] KVM: arm64: Implement AT instruction handling
Date: Mon,  2 Oct 2017 22:11:02 -0500
Message-ID: <1507000273-3735-18-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD5BD49D20
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eN8pZFUpCc1z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:42 -0400 (EDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com
 [209.85.214.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 989ED49D29
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:41 -0400 (EDT)
Received: by mail-it0-f42.google.com with SMTP id m123so10018855ita.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:01 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement AT instruction handling logic in EL2. This will be used to
emulate AT instructions executed in the virtual EL2.

AT instruction emulation works by loading the proper processor context,
which depends on the trapped instruction and the virtual HCR_EL2, to the
EL1 virtual memory control registers and executing AT instructions. Note
that ctxt->hw_sys_regs is expected to have the proper processor context
before calling the handling function(__kvm_at_insn) implemented in this
patch.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h |   3 +
 arch/arm64/kvm/hyp/Makefile      |   1 +
 arch/arm64/kvm/hyp/at.c          | 131 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/at.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e492749..4bded9d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -56,6 +56,9 @@
 extern void __kvm_tlb_flush_vmid(u64 vttbr);
 extern void __kvm_tlb_flush_local_vmid(u64 vttbr);
 
+extern void __kvm_at_insn(struct kvm_vcpu *vcpu, unsigned long vaddr,
+			  bool el2_regime, int sys_encoding);
+
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 14c4e3b..1b03adb 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
+obj-$(CONFIG_KVM_ARM_HOST) += at.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
 
diff --git a/arch/arm64/kvm/hyp/at.c b/arch/arm64/kvm/hyp/at.c
new file mode 100644
index 0000000..d491d94
--- /dev/null
+++ b/arch/arm64/kvm/hyp/at.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2017 - Linaro Ltd
+ * Author: Jintack Lim <jintack.lim@linaro.org>
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
+#include <asm/kvm_hyp.h>
+
+static void __hyp_text __save_vmregs(struct kvm_cpu_context *ctxt)
+{
+	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
+
+	sys_regs[TTBR0_EL1]     = read_sysreg_el1(ttbr0);
+	sys_regs[TTBR1_EL1]     = read_sysreg_el1(ttbr1);
+	sys_regs[TCR_EL1]       = read_sysreg_el1(tcr);
+	sys_regs[SCTLR_EL1]     = read_sysreg_el1(sctlr);
+}
+
+static void __hyp_text __restore_vmregs(struct kvm_cpu_context *ctxt)
+{
+	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
+
+	write_sysreg_el1(sys_regs[TTBR0_EL1],   ttbr0);
+	write_sysreg_el1(sys_regs[TTBR1_EL1],   ttbr1);
+	write_sysreg_el1(sys_regs[TCR_EL1],     tcr);
+	write_sysreg_el1(sys_regs[SCTLR_EL1],   sctlr);
+}
+
+void __hyp_text __at_switch_to_guest_nvhe(struct kvm_vcpu *vcpu,
+					  bool el2_regime)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	u64 val;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__save_vmregs(host_ctxt);
+	__restore_vmregs(guest_ctxt);
+
+	val = read_sysreg(hcr_el2);
+	if (el2_regime)
+		val |= (HCR_NV | HCR_NV1);
+	write_sysreg(val, hcr_el2);
+}
+
+void __hyp_text __at_switch_to_guest_vhe(struct kvm_vcpu *vcpu, bool el2_regime)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	u64 val;
+
+	__restore_vmregs(guest_ctxt);
+
+	val = read_sysreg(hcr_el2);
+	val &= ~HCR_TGE;
+	if (el2_regime)
+		val |= (HCR_NV | HCR_NV1);
+	write_sysreg(val, hcr_el2);
+}
+
+/*
+ * Switching to guest.
+ *
+ * 1. [nvhe] Save host vm regs
+ * 2. [both] Restore guest vm regs
+ * 3. [both] Set HCR_EL2.NV/NV1 bit if necessary
+ * 4. [vhe]  Clear HCR_EL2.TGE
+ */
+static hyp_alternate_select(__at_switch_to_guest,
+			    __at_switch_to_guest_nvhe, __at_switch_to_guest_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+void __hyp_text __kvm_at_insn(struct kvm_vcpu *vcpu, unsigned long vaddr,
+			      bool el2_regime, int sys_encoding)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+
+	__at_switch_to_guest()(vcpu, el2_regime);
+
+	switch (sys_encoding) {
+	case AT_S1E1R:
+	case AT_S1E2R:
+		asm volatile("at s1e1r, %0" : : "r" (vaddr));
+		break;
+	case AT_S1E1W:
+	case AT_S1E2W:
+		asm volatile("at s1e1w, %0" : : "r" (vaddr));
+		break;
+	case AT_S1E0R:
+		asm volatile("at s1e0r, %0" : : "r" (vaddr));
+		break;
+	case AT_S1E0W:
+		asm volatile("at s1e0w, %0" : : "r" (vaddr));
+		break;
+	case AT_S1E1RP:
+		asm volatile("at s1e1rp, %0" : : "r" (vaddr));
+		break;
+	case AT_S1E1WP:
+		asm volatile("at s1e1wp, %0" : : "r" (vaddr));
+		break;
+	default:
+		break;
+	}
+
+	/* Save the translation result to the virtual machine's context */
+	ctxt->sys_regs[PAR_EL1] = read_sysreg(par_el1);
+
+	/* Switch to the host */
+	if (has_vhe()) {
+		write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	} else {
+		/* We don't save guest vm regs; we didn't make any changes */
+		__restore_vmregs(host_ctxt);
+		write_sysreg(HCR_RW, hcr_el2);
+	}
+}
-- 
1.9.1
