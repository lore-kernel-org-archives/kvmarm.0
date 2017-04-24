From: David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] arm64: Add MIDR values for Cavium cn83XX SoCs
Date: Mon, 24 Apr 2017 11:42:49 -0700
Message-ID: <20170424184250.667-2-david.daney@cavium.com>
References: <20170424184250.667-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170424184250.667-1-david.daney@cavium.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>, David Daney <david.daney@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 0984d1b..235e77d 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 
 #define CAVIUM_CPU_PART_THUNDERX	0x0A1
 #define CAVIUM_CPU_PART_THUNDERX_81XX	0x0A2
+#define CAVIUM_CPU_PART_THUNDERX_83XX	0x0A3
 
 #define BRCM_CPU_PART_VULCAN		0x516
 
@@ -96,6 +97,7 @@
 #define MIDR_CORTEX_A73 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
+#define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
 #define MIDR_QCOM_FALKOR_V1 MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_FALKOR_V1)
 
 #ifndef __ASSEMBLY__
-- 
2.7.4

