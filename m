From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 4/4] arm64: Work around Falkor erratum 1009
Date: Wed, 25 Jan 2017 10:52:32 -0500
Message-ID: <20170125155232.10277-4-cov@codeaurora.org>
References: <20170125155232.10277-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487464018B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:52:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WO9LBD4LP3bh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jan 2017 10:52:48 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 530F940666
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:52:48 -0500 (EST)
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

During a TLB invalidate sequence targeting the inner shareable domain,
Falkor may prematurely complete the DSB before all loads and stores using
the old translation are observed. Instruction fetches are not subject to
the conditions of this erratum. If the original code sequence includes
multiple TLB invalidate instructions followed by a single DSB, onle one of
the TLB instructions needs to be repeated to work around this erratum.
While the erratum only applies to cases in which the TLBI specifies the
inner-shareable domain (*IS form of TLBI) and the DSB is ISH form or
stronger (OSH, SYS), this changes applies the workaround overabundantly--
to local TLBI, DSB NSH sequences as well--for simplicity.

Based on work by Shanker Donthineni <shankerd@codeaurora.org>

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 10 ++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/tlbflush.h      | 18 +++++++++++++++---
 arch/arm64/kernel/cpu_errata.c         |  7 +++++++
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index e090415a97d3..d1ccd5f479ae 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -64,3 +64,4 @@ stable kernels.
 |                |                 |                 |                         |
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585     |
 | Qualcomm       | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003|
+| Qualcomm       | Falkor v1       | E1009           | QCOM_FALKOR_ERRATUM_1009|
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 366c7d4d1cc5..69b73cbdc6b7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -490,6 +490,16 @@ config QCOM_FALKOR_ERRATUM_1003
 
 	  If unsure, say Y.
 
+config QCOM_FALKOR_ERRATUM_1009
+	bool "Falkor E1009: Prematurely complete a DSB after a TLBI"
+	default y
+	help
+	  Falkor CPU may prematurely complete a DSB following a TLBI xxIS
+	  invalidate maintenance operation. Repeat the TLBI operation one
+	  more time to fix the issue.
+
+	  If unsure, say Y.
+
 endmenu
 
 
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 5aaf7eede432..55bcd02e4a3f 100644
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
index deab52374119..fc434f421c7b 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -36,9 +36,21 @@
  * not. The macros handles invoking the asm with or without the
  * register argument as appropriate.
  */
-#define __TLBI_0(op, arg)		asm ("tlbi " #op)
-#define __TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
-#define __TLBI_N(op, arg, n, ...)	__TLBI_##n(op, arg)
+#define __TLBI_0(op, arg) asm volatile ("tlbi " #op "\n"		       \
+			    ALTERNATIVE("nop\n		nop",		       \
+					"dsb ish\n	tlbi " #op,	       \
+					ARM64_WORKAROUND_REPEAT_TLBI,	       \
+					CONFIG_QCOM_FALKOR_ERRATUM_1009)       \
+			    : : )
+
+#define __TLBI_1(op, arg) asm volatile ("tlbi " #op ", %0\n"		       \
+			    ALTERNATIVE("nop\n		nop",		       \
+					"dsb ish\n	tlbi " #op ", %0",     \
+					ARM64_WORKAROUND_REPEAT_TLBI,	       \
+					CONFIG_QCOM_FALKOR_ERRATUM_1009)       \
+			    : : "r" (arg))
+
+#define __TLBI_N(op, arg, n, ...) __TLBI_##n(op, arg)
 
 #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 787b5422c559..e644364b5351 100644
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
