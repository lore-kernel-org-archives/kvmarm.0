From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 07/55] KVM: arm/arm64: Add virtual EL2 state emulation framework
Date: Mon,  9 Jan 2017 01:24:03 -0500
Message-ID: <1483943091-1364-8-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E7840625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q2kikgRy5oqZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:01 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2534403F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:59 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096OdxF005146
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:41 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 3802382
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:41 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 200B182
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:41 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Pem6004511
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:41 -0500
Received: by mail-qk0-f199.google.com with SMTP id t84so100989957qke.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:41 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Add a framework to set up the guest's context depending on the guest's
exception level. A chosen context is written to hardware in the lowvisor.
We don't set the virtual EL2 context yet.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_emulate.h   |   4 ++
 arch/arm/kvm/arm.c                   |   5 ++
 arch/arm64/include/asm/kvm_emulate.h |   4 ++
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/context.c             |  49 ++++++++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c       | 109 +++++++++++++++++++----------------
 6 files changed, 122 insertions(+), 51 deletions(-)
 create mode 100644 arch/arm64/kvm/context.c

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 399cd75e..0a03b7d 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -47,6 +47,10 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+static inline void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu) { };
+static inline void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu) { };
+static inline void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt) { };
+
 static inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
 {
 	return kvm_condition_valid32(vcpu);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d2dfa32..436bf5a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -41,6 +41,7 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
@@ -646,6 +647,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		}
 
 		kvm_arm_setup_debug(vcpu);
+		kvm_arm_setup_shadow_state(vcpu);
 
 		/**************************************************************
 		 * Enter the guest
@@ -662,6 +664,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * Back from guest
 		 *************************************************************/
 
+		kvm_arm_restore_shadow_state(vcpu);
 		kvm_arm_clear_debug(vcpu);
 
 		/*
@@ -1369,6 +1372,8 @@ static int init_hyp_mode(void)
 			kvm_err("Cannot map host CPU state: %d\n", err);
 			goto out_err;
 		}
+
+		kvm_arm_init_cpu_context(cpu_ctxt);
 	}
 
 	kvm_info("Hyp mode initialized successfully\n");
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 830be2e..8892c82 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -42,6 +42,10 @@
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu);
+void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu);
+void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt);
+
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index d50a82a..7811d27 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
+kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o context.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
new file mode 100644
index 0000000..320afc6
--- /dev/null
+++ b/arch/arm64/kvm/context.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2016 - Linaro Ltd.
+ * Author: Christoffer Dall <christoffer.dall@linaro.org>
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
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+
+/**
+ * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
+ * @vcpu: The VCPU pointer
+ */
+void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
+	ctxt->hw_sys_regs = ctxt->sys_regs;
+	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
+}
+
+/**
+ * kvm_arm_restore_shadow_state -- write back shadow state from guest
+ * @vcpu: The VCPU pointer
+ */
+void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+	*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
+	ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
+}
+
+void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
+{
+	cpu_ctxt->hw_sys_regs = &cpu_ctxt->sys_regs[0];
+}
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9341376..f2a1b32 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 /* Yes, this does nothing, on purpose */
@@ -33,37 +34,41 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
-	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
-	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
-	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
-	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
+	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
+
+	sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
+	sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
+	sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
+	sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
+	sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
-	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
+	ctxt->hw_pstate			= read_sysreg_el2(spsr);
 }
 
 static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
-	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
-	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
-	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
-	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
-	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
-	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(tcr);
-	ctxt->sys_regs[ESR_EL1]		= read_sysreg_el1(esr);
-	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg_el1(afsr0);
-	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg_el1(afsr1);
-	ctxt->sys_regs[FAR_EL1]		= read_sysreg_el1(far);
-	ctxt->sys_regs[MAIR_EL1]	= read_sysreg_el1(mair);
-	ctxt->sys_regs[VBAR_EL1]	= read_sysreg_el1(vbar);
-	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(contextidr);
-	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
-	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
-	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
-
-	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
+	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
+
+	sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
+	sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
+	sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
+	sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
+	sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
+	sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
+	sys_regs[TCR_EL1]	= read_sysreg_el1(tcr);
+	sys_regs[ESR_EL1]	= read_sysreg_el1(esr);
+	sys_regs[AFSR0_EL1]	= read_sysreg_el1(afsr0);
+	sys_regs[AFSR1_EL1]	= read_sysreg_el1(afsr1);
+	sys_regs[FAR_EL1]	= read_sysreg_el1(far);
+	sys_regs[MAIR_EL1]	= read_sysreg_el1(mair);
+	sys_regs[VBAR_EL1]	= read_sysreg_el1(vbar);
+	sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(contextidr);
+	sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
+	sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
+	sys_regs[PAR_EL1]		= read_sysreg(par_el1);
+
+	ctxt->hw_sp_el1			= read_sysreg(sp_el1);
 	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
 }
@@ -86,37 +91,41 @@ void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
-	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
-	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
+	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
+
+	write_sysreg(sys_regs[ACTLR_EL1],	  actlr_el1);
+	write_sysreg(sys_regs[TPIDR_EL0],	  tpidr_el0);
+	write_sysreg(sys_regs[TPIDRRO_EL0],	tpidrro_el0);
+	write_sysreg(sys_regs[TPIDR_EL1],	  tpidr_el1);
+	write_sysreg(sys_regs[MDSCR_EL1],	  mdscr_el1);
 	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
 	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
-	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
+	write_sysreg_el2(ctxt->hw_pstate,	  spsr);
 }
 
 static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
-	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
-	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
-	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	ttbr0);
-	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	ttbr1);
-	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	tcr);
-	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	esr);
-	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	afsr0);
-	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	afsr1);
-	write_sysreg_el1(ctxt->sys_regs[FAR_EL1],	far);
-	write_sysreg_el1(ctxt->sys_regs[MAIR_EL1],	mair);
-	write_sysreg_el1(ctxt->sys_regs[VBAR_EL1],	vbar);
-	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL1],contextidr);
-	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
-	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
-	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
-
-	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
+	u64 *sys_regs = kern_hyp_va(ctxt->hw_sys_regs);
+
+	write_sysreg(sys_regs[MPIDR_EL1],	vmpidr_el2);
+	write_sysreg(sys_regs[CSSELR_EL1],	csselr_el1);
+	write_sysreg_el1(sys_regs[SCTLR_EL1],	sctlr);
+	write_sysreg_el1(sys_regs[CPACR_EL1],	cpacr);
+	write_sysreg_el1(sys_regs[TTBR0_EL1],	ttbr0);
+	write_sysreg_el1(sys_regs[TTBR1_EL1],	ttbr1);
+	write_sysreg_el1(sys_regs[TCR_EL1],	tcr);
+	write_sysreg_el1(sys_regs[ESR_EL1],	esr);
+	write_sysreg_el1(sys_regs[AFSR0_EL1],	afsr0);
+	write_sysreg_el1(sys_regs[AFSR1_EL1],	afsr1);
+	write_sysreg_el1(sys_regs[FAR_EL1],	far);
+	write_sysreg_el1(sys_regs[MAIR_EL1],	mair);
+	write_sysreg_el1(sys_regs[VBAR_EL1],	vbar);
+	write_sysreg_el1(sys_regs[CONTEXTIDR_EL1], contextidr);
+	write_sysreg_el1(sys_regs[AMAIR_EL1],	amair);
+	write_sysreg_el1(sys_regs[CNTKCTL_EL1], cntkctl);
+	write_sysreg(sys_regs[PAR_EL1],		par_el1);
+
+	write_sysreg(ctxt->hw_sp_el1,			sp_el1);
 	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
 }
-- 
1.9.1
