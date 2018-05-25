From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 12/15] ARM: KVM: invalidate icache on guest exit for
 Cortex-A15
Date: Fri, 25 May 2018 15:01:24 +0100
Message-ID: <E1fMDHY-00073s-7i@rmk-PC.armlinux.org.uk>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180525135938.GE17671@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

In order to avoid aliasing attacks against the branch predictor
on Cortex-A15, let's invalidate the BTB on guest exit, which can
only be done by invalidating the icache (with ACTLR[0] being set).

We use the same hack as for A12/A17 to perform the vector decoding.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/include/asm/kvm_mmu.h |  5 +++++
 arch/arm/kvm/hyp/hyp-entry.S   | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index d08ce9c41df4..48edb1f4ced4 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -306,6 +306,11 @@ static inline void *kvm_get_hyp_vector(void)
 		return kvm_ksym_ref(__kvm_hyp_vector_bp_inv);
 	}
 
+	case ARM_CPU_PART_CORTEX_A15:
+	{
+		extern char __kvm_hyp_vector_ic_inv[];
+		return kvm_ksym_ref(__kvm_hyp_vector_ic_inv);
+	}
 #endif
 	default:
 	{
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index e789f52a5129..918a05dd2d63 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -73,6 +73,28 @@
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	.align 5
+__kvm_hyp_vector_ic_inv:
+	.global __kvm_hyp_vector_ic_inv
+
+	/*
+	 * We encode the exception entry in the bottom 3 bits of
+	 * SP, and we have to guarantee to be 8 bytes aligned.
+	 */
+	W(add)	sp, sp, #1	/* Reset 	  7 */
+	W(add)	sp, sp, #1	/* Undef	  6 */
+	W(add)	sp, sp, #1	/* Syscall	  5 */
+	W(add)	sp, sp, #1	/* Prefetch abort 4 */
+	W(add)	sp, sp, #1	/* Data abort	  3 */
+	W(add)	sp, sp, #1	/* HVC		  2 */
+	W(add)	sp, sp, #1	/* IRQ		  1 */
+	W(nop)			/* FIQ		  0 */
+
+	mcr	p15, 0, r0, c7, c5, 0	/* ICIALLU */
+	isb
+
+	b	decode_vectors
+
+	.align 5
 __kvm_hyp_vector_bp_inv:
 	.global __kvm_hyp_vector_bp_inv
 
@@ -92,6 +114,8 @@
 	mcr	p15, 0, r0, c7, c5, 6	/* BPIALL */
 	isb
 
+decode_vectors:
+
 #ifdef CONFIG_THUMB2_KERNEL
 	/*
 	 * Yet another silly hack: Use VPIDR as a temp register.
-- 
2.7.4
