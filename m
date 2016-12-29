From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Thu, 29 Dec 2016 17:43:32 -0500
Message-ID: <20161229224335.13531-2-cov@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC918404FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 17:42:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cF7blC+GVTcH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2016 17:42:18 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39F21405B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 17:42:18 -0500 (EST)
In-Reply-To: <20161229224335.13531-1-cov@codeaurora.org>
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
List-Id: kvmarm@lists.cs.columbia.edu

From: Shanker Donthineni <shankerd@codeaurora.org>

On the Qualcomm Datacenter Technologies Falkor v1 CPU, memory accesses may
allocate TLB entries using an incorrect ASID when TTBRx_EL1 is being
updated. Changing the TTBRx_EL1[ASID] and TTBRx_EL1[BADDR] fields
separately using a reserved ASID will ensure that there are no TLB entries
with incorrect ASID after changing the the ASID.

Pseudo code:
  write TTBRx_EL1[ASID] to a reserved value
  ISB
  write TTBRx_EL1[BADDR] to a desired value
  ISB
  write TTBRx_EL1[ASID] to a desired value
  ISB

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 Documentation/arm64/silicon-errata.txt | 43 +++++++++++++++++-----------------
 arch/arm64/Kconfig                     | 16 +++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         |  7 ++++++
 arch/arm64/mm/context.c                | 10 ++++++++
 arch/arm64/mm/proc.S                   | 12 ++++++++++
 6 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 405da11..7151aed 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -42,24 +42,25 @@ file acts as a registry of software workarounds in the Linux Kernel and
 will be updated when new workarounds are committed and backported to
 stable kernels.
 
-| Implementor    | Component       | Erratum ID      | Kconfig                 |
-+----------------+-----------------+-----------------+-------------------------+
-| ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319    |
-| ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319    |
-| ARM            | Cortex-A53      | #824069         | ARM64_ERRATUM_824069    |
-| ARM            | Cortex-A53      | #819472         | ARM64_ERRATUM_819472    |
-| ARM            | Cortex-A53      | #845719         | ARM64_ERRATUM_845719    |
-| ARM            | Cortex-A53      | #843419         | ARM64_ERRATUM_843419    |
-| ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075    |
-| ARM            | Cortex-A57      | #852523         | N/A                     |
-| ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220    |
-| ARM            | Cortex-A72      | #853709         | N/A                     |
-| ARM            | MMU-500         | #841119,#826419 | N/A                     |
-|                |                 |                 |                         |
-| Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375    |
-| Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144    |
-| Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154    |
-| Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456    |
-| Cavium         | ThunderX SMMUv2 | #27704          | N/A		       |
-|                |                 |                 |                         |
-| Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585     |
+| Implementor   | Component       | Erratum ID      | Kconfig                  |
++---------------+-----------------+-----------------+--------------------------+
+| ARM           | Cortex-A53      | #826319         | ARM64_ERRATUM_826319     |
+| ARM           | Cortex-A53      | #827319         | ARM64_ERRATUM_827319     |
+| ARM           | Cortex-A53      | #824069         | ARM64_ERRATUM_824069     |
+| ARM           | Cortex-A53      | #819472         | ARM64_ERRATUM_819472     |
+| ARM           | Cortex-A53      | #845719         | ARM64_ERRATUM_845719     |
+| ARM           | Cortex-A53      | #843419         | ARM64_ERRATUM_843419     |
+| ARM           | Cortex-A57      | #832075         | ARM64_ERRATUM_832075     |
+| ARM           | Cortex-A57      | #852523         | N/A                      |
+| ARM           | Cortex-A57      | #834220         | ARM64_ERRATUM_834220     |
+| ARM           | Cortex-A72      | #853709         | N/A                      |
+| ARM           | MMU-500         | #841119,#826419 | N/A                      |
+|               |                 |                 |                          |
+| Cavium        | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375     |
+| Cavium        | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144     |
+| Cavium        | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154     |
+| Cavium        | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456     |
+| Cavium        | ThunderX SMMUv2 | #27704          | N/A                      |
+|               |                 |                 |                          |
+| Freescale/NXP | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585      |
+| Qualcomm      | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003 |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1117421..7ce4a4b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -479,6 +479,22 @@ config CAVIUM_ERRATUM_27456
 
 	  If unsure, say Y.
 
+config QCOM_FALKOR_ERRATUM_1003
+	bool "Falkor E1003: Incorrect translation due to ASID change"
+	default y
+	help
+	  An incorrect translation TLBI entry may be created while
+	  changing the ASID & translation table address together for
+	  TTBR0_EL1. The workaround for this issue is use a reserved
+	  ASID in cpu_do_switch_mm() before switching to target ASID.
+
+	  If unsure, say Y.
+
+config QCOM_FALKOR_E1003_RESERVED_ASID
+	int
+	default 1
+	depends on QCOM_FALKOR_ERRATUM_1003
+
 endmenu
 
 
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 4174f09..5aaf7ee 100644
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
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index b75e917..787b542 100644
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
index 4c63cb1..9514a89 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -87,6 +87,11 @@ static void flush_context(unsigned int cpu)
 	/* Update the list of reserved ASIDs and the ASID bitmap. */
 	bitmap_clear(asid_map, 0, NUM_USER_ASIDS);
 
+	/* Reserve ASID for Falkor erratum 1003 */
+	if (IS_ENABLED(CONFIG_QCOM_FALKOR_ERRATUM_1003) &&
+	    cpus_have_cap(ARM64_WORKAROUND_QCOM_FALKOR_E1003))
+		__set_bit(CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID, asid_map);
+
 	/*
 	 * Ensure the generation bump is observed before we xchg the
 	 * active_asids.
@@ -244,6 +249,11 @@ static int asids_init(void)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
 		      NUM_USER_ASIDS);
 
+	/* Reserve ASID for Falkor erratum 1003 */
+	if (IS_ENABLED(CONFIG_QCOM_FALKOR_ERRATUM_1003) &&
+	    cpus_have_cap(ARM64_WORKAROUND_QCOM_FALKOR_E1003))
+		__set_bit(CONFIG_QCOM_FALKOR_E1003_RESERVED_ASID, asid_map);
+
 	pr_info("ASID allocator initialised with %lu entries\n", NUM_USER_ASIDS);
 	return 0;
 }
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 32682be..0c6d173 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -140,6 +140,18 @@ ENDPROC(cpu_do_resume)
 ENTRY(cpu_do_switch_mm)
 	mmid	x1, x1				// get mm->context.id
 	bfi	x0, x1, #48, #16		// set the ASID
+#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
+alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
+	mrs     x2, ttbr0_el1                   // get cuurent TTBR0_EL1
+	mov     x3, #CONFIG_QCOM_FALKOR_ERRATUM_1003	// reserved ASID
+	bfi     x2, x3, #48, #16                // set the reserved ASID + old BADDR
+	msr     ttbr0_el1, x2                   // update TTBR0_EL1
+	isb
+	bfi     x2, x0, #0, #48                 // set the desired BADDR + reserved ASID
+	msr     ttbr0_el1, x2                   // update TTBR0_EL1
+	isb
+alternative_else_nop_endif
+#endif
 	msr	ttbr0_el1, x0			// set TTBR0
 	isb
 	post_ttbr0_update_workaround
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
