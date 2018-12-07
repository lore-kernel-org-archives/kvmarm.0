From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v6 01/13] arm64: add comments about EC exception levels
Date: Fri,  7 Dec 2018 18:39:19 +0000
Message-ID: <20181207183931.4285-2-kristina.martsenko@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207183931.4285-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Richard Henderson <richard.henderson@linaro.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

To make it clear which exceptions can't be taken to EL1 or EL2, add
comments next to the ESR_ELx_EC_* macro definitions.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/esr.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 676de2ec1762..23602a0083ad 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -29,23 +29,23 @@
 #define ESR_ELx_EC_CP14_MR	(0x05)
 #define ESR_ELx_EC_CP14_LS	(0x06)
 #define ESR_ELx_EC_FP_ASIMD	(0x07)
-#define ESR_ELx_EC_CP10_ID	(0x08)
+#define ESR_ELx_EC_CP10_ID	(0x08)	/* EL2 only */
 /* Unallocated EC: 0x09 - 0x0B */
 #define ESR_ELx_EC_CP14_64	(0x0C)
 /* Unallocated EC: 0x0d */
 #define ESR_ELx_EC_ILL		(0x0E)
 /* Unallocated EC: 0x0F - 0x10 */
 #define ESR_ELx_EC_SVC32	(0x11)
-#define ESR_ELx_EC_HVC32	(0x12)
-#define ESR_ELx_EC_SMC32	(0x13)
+#define ESR_ELx_EC_HVC32	(0x12)	/* EL2 only */
+#define ESR_ELx_EC_SMC32	(0x13)	/* EL2 and above */
 /* Unallocated EC: 0x14 */
 #define ESR_ELx_EC_SVC64	(0x15)
-#define ESR_ELx_EC_HVC64	(0x16)
-#define ESR_ELx_EC_SMC64	(0x17)
+#define ESR_ELx_EC_HVC64	(0x16)	/* EL2 and above */
+#define ESR_ELx_EC_SMC64	(0x17)	/* EL2 and above */
 #define ESR_ELx_EC_SYS64	(0x18)
 #define ESR_ELx_EC_SVE		(0x19)
 /* Unallocated EC: 0x1A - 0x1E */
-#define ESR_ELx_EC_IMP_DEF	(0x1f)
+#define ESR_ELx_EC_IMP_DEF	(0x1f)	/* EL3 only */
 #define ESR_ELx_EC_IABT_LOW	(0x20)
 #define ESR_ELx_EC_IABT_CUR	(0x21)
 #define ESR_ELx_EC_PC_ALIGN	(0x22)
@@ -68,7 +68,7 @@
 /* Unallocated EC: 0x36 - 0x37 */
 #define ESR_ELx_EC_BKPT32	(0x38)
 /* Unallocated EC: 0x39 */
-#define ESR_ELx_EC_VECTOR32	(0x3A)
+#define ESR_ELx_EC_VECTOR32	(0x3A)	/* EL2 only */
 /* Unallocted EC: 0x3B */
 #define ESR_ELx_EC_BRK64	(0x3C)
 /* Unallocated EC: 0x3D - 0x3F */
-- 
2.11.0
