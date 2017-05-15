From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 04/11] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Mon, 15 May 2017 18:43:52 +0100
Message-ID: <20170515174400.29735-5-james.morse@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515174400.29735-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that KVM uses tpidr_el2 in the same way as Linux's cpu_offset in
tpidr_el1, merge the two. This saves KVM from save/restoring tpidr_el1
on VHE hosts, and allows future code to blindly access per-cpu variables
without triggering world-switch.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm64/include/asm/assembler.h |  8 ++++++++
 arch/arm64/include/asm/percpu.h    | 11 +++++++++--
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/cpufeature.c     | 22 ++++++++++++++++++++++
 arch/arm64/mm/proc.S               |  8 ++++++++
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 1b67c3782d00..06252602901e 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -236,7 +236,11 @@ lr	.req	x30		// link register
 	 */
 	.macro adr_this_cpu, dst, sym, tmp
 	adr_l	\dst, \sym
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	\tmp, tpidr_el1
+alternative_else
+	mrs	\tmp, tpidr_el2
+alternative_endif
 	add	\dst, \dst, \tmp
 	.endm
 
@@ -247,7 +251,11 @@ lr	.req	x30		// link register
 	 */
 	.macro ldr_this_cpu dst, sym, tmp
 	adr_l	\dst, \sym
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	\tmp, tpidr_el1
+alternative_else
+	mrs	\tmp, tpidr_el2
+alternative_endif
 	ldr	\dst, [\dst, \tmp]
 	.endm
 
diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 3bd498e4de4c..43393208229e 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -16,11 +16,15 @@
 #ifndef __ASM_PERCPU_H
 #define __ASM_PERCPU_H
 
+#include <asm/alternative.h>
 #include <asm/stack_pointer.h>
 
 static inline void set_my_cpu_offset(unsigned long off)
 {
-	asm volatile("msr tpidr_el1, %0" :: "r" (off) : "memory");
+	asm volatile(ALTERNATIVE("msr tpidr_el1, %0",
+				 "msr tpidr_el2, %0",
+				 ARM64_HAS_VIRT_HOST_EXTN)
+			:: "r" (off) : "memory");
 }
 
 static inline unsigned long __my_cpu_offset(void)
@@ -31,7 +35,10 @@ static inline unsigned long __my_cpu_offset(void)
 	 * We want to allow caching the value, so avoid using volatile and
 	 * instead use a fake stack read to hazard against barrier().
 	 */
-	asm("mrs %0, tpidr_el1" : "=r" (off) :
+	asm(ALTERNATIVE("mrs %0, tpidr_el1",
+			"mrs %0, tpidr_el2",
+			ARM64_HAS_VIRT_HOST_EXTN)
+		: "=r" (off) :
 		"Q" (*(const unsigned long *)current_stack_pointer));
 
 	return off;
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 9428b93fefb2..211ee60feeae 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -190,5 +190,6 @@ static inline void spin_lock_prefetch(const void *ptr)
 
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
+int cpu_copy_el2regs(void *__unused);
 
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 94b8f7fc3310..e965639ff08b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -843,6 +843,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = runs_at_el2,
+		.enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
@@ -1255,3 +1256,24 @@ static int __init enable_mrs_emulation(void)
 }
 
 late_initcall(enable_mrs_emulation);
+
+int cpu_copy_el2regs(void *__unused)
+{
+	int do_copyregs = 0;
+
+	/*
+	 * Copy register values that aren't redirected by hardware.
+	 *
+	 * Before code patching, we only set tpidr_el1, all CPUs need to copy
+	 * this value to tpidr_el2 before we patch the code. Once we've done
+	 * that, freshly-onlined CPUs will set tpidr_el2, so we don't need to
+	 * do anything here.
+	 */
+	asm volatile(ALTERNATIVE("mov %0, #1", "nop", ARM64_HAS_VIRT_HOST_EXTN)
+		    : "=r" (do_copyregs) : : );
+
+	if (do_copyregs)
+		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
+
+	return 0;
+}
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 877d42fb0df6..109d43a15aaf 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -70,7 +70,11 @@ ENTRY(cpu_do_suspend)
 	mrs	x8, mdscr_el1
 	mrs	x9, oslsr_el1
 	mrs	x10, sctlr_el1
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	x11, tpidr_el1
+alternative_else
+	mrs	x11, tpidr_el2
+alternative_endif
 	mrs	x12, sp_el0
 	stp	x2, x3, [x0]
 	stp	x4, xzr, [x0, #16]
@@ -116,7 +120,11 @@ ENTRY(cpu_do_resume)
 	msr	mdscr_el1, x10
 
 	msr	sctlr_el1, x12
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	msr	tpidr_el1, x13
+alternative_else
+	msr	tpidr_el2, x13
+alternative_endif
 	msr	sp_el0, x14
 	/*
 	 * Restore oslsr_el1 by writing oslar_el1
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
