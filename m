From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Wed, 25 Jan 2017 10:52:30 -0500
Message-ID: <20170125155232.10277-2-cov@codeaurora.org>
References: <20170125155232.10277-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A775840692
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:52:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hfX+PYBOscug for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jan 2017 10:52:37 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DD3740625
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:52:37 -0500 (EST)
In-Reply-To: <20170125155232.10277-1-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Jon Masters <jcm@redhat.com>, Neil Leeder <nleeder@codeaurora.org>, Mark Langsdorf <mlangsdo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

The Qualcomm Datacenter Technologies Falkor v1 CPU may allocate TLB entries
using an incorrect ASID when TTBRx_EL1 is being updated. When the erratum
is triggered, page table entries using the new translation table base
address (BADDR) will be allocated into the TLB using the old ASID. All
circumstances leading to the incorrect ASID being cached in the TLB arise
when software writes TTBRx_EL1[ASID] and TTBRx_EL1[BADDR], a memory
operation is in the process of performing a translation using the specific
TTBRx_EL1 being written, and the memory operation uses a translation table
descriptor designated as non-global. EL2 and EL3 code changing the EL1&0
ASID is not subject to this erratum because hardware is prohibited from
performing translations from an out-of-context translation regime.

Consider the following pseudo code.

  write new BADDR and ASID values to TTBRx_EL1

Replacing the above sequence with the one below will ensure that no TLB
entries with an incorrect ASID are used by software.

  write reserved value to TTBRx_EL1[ASID]
  ISB
  write new value to TTBRx_EL1[BADDR]
  ISB
  write new value to TTBRx_EL1[ASID]
  ISB

When the above sequence is used, page table entries using the new BADDR
value may still be incorrectly allocated into the TLB using the reserved
ASID. Yet this will not reduce functionality, since TLB entries incorrectly
tagged with the reserved ASID will never be hit by a later instruction.

Based on work by Shanker Donthineni <shankerd@codeaurora.org>

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 11 +++++++++++
 arch/arm64/include/asm/assembler.h     | 23 +++++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/mmu_context.h   |  8 +++++++-
 arch/arm64/kernel/cpu_errata.c         |  7 +++++++
 arch/arm64/mm/context.c                | 11 +++++++++++
 arch/arm64/mm/proc.S                   |  1 +
 8 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 405da11fc3e4..e090415a97d3 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -63,3 +63,4 @@ stable kernels.
 | Cavium         | ThunderX SMMUv2 | #27704          | N/A		       |
 |                |                 |                 |                         |
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585     |
+| Qualcomm       | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003|
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 111742126897..366c7d4d1cc5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -479,6 +479,17 @@ config CAVIUM_ERRATUM_27456
 
 	  If unsure, say Y.
 
+config QCOM_FALKOR_ERRATUM_1003
+	bool "Falkor E1003: Incorrect translation due to ASID change"
+	default y
+	help
+	  On Falkor v1, an incorrect ASID may be cached in the TLB when ASID
+	  and BADDR are changed together in TTBRx_EL1. The workaround for this
+	  issue is to use a reserved ASID in cpu_do_switch_mm() before
+	  switching to the new ASID.
+
+	  If unsure, say Y.
+
 endmenu
 
 
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 3a4301163e04..1b67c3782d00 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -25,6 +25,7 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/cpufeature.h>
+#include <asm/mmu_context.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptrace.h>
@@ -441,6 +442,28 @@ alternative_endif
 	.endm
 
 /*
+ * Errata workaround prior to TTBR0_EL1 update
+ *
+ * 	val:	TTBR value with new BADDR, preserved
+ * 	tmp0:	temporary register, clobbered
+ * 	tmp1:	other temporary register, clobbered
+ */
+	.macro	pre_ttbr0_update_workaround, val, tmp0, tmp1
+#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
+alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
+	mrs	\tmp0, ttbr0_el1
+	mov	\tmp1, #FALKOR_RESERVED_ASID
+	bfi	\tmp0, \tmp1, #48, #16		// reserved ASID + old BADDR
+	msr	ttbr0_el1, \tmp0
+	isb
+	bfi	\tmp0, \val, #0, #48		// reserved ASID + new BADDR
+	msr	ttbr0_el1, \tmp0
+	isb
+alternative_else_nop_endif
+#endif
+	.endm
+
+/*
  * Errata workaround post TTBR0_EL1 update.
  */
 	.macro	post_ttbr0_update_workaround
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 4174f09678c4..5aaf7eede432 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -35,7 +35,8 @@
 #define ARM64_HYP_OFFSET_LOW			14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_HAS_NO_FPSIMD			16
+#define ARM64_WORKAROUND_QCOM_FALKOR_E1003	17
 
-#define ARM64_NCAPS				17
+#define ARM64_NCAPS				18
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 0363fe80455c..9632b0508037 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -19,6 +19,10 @@
 #ifndef __ASM_MMU_CONTEXT_H
 #define __ASM_MMU_CONTEXT_H
 
+#define FALKOR_RESERVED_ASID	1
+
+#ifndef __ASSEMBLY__
+
 #include <linux/compiler.h>
 #include <linux/sched.h>
 
@@ -220,4 +224,6 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
 void verify_cpu_asid_bits(void);
 
-#endif
+#endif /* !__ASSEMBLY__ */
+
+#endif /* !__ASM_MMU_CONTEXT_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index b75e917aac46..787b5422c559 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -130,6 +130,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.def_scope = SCOPE_LOCAL_CPU,
 		.enable = cpu_enable_trap_ctr_access,
 	},
+#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
+	{
+		.desc = "Qualcomm Falkor erratum 1003",
+		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
+		MIDR_RANGE(MIDR_QCOM_FALKOR_V1, 0x00, 0x00),
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 4c63cb154859..67df38184903 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -79,6 +79,13 @@ void verify_cpu_asid_bits(void)
 	}
 }
 
+static void set_reserved_asid_bits(void)
+{
+	if (IS_ENABLED(CONFIG_QCOM_FALKOR_ERRATUM_1003) &&
+	    cpus_have_cap(ARM64_WORKAROUND_QCOM_FALKOR_E1003))
+		__set_bit(FALKOR_RESERVED_ASID, asid_map);
+}
+
 static void flush_context(unsigned int cpu)
 {
 	int i;
@@ -87,6 +94,8 @@ static void flush_context(unsigned int cpu)
 	/* Update the list of reserved ASIDs and the ASID bitmap. */
 	bitmap_clear(asid_map, 0, NUM_USER_ASIDS);
 
+	set_reserved_asid_bits();
+
 	/*
 	 * Ensure the generation bump is observed before we xchg the
 	 * active_asids.
@@ -244,6 +253,8 @@ static int asids_init(void)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
 		      NUM_USER_ASIDS);
 
+	set_reserved_asid_bits();
+
 	pr_info("ASID allocator initialised with %lu entries\n", NUM_USER_ASIDS);
 	return 0;
 }
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 32682be978e0..cd4d53d7e458 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -138,6 +138,7 @@ ENDPROC(cpu_do_resume)
  *	- pgd_phys - physical address of new TTB
  */
 ENTRY(cpu_do_switch_mm)
+	pre_ttbr0_update_workaround x0, x1, x2
 	mmid	x1, x1				// get mm->context.id
 	bfi	x0, x1, #48, #16		// set the ASID
 	msr	ttbr0_el1, x0			// set TTBR0
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
