Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED5A3DFC8F;
	Wed, 30 Sep 2026 21:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804987; cv=none; b=M5yaRo87TKKiFICQyxg4JHqqR1pmeftVvk0bofa8ottwn0U2q4OxC3ZMuK+vQAunxck05g3cqwuUydL4qdIcaWPdz7oMPEP2PuImev6YtsmTbrO0nW1dcDfiPQ3Znozwl317VBp5uwe4iaSSbLjmHNcBc079Qe0vOttk4Kn/HQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804987; c=relaxed/simple;
	bh=jOjbheMvQ2oaiZTFNxEcabEupt1ryfHHOU/dZyrsMYg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rcN6uy5scrL775GWNUAFWJAZZnbtegcMPN//Q66yeAZ4f7UDdac7rDIX9XG9awPk/4WieBtvyJGMgUIgypKA2xKwJ0DgPQwnzzk4VH5z+0gNtjOmNTSg/7D/x1kIxRYlITeoxz1chz7M/5G7KBlLe/wpcXeVSBWEbpHEapOrfvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzU1Gddb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzU1Gddb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AE71F000FF;
	Wed, 30 Sep 2026 21:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804986;
	bh=C2a3aKAOAWCQvHPMfzvxGHSX9GtshWwwpXGCiSwIczA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WzU1GddbjGM7swVSQkhFafBDdOITmXPNaZdy67ofXsd4NJDdZZYHCAfEK52xy8rZ3
	 RCIzcuTG2eL5ihVSZ+v9S0IQ7n0Gthb0wcuiQnz1vXx2iFuhY0u3yuhhJNl5Va8cZ3
	 jztHOvaGmeKutPS0AQgHqVtRvUOm0w5cZ0AB2KkbeSiO08z8kCPcyOaZ5aw/Ny8lZb
	 mOmZ4eSZxDCOLePvz/9buUz1/eP9DiWqap7VQwDpn5H28hBPWJbFoeF6rBxwM0kQWH
	 qCFM1lG1tPGRDfNVm8RRgU6WMCzLtiKYzgrf9FTDWdT9J71dS53aTYHJ6fuCWxOruY
	 X6YQSiCgcr/iQ==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:24 +0100
Subject: [PATCH v21 14/15] tools: Synchronise the kernel esr.h
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-14-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7228; i=broonie@kernel.org;
 h=from:subject:message-id; bh=jOjbheMvQ2oaiZTFNxEcabEupt1ryfHHOU/dZyrsMYg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO+PNwvuwtOgqKb1SLmqd/GgYUJkrZPsLYrL
 2lZe0r5DmKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DvgAKCRAk1otyXVSH
 0EMYB/9rMvSHV7saPUZOt8G7n3A+cchdJZJs5kVWKk/Rhd1Qo1khx9owVuGtnqa3L5kXaa9ys8F
 w9zxo3Y0hQTIbQp5DDTwYmrQy/LwPv2eDCIHGin81IFqRpxoKCygRzifPNt3CxDiE5iPtulOMbE
 LCpJyCIeF1P7gV62nK5H+ixOwPlIQ+w+0OfoZDyeJN6G3UM0pa2/5uB0iHrJ5rem9Hu9gfzAGgB
 wGB8BRd+iHrJ5oPG8eXHoH016ODC/2U+dt4KuWZJIGv6ROCz12UEi+ckxJ2PsqGpTOGqTh+X9dx
 JjIPvUa9FcOKcujb/YCDUA/TGWdCxhgdBLAD5Gv5Qv3R6b6V
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

To pick up definitions for GCS.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/arch/arm64/include/asm/esr.h | 113 +++++++++++++++++++++++++++++++++----
 1 file changed, 102 insertions(+), 11 deletions(-)

diff --git a/tools/arch/arm64/include/asm/esr.h b/tools/arch/arm64/include/asm/esr.h
index f3c6403e5ef2..24c6ebe3fd41 100644
--- a/tools/arch/arm64/include/asm/esr.h
+++ b/tools/arch/arm64/include/asm/esr.h
@@ -19,7 +19,8 @@
 #define ESR_ELx_EC_FP_ASIMD	UL(0x07)
 #define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
 #define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
-/* Unallocated EC: 0x0A - 0x0B */
+#define ESR_ELx_EC_OTHER	UL(0x0A)
+/* Unallocated EC: 0x0B */
 #define ESR_ELx_EC_CP14_64	UL(0x0C)
 #define ESR_ELx_EC_BTI		UL(0x0D)
 #define ESR_ELx_EC_ILL		UL(0x0E)
@@ -50,7 +51,8 @@
 #define ESR_ELx_EC_FP_EXC32	UL(0x28)
 /* Unallocated EC: 0x29 - 0x2B */
 #define ESR_ELx_EC_FP_EXC64	UL(0x2C)
-/* Unallocated EC: 0x2D - 0x2E */
+#define ESR_ELx_EC_GCS		UL(0x2D)
+/* Unallocated EC:  0x2E */
 #define ESR_ELx_EC_SERROR	UL(0x2F)
 #define ESR_ELx_EC_BREAKPT_LOW	UL(0x30)
 #define ESR_ELx_EC_BREAKPT_CUR	UL(0x31)
@@ -97,6 +99,8 @@
 #define ESR_ELx_AET_CE		(UL(6) << ESR_ELx_AET_SHIFT)
 
 /* Shared ISS field definitions for Data/Instruction aborts */
+#define ESR_ELx_VNCR_SHIFT	(13)
+#define ESR_ELx_VNCR		(UL(1) << ESR_ELx_VNCR_SHIFT)
 #define ESR_ELx_SET_SHIFT	(11)
 #define ESR_ELx_SET_MASK	(UL(3) << ESR_ELx_SET_SHIFT)
 #define ESR_ELx_FnV_SHIFT	(10)
@@ -119,6 +123,16 @@
 #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
 #define ESR_ELx_FSC_SECC	(0x18)
 #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
+#define ESR_ELx_FSC_EXCL_ATOMIC	(0x35)
+#define ESR_ELx_FSC_ADDRSZ	(0x00)
+
+/*
+ * Annoyingly, the negative levels for Address size faults aren't laid out
+ * contiguously (or in the desired order)
+ */
+#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x25 : 0x2C)
+#define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
+						   (ESR_ELx_FSC_ADDRSZ + (n)))
 
 /* Status codes for individual page table levels */
 #define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))
@@ -141,12 +155,12 @@
 #define ESR_ELx_SF 		(UL(1) << ESR_ELx_SF_SHIFT)
 #define ESR_ELx_AR_SHIFT	(14)
 #define ESR_ELx_AR 		(UL(1) << ESR_ELx_AR_SHIFT)
-#define ESR_ELx_VNCR_SHIFT	(13)
-#define ESR_ELx_VNCR		(UL(1) << ESR_ELx_VNCR_SHIFT)
 #define ESR_ELx_CM_SHIFT	(8)
 #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
 
 /* ISS2 field definitions for Data Aborts */
+#define ESR_ELx_HDBSSF_SHIFT	(11)
+#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
 #define ESR_ELx_TnD_SHIFT	(10)
 #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
 #define ESR_ELx_TagAccess_SHIFT	(9)
@@ -161,8 +175,6 @@
 #define ESR_ELx_Xs_MASK		(GENMASK_ULL(4, 0))
 
 /* ISS field definitions for exceptions taken in to Hyp */
-#define ESR_ELx_FSC_ADDRSZ	(0x00)
-#define ESR_ELx_FSC_ADDRSZ_L(n)	(ESR_ELx_FSC_ADDRSZ + (n))
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
@@ -174,6 +186,13 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
+/* ISS definitions for LD64B/ST64B/{T,P}SBCSYNC instructions */
+#define ESR_ELx_ISS_OTHER_ST64BV	(0)
+#define ESR_ELx_ISS_OTHER_ST64BV0	(1)
+#define ESR_ELx_ISS_OTHER_LDST64B	(2)
+#define ESR_ELx_ISS_OTHER_TSBCSYNC	(3)
+#define ESR_ELx_ISS_OTHER_PSBCSYNC	(4)
+
 #define DISR_EL1_IDS		(UL(1) << 24)
 /*
  * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
@@ -371,12 +390,14 @@
 /*
  * ISS values for SME traps
  */
+#define ESR_ELx_SME_ISS_SMTC_MASK		GENMASK(2, 0)
+#define ESR_ELx_SME_ISS_SMTC(esr)		((esr) & ESR_ELx_SME_ISS_SMTC_MASK)
 
-#define ESR_ELx_SME_ISS_SME_DISABLED	0
-#define ESR_ELx_SME_ISS_ILL		1
-#define ESR_ELx_SME_ISS_SM_DISABLED	2
-#define ESR_ELx_SME_ISS_ZA_DISABLED	3
-#define ESR_ELx_SME_ISS_ZT_DISABLED	4
+#define ESR_ELx_SME_ISS_SMTC_SME_DISABLED	0
+#define ESR_ELx_SME_ISS_SMTC_ILL		1
+#define ESR_ELx_SME_ISS_SMTC_SM_DISABLED	2
+#define ESR_ELx_SME_ISS_SMTC_ZA_DISABLED	3
+#define ESR_ELx_SME_ISS_SMTC_ZT_DISABLED	4
 
 /* ISS field definitions for MOPS exceptions */
 #define ESR_ELx_MOPS_ISS_MEM_INST	(UL(1) << 24)
@@ -387,6 +408,31 @@
 #define ESR_ELx_MOPS_ISS_SRCREG(esr)	(((esr) & (UL(0x1f) << 5)) >> 5)
 #define ESR_ELx_MOPS_ISS_SIZEREG(esr)	(((esr) & (UL(0x1f) << 0)) >> 0)
 
+/* ISS field definitions for GCS */
+#define ESR_ELx_ExType_SHIFT	(20)
+#define ESR_ELx_ExType_MASK		GENMASK(23, 20)
+#define ESR_ELx_Raddr_SHIFT		(10)
+#define ESR_ELx_Raddr_MASK		GENMASK(14, 10)
+#define ESR_ELx_Rn_SHIFT		(5)
+#define ESR_ELx_Rn_MASK			GENMASK(9, 5)
+#define ESR_ELx_Rvalue_SHIFT		5
+#define ESR_ELx_Rvalue_MASK		GENMASK(9, 5)
+#define ESR_ELx_IT_SHIFT		(0)
+#define ESR_ELx_IT_MASK			GENMASK(4, 0)
+
+#define ESR_ELx_ExType_DATA_CHECK	0
+#define ESR_ELx_ExType_EXLOCK		1
+#define ESR_ELx_ExType_STR		2
+
+#define ESR_ELx_IT_RET			0
+#define ESR_ELx_IT_GCSPOPM		1
+#define ESR_ELx_IT_RET_KEYA		2
+#define ESR_ELx_IT_RET_KEYB		3
+#define ESR_ELx_IT_GCSSS1		4
+#define ESR_ELx_IT_GCSSS2		5
+#define ESR_ELx_IT_GCSPOPCX		6
+#define ESR_ELx_IT_GCSPOPX		7
+
 #ifndef __ASSEMBLER__
 #include <asm/types.h>
 
@@ -408,6 +454,11 @@ static inline bool esr_is_cfi_brk(unsigned long esr)
 	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
 }
 
+static inline bool esr_is_ubsan_brk(unsigned long esr)
+{
+	return (esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	esr = esr & ESR_ELx_FSC;
@@ -439,6 +490,46 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_ACCESS_L(0));
 }
 
+static inline bool esr_fsc_is_excl_atomic_fault(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return esr == ESR_ELx_FSC_EXCL_ATOMIC;
+}
+
+static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
+{
+	esr &= ESR_ELx_FSC;
+
+	return (esr == ESR_ELx_FSC_ADDRSZ_L(3))	||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(2))	||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(1)) ||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(0))	||
+	       (esr == ESR_ELx_FSC_ADDRSZ_L(-1));
+}
+
+static inline bool esr_fsc_is_sea_ttw(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return (esr == ESR_ELx_FSC_SEA_TTW(3)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(2)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(1)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(0)) ||
+	       (esr == ESR_ELx_FSC_SEA_TTW(-1));
+}
+
+static inline bool esr_fsc_is_secc_ttw(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return (esr == ESR_ELx_FSC_SECC_TTW(3)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(2)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(1)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(0)) ||
+	       (esr == ESR_ELx_FSC_SECC_TTW(-1));
+}
+
 /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
 static inline bool esr_iss_is_eretax(unsigned long esr)
 {

-- 
2.47.3

