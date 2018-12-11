From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6 02/13] arm64: add pointer authentication register bits
Date: Tue, 11 Dec 2018 20:08:33 +0000
Message-ID: <20181211200754.GA5218@edgewater-inn.cambridge.arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-3-kristina.martsenko@arm.com>
 <ef051a9b-d58f-07af-a446-4b7326ff9311@linaro.org>
 <1e72484b-f89f-eacd-1976-14fdf6f23e26@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e72484b-f89f-eacd-1976-14fdf6f23e26@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Richard Henderson <richard.henderson@linaro.org>, linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 07:54:25PM +0000, Kristina Martsenko wrote:
> On 09/12/2018 14:24, Richard Henderson wrote:
> > On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> >>  #define SCTLR_ELx_DSSBS	(1UL << 44)
> >> +#define SCTLR_ELx_ENIA	(1 << 31)
> > 
> > 1U or 1UL lest you produce signed -0x80000000.
> 
> Thanks, this was setting all SCTLR bits above 31 as well... Now fixed.

Ouch, that's subtle and a mistake that we're likely to keep making in
the future, I fear. I've bitten the bullet and replaced all these
definitions with the _BITUL() macro instead. That also means we don't
have to worry about these constants being used in assembly files when
using older versions of binutils.

Will

--->8

>From 25f3852cd8912174c3410414115783799357230a Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Tue, 11 Dec 2018 16:42:31 +0000
Subject: [PATCH] arm64: sysreg: Use _BITUL() when defining register bits

Using shifts directly is error-prone and can cause inadvertent sign
extensions or build problems with older versions of binutils.

Consistent use of the _BITUL() macro makes these problems disappear.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 81 +++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cea9e53be729..8310cc58d50c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -20,6 +20,7 @@
 #ifndef __ASM_SYSREG_H
 #define __ASM_SYSREG_H
 
+#include <linux/const.h>
 #include <linux/stringify.h>
 
 /*
@@ -444,31 +445,31 @@
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
 /* Common SCTLR_ELx flags. */
-#define SCTLR_ELx_DSSBS	(1UL << 44)
-#define SCTLR_ELx_ENIA	(1 << 31)
-#define SCTLR_ELx_ENIB	(1 << 30)
-#define SCTLR_ELx_ENDA	(1 << 27)
-#define SCTLR_ELx_EE    (1 << 25)
-#define SCTLR_ELx_IESB	(1 << 21)
-#define SCTLR_ELx_WXN	(1 << 19)
-#define SCTLR_ELx_ENDB	(1 << 13)
-#define SCTLR_ELx_I	(1 << 12)
-#define SCTLR_ELx_SA	(1 << 3)
-#define SCTLR_ELx_C	(1 << 2)
-#define SCTLR_ELx_A	(1 << 1)
-#define SCTLR_ELx_M	1
+#define SCTLR_ELx_DSSBS	(_BITUL(44))
+#define SCTLR_ELx_ENIA	(_BITUL(31))
+#define SCTLR_ELx_ENIB	(_BITUL(30))
+#define SCTLR_ELx_ENDA	(_BITUL(27))
+#define SCTLR_ELx_EE    (_BITUL(25))
+#define SCTLR_ELx_IESB	(_BITUL(21))
+#define SCTLR_ELx_WXN	(_BITUL(19))
+#define SCTLR_ELx_ENDB	(_BITUL(13))
+#define SCTLR_ELx_I	(_BITUL(12))
+#define SCTLR_ELx_SA	(_BITUL(3))
+#define SCTLR_ELx_C	(_BITUL(2))
+#define SCTLR_ELx_A	(_BITUL(1))
+#define SCTLR_ELx_M	(_BITUL(0))
 
 #define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
 			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
 
 /* SCTLR_EL2 specific flags. */
-#define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
-			 (1 << 18) | (1 << 22) | (1 << 23) | (1 << 28) | \
-			 (1 << 29))
-#define SCTLR_EL2_RES0	((1 << 6)  | (1 << 7)  | (1 << 8)  | (1 << 9)  | \
-			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
-			 (1 << 17) | (1 << 20) | (1 << 24) | (1 << 26) | \
-			 (1 << 27) | (1 << 30) | (1 << 31) | \
+#define SCTLR_EL2_RES1	((_BITUL(4))  | (_BITUL(5))  | (_BITUL(11)) | (_BITUL(16)) | \
+			 (_BITUL(18)) | (_BITUL(22)) | (_BITUL(23)) | (_BITUL(28)) | \
+			 (_BITUL(29)))
+#define SCTLR_EL2_RES0	((_BITUL(6))  | (_BITUL(7))  | (_BITUL(8))  | (_BITUL(9))  | \
+			 (_BITUL(10)) | (_BITUL(13)) | (_BITUL(14)) | (_BITUL(15)) | \
+			 (_BITUL(17)) | (_BITUL(20)) | (_BITUL(24)) | (_BITUL(26)) | \
+			 (_BITUL(27)) | (_BITUL(30)) | (_BITUL(31)) | \
 			 (0xffffefffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
@@ -490,23 +491,23 @@
 #endif
 
 /* SCTLR_EL1 specific flags. */
-#define SCTLR_EL1_UCI		(1 << 26)
-#define SCTLR_EL1_E0E		(1 << 24)
-#define SCTLR_EL1_SPAN		(1 << 23)
-#define SCTLR_EL1_NTWE		(1 << 18)
-#define SCTLR_EL1_NTWI		(1 << 16)
-#define SCTLR_EL1_UCT		(1 << 15)
-#define SCTLR_EL1_DZE		(1 << 14)
-#define SCTLR_EL1_UMA		(1 << 9)
-#define SCTLR_EL1_SED		(1 << 8)
-#define SCTLR_EL1_ITD		(1 << 7)
-#define SCTLR_EL1_CP15BEN	(1 << 5)
-#define SCTLR_EL1_SA0		(1 << 4)
-
-#define SCTLR_EL1_RES1	((1 << 11) | (1 << 20) | (1 << 22) | (1 << 28) | \
-			 (1 << 29))
-#define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
-			 (1 << 27) | (1 << 30) | (1 << 31) | \
+#define SCTLR_EL1_UCI		(_BITUL(26))
+#define SCTLR_EL1_E0E		(_BITUL(24))
+#define SCTLR_EL1_SPAN		(_BITUL(23))
+#define SCTLR_EL1_NTWE		(_BITUL(18))
+#define SCTLR_EL1_NTWI		(_BITUL(16))
+#define SCTLR_EL1_UCT		(_BITUL(15))
+#define SCTLR_EL1_DZE		(_BITUL(14))
+#define SCTLR_EL1_UMA		(_BITUL(9))
+#define SCTLR_EL1_SED		(_BITUL(8))
+#define SCTLR_EL1_ITD		(_BITUL(7))
+#define SCTLR_EL1_CP15BEN	(_BITUL(5))
+#define SCTLR_EL1_SA0		(_BITUL(4))
+
+#define SCTLR_EL1_RES1	((_BITUL(11)) | (_BITUL(20)) | (_BITUL(22)) | (_BITUL(28)) | \
+			 (_BITUL(29)))
+#define SCTLR_EL1_RES0  ((_BITUL(6))  | (_BITUL(10)) | (_BITUL(13)) | (_BITUL(17)) | \
+			 (_BITUL(27)) | (_BITUL(30)) | (_BITUL(31)) | \
 			 (0xffffefffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
@@ -706,13 +707,13 @@
 #define ZCR_ELx_LEN_SIZE	9
 #define ZCR_ELx_LEN_MASK	0x1ff
 
-#define CPACR_EL1_ZEN_EL1EN	(1 << 16) /* enable EL1 access */
-#define CPACR_EL1_ZEN_EL0EN	(1 << 17) /* enable EL0 access, if EL1EN set */
+#define CPACR_EL1_ZEN_EL1EN	(_BITUL(16)) /* enable EL1 access */
+#define CPACR_EL1_ZEN_EL0EN	(_BITUL(17)) /* enable EL0 access, if EL1EN set */
 #define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
 
 
 /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
-#define SYS_MPIDR_SAFE_VAL		(1UL << 31)
+#define SYS_MPIDR_SAFE_VAL	(_BITUL(31))
 
 #ifdef __ASSEMBLY__
 
-- 
2.1.4
