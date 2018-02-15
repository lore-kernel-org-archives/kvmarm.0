From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 17/40] KVM: arm64: Move userspace system registers into separate function
Date: Thu, 15 Feb 2018 22:03:09 +0100
Message-ID: <20180215210332.8648-18-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

There's a semantic difference between the EL1 registers that control
operation of a kernel running in EL1 and EL1 registers that only control
userspace execution in EL0.  Since we can defer saving/restoring the
latter, move them into their own function.

ACTLR_EL1 is not used by a VHE host, so we can move this register into
the EL1 state which is not saved/restored for a VHE host.

We also take this chance to rename the function saving/restoring the
remaining system register to make it clear this function deals with
the EL1 system registers.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v3:
     - Correct the comment about ACTLR_EL1 and adjust commit text.
    
    Changes since v2:
     - Save restore ACTLR_EL1 as part of the EL1 registers state instead of
       the user register state, as ACTLR_EL1 can't affect the host's execution
       on VHE systems.
    
    Changes since v1:
     - Added comment about sp_el0 to common save sysreg save/restore functions

 arch/arm64/kvm/hyp/sysreg-sr.c | 48 ++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 99fc60516103..d5a5145b4e7c 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -28,24 +28,33 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
 /*
  * Non-VHE: Both host and guest must save everything.
  *
- * VHE: Host must save tpidr*_el0, actlr_el1, mdscr_el1, sp_el0,
+ * VHE: Host must save tpidr*_el0, mdscr_el1, sp_el0,
  * and guest must save everything.
  */
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
-	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
-	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
+
+	/*
+	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
+	 * therefore be saved/restored on every entry/exit to/from the guest.
+	 */
 	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
 }
 
-static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
+static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
+	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
+}
+
+static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
+	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
 	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
 	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
@@ -73,35 +82,46 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 }
 
 static hyp_alternate_select(__sysreg_call_save_host_state,
-			    __sysreg_save_state, __sysreg_do_nothing,
+			    __sysreg_save_el1_state, __sysreg_do_nothing,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_call_save_host_state()(ctxt);
 	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
 }
 
 void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_save_state(ctxt);
+	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
 }
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
-	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
+
+	/*
+	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
+	 * therefore be saved/restored on every entry/exit to/from the guest.
+	 */
 	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
 }
 
-static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
+static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  	tpidr_el0);
+	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], 	tpidrro_el0);
+}
+
+static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
 	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
+	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
 	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
 	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	ttbr0);
 	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	ttbr1);
@@ -129,19 +149,21 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 }
 
 static hyp_alternate_select(__sysreg_call_restore_host_state,
-			    __sysreg_restore_state, __sysreg_do_nothing,
+			    __sysreg_restore_el1_state, __sysreg_do_nothing,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_call_restore_host_state()(ctxt);
 	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
 }
 
 void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_state(ctxt);
+	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
 }
 
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
-- 
2.14.2
