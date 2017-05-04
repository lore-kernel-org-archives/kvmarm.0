From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Move shared files to virt/kvm/arm
Date: Thu,  4 May 2017 14:33:11 +0200
Message-ID: <20170504123311.25252-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 868E840A69
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 08:30:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gN1-0WuVTUtk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 08:30:11 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 282A540296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 08:30:10 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id u65so2083232wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 May 2017 05:33:17 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

For some time now we have been having a lot of shared functionality
between the arm and arm64 KVM support in arch/arm, which not only
required a horrible inter-arch reference from the Makefile in
arch/arm64/kvm, but also created confusion for newcomers to the code
base, as was recently seen on the mailing list.

Further, it causes confusion for things like cscope, which needs special
attention to index specific shared files for arm64 from the arm tree.

Move the shared files into virt/kvm/arm and move the trace points along
with it.  When moving the tracepoints we have to modify the way the vgic
creates definitions of the trace points, so we take the chance to
include the VGIC tracepoints in its very own special vgic trace.h file.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
Hi Marc,

What do you think of this?  If you like it, I think we should include it
for this merge window.

Thanks,
-Christoffer

 arch/arm/kvm/Makefile                 |   7 +-
 arch/arm/kvm/trace.h                  | 247 ----------------------------------
 arch/arm64/kvm/Makefile               |   5 +-
 {arch/arm/kvm => virt/kvm/arm}/arm.c  |   0
 {arch/arm/kvm => virt/kvm/arm}/mmio.c |   0
 {arch/arm/kvm => virt/kvm/arm}/mmu.c  |   0
 {arch/arm/kvm => virt/kvm/arm}/perf.c |   0
 {arch/arm/kvm => virt/kvm/arm}/psci.c |   0
 virt/kvm/arm/trace.h                  | 246 +++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/trace.h             |  37 +++++
 virt/kvm/arm/vgic/vgic.c              |   2 +-
 11 files changed, 280 insertions(+), 264 deletions(-)
 rename {arch/arm/kvm => virt/kvm/arm}/arm.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/mmio.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/mmu.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/perf.c (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/psci.c (100%)
 create mode 100644 virt/kvm/arm/vgic/trace.h

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 7b3670c..d9beee65 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -18,9 +18,12 @@ KVM := ../../../virt/kvm
 kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 
 obj-$(CONFIG_KVM_ARM_HOST) += hyp/
+
 obj-y += kvm-arm.o init.o interrupts.o
-obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
-obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o vgic-v3-coproc.o
+obj-y += handle_exit.o guest.o emulate.o reset.o
+obj-y += coproc.o coproc_a15.o coproc_a7.o   vgic-v3-coproc.o
+obj-y += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
+obj-y += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 obj-y += $(KVM)/arm/aarch32.o
 
 obj-y += $(KVM)/arm/vgic/vgic.o
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
index c25a885..fc09437 100644
--- a/arch/arm/kvm/trace.h
+++ b/arch/arm/kvm/trace.h
@@ -6,133 +6,6 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
-/*
- * Tracepoints for entry/exit to guest
- */
-TRACE_EVENT(kvm_entry,
-	TP_PROTO(unsigned long vcpu_pc),
-	TP_ARGS(vcpu_pc),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	vcpu_pc		)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu_pc		= vcpu_pc;
-	),
-
-	TP_printk("PC: 0x%08lx", __entry->vcpu_pc)
-);
-
-TRACE_EVENT(kvm_exit,
-	TP_PROTO(int idx, unsigned int exit_reason, unsigned long vcpu_pc),
-	TP_ARGS(idx, exit_reason, vcpu_pc),
-
-	TP_STRUCT__entry(
-		__field(	int,		idx		)
-		__field(	unsigned int,	exit_reason	)
-		__field(	unsigned long,	vcpu_pc		)
-	),
-
-	TP_fast_assign(
-		__entry->idx			= idx;
-		__entry->exit_reason		= exit_reason;
-		__entry->vcpu_pc		= vcpu_pc;
-	),
-
-	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
-		  __print_symbolic(__entry->idx, kvm_arm_exception_type),
-		  __entry->exit_reason,
-		  __print_symbolic(__entry->exit_reason, kvm_arm_exception_class),
-		  __entry->vcpu_pc)
-);
-
-TRACE_EVENT(kvm_guest_fault,
-	TP_PROTO(unsigned long vcpu_pc, unsigned long hsr,
-		 unsigned long hxfar,
-		 unsigned long long ipa),
-	TP_ARGS(vcpu_pc, hsr, hxfar, ipa),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	vcpu_pc		)
-		__field(	unsigned long,	hsr		)
-		__field(	unsigned long,	hxfar		)
-		__field(   unsigned long long,	ipa		)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu_pc		= vcpu_pc;
-		__entry->hsr			= hsr;
-		__entry->hxfar			= hxfar;
-		__entry->ipa			= ipa;
-	),
-
-	TP_printk("ipa %#llx, hsr %#08lx, hxfar %#08lx, pc %#08lx",
-		  __entry->ipa, __entry->hsr,
-		  __entry->hxfar, __entry->vcpu_pc)
-);
-
-TRACE_EVENT(kvm_access_fault,
-	TP_PROTO(unsigned long ipa),
-	TP_ARGS(ipa),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	ipa		)
-	),
-
-	TP_fast_assign(
-		__entry->ipa		= ipa;
-	),
-
-	TP_printk("IPA: %lx", __entry->ipa)
-);
-
-TRACE_EVENT(kvm_irq_line,
-	TP_PROTO(unsigned int type, int vcpu_idx, int irq_num, int level),
-	TP_ARGS(type, vcpu_idx, irq_num, level),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	type		)
-		__field(	int,		vcpu_idx	)
-		__field(	int,		irq_num		)
-		__field(	int,		level		)
-	),
-
-	TP_fast_assign(
-		__entry->type		= type;
-		__entry->vcpu_idx	= vcpu_idx;
-		__entry->irq_num	= irq_num;
-		__entry->level		= level;
-	),
-
-	TP_printk("Inject %s interrupt (%d), vcpu->idx: %d, num: %d, level: %d",
-		  (__entry->type == KVM_ARM_IRQ_TYPE_CPU) ? "CPU" :
-		  (__entry->type == KVM_ARM_IRQ_TYPE_PPI) ? "VGIC PPI" :
-		  (__entry->type == KVM_ARM_IRQ_TYPE_SPI) ? "VGIC SPI" : "UNKNOWN",
-		  __entry->type, __entry->vcpu_idx, __entry->irq_num, __entry->level)
-);
-
-TRACE_EVENT(kvm_mmio_emulate,
-	TP_PROTO(unsigned long vcpu_pc, unsigned long instr,
-		 unsigned long cpsr),
-	TP_ARGS(vcpu_pc, instr, cpsr),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	vcpu_pc		)
-		__field(	unsigned long,	instr		)
-		__field(	unsigned long,	cpsr		)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu_pc		= vcpu_pc;
-		__entry->instr			= instr;
-		__entry->cpsr			= cpsr;
-	),
-
-	TP_printk("Emulate MMIO at: 0x%08lx (instr: %08lx, cpsr: %08lx)",
-		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
-);
-
 /* Architecturally implementation defined CP15 register access */
 TRACE_EVENT(kvm_emulate_cp15_imp,
 	TP_PROTO(unsigned long Op1, unsigned long Rt1, unsigned long CRn,
@@ -181,87 +54,6 @@ TRACE_EVENT(kvm_wfx,
 		__entry->is_wfe ? 'e' : 'i', __entry->vcpu_pc)
 );
 
-TRACE_EVENT(kvm_unmap_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier unmap hva: %#08lx", __entry->hva)
-);
-
-TRACE_EVENT(kvm_unmap_hva_range,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	start		)
-		__field(	unsigned long,	end		)
-	),
-
-	TP_fast_assign(
-		__entry->start		= start;
-		__entry->end		= end;
-	),
-
-	TP_printk("mmu notifier unmap range: %#08lx -- %#08lx",
-		  __entry->start, __entry->end)
-);
-
-TRACE_EVENT(kvm_set_spte_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier set pte hva: %#08lx", __entry->hva)
-);
-
-TRACE_EVENT(kvm_age_hva,
-	TP_PROTO(unsigned long start, unsigned long end),
-	TP_ARGS(start, end),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	start		)
-		__field(	unsigned long,	end		)
-	),
-
-	TP_fast_assign(
-		__entry->start		= start;
-		__entry->end		= end;
-	),
-
-	TP_printk("mmu notifier age hva: %#08lx -- %#08lx",
-		  __entry->start, __entry->end)
-);
-
-TRACE_EVENT(kvm_test_age_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier test age hva: %#08lx", __entry->hva)
-);
-
 TRACE_EVENT(kvm_hvc,
 	TP_PROTO(unsigned long vcpu_pc, unsigned long r0, unsigned long imm),
 	TP_ARGS(vcpu_pc, r0, imm),
@@ -282,45 +74,6 @@ TRACE_EVENT(kvm_hvc,
 		  __entry->vcpu_pc, __entry->r0, __entry->imm)
 );
 
-TRACE_EVENT(kvm_set_way_flush,
-	    TP_PROTO(unsigned long vcpu_pc, bool cache),
-	    TP_ARGS(vcpu_pc, cache),
-
-	    TP_STRUCT__entry(
-		    __field(	unsigned long,	vcpu_pc		)
-		    __field(	bool,		cache		)
-	    ),
-
-	    TP_fast_assign(
-		    __entry->vcpu_pc		= vcpu_pc;
-		    __entry->cache		= cache;
-	    ),
-
-	    TP_printk("S/W flush at 0x%016lx (cache %s)",
-		      __entry->vcpu_pc, __entry->cache ? "on" : "off")
-);
-
-TRACE_EVENT(kvm_toggle_cache,
-	    TP_PROTO(unsigned long vcpu_pc, bool was, bool now),
-	    TP_ARGS(vcpu_pc, was, now),
-
-	    TP_STRUCT__entry(
-		    __field(	unsigned long,	vcpu_pc		)
-		    __field(	bool,		was		)
-		    __field(	bool,		now		)
-	    ),
-
-	    TP_fast_assign(
-		    __entry->vcpu_pc		= vcpu_pc;
-		    __entry->was		= was;
-		    __entry->now		= now;
-	    ),
-
-	    TP_printk("VM op at 0x%016lx (cache was %s, now %s)",
-		      __entry->vcpu_pc, __entry->was ? "on" : "off",
-		      __entry->now ? "on" : "off")
-);
-
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index afd51be..5d98100 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -7,14 +7,13 @@ CFLAGS_arm.o := -I.
 CFLAGS_mmu.o := -I.
 
 KVM=../../../virt/kvm
-ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp/
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
diff --git a/arch/arm/kvm/arm.c b/virt/kvm/arm/arm.c
similarity index 100%
rename from arch/arm/kvm/arm.c
rename to virt/kvm/arm/arm.c
diff --git a/arch/arm/kvm/mmio.c b/virt/kvm/arm/mmio.c
similarity index 100%
rename from arch/arm/kvm/mmio.c
rename to virt/kvm/arm/mmio.c
diff --git a/arch/arm/kvm/mmu.c b/virt/kvm/arm/mmu.c
similarity index 100%
rename from arch/arm/kvm/mmu.c
rename to virt/kvm/arm/mmu.c
diff --git a/arch/arm/kvm/perf.c b/virt/kvm/arm/perf.c
similarity index 100%
rename from arch/arm/kvm/perf.c
rename to virt/kvm/arm/perf.c
diff --git a/arch/arm/kvm/psci.c b/virt/kvm/arm/psci.c
similarity index 100%
rename from arch/arm/kvm/psci.c
rename to virt/kvm/arm/psci.c
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 37d8b98..f7dc5dd 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -7,26 +7,250 @@
 #define TRACE_SYSTEM kvm
 
 /*
- * Tracepoints for vgic
+ * Tracepoints for entry/exit to guest
  */
-TRACE_EVENT(vgic_update_irq_pending,
-	TP_PROTO(unsigned long vcpu_id, __u32 irq, bool level),
-	TP_ARGS(vcpu_id, irq, level),
+TRACE_EVENT(kvm_entry,
+	TP_PROTO(unsigned long vcpu_pc),
+	TP_ARGS(vcpu_pc),
 
 	TP_STRUCT__entry(
-		__field(	unsigned long,	vcpu_id	)
-		__field(	__u32,		irq	)
-		__field(	bool,		level	)
+		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
-		__entry->vcpu_id	= vcpu_id;
-		__entry->irq		= irq;
+		__entry->vcpu_pc		= vcpu_pc;
+	),
+
+	TP_printk("PC: 0x%08lx", __entry->vcpu_pc)
+);
+
+TRACE_EVENT(kvm_exit,
+	TP_PROTO(int idx, unsigned int exit_reason, unsigned long vcpu_pc),
+	TP_ARGS(idx, exit_reason, vcpu_pc),
+
+	TP_STRUCT__entry(
+		__field(	int,		idx		)
+		__field(	unsigned int,	exit_reason	)
+		__field(	unsigned long,	vcpu_pc		)
+	),
+
+	TP_fast_assign(
+		__entry->idx			= idx;
+		__entry->exit_reason		= exit_reason;
+		__entry->vcpu_pc		= vcpu_pc;
+	),
+
+	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
+		  __print_symbolic(__entry->idx, kvm_arm_exception_type),
+		  __entry->exit_reason,
+		  __print_symbolic(__entry->exit_reason, kvm_arm_exception_class),
+		  __entry->vcpu_pc)
+);
+
+TRACE_EVENT(kvm_guest_fault,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long hsr,
+		 unsigned long hxfar,
+		 unsigned long long ipa),
+	TP_ARGS(vcpu_pc, hsr, hxfar, ipa),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_pc		)
+		__field(	unsigned long,	hsr		)
+		__field(	unsigned long,	hxfar		)
+		__field(   unsigned long long,	ipa		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc		= vcpu_pc;
+		__entry->hsr			= hsr;
+		__entry->hxfar			= hxfar;
+		__entry->ipa			= ipa;
+	),
+
+	TP_printk("ipa %#llx, hsr %#08lx, hxfar %#08lx, pc %#08lx",
+		  __entry->ipa, __entry->hsr,
+		  __entry->hxfar, __entry->vcpu_pc)
+);
+
+TRACE_EVENT(kvm_access_fault,
+	TP_PROTO(unsigned long ipa),
+	TP_ARGS(ipa),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	ipa		)
+	),
+
+	TP_fast_assign(
+		__entry->ipa		= ipa;
+	),
+
+	TP_printk("IPA: %lx", __entry->ipa)
+);
+
+TRACE_EVENT(kvm_irq_line,
+	TP_PROTO(unsigned int type, int vcpu_idx, int irq_num, int level),
+	TP_ARGS(type, vcpu_idx, irq_num, level),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	type		)
+		__field(	int,		vcpu_idx	)
+		__field(	int,		irq_num		)
+		__field(	int,		level		)
+	),
+
+	TP_fast_assign(
+		__entry->type		= type;
+		__entry->vcpu_idx	= vcpu_idx;
+		__entry->irq_num	= irq_num;
 		__entry->level		= level;
 	),
 
-	TP_printk("VCPU: %ld, IRQ %d, level: %d",
-		  __entry->vcpu_id, __entry->irq, __entry->level)
+	TP_printk("Inject %s interrupt (%d), vcpu->idx: %d, num: %d, level: %d",
+		  (__entry->type == KVM_ARM_IRQ_TYPE_CPU) ? "CPU" :
+		  (__entry->type == KVM_ARM_IRQ_TYPE_PPI) ? "VGIC PPI" :
+		  (__entry->type == KVM_ARM_IRQ_TYPE_SPI) ? "VGIC SPI" : "UNKNOWN",
+		  __entry->type, __entry->vcpu_idx, __entry->irq_num, __entry->level)
+);
+
+TRACE_EVENT(kvm_mmio_emulate,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long instr,
+		 unsigned long cpsr),
+	TP_ARGS(vcpu_pc, instr, cpsr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_pc		)
+		__field(	unsigned long,	instr		)
+		__field(	unsigned long,	cpsr		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc		= vcpu_pc;
+		__entry->instr			= instr;
+		__entry->cpsr			= cpsr;
+	),
+
+	TP_printk("Emulate MMIO at: 0x%08lx (instr: %08lx, cpsr: %08lx)",
+		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
+);
+
+TRACE_EVENT(kvm_unmap_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier unmap hva: %#08lx", __entry->hva)
+);
+
+TRACE_EVENT(kvm_unmap_hva_range,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier unmap range: %#08lx -- %#08lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_set_spte_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier set pte hva: %#08lx", __entry->hva)
+);
+
+TRACE_EVENT(kvm_age_hva,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier age hva: %#08lx -- %#08lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_test_age_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier test age hva: %#08lx", __entry->hva)
+);
+
+TRACE_EVENT(kvm_set_way_flush,
+	    TP_PROTO(unsigned long vcpu_pc, bool cache),
+	    TP_ARGS(vcpu_pc, cache),
+
+	    TP_STRUCT__entry(
+		    __field(	unsigned long,	vcpu_pc		)
+		    __field(	bool,		cache		)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->vcpu_pc		= vcpu_pc;
+		    __entry->cache		= cache;
+	    ),
+
+	    TP_printk("S/W flush at 0x%016lx (cache %s)",
+		      __entry->vcpu_pc, __entry->cache ? "on" : "off")
+);
+
+TRACE_EVENT(kvm_toggle_cache,
+	    TP_PROTO(unsigned long vcpu_pc, bool was, bool now),
+	    TP_ARGS(vcpu_pc, was, now),
+
+	    TP_STRUCT__entry(
+		    __field(	unsigned long,	vcpu_pc		)
+		    __field(	bool,		was		)
+		    __field(	bool,		now		)
+	    ),
+
+	    TP_fast_assign(
+		    __entry->vcpu_pc		= vcpu_pc;
+		    __entry->was		= was;
+		    __entry->now		= now;
+	    ),
+
+	    TP_printk("VM op at 0x%016lx (cache was %s, now %s)",
+		      __entry->vcpu_pc, __entry->was ? "on" : "off",
+		      __entry->now ? "on" : "off")
 );
 
 /*
diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
new file mode 100644
index 0000000..ed32292
--- /dev/null
+++ b/virt/kvm/arm/vgic/trace.h
@@ -0,0 +1,37 @@
+#if !defined(_TRACE_VGIC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VGIC_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+TRACE_EVENT(vgic_update_irq_pending,
+	TP_PROTO(unsigned long vcpu_id, __u32 irq, bool level),
+	TP_ARGS(vcpu_id, irq, level),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_id	)
+		__field(	__u32,		irq	)
+		__field(	bool,		level	)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->irq		= irq;
+		__entry->level		= level;
+	),
+
+	TP_printk("VCPU: %ld, IRQ %d, level: %d",
+		  __entry->vcpu_id, __entry->irq, __entry->level)
+);
+
+#endif /* _TRACE_VGIC_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm/vgic
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 3d0979c..d40210a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -21,7 +21,7 @@
 #include "vgic.h"
 
 #define CREATE_TRACE_POINTS
-#include "../trace.h"
+#include "trace.h"
 
 #ifdef CONFIG_DEBUG_SPINLOCK
 #define DEBUG_SPINLOCK_BUG_ON(p) BUG_ON(p)
-- 
2.9.0
