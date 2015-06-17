From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2] arm: KVM: force execution of HCPTR access on VM exit
Date: Wed, 17 Jun 2015 10:27:19 +0100
Message-ID: <1434533239-16145-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AD555CD3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 05:16:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VEN2TNA0EA80 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 05:16:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9FC55CD0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 05:16:51 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On VM entry, we disable access to the VFP registers in order to
perform a lazy save/restore of these registers.

On VM exit, we restore access, test if we did enable them before,
and save/restore the guest/host registers if necessary. In this
sequence, the FPEXC register is always accessed, irrespective
of the trapping configuration.

If the guest didn't touch the VFP registers, then the HCPTR access
has now enabled such access, but we're missing a barrier to ensure
architectural execution of the new HCPTR configuration. If the HCPTR
access has been delayed/reordered, the subsequent access to FPEXC
will cause a trap, which we aren't prepared to handle at all.

The same condition exists when trapping to enable VFP for the guest.

The fix is to introduce a barrier after enabling VFP access. In the
vmexit case, it can be relaxed to only takes place if the guest hasn't
accessed its view of the VFP registers, making the access to FPEXC safe.

The set_hcptr macro is modified to deal with both vmenter/vmexit and
vmtrap operations, and now takes an optional label that is branched to
when the guest hasn't touched the VFP registers.

Reported-by: Vikram Sethi <vikrams@codeaurora.org>
Cc: stable@kernel.org	# v3.9+
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
* From v1:
  - Changed from a discrete fix to be integrated in set_hcptr
  - Also introduce an ISB on vmtrap (reported by Vikram)
  - Dropped Christoffer Reviewed-by, due to significant changes

 arch/arm/kvm/interrupts.S      | 10 ++++------
 arch/arm/kvm/interrupts_head.S | 20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 79caf79..f7db3a5 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -170,13 +170,9 @@ __kvm_vcpu_return:
 	@ Don't trap coprocessor accesses for host kernel
 	set_hstr vmexit
 	set_hdcr vmexit
-	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
+	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
 
 #ifdef CONFIG_VFPv3
-	@ Save floating point registers we if let guest use them.
-	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
-	bne	after_vfp_restore
-
 	@ Switch VFP/NEON hardware state to the host's
 	add	r7, vcpu, #VCPU_VFP_GUEST
 	store_vfp_state r7
@@ -188,6 +184,8 @@ after_vfp_restore:
 	@ Restore FPEXC_EN which we clobbered on entry
 	pop	{r2}
 	VFPFMXR FPEXC, r2
+#else
+after_vfp_restore:
 #endif
 
 	@ Reset Hyp-role
@@ -483,7 +481,7 @@ switch_to_guest_vfp:
 	push	{r3-r7}
 
 	@ NEON/VFP used.  Turn on VFP access.
-	set_hcptr vmexit, (HCPTR_TCP(10) | HCPTR_TCP(11))
+	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
 
 	@ Switch VFP/NEON hardware state to the guest's
 	add	r7, r0, #VCPU_VFP_HOST
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 35e4a3a..48efe2e 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -591,8 +591,13 @@ ARM_BE8(rev	r6, r6  )
 .endm
 
 /* Configures the HCPTR (Hyp Coprocessor Trap Register) on entry/return
- * (hardware reset value is 0). Keep previous value in r2. */
-.macro set_hcptr operation, mask
+ * (hardware reset value is 0). Keep previous value in r2.
+ * An ISB is emited on vmexit/vmtrap, but executed on vmexit only if
+ * VFP wasn't already enabled (always executed on vmtrap).
+ * If a label is specified with vmexit, it is branched to if VFP wasn't
+ * enabled.
+ */
+.macro set_hcptr operation, mask, label = none
 	mrc	p15, 4, r2, c1, c1, 2
 	ldr	r3, =\mask
 	.if \operation == vmentry
@@ -601,6 +606,17 @@ ARM_BE8(rev	r6, r6  )
 	bic	r3, r2, r3		@ Don't trap defined coproc-accesses
 	.endif
 	mcr	p15, 4, r3, c1, c1, 2
+	.if \operation != vmentry
+	.if \operation == vmexit
+	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
+	beq	1f
+	.endif
+	isb
+	.if \label != none
+	b	\label
+	.endif
+1:
+	.endif
 .endm
 
 /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
-- 
2.1.4
