From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 10/15] KVM: arm: implement world switch for debug registers
Date: Mon, 10 Aug 2015 21:26:02 +0800
Message-ID: <1439213167-8988-11-git-send-email-zhichao.huang@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 341A65A799
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:15:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v2-OZx0E6dt4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:15:21 -0400 (EDT)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
 [209.85.220.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E34FB5A6C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:15:20 -0400 (EDT)
Received: by pabyb7 with SMTP id yb7so106849348pab.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:28:21 -0700 (PDT)
In-Reply-To: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Implement switching of the debug registers. While the number
of registers is massive, CPUs usually don't implement them all
(A15 has 6 breakpoints and 4 watchpoints, which gives us a total
of 22 registers "only").

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/interrupts_head.S | 170 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 159 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 7ac5e51..b9e7410 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -5,6 +5,7 @@
 #define VCPU_USR_SP		(VCPU_USR_REG(13))
 #define VCPU_USR_LR		(VCPU_USR_REG(14))
 #define CP15_OFFSET(_cp15_reg_idx) (VCPU_CP15 + (_cp15_reg_idx * 4))
+#define CP14_OFFSET(_cp14_reg_idx) ((_cp14_reg_idx) * 4)
 
 /*
  * Many of these macros need to access the VCPU structure, which is always
@@ -239,6 +240,136 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	save_guest_regs_mode irq, #VCPU_IRQ_REGS
 .endm
 
+/* Assume r10/r11/r12 are in use, clobbers r2-r3 */
+.macro cp14_read_and_str base Op2 cp14_reg0 skip_num
+	adr	r3, 1f
+	add	r3, r3, \skip_num, lsl #3
+	bx	r3
+1:
+	mrc	p14, 0, r2, c0, c15, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+15)]
+	mrc	p14, 0, r2, c0, c14, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+14)]
+	mrc	p14, 0, r2, c0, c13, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+13)]
+	mrc	p14, 0, r2, c0, c12, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+12)]
+	mrc	p14, 0, r2, c0, c11, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+11)]
+	mrc	p14, 0, r2, c0, c10, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+10)]
+	mrc	p14, 0, r2, c0, c9, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+9)]
+	mrc	p14, 0, r2, c0, c8, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+8)]
+	mrc	p14, 0, r2, c0, c7, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+7)]
+	mrc	p14, 0, r2, c0, c6, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+6)]
+	mrc	p14, 0, r2, c0, c5, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+5)]
+	mrc	p14, 0, r2, c0, c4, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+4)]
+	mrc	p14, 0, r2, c0, c3, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+3)]
+	mrc	p14, 0, r2, c0, c2, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+2)]
+	mrc	p14, 0, r2, c0, c1, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0+1)]
+	mrc	p14, 0, r2, c0, c0, \Op2
+	str     r2, [\base, #CP14_OFFSET(\cp14_reg0)]
+.endm
+
+/* Assume r11/r12 are in use, clobbers r2-r3 */
+.macro cp14_ldr_and_write base Op2 cp14_reg0 skip_num
+	adr	r3, 1f
+	add	r3, r3, \skip_num, lsl #3
+	bx	r3
+1:
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+15)]
+	mcr	p14, 0, r2, c0, c15, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+14)]
+	mcr	p14, 0, r2, c0, c14, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+13)]
+	mcr	p14, 0, r2, c0, c13, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+12)]
+	mcr	p14, 0, r2, c0, c12, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+11)]
+	mcr	p14, 0, r2, c0, c11, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+10)]
+	mcr	p14, 0, r2, c0, c10, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+9)]
+	mcr	p14, 0, r2, c0, c9, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+8)]
+	mcr	p14, 0, r2, c0, c8, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+7)]
+	mcr	p14, 0, r2, c0, c7, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+6)]
+	mcr	p14, 0, r2, c0, c6, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+5)]
+	mcr	p14, 0, r2, c0, c5, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+4)]
+	mcr	p14, 0, r2, c0, c4, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+3)]
+	mcr	p14, 0, r2, c0, c3, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+2)]
+	mcr	p14, 0, r2, c0, c2, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0+1)]
+	mcr	p14, 0, r2, c0, c1, \Op2
+	ldr     r2, [\base, #CP14_OFFSET(\cp14_reg0)]
+	mcr	p14, 0, r2, c0, c0, \Op2
+.endm
+
+/* Get extract number of BRPs and WRPs. Saved in r11/r12 */
+.macro read_hw_dbg_num
+	mrc	p14, 0, r2, c0, c0, 0
+	ubfx	r11, r2, #24, #4
+	add	r11, r11, #1		@ Extract BRPs
+	ubfx	r12, r2, #28, #4
+	add	r12, r12, #1		@ Extract WRPs
+	mov	r2, #16
+	sub	r11, r2, r11		@ How many BPs to skip
+	sub	r12, r2, r12		@ How many WPs to skip
+.endm
+
+/* Reads cp14 registers from hardware.
+ * Writes cp14 registers in-order to the CP14 struct pointed to by r10
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r2-r12
+ */
+.macro save_debug_state
+	read_hw_dbg_num
+	cp14_read_and_str r10, 4, cp14_DBGBVR0, r11
+	cp14_read_and_str r10, 5, cp14_DBGBCR0, r11
+	cp14_read_and_str r10, 6, cp14_DBGWVR0, r12
+	cp14_read_and_str r10, 7, cp14_DBGWCR0, r12
+
+	/* DBGDSCR reg */
+	mrc	p14, 0, r2, c0, c1, 0
+	str	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
+.endm
+
+/* Reads cp14 registers in-order from the CP14 struct pointed to by r10
+ * Writes cp14 registers to hardware.
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r2-r12
+ */
+.macro restore_debug_state
+	read_hw_dbg_num
+	cp14_ldr_and_write r10, 4, cp14_DBGBVR0, r11
+	cp14_ldr_and_write r10, 5, cp14_DBGBCR0, r11
+	cp14_ldr_and_write r10, 6, cp14_DBGWVR0, r12
+	cp14_ldr_and_write r10, 7, cp14_DBGWCR0, r12
+
+	/* DBGDSCR reg */
+	ldr	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
+	mcr	p14, 0, r2, c0, c2, 2
+.endm
+
 /* Reads cp14/cp15 registers from hardware and stores them in memory
  * @store_to_vcpu: If 0, registers are written in-order to the stack,
  * 		   otherwise to the VCPU struct pointed to by vcpup
@@ -248,11 +379,17 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Clobbers r2 - r12
  */
 .macro read_coproc_state store_to_vcpu
-	.if \store_to_vcpu == 0
-	mrc	p14, 0, r2, c0, c1, 0	@ DBGDSCR
-	push	{r2}
+	.if \store_to_vcpu == 1
+	add	r10, vcpu, #VCPU_CP14
+	.else
+	add	r10, vcpu, #VCPU_HOST_CONTEXT
+	ldr	r10, [r10]
+	add	r10, r10, #VCPU_CP14_HOST
 	.endif
 
+	/* Assumes r10 pointer in cp14 regs  */
+	bl __save_debug_state
+
 	mrc	p15, 0, r2, c1, c0, 0	@ SCTLR
 	mrc	p15, 0, r3, c1, c0, 2	@ CPACR
 	mrc	p15, 0, r4, c2, c0, 2	@ TTBCR
@@ -331,6 +468,17 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Assumes vcpu pointer in vcpu reg
  */
 .macro write_coproc_state read_from_vcpu
+	.if \read_from_vcpu == 1
+	add	r10, vcpu, #VCPU_CP14
+	.else
+	add	r10, vcpu, #VCPU_HOST_CONTEXT
+	ldr	r10, [r10]
+	add	r10, r10, #VCPU_CP14_HOST
+	.endif
+
+	/* Assumes r10 pointer in cp14 regs  */
+	bl __restore_debug_state
+
 	.if \read_from_vcpu == 0
 	pop	{r2,r4-r7}
 	.else
@@ -399,14 +547,6 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	mcr	p15, 0, r10, c10, c2, 0	@ PRRR
 	mcr	p15, 0, r11, c10, c2, 1	@ NMRR
 	mcr	p15, 2, r12, c0, c0, 0	@ CSSELR
-
-	.if \read_from_vcpu == 0
-	pop	{r2}
-	.else
-	mov	r2, #0
-	.endif
-
-	mcr	p14, 0, r2, c0, c2, 2	@ DBGDSCR
 .endm
 
 /*
@@ -657,3 +797,11 @@ ARM_BE8(rev	r6, r6  )
 .macro load_vcpu
 	mrc	p15, 4, vcpu, c13, c0, 2	@ HTPIDR
 .endm
+
+__save_debug_state:
+	save_debug_state
+	bx	lr
+
+__restore_debug_state:
+	restore_debug_state
+	bx	lr
-- 
1.7.12.4
