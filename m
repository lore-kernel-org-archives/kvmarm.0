From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH 09/10] KVM: arm: implement lazy world switch for debug
 registers
Date: Sat, 16 May 2015 12:45:50 +0800
Message-ID: <1431751551-4788-10-git-send-email-zhichao.huang@linaro.org>
References: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEFBD51839
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2015 00:38:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PQ5r03GQDMWM for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 May 2015 00:38:04 -0400 (EDT)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
 [209.85.192.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C8F651837
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2015 00:38:04 -0400 (EDT)
Received: by pdeq5 with SMTP id q5so45181828pde.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 21:47:16 -0700 (PDT)
In-Reply-To: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Implement switching of the debug registers. While the number
of registers is massive, CPUs usually don't implement them all
(A15 has 6 breakpoints and 4 watchpoints, which gives us a total
of 22 registers "only").

Also, we only save/restore them when DBGDSCR has debug enabled,
or when we've flagged the debug registers as dirty. It means that
most of the time, we only save/restore DBGDSCR.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/interrupts.S      |  16 +++
 arch/arm/kvm/interrupts_head.S | 256 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 272 insertions(+)

diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 79caf79..d626275 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -116,6 +116,12 @@ ENTRY(__kvm_vcpu_run)
 	read_cp15_state store_to_vcpu = 0
 	write_cp15_state read_from_vcpu = 1
 
+	@ Store hardware CP14 state and load guest state
+	compute_debug_state 1f
+	bl __save_host_debug_regs
+	bl __restore_guest_debug_regs
+
+1:
 	@ If the host kernel has not been configured with VFPv3 support,
 	@ then it is safer if we deny guests from using it as well.
 #ifdef CONFIG_VFPv3
@@ -201,6 +207,16 @@ after_vfp_restore:
 	mrc	p15, 0, r2, c0, c0, 5
 	mcr	p15, 4, r2, c0, c0, 5
 
+	@ Store guest CP14 state and restore host state
+	skip_debug_state 1f
+	bl __save_guest_debug_regs
+	bl __restore_host_debug_regs
+	/* Clear the dirty flag for the next run, as all the state has
+	 * already been saved. Note that we nuke the whole 32bit word.
+	 * If we ever add more flags, we'll have to be more careful...
+	 */
+	clear_debug_dirty_bit
+1:
 	@ Store guest CP15 state and restore host state
 	read_cp15_state store_to_vcpu = 1
 	write_cp15_state read_from_vcpu = 0
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 3a0128c..ed406be 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -7,6 +7,7 @@
 #define VCPU_USR_SP		(VCPU_USR_REG(13))
 #define VCPU_USR_LR		(VCPU_USR_REG(14))
 #define CP15_OFFSET(_cp15_reg_idx) (VCPU_CP15 + (_cp15_reg_idx * 4))
+#define CP14_OFFSET(_cp14_reg_idx) (VCPU_CP14 + ((_cp14_reg_idx) * 4))
 
 /*
  * Many of these macros need to access the VCPU structure, which is always
@@ -99,6 +100,10 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	mrs	r8, LR_fiq
 	mrs	r9, SPSR_fiq
 	push	{r2-r9}
+
+	/* DBGDSCR reg */
+	mrc	p14, 0, r2, c0, c1, 0
+	push	{r2}
 .endm
 
 .macro pop_host_regs_mode mode
@@ -113,6 +118,9 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Clobbers all registers, in all modes, except r0 and r1.
  */
 .macro restore_host_regs
+	pop	{r2}
+	mcr	p14, 0, r2, c0, c2, 2
+
 	pop	{r2-r9}
 	msr	r8_fiq, r2
 	msr	r9_fiq, r3
@@ -161,6 +169,9 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Clobbers *all* registers.
  */
 .macro restore_guest_regs
+	ldr	r2, [vcpu, #CP14_OFFSET(cp14_DBGDSCRext)]
+	mcr	p14, 0, r2, c0, c2, 2
+
 	restore_guest_regs_mode svc, #VCPU_SVC_REGS
 	restore_guest_regs_mode abt, #VCPU_ABT_REGS
 	restore_guest_regs_mode und, #VCPU_UND_REGS
@@ -239,6 +250,10 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	save_guest_regs_mode abt, #VCPU_ABT_REGS
 	save_guest_regs_mode und, #VCPU_UND_REGS
 	save_guest_regs_mode irq, #VCPU_IRQ_REGS
+
+	/* DBGDSCR reg */
+	mrc	p14, 0, r2, c0, c1, 0
+	str	r2, [vcpu, #CP14_OFFSET(cp14_DBGDSCRext)]
 .endm
 
 /* Reads cp15 registers from hardware and stores them in memory
@@ -438,6 +453,231 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	str	r5, [vcpu, #VCPU_DEBUG_FLAGS]
 .endm
 
+/* Assume r11/r12 in used, clobbers r2-r10 */
+.macro cp14_read_and_push Op2 skip_num
+	cmp	\skip_num, #8
+	// if (skip_num >= 8) then skip c8-c15 directly
+	bge	1f
+	adr	r2, 9998f
+	add	r2, r2, \skip_num, lsl #2
+	bx	r2
+1:
+	adr	r2, 9999f
+	sub	r3, \skip_num, #8
+	add	r2, r2, r3, lsl #2
+	bx	r2
+9998:
+	mrc	p14, 0, r10, c0, c15, \Op2
+	mrc	p14, 0, r9, c0, c14, \Op2
+	mrc	p14, 0, r8, c0, c13, \Op2
+	mrc	p14, 0, r7, c0, c12, \Op2
+	mrc	p14, 0, r6, c0, c11, \Op2
+	mrc	p14, 0, r5, c0, c10, \Op2
+	mrc	p14, 0, r4, c0, c9, \Op2
+	mrc	p14, 0, r3, c0, c8, \Op2
+	push	{r3-r10}
+9999:
+	mrc	p14, 0, r10, c0, c7, \Op2
+	mrc	p14, 0, r9, c0, c6, \Op2
+	mrc	p14, 0, r8, c0, c5, \Op2
+	mrc	p14, 0, r7, c0, c4, \Op2
+	mrc	p14, 0, r6, c0, c3, \Op2
+	mrc	p14, 0, r5, c0, c2, \Op2
+	mrc	p14, 0, r4, c0, c1, \Op2
+	mrc	p14, 0, r3, c0, c0, \Op2
+	push	{r3-r10}
+.endm
+
+/* Assume r11/r12 in used, clobbers r2-r10 */
+.macro cp14_pop_and_write Op2 skip_num
+	cmp	\skip_num, #8
+	// if (skip_num >= 8) then skip c8-c15 directly
+	bge	1f
+	adr	r2, 9998f
+	add	r2, r2, \skip_num, lsl #2
+	pop	{r3-r10}
+	bx	r2
+1:
+	adr	r2, 9999f
+	sub	r3, \skip_num, #8
+	add	r2, r2, r3, lsl #2
+	pop	{r3-r10}
+	bx	r2
+
+9998:
+	mcr	p14, 0, r10, c0, c15, \Op2
+	mcr	p14, 0, r9, c0, c14, \Op2
+	mcr	p14, 0, r8, c0, c13, \Op2
+	mcr	p14, 0, r7, c0, c12, \Op2
+	mcr	p14, 0, r6, c0, c11, \Op2
+	mcr	p14, 0, r5, c0, c10, \Op2
+	mcr	p14, 0, r4, c0, c9, \Op2
+	mcr	p14, 0, r3, c0, c8, \Op2
+
+	pop	{r3-r10}
+9999:
+	mcr	p14, 0, r10, c0, c7, \Op2
+	mcr	p14, 0, r9, c0, c6, \Op2
+	mcr	p14, 0, r8, c0, c5, \Op2
+	mcr	p14, 0, r7, c0, c4, \Op2
+	mcr	p14, 0, r6, c0, c3, \Op2
+	mcr	p14, 0, r5, c0, c2, \Op2
+	mcr	p14, 0, r4, c0, c1, \Op2
+	mcr	p14, 0, r3, c0, c0, \Op2
+.endm
+
+/* Assume r11/r12 in used, clobbers r2-r3 */
+.macro cp14_read_and_str Op2 cp14_reg0 skip_num
+	adr	r3, 1f
+	add	r3, r3, \skip_num, lsl #3
+	bx	r3
+1:
+	mrc	p14, 0, r2, c0, c15, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+15)]
+	mrc	p14, 0, r2, c0, c14, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+14)]
+	mrc	p14, 0, r2, c0, c13, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+13)]
+	mrc	p14, 0, r2, c0, c12, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+12)]
+	mrc	p14, 0, r2, c0, c11, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+11)]
+	mrc	p14, 0, r2, c0, c10, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+10)]
+	mrc	p14, 0, r2, c0, c9, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+9)]
+	mrc	p14, 0, r2, c0, c8, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+8)]
+	mrc	p14, 0, r2, c0, c7, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+7)]
+	mrc	p14, 0, r2, c0, c6, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+6)]
+	mrc	p14, 0, r2, c0, c5, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+5)]
+	mrc	p14, 0, r2, c0, c4, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+4)]
+	mrc	p14, 0, r2, c0, c3, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+3)]
+	mrc	p14, 0, r2, c0, c2, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+2)]
+	mrc	p14, 0, r2, c0, c1, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+1)]
+	mrc	p14, 0, r2, c0, c0, \Op2
+	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0)]
+.endm
+
+/* Assume r11/r12 in used, clobbers r2-r3 */
+.macro cp14_ldr_and_write Op2 cp14_reg0 skip_num
+	adr	r3, 1f
+	add	r3, r3, \skip_num, lsl #3
+	bx	r3
+1:
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+15)]
+	mcr	p14, 0, r2, c0, c15, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+14)]
+	mcr	p14, 0, r2, c0, c14, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+13)]
+	mcr	p14, 0, r2, c0, c13, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+12)]
+	mcr	p14, 0, r2, c0, c12, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+11)]
+	mcr	p14, 0, r2, c0, c11, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+10)]
+	mcr	p14, 0, r2, c0, c10, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+9)]
+	mcr	p14, 0, r2, c0, c9, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+8)]
+	mcr	p14, 0, r2, c0, c8, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+7)]
+	mcr	p14, 0, r2, c0, c7, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+6)]
+	mcr	p14, 0, r2, c0, c6, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+5)]
+	mcr	p14, 0, r2, c0, c5, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+4)]
+	mcr	p14, 0, r2, c0, c4, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+3)]
+	mcr	p14, 0, r2, c0, c3, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+2)]
+	mcr	p14, 0, r2, c0, c2, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+1)]
+	mcr	p14, 0, r2, c0, c1, \Op2
+	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0)]
+	mcr	p14, 0, r2, c0, c0, \Op2
+.endm
+
+/* Get extract number of BRPs and WRPs. Saved in r11/r12 */
+.macro read_hw_dbg_num
+	mrc	p14, 0, r2, c0, c0, 0
+	ubfx	r11, r2, #24, #4
+	add	r11, r11, #1		// Extract BRPs
+	ubfx	r12, r2, #28, #4
+	add	r12, r12, #1		// Extract WRPs
+	mov	r2, #16
+	sub	r11, r2, r11		// How many BPs to skip
+	sub	r12, r2, r12		// How many WPs to skip
+.endm
+
+/* Reads cp14 registers from hardware.
+ * Writes cp14 registers in-order to the stack.
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r2-r12
+ */
+.macro save_host_debug_regs
+	read_hw_dbg_num
+	cp14_read_and_push #4, r11	@ DBGBVR
+	cp14_read_and_push #5, r11	@ DBGBCR
+	cp14_read_and_push #6, r12	@ DBGWVR
+	cp14_read_and_push #7, r12	@ DBGWCR
+.endm
+
+/* Reads cp14 registers from hardware.
+ * Writes cp14 registers in-order to the VCPU struct pointed to by vcpup.
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r2-r12
+ */
+.macro save_guest_debug_regs
+	read_hw_dbg_num
+	cp14_read_and_str #4, cp14_DBGBVR0, r11
+	cp14_read_and_str #5, cp14_DBGBCR0, r11
+	cp14_read_and_str #6, cp14_DBGWVR0, r12
+	cp14_read_and_str #7, cp14_DBGWCR0, r12
+.endm
+
+/* Reads cp14 registers in-order from the stack.
+ * Writes cp14 registers to hardware.
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r2-r12
+ */
+.macro restore_host_debug_regs
+	read_hw_dbg_num
+	cp14_pop_and_write #4, r11	@ DBGBVR
+	cp14_pop_and_write #5, r11	@ DBGBCR
+	cp14_pop_and_write #6, r12	@ DBGWVR
+	cp14_pop_and_write #7, r12	@ DBGWCR
+.endm
+
+/* Reads cp14 registers in-order from the VCPU struct pointed to by vcpup
+ * Writes cp14 registers to hardware.
+ *
+ * Assumes vcpu pointer in vcpu reg
+ *
+ * Clobbers r2-r12
+ */
+.macro restore_guest_debug_regs
+	read_hw_dbg_num
+	cp14_ldr_and_write #4, cp14_DBGBVR0, r11
+	cp14_ldr_and_write #5, cp14_DBGBCR0, r11
+	cp14_ldr_and_write #6, cp14_DBGWVR0, r12
+	cp14_ldr_and_write #7, cp14_DBGWCR0, r12
+.endm
+
 /*
  * Save the VGIC CPU state into memory
  *
@@ -673,3 +913,19 @@ ARM_BE8(rev	r6, r6  )
 .macro load_vcpu
 	mrc	p15, 4, vcpu, c13, c0, 2	@ HTPIDR
 .endm
+
+__save_host_debug_regs:
+	save_host_debug_regs
+	bx	lr
+
+__save_guest_debug_regs:
+	save_guest_debug_regs
+	bx	lr
+
+__restore_host_debug_regs:
+	restore_host_debug_regs
+	bx	lr
+
+__restore_guest_debug_regs:
+	restore_guest_debug_regs
+	bx	lr
-- 
1.7.12.4
