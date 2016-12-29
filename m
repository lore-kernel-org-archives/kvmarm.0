From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2 1/5] arm64: Define Falkor v1 CPU
Date: Thu, 29 Dec 2016 17:43:31 -0500
Message-ID: <20161229224335.13531-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1A90404CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 17:42:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0SVOIhKLZLiG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2016 17:42:16 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AFDA40197
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2016 17:42:15 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shanker Donthineni <shankerd@codeaurora.org>

Define the MIDR implementer and part number field values for the Qualcomm
Datacenter Technologies Falkor processor version 1 in the usual manner.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/include/asm/cputype.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 26a68dd..ee60561 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -71,6 +71,7 @@
 #define ARM_CPU_IMP_APM			0x50
 #define ARM_CPU_IMP_CAVIUM		0x43
 #define ARM_CPU_IMP_BRCM		0x42
+#define ARM_CPU_IMP_QCOM		0x51
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -84,10 +85,13 @@
 
 #define BRCM_CPU_PART_VULCAN		0x516
 
+#define QCOM_CPU_PART_FALKOR_V1		0x800
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
+#define MIDR_QCOM_FALKOR_V1 MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_FALKOR_V1)
 
 #ifndef __ASSEMBLY__
 
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
