From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 08/21] arm64: KVM: Implement debug save/restore
Date: Fri, 27 Nov 2015 18:50:02 +0000
Message-ID: <1448650215-15218-9-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 044A0412A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R2rEOeglDCZn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9BD949767
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:31 -0500 (EST)
In-Reply-To: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
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

Implement the debug save restore as a direct translation of
the assembly code version.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile   |   1 +
 arch/arm64/kvm/hyp/debug-sr.c | 130 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp.h      |   9 +++
 3 files changed, 140 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/debug-sr.c

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ec94200..ec14cac 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
new file mode 100644
index 0000000..a0b2b99
--- /dev/null
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -0,0 +1,130 @@
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
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_mmu.h>
+
+#include "hyp.h"
+
+#define read_debug(r,n)		read_sysreg(r##n##_el1)
+#define write_debug(v,r,n)	write_sysreg(v, r##n##_el1)
+
+#define save_debug(ptr,reg,nr)						\
+	switch (nr) {							\
+	case 15:	ptr[15] = read_debug(reg, 15);			\
+	case 14:	ptr[14] = read_debug(reg, 14);			\
+	case 13:	ptr[13] = read_debug(reg, 13);			\
+	case 12:	ptr[12] = read_debug(reg, 12);			\
+	case 11:	ptr[11] = read_debug(reg, 11);			\
+	case 10:	ptr[10] = read_debug(reg, 10);			\
+	case 9:		ptr[9] = read_debug(reg, 9);			\
+	case 8:		ptr[8] = read_debug(reg, 8);			\
+	case 7:		ptr[7] = read_debug(reg, 7);			\
+	case 6:		ptr[6] = read_debug(reg, 6);			\
+	case 5:		ptr[5] = read_debug(reg, 5);			\
+	case 4:		ptr[4] = read_debug(reg, 4);			\
+	case 3:		ptr[3] = read_debug(reg, 3);			\
+	case 2:		ptr[2] = read_debug(reg, 2);			\
+	case 1:		ptr[1] = read_debug(reg, 1);			\
+	default:	ptr[0] = read_debug(reg, 0);			\
+	}
+
+#define restore_debug(ptr,reg,nr)					\
+	switch (nr) {							\
+	case 15:	write_debug(ptr[15], reg, 15);			\
+	case 14:	write_debug(ptr[14], reg, 14);			\
+	case 13:	write_debug(ptr[13], reg, 13);			\
+	case 12:	write_debug(ptr[12], reg, 12);			\
+	case 11:	write_debug(ptr[11], reg, 11);			\
+	case 10:	write_debug(ptr[10], reg, 10);			\
+	case 9:		write_debug(ptr[9], reg, 9);			\
+	case 8:		write_debug(ptr[8], reg, 8);			\
+	case 7:		write_debug(ptr[7], reg, 7);			\
+	case 6:		write_debug(ptr[6], reg, 6);			\
+	case 5:		write_debug(ptr[5], reg, 5);			\
+	case 4:		write_debug(ptr[4], reg, 4);			\
+	case 3:		write_debug(ptr[3], reg, 3);			\
+	case 2:		write_debug(ptr[2], reg, 2);			\
+	case 1:		write_debug(ptr[1], reg, 1);			\
+	default:	write_debug(ptr[0], reg, 0);			\
+	}
+
+void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
+				   struct kvm_guest_debug_arch *dbg,
+				   struct kvm_cpu_context *ctxt)
+{
+	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY) {
+		u64 aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
+		int brps, wrps;
+
+		brps = (aa64dfr0 >> 12) & 0xf;
+		wrps = (aa64dfr0 >> 20) & 0xf;
+
+		save_debug(dbg->dbg_bcr, dbgbcr, brps);
+		save_debug(dbg->dbg_bvr, dbgbvr, brps);
+		save_debug(dbg->dbg_wcr, dbgwcr, wrps);
+		save_debug(dbg->dbg_wvr, dbgwvr, wrps);
+
+		ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
+	}
+}
+
+void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
+				      struct kvm_guest_debug_arch *dbg,
+				      struct kvm_cpu_context *ctxt)
+{
+	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY) {
+		u64 aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
+		int brps, wrps;
+
+		brps = (aa64dfr0 >> 12) & 0xf;
+		wrps = (aa64dfr0 >> 20) & 0xf;
+
+		restore_debug(dbg->dbg_bcr, dbgbcr, brps);
+		restore_debug(dbg->dbg_bvr, dbgbvr, brps);
+		restore_debug(dbg->dbg_wcr, dbgwcr, wrps);
+		restore_debug(dbg->dbg_wvr, dbgwvr, wrps);
+
+		write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
+	}
+}
+
+void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
+{
+	if ((vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE) ||
+	    (vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE))
+		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+
+	__debug_save_state(vcpu, &vcpu->arch.host_debug_state,
+			   kern_hyp_va(vcpu->arch.host_cpu_context));
+}
+
+void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY) {
+		__debug_restore_state(vcpu, &vcpu->arch.host_debug_state,
+				      kern_hyp_va(vcpu->arch.host_cpu_context));
+		vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	}
+}
+
+u32 __hyp_text __debug_read_mdcr_el2(void)
+{
+	return read_sysreg(mdcr_el2);
+}
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 4639330..2581232 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -41,5 +41,14 @@ void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
+void __debug_save_state(struct kvm_vcpu *vcpu,
+			struct kvm_guest_debug_arch *dbg,
+			struct kvm_cpu_context *ctxt);
+void __debug_restore_state(struct kvm_vcpu *vcpu,
+			   struct kvm_guest_debug_arch *dbg,
+			   struct kvm_cpu_context *ctxt);
+void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
+void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HYP_H__ */
 
-- 
2.1.4
