From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5 04/16] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Wed,  6 Dec 2017 19:01:30 +0000
Message-ID: <20171206190142.9246-5-james.morse@arm.com>
References: <20171206190142.9246-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206190142.9246-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Now that KVM uses tpidr_el2 in the same way as Linux's cpu_offset in
tpidr_el1, merge the two. This saves KVM from save/restoring tpidr_el1
on VHE hosts, and allows future code to blindly access per-cpu variables
without triggering world-switch.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Reviewed-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
---
Changes since v3:
 * Moved 'alternatives_applied' test all into C,
 * Made enable method static and dragged up before first-use.

Changes since v1:
 * cpu_copy_el2regs()'s 'have I been patched' test now always sets a register,
   just in case the compiler optimises out part of the logic.

 arch/arm64/include/asm/alternative.h |  2 ++
 arch/arm64/include/asm/assembler.h   |  8 ++++++++
 arch/arm64/include/asm/percpu.h      | 11 +++++++++--
 arch/arm64/kernel/alternative.c      |  9 +++++----
 arch/arm64/kernel/cpufeature.c       | 17 +++++++++++++++++
 arch/arm64/mm/proc.S                 |  8 ++++++++
 6 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 4a85c6952a22..669028172fd6 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -12,6 +12,8 @@
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 
+extern int alternatives_applied;
+
 struct alt_instr {
 	s32 orig_offset;	/* offset to original instruction */
 	s32 alt_offset;		/* offset to replacement instruction */
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index c45bc94f15d0..c070c263021e 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -254,7 +254,11 @@ lr	.req	x30		// link register
 #else
 	adr_l	\dst, \sym
 #endif
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	\tmp, tpidr_el1
+alternative_else
+	mrs	\tmp, tpidr_el2
+alternative_endif
 	add	\dst, \dst, \tmp
 	.endm
 
@@ -265,7 +269,11 @@ lr	.req	x30		// link register
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
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 6dd0a3a3e5c9..414288a558c8 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -32,6 +32,8 @@
 #define ALT_ORIG_PTR(a)		__ALT_PTR(a, orig_offset)
 #define ALT_REPL_PTR(a)		__ALT_PTR(a, alt_offset)
 
+int alternatives_applied;
+
 struct alt_region {
 	struct alt_instr *begin;
 	struct alt_instr *end;
@@ -143,7 +145,6 @@ static void __apply_alternatives(void *alt_region, bool use_linear_alias)
  */
 static int __apply_alternatives_multi_stop(void *unused)
 {
-	static int patched = 0;
 	struct alt_region region = {
 		.begin	= (struct alt_instr *)__alt_instructions,
 		.end	= (struct alt_instr *)__alt_instructions_end,
@@ -151,14 +152,14 @@ static int __apply_alternatives_multi_stop(void *unused)
 
 	/* We always have a CPU 0 at this point (__init) */
 	if (smp_processor_id()) {
-		while (!READ_ONCE(patched))
+		while (!READ_ONCE(alternatives_applied))
 			cpu_relax();
 		isb();
 	} else {
-		BUG_ON(patched);
+		BUG_ON(alternatives_applied);
 		__apply_alternatives(&region, true);
 		/* Barriers provided by the cache flushing */
-		WRITE_ONCE(patched, 1);
+		WRITE_ONCE(alternatives_applied, 1);
 	}
 
 	return 0;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 98e6563015a4..cb9c4e5a72f8 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -879,6 +879,22 @@ static int __init parse_kpti(char *str)
 __setup("kpti=", parse_kpti);
 #endif	/* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
+static int cpu_copy_el2regs(void *__unused)
+{
+	/*
+	 * Copy register values that aren't redirected by hardware.
+	 *
+	 * Before code patching, we only set tpidr_el1, all CPUs need to copy
+	 * this value to tpidr_el2 before we patch the code. Once we've done
+	 * that, freshly-onlined CPUs will set tpidr_el2, so we don't need to
+	 * do anything here.
+	 */
+	if (!alternatives_applied)
+		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
+
+	return 0;
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -948,6 +964,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = runs_at_el2,
+		.enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 3146dc96f05b..2f5051411783 100644
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
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
