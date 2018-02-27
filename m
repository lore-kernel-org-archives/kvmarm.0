From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 17/40] KVM: arm64: Move userspace system registers into
 separate function
Date: Tue, 27 Feb 2018 12:34:06 +0100
Message-ID: <20180227113429.637-18-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E82F49E00
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:29:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KfBosxiSwseJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:28:54 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FA4D49E61
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:04 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id t6so14822308wmt.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:34:57 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

There's a semantic difference between the EL1 registers that control
operation of a kernel running in EL1 and EL1 registers that only control
userspace execution in EL0.  Since we can defer saving/restoring the
latter, move them into their own function.

The ARMv8 ARM (ARM DDI 0487C.a) Section D10.2.1 recommends that
ACTLR_EL1 has no effect on the processor when running the VHE host, and
we can therefore move this register into the EL1 state which is only
saved/restored on vcpu_put/load for a VHE host.

We also take this chance to rename the function saving/restoring the
remaining system register to make it clear this function deals with
the EL1 system registers.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v4:
     - Clarified rationale for deferring ACTLR_EL1 in the commit message.
    
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
