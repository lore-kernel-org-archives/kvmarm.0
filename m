From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/13] arm64: Panic when VHE and non VHE CPUs coexist
Date: Wed,  8 Jul 2015 17:19:14 +0100
Message-ID: <1436372356-30410-12-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52CBF5812F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y6YyW5qFIMeI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:08:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69F9458159
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:12 -0400 (EDT)
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Having both VHE and non-VHE capable CPUs in the same system
is likely to be a recipe for disaster.

If the boot CPU has VHE, but a secondary is not, we won't be
able to downgrade and run the kernel at EL1. Add CPU hotplug
to the mix, and this produces a terrifying mess.

Let's solve the problem once and for all. If you mix VHE and
non-VHE CPUs in the same system, you deserve to loose, and this
patch makes sure you don't get a chance.

This is implemented by storing the kernel execution level in
a global variable. Secondaries will park themselves in a
WFI loop if they observe a mismatch. Also, the primary CPU
will detect that the secondary CPU has died on a mismatched
execution level. Panic will follow.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/virt.h | 15 +++++++++++++++
 arch/arm64/kernel/head.S      | 15 +++++++++++++++
 arch/arm64/kernel/smp.c       |  4 ++++
 3 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 9f22dd6..8e246f7 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -36,6 +36,11 @@
  */
 extern u32 __boot_cpu_mode[2];
 
+/*
+ * __run_cpu_mode records the mode the boot CPU uses for the kernel.
+ */
+extern u32 __run_cpu_mode;
+
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 phys_addr_t __hyp_get_vectors(void);
 
@@ -60,6 +65,16 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return el == CurrentEL_EL2;
 }
 
+static inline bool is_kernel_mode_mismatched(void)
+{
+	u64 el;
+	u32 mode;
+
+	asm("mrs %0, CurrentEL" : "=r" (el));
+	mode = ACCESS_ONCE(__run_cpu_mode);
+	return el != mode;
+}
+
 /* The section containing the hypervisor text */
 extern char __hyp_text_start[];
 extern char __hyp_text_end[];
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index a179747..318e69f 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -578,7 +578,20 @@ ENTRY(set_cpu_boot_mode_flag)
 1:	str	w20, [x1]			// This CPU has booted in EL1
 	dmb	sy
 	dc	ivac, x1			// Invalidate potentially stale cache line
+	adr_l	x1, __run_cpu_mode
+	ldr	w0, [x1]
+	mrs	x20, CurrentEL
+	str	w20, [x1]
+	dmb	sy
+	dc	ivac, x1			// Invalidate potentially stale cache line
+	cbz	x0, skip_el_check
+	cmp	x0, x20
+	bne	mismatched_el
+skip_el_check:
 	ret
+mismatched_el:
+	wfi
+	b	mismatched_el
 ENDPROC(set_cpu_boot_mode_flag)
 
 /*
@@ -593,6 +606,8 @@ ENDPROC(set_cpu_boot_mode_flag)
 ENTRY(__boot_cpu_mode)
 	.long	BOOT_CPU_MODE_EL2
 	.long	BOOT_CPU_MODE_EL1
+ENTRY(__run_cpu_mode)
+	.long	0
 	.popsection
 
 #ifdef CONFIG_SMP
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 695801a..b467f51 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -52,6 +52,7 @@
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
+#include <asm/virt.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ipi.h>
@@ -112,6 +113,9 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 			pr_crit("CPU%u: failed to come online\n", cpu);
 			ret = -EIO;
 		}
+
+		if (is_kernel_mode_mismatched())
+			panic("CPU%u: incompatible execution level", cpu);
 	} else {
 		pr_err("CPU%u: failed to boot: %d\n", cpu, ret);
 	}
-- 
2.1.4
