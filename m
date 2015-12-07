From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 14/22] arm64: KVM: Implement TLB handling
Date: Mon,  7 Dec 2015 10:53:30 +0000
Message-ID: <1449485618-9443-15-git-send-email-marc.zyngier@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B3E49723
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 05:52:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3TUy1HzBxDfa for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 05:52:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E950412F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 05:52:30 -0500 (EST)
In-Reply-To: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement the TLB handling as a direct translation of the assembly
code version.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/Makefile |  1 +
 arch/arm64/kvm/hyp/entry.S  |  1 +
 arch/arm64/kvm/hyp/tlb.c    | 73 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/tlb.c

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 56238d0..1a529f5 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
+obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 852ac12..cae59e5 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -148,6 +148,7 @@ ENTRY(__fpsimd_guest_restore)
 	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
 	bl	__fpsimd_restore_state
 
+	// Skip restoring fpexc32 for AArch64 guests
 	mrs	x1, hcr_el2
 	tbnz	x1, #HCR_RW_SHIFT, 1f
 	ldr	x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
new file mode 100644
index 0000000..6fcb93a
--- /dev/null
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -0,0 +1,73 @@
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
+void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+{
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	kvm = kern_hyp_va(kvm);
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	isb();
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	asm volatile("tlbi ipas2e1is, %0" : : "r" (ipa));
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(ish);
+	asm volatile("tlbi vmalle1is" : : );
+	dsb(ish);
+	isb();
+
+	write_sysreg(0, vttbr_el2);
+}
+
+void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
+{
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	kvm = kern_hyp_va(kvm);
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	isb();
+
+	asm volatile("tlbi vmalls12e1is" : : );
+	dsb(ish);
+	isb();
+
+	write_sysreg(0, vttbr_el2);
+}
+
+void __hyp_text __tlb_flush_vm_context(void)
+{
+	dsb(ishst);
+	asm volatile("tlbi alle1is	\n"
+		     "ic ialluis	  ": : );
+	dsb(ish);
+}
-- 
2.1.4
