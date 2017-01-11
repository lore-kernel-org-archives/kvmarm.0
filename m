From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v3 5/5] arm64: Work around Falkor erratum 1009
Date: Wed, 11 Jan 2017 09:41:18 -0500
Message-ID: <20170111144118.17062-5-cov@codeaurora.org>
References: <20170111144118.17062-1-cov@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170111144118.17062-1-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Mark Langsdorf <mlangsdo@redhat.com>, Mark Salter <msalter@redhat.com>, Jon Masters <jcm@redhat.com>, Christopher Covington <cov@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

During a TLB invalidate sequence targeting the inner shareable
domain, Falkor may prematurely complete the DSB before all loads
and stores using the old translation are observed; instruction
fetches are not subject to the conditions of this erratum.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 10 ++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/tlbflush.h      |  5 ++++-
 arch/arm64/kernel/cpu_errata.c         |  7 +++++++
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 7151aed..98bef2a 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -64,3 +64,4 @@ stable kernels.
 |               |                 |                 |                          |
 | Freescale/NXP | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585      |
 | Qualcomm      | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003 |
+| Qualcomm      | Falkor v1       | E1009           | QCOM_FALKOR_ERRATUM_1009 |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2a80ac9..d13e903 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -490,6 +490,16 @@ config QCOM_FALKOR_ERRATUM_1003
 
 	  If unsure, say Y.
 
+config QCOM_FALKOR_ERRATUM_1009
+	bool "Falkor E1009: Prematurely complete a DSB after a TLBI"
+	default y
+	help
+	  Falkor CPU may prematurely complete a DSB following a TLBI xxIS
+	  invalidate maintenance operations. Repeat the TLBI operation one
+	  more time to fix the issue.
+
+	  If unsure, say Y.
+
 endmenu
 
 
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 5aaf7ee..55bcd02 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -36,7 +36,8 @@
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	17
+#define ARM64_WORKAROUND_REPEAT_TLBI		18
 
-#define ARM64_NCAPS				18
+#define ARM64_NCAPS				19
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index f28813c..7313cd3 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -85,7 +85,10 @@
 			asm (__TLBI_INSTR(op, ##__VA_ARGS__)		       \
 			__TLBI_IO(op, ##__VA_ARGS__));			       \
 		asm volatile (	     as			"\ndsb " #attr "\n"    \
-		: : : "memory"); } while (0)
+			ALTERNATIVE("nop"		"\nnop"	       "\n",   \
+			__TLBI_INSTR(op, ##__VA_ARGS__)	"\ndsb " #attr "\n",   \
+			ARM64_WORKAROUND_REPEAT_TLBI)			       \
+		__TLBI_IO(op, ##__VA_ARGS__) : "memory"); } while (0)
 
 #define __tlbi_dsb(...)	__tlbi_asm_dsb("", ##__VA_ARGS__)
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 787b542..e644364 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -137,6 +137,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_RANGE(MIDR_QCOM_FALKOR_V1, 0x00, 0x00),
 	},
 #endif
+#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1009
+	{
+		.desc = "Qualcomm Falkor erratum 1009",
+		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
+		MIDR_RANGE(MIDR_QCOM_FALKOR_V1, 0x00, 0x00),
+	},
+#endif
 	{
 	}
 };
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
