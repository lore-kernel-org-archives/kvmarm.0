From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 09/13] KVM: arm64: Save/Restore guest DISR_EL1
Date: Mon, 15 Jan 2018 19:39:02 +0000
Message-ID: <20180115193906.30053-10-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8592449E19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j-KGKXt+FtYh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:36:58 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2778D49DFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:57 -0500 (EST)
In-Reply-To: <20180115193906.30053-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If we deliver a virtual SError to the guest, the guest may defer it
with an ESB instruction. The guest reads the deferred value via DISR_EL1,
but the guests view of DISR_EL1 is re-mapped to VDISR_EL2 when HCR_EL2.AMO
is set.

Add the KVM code to save/restore VDISR_EL2, and make it accessible to
userspace as DISR_EL1.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
v5 of this patch missed some Reviewed-bys, which came from here:
https://patchwork.kernel.org/patch/10017465/

 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/include/asm/sysreg.h   | 1 +
 arch/arm64/kvm/hyp/sysreg-sr.c    | 6 ++++++
 arch/arm64/kvm/sys_regs.c         | 1 +
 4 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3014b39b8fe2..84fcb2a896a1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -121,6 +121,7 @@ enum vcpu_sysreg {
 	PAR_EL1,	/* Physical Address Register */
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
+	DISR_EL1,	/* Deferred Interrupt Status Register */
 
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index aec10f75a43c..e213bd92e998 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -358,6 +358,7 @@
 #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
 
+#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1,  1)
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
 #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index c54cc2afb92b..2c17afd2be96 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -66,6 +66,9 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
+
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
+		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
 }
 
 static hyp_alternate_select(__sysreg_call_save_host_state,
@@ -119,6 +122,9 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
 	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
 	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
+
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
+		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
 }
 
 static hyp_alternate_select(__sysreg_call_restore_host_state,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1830ebc227d1..9edf4ac8a320 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1169,6 +1169,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
 	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
 	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_EOIR0_EL1), read_from_write_only },
-- 
2.15.1
