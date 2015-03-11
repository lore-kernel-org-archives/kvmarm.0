From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}
Date: Wed, 11 Mar 2015 15:23:00 +0100
Message-ID: <1426083780-27588-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0203D48704
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:16:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gD-LdJb6MEyj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 10:16:25 -0400 (EDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
 [209.85.217.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2ED7C486F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:16:24 -0400 (EDT)
Received: by lbiw7 with SMTP id w7so9196738lbi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 07:22:44 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We can definitely decide at run-time whether to use the GIC and timers
or not, and the extra code and data structures that we allocate space
for is really negligable with this config option, so I don't think it's
worth the extra complexity of always having to define stub static
inlines.  The !CONFIG_KVM_ARM_VGIC/TIMER case is pretty much an untested
code path anyway, so we're better off just getting rid of it.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
This depends on Paolo's patch:
KVM: arm/arm64: prefer IS_ENABLED to a static variable

I've applied it to queue together with Eric's IRQFD series.

 arch/arm/kernel/asm-offsets.c  |  4 --
 arch/arm/kvm/Kconfig           | 29 +++-----------
 arch/arm/kvm/Makefile          |  8 ++--
 arch/arm/kvm/arm.c             |  6 ---
 arch/arm/kvm/guest.c           | 18 ---------
 arch/arm/kvm/interrupts_head.S |  8 ----
 arch/arm64/kvm/Kconfig         | 17 +--------
 arch/arm64/kvm/Makefile        | 16 ++++----
 include/kvm/arm_arch_timer.h   | 31 ---------------
 include/kvm/arm_vgic.h         | 85 ------------------------------------------
 10 files changed, 20 insertions(+), 202 deletions(-)

diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 2d2d608..488eaac 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -190,7 +190,6 @@ int main(void)
   DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
   DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
   DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
-#ifdef CONFIG_KVM_ARM_VGIC
   DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
   DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
   DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
@@ -200,14 +199,11 @@ int main(void)
   DEFINE(VGIC_V2_CPU_APR,	offsetof(struct vgic_cpu, vgic_v2.vgic_apr));
   DEFINE(VGIC_V2_CPU_LR,	offsetof(struct vgic_cpu, vgic_v2.vgic_lr));
   DEFINE(VGIC_CPU_NR_LR,	offsetof(struct vgic_cpu, nr_lr));
-#ifdef CONFIG_KVM_ARM_TIMER
   DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
   DEFINE(VCPU_TIMER_CNTV_CVAL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_cval));
   DEFINE(KVM_TIMER_CNTVOFF,	offsetof(struct kvm, arch.timer.cntvoff));
   DEFINE(KVM_TIMER_ENABLED,	offsetof(struct kvm, arch.timer.enabled));
-#endif
   DEFINE(KVM_VGIC_VCTRL,	offsetof(struct kvm, arch.vgic.vctrl_base));
-#endif
   DEFINE(KVM_VTTBR,		offsetof(struct kvm, arch.vttbr));
 #endif
   return 0; 
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 338ace7..7b6347b 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -18,6 +18,7 @@ if VIRTUALIZATION
 
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
+	depends on MMU && OF
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
@@ -26,10 +27,11 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
-	depends on ARM_VIRT_EXT && ARM_LPAE
+	select MMU_NOTIFIER
+	select HAVE_KVM_IRQCHIP
+	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
-	  Support hosting virtualized guest machines. You will also
-	  need to select one or more of the processor modules below.
+	  Support hosting virtualized guest machines.
 
 	  This module provides access to the hardware capabilities through
 	  a character device node named /dev/kvm.
@@ -37,10 +39,7 @@ config KVM
 	  If unsure, say N.
 
 config KVM_ARM_HOST
-	bool "KVM host support for ARM cpus."
-	depends on KVM
-	depends on MMU
-	select	MMU_NOTIFIER
+	bool
 	---help---
 	  Provides host support for ARM processors.
 
@@ -55,20 +54,4 @@ config KVM_ARM_MAX_VCPUS
 	  large, so only choose a reasonable number that you expect to
 	  actually use.
 
-config KVM_ARM_VGIC
-	bool "KVM support for Virtual GIC"
-	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
-	default y
-	---help---
-	  Adds support for a hardware assisted, in-kernel GIC emulation.
-
-config KVM_ARM_TIMER
-	bool "KVM support for Architected Timers"
-	depends on KVM_ARM_VGIC && ARM_ARCH_TIMER
-	select HAVE_KVM_IRQCHIP
-	default y
-	---help---
-	  Adds support for the Architected Timers in virtual machines
-
 endif # VIRTUALIZATION
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 443b8be..60be7be 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -20,7 +20,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
 obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
-obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
-obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v2.o
-obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v2-emul.o
-obj-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
+obj-y += $(KVM)/arm/vgic.o
+obj-y += $(KVM)/arm/vgic-v2.o
+obj-y += $(KVM)/arm/vgic-v2-emul.o
+obj-y += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e0e9434..37b46c5 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -170,9 +170,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 	switch (ext) {
-#ifdef CONFIG_KVM_ARM_VGIC
 	case KVM_CAP_IRQCHIP:
-#endif
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
@@ -829,8 +827,6 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 
 	switch (dev_id) {
 	case KVM_ARM_DEVICE_VGIC_V2:
-		if (!IS_ENABLED(CONFIG_KVM_ARM_VGIC))
-			return -ENXIO;
 		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
 	default:
 		return -ENODEV;
@@ -845,8 +841,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
-		if (!IS_ENABLED(CONFIG_KVM_ARM_VGIC))
-			return -ENXIO;
 		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 384bab6..d503fbb 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -109,22 +109,6 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
-#ifndef CONFIG_KVM_ARM_TIMER
-
-#define NUM_TIMER_REGS 0
-
-static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
-{
-	return 0;
-}
-
-static bool is_timer_reg(u64 index)
-{
-	return false;
-}
-
-#else
-
 #define NUM_TIMER_REGS 3
 
 static bool is_timer_reg(u64 index)
@@ -152,8 +136,6 @@ static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return 0;
 }
 
-#endif
-
 static int set_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 14d4883..35e4a3a 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -402,7 +402,6 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Assumes vcpu pointer in vcpu reg
  */
 .macro save_vgic_state
-#ifdef CONFIG_KVM_ARM_VGIC
 	/* Get VGIC VCTRL base into r2 */
 	ldr	r2, [vcpu, #VCPU_KVM]
 	ldr	r2, [r2, #KVM_VGIC_VCTRL]
@@ -460,7 +459,6 @@ ARM_BE8(rev	r6, r6	)
 	subs	r4, r4, #1
 	bne	1b
 2:
-#endif
 .endm
 
 /*
@@ -469,7 +467,6 @@ ARM_BE8(rev	r6, r6	)
  * Assumes vcpu pointer in vcpu reg
  */
 .macro restore_vgic_state
-#ifdef CONFIG_KVM_ARM_VGIC
 	/* Get VGIC VCTRL base into r2 */
 	ldr	r2, [vcpu, #VCPU_KVM]
 	ldr	r2, [r2, #KVM_VGIC_VCTRL]
@@ -501,7 +498,6 @@ ARM_BE8(rev	r6, r6  )
 	subs	r4, r4, #1
 	bne	1b
 2:
-#endif
 .endm
 
 #define CNTHCTL_PL1PCTEN	(1 << 0)
@@ -515,7 +511,6 @@ ARM_BE8(rev	r6, r6  )
  * Clobbers r2-r5
  */
 .macro save_timer_state
-#ifdef CONFIG_KVM_ARM_TIMER
 	ldr	r4, [vcpu, #VCPU_KVM]
 	ldr	r2, [r4, #KVM_TIMER_ENABLED]
 	cmp	r2, #0
@@ -537,7 +532,6 @@ ARM_BE8(rev	r6, r6  )
 	mcrr	p15, 4, r2, r2, c14	@ CNTVOFF
 
 1:
-#endif
 	@ Allow physical timer/counter access for the host
 	mrc	p15, 4, r2, c14, c1, 0	@ CNTHCTL
 	orr	r2, r2, #(CNTHCTL_PL1PCEN | CNTHCTL_PL1PCTEN)
@@ -559,7 +553,6 @@ ARM_BE8(rev	r6, r6  )
 	bic	r2, r2, #CNTHCTL_PL1PCEN
 	mcr	p15, 4, r2, c14, c1, 0	@ CNTHCTL
 
-#ifdef CONFIG_KVM_ARM_TIMER
 	ldr	r4, [vcpu, #VCPU_KVM]
 	ldr	r2, [r4, #KVM_TIMER_ENABLED]
 	cmp	r2, #0
@@ -579,7 +572,6 @@ ARM_BE8(rev	r6, r6  )
 	and	r2, r2, #3
 	mcr	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
 1:
-#endif
 .endm
 
 .equ vmentry,	0
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f5590c8..ee43750 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -18,6 +18,7 @@ if VIRTUALIZATION
 
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
+	depends on OF
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
@@ -25,8 +26,7 @@ config KVM
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
 	select KVM_ARM_HOST
-	select KVM_ARM_VGIC
-	select KVM_ARM_TIMER
+	select HAVE_KVM_IRQCHIP
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
 	---help---
@@ -50,17 +50,4 @@ config KVM_ARM_MAX_VCPUS
 	  large, so only choose a reasonable number that you expect to
 	  actually use.
 
-config KVM_ARM_VGIC
-	bool
-	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
-	---help---
-	  Adds support for a hardware assisted, in-kernel GIC emulation.
-
-config KVM_ARM_TIMER
-	bool
-	depends on KVM_ARM_VGIC
-	---help---
-	  Adds support for the Architected Timers in virtual machines.
-
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 4e6e09e..c92b26a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -19,11 +19,11 @@ kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o reset.o sys_regs.o sys_regs_generic_v8.o
 
-kvm-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
-kvm-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v2.o
-kvm-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v2-emul.o
-kvm-$(CONFIG_KVM_ARM_VGIC) += vgic-v2-switch.o
-kvm-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v3.o
-kvm-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v3-emul.o
-kvm-$(CONFIG_KVM_ARM_VGIC) += vgic-v3-switch.o
-kvm-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2-emul.o
+kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v2-switch.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
+kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index b3f45a5..a74e4c2 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -24,17 +24,14 @@
 #include <linux/workqueue.h>
 
 struct arch_timer_kvm {
-#ifdef CONFIG_KVM_ARM_TIMER
 	/* Is the timer enabled */
 	bool			enabled;
 
 	/* Virtual offset */
 	cycle_t			cntvoff;
-#endif
 };
 
 struct arch_timer_cpu {
-#ifdef CONFIG_KVM_ARM_TIMER
 	/* Registers: control register, timer value */
 	u32				cntv_ctl;	/* Saved/restored */
 	cycle_t				cntv_cval;	/* Saved/restored */
@@ -55,10 +52,8 @@ struct arch_timer_cpu {
 
 	/* Timer IRQ */
 	const struct kvm_irq_level	*irq;
-#endif
 };
 
-#ifdef CONFIG_KVM_ARM_TIMER
 int kvm_timer_hyp_init(void);
 void kvm_timer_enable(struct kvm *kvm);
 void kvm_timer_init(struct kvm *kvm);
@@ -72,30 +67,4 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
 int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
 
-#else
-static inline int kvm_timer_hyp_init(void)
-{
-	return 0;
-};
-
-static inline void kvm_timer_enable(struct kvm *kvm) {}
-static inline void kvm_timer_init(struct kvm *kvm) {}
-static inline void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-					const struct kvm_irq_level *irq) {}
-static inline void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu) {}
-static inline void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu) {}
-static inline void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu) {}
-static inline void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu) {}
-
-static inline int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
-{
-	return 0;
-}
-
-static inline u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
-{
-	return 0;
-}
-#endif
-
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7c55dd5..b81630b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -148,7 +148,6 @@ struct vgic_vm_ops {
 };
 
 struct vgic_dist {
-#ifdef CONFIG_KVM_ARM_VGIC
 	spinlock_t		lock;
 	bool			in_kernel;
 	bool			ready;
@@ -237,7 +236,6 @@ struct vgic_dist {
 	unsigned long		*irq_pending_on_cpu;
 
 	struct vgic_vm_ops	vm_ops;
-#endif
 };
 
 struct vgic_v2_cpu_if {
@@ -265,7 +263,6 @@ struct vgic_v3_cpu_if {
 };
 
 struct vgic_cpu {
-#ifdef CONFIG_KVM_ARM_VGIC
 	/* per IRQ to LR mapping */
 	u8		*vgic_irq_lr_map;
 
@@ -284,7 +281,6 @@ struct vgic_cpu {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
 	};
-#endif
 };
 
 #define LR_EMPTY	0xff
@@ -297,7 +293,6 @@ struct kvm_vcpu;
 struct kvm_run;
 struct kvm_exit_mmio;
 
-#ifdef CONFIG_KVM_ARM_VGIC
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
 int kvm_vgic_hyp_init(void);
 int kvm_vgic_map_resources(struct kvm *kvm);
@@ -334,84 +329,4 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
 }
 #endif
 
-#else
-static inline int kvm_vgic_hyp_init(void)
-{
-	return 0;
-}
-
-static inline int kvm_vgic_set_addr(struct kvm *kvm, unsigned long type, u64 addr)
-{
-	return 0;
-}
-
-static inline int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
-{
-	return -ENXIO;
-}
-
-static inline int kvm_vgic_map_resources(struct kvm *kvm)
-{
-	return 0;
-}
-
-static inline int kvm_vgic_create(struct kvm *kvm, u32 type)
-{
-	return 0;
-}
-
-static inline void kvm_vgic_destroy(struct kvm *kvm)
-{
-}
-
-static inline void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-static inline void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu) {}
-static inline void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu) {}
-
-static inline int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid,
-				      unsigned int irq_num, bool level)
-{
-	return 0;
-}
-
-static inline int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-static inline bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				    struct kvm_exit_mmio *mmio)
-{
-	return false;
-}
-
-static inline int irqchip_in_kernel(struct kvm *kvm)
-{
-	return 0;
-}
-
-static inline bool vgic_initialized(struct kvm *kvm)
-{
-	return true;
-}
-
-static inline bool vgic_ready(struct kvm *kvm)
-{
-	return true;
-}
-
-static inline int kvm_vgic_get_max_vcpus(void)
-{
-	return KVM_MAX_VCPUS;
-}
-#endif
-
 #endif
-- 
2.1.2.330.g565301e.dirty
