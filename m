From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 04/13] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Tue, 17 Oct 2017 18:44:23 +0100
Message-ID: <20171017174432.1684-5-james.morse@arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E1249D24
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 13:45:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xSW6OYMskABb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 13:45:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F15B749D48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 13:45:32 -0400 (EDT)
In-Reply-To: <20171017174432.1684-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that KVM uses tpidr_el2 in the same way as Linux's cpu_offset in
tpidr_el1, merge the two. This saves KVM from save/restoring tpidr_el1
on VHE hosts, and allows future code to blindly access per-cpu variables
without triggering world-switch.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>

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
index 6e1cb8c5af4d..f9e2f69f296e 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -11,6 +11,8 @@
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 
+extern int alternatives_applied;
+
 struct alt_instr {
 	s32 orig_offset;	/* offset to original instruction */
 	s32 alt_offset;		/* offset to replacement instruction */
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d58a6253c6ab..1ba12f59dec0 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -242,7 +242,11 @@ lr	.req	x30		// link register
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
 
@@ -253,7 +257,11 @@ lr	.req	x30		// link register
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
index cd52d365d1f0..ecceb51f4998 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -796,6 +796,22 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
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
@@ -865,6 +881,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = runs_at_el2,
+		.enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
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
2.13.3
