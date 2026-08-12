Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2E236D9E7;
	Wed, 12 Aug 2026 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562039; cv=none; b=GGVQRNy4fYZ4LFwwV3jkvk5j+9PgKqdfY/5bW11ymlpTH+RBmme6cJ6GLxzVP/8m4lbMWXg2xZB6j+5vgNbXwECWthyzz7aIM9rFHm6gSzx59nzM1/pLvpssYHoOeEJObaVlrEn8+tHSatzmv7UnrRXP0iXrAeT9y2vY/0O3ESA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562039; c=relaxed/simple;
	bh=sIWieTk4WURR6tewmd4CqdDOGodIh/nx0/zJZ1rNZT8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o4Ib2rQda4mVf9uKinmsTZ2/NyJnUpGKISL+npLnUb0TAN6DCklNTRWvU7s2F9ZcaF4OS9YnoHcA6U7nU3lxFSiiwTpwmvW/UP9VePkMyRUqxGF2c/GKuYDXxZkXx4Fx+YUR6HNB6ijiZJJ+UOAt1WY7qE7Pe4x/6025jTrr19M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMyQHPbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMyQHPbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6D71F000E9;
	Wed, 12 Aug 2026 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562038;
	bh=0g4KetOtT1QniGH3lYu0d4Ii94UczTzbZTbGp4YhhKU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DMyQHPbppzGoVQPYrKFAxDbmU/4yFf9ST8105HrpM97FI+pG3kkBUEoAnuHzDdxnU
	 Q7hnBw1zHuQicWcB0fCNMiLtJQA5stWMfCdpoaqmAH84s6p1rOeSHgGPB7A6kONYv4
	 FZ2xuVJVcKQR5Y+whqibmE947VFjyqiy0hWO8hxWDaiAktSi+JFmOn4gjNHUzvjynk
	 9KuOtWIY45BqWsT3J4GMe5bysN9FJn3hnLnzaXuPD9PPoQTDM9GLVaUH0knuzaNfip
	 jyoa2R+ZH9W4hFoE2MP6FTEnSiAyEtW9m6r7xwXCyxrBz+qeyE0LxN8DF/4dhtWm/R
	 Qh8HDdIwFkKEg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:12 +0100
Subject: [PATCH v19 13/14] tools: Synchronise the kernel esr.h
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-13-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7181; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sIWieTk4WURR6tewmd4CqdDOGodIh/nx0/zJZ1rNZT8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMXEVCLLxfy37+Iu8ZL5ORovesDelBeYghB9j
 a82tNZ/nGSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFxAAKCRAk1otyXVSH
 0FehB/9d/eNf1Hb1izZioig0gINotnP5grSgqXo+ZIKQyb1vsHw8qTLED/UJWvqaBF3VUiCZXw/
 bIjhEaj1aeBVcTcgYOTCsQBb2/KqLd4DgPV14np+SPfULIvqHsexOKVxSafRcv1K2l940ZCw3nU
 MH/Vy4vwPU4amI38/y8aYhobDHDs8mPMlLP2GEJ8ioyRhJDDpqJ0b25wEa4sbeikmzlNprE6JE0
 v+MXjLeelZaZPeOdwRBQDBIX+mTNhLCTHRdl5/6rWjv/DA6YdZ5lVHz8wlqOSmNZSlpjmkm6U0M
 B7DKUjlUAtx8UsbqH2Dp/nU1BHjXMdyGi5DtSlLUqHkUWpJk
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

To pick up definitions for GCS.

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

