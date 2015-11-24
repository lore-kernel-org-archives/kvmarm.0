From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/8] arm64: KVM: Add workaround for Cortex-A57 erratum 834220
Date: Tue, 24 Nov 2015 18:35:31 +0100
Message-ID: <1448386536-30118-4-git-send-email-christoffer.dall@linaro.org>
References: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4319D4130A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jp02SP11IJiC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:34:21 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53CC841AF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:21 -0500 (EST)
Received: by wmuu63 with SMTP id u63so106540711wmu.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:35:19 -0800 (PST)
In-Reply-To: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Cortex-A57 parts up to r1p2 can misreport Stage 2 translation faults
when a Stage 1 permission fault or device alignment fault should
have been reported.

This patch implements the workaround (which is to validate that the
Stage-1 translation actually succeeds) by using code patching.

Cc: stable@vger.kernel.org
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/Kconfig                  | 21 +++++++++++++++++++++
 arch/arm64/include/asm/cpufeature.h |  3 ++-
 arch/arm64/kernel/cpu_errata.c      |  9 +++++++++
 arch/arm64/kvm/hyp.S                |  6 ++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9ac16a4..e55848c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -316,6 +316,27 @@ config ARM64_ERRATUM_832075
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_834220
+	bool "Cortex-A57: 834220: Stage 2 translation fault might be incorrectly reported in presence of a Stage 1 fault"
+	depends on KVM
+	default y
+	help
+	  This option adds an alternative code sequence to work around ARM
+	  erratum 834220 on Cortex-A57 parts up to r1p2.
+
+	  Affected Cortex-A57 parts might report a Stage 2 translation
+	  fault as the result of a Stage 1 fault for load crossing a
+	  page boundary when there is a permission or device memory
+	  alignment fault at Stage 1 and a translation fault at Stage 2.
+
+	  The workaround is to verify that the Stage 1 translation
+	  doesn't generate a fault before handling the Stage 2 fault.
+	  Please note that this does not necessarily enable the workaround,
+	  as it depends on the alternative framework, which will only patch
+	  the kernel if an affected CPU is detected.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_845719
 	bool "Cortex-A53: 845719: a load might read incorrect data"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 11d5bb0f..52722ee 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -29,8 +29,9 @@
 #define ARM64_HAS_PAN				4
 #define ARM64_HAS_LSE_ATOMICS			5
 #define ARM64_WORKAROUND_CAVIUM_23154		6
+#define ARM64_WORKAROUND_834220			7
 
-#define ARM64_NCAPS				7
+#define ARM64_NCAPS				8
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 24926f2..feb6b4e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -75,6 +75,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 			   (1 << MIDR_VARIANT_SHIFT) | 2),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_834220
+	{
+	/* Cortex-A57 r0p0 - r1p2 */
+		.desc = "ARM erratum 834220",
+		.capability = ARM64_WORKAROUND_834220,
+		MIDR_RANGE(MIDR_CORTEX_A57, 0x00,
+			   (1 << MIDR_VARIANT_SHIFT) | 2),
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_845719
 	{
 	/* Cortex-A53 r0p[01234] */
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 1599701..ff2e038 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -1015,9 +1015,15 @@ el1_trap:
 	b.ne	1f		// Not an abort we care about
 
 	/* This is an abort. Check for permission fault */
+alternative_if_not ARM64_WORKAROUND_834220
 	and	x2, x1, #ESR_ELx_FSC_TYPE
 	cmp	x2, #FSC_PERM
 	b.ne	1f		// Not a permission fault
+alternative_else
+	nop			// Use the permission fault path to
+	nop			// check for a valid S1 translation,
+	nop			// regardless of the ESR value.
+alternative_endif
 
 	/*
 	 * Check for Stage-1 page table walk, which is guaranteed
-- 
2.1.2.330.g565301e.dirty
