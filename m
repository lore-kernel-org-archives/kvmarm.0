Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550EA2D0C73
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649790; cv=none; b=AXEocbf+DVkIiRzguJBJs6SLE5H0JhAjCG6sJT+TjTQZQv3IcPhkIq7dkZ422DPOrBH7XUDABhPEz3NR9YgkIdpVnefPFW8nIm4bpGfgEzXwSTixObTM/YBsHGiDPBU7tbDrNSkhYfpFvaY0HOUNcDaJHZiA+4RcilgU8qFhcIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649790; c=relaxed/simple;
	bh=6Tr4kf7vFu7YuYjDqQ3S3owB0KlK2pmWRH9TBZyDAxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk6IenroQVZRaZW6Ei1xj2CNEodpqGnXAFUWjED3d+mWLshIittQz3/3uvVkdS8M2WyuDkzY2a8zp3U73wOn/f+ijZmZ3QQS57K2DiIHL1HsQeBVkBZ7Gj8Wqswnq9Rhh+x8O8J0RInGUO1YV7WAGDMtKzI0CxxHe59yTC3zpSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86C7D497;
	Tue, 23 Sep 2025 10:49:39 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4E63D3F5A1;
	Tue, 23 Sep 2025 10:49:44 -0700 (PDT)
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>
Subject: [RFC PATCH 08/16] arm64/insn: always inline aarch64_insn_gen_logical_immediate()
Date: Tue, 23 Sep 2025 18:48:55 +0100
Message-ID: <20250923174903.76283-9-ada.coupriediaz@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174903.76283-1-ada.coupriediaz@arm.com>
References: <20250923174903.76283-1-ada.coupriediaz@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As it is always called with an explicit logic instruction type, we can
check for its validity at compile time and remove the runtime error print.

Pull its helper functions, `aarch64_encode_immediate()` and
`range_of_ones()`, into the header and make them `__always_inline`
as well.
This is safe as they only call other `__always_inline` functions.

This makes `aarch64_insn_gen_logical_immediate()` safe for inlining
and usage from patching callbacks.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 149 ++++++++++++++++++++++++++++++++--
 arch/arm64/lib/insn.c         | 136 -------------------------------
 2 files changed, 144 insertions(+), 141 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 5a25e311717f..a94ecc9140f1 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -16,6 +16,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/bitops.h>
+
 enum aarch64_insn_hint_cr_op {
 	AARCH64_INSN_HINT_NOP	= 0x0 << 5,
 	AARCH64_INSN_HINT_YIELD	= 0x1 << 5,
@@ -880,11 +882,148 @@ u32 aarch64_insn_gen_logical_shifted_reg(enum aarch64_insn_register dst,
 u32 aarch64_insn_gen_move_reg(enum aarch64_insn_register dst,
 			      enum aarch64_insn_register src,
 			      enum aarch64_insn_variant variant);
-u32 aarch64_insn_gen_logical_immediate(enum aarch64_insn_logic_type type,
-				       enum aarch64_insn_variant variant,
-				       enum aarch64_insn_register Rn,
-				       enum aarch64_insn_register Rd,
-				       u64 imm);
+
+static __always_inline bool range_of_ones(u64 val)
+{
+	/* Doesn't handle full ones or full zeroes */
+	u64 sval = val >> __ffs64(val);
+
+	/* One of Sean Eron Anderson's bithack tricks */
+	return ((sval + 1) & (sval)) == 0;
+}
+
+static __always_inline u32 aarch64_encode_immediate(u64 imm,
+				 enum aarch64_insn_variant variant,
+				 u32 insn)
+{
+	unsigned int immr, imms, n, ones, ror, esz, tmp;
+	u64 mask;
+
+	switch (variant) {
+	case AARCH64_INSN_VARIANT_32BIT:
+		esz = 32;
+		break;
+	case AARCH64_INSN_VARIANT_64BIT:
+		insn |= AARCH64_INSN_SF_BIT;
+		esz = 64;
+		break;
+	default:
+		return AARCH64_BREAK_FAULT;
+	}
+
+	mask = GENMASK(esz - 1, 0);
+
+	/* Can't encode full zeroes, full ones, or value wider than the mask */
+	if (!imm || imm == mask || imm & ~mask)
+		return AARCH64_BREAK_FAULT;
+
+	/*
+	 * Inverse of Replicate(). Try to spot a repeating pattern
+	 * with a pow2 stride.
+	 */
+	for (tmp = esz / 2; tmp >= 2; tmp /= 2) {
+		u64 emask = BIT(tmp) - 1;
+
+		if ((imm & emask) != ((imm >> tmp) & emask))
+			break;
+
+		esz = tmp;
+		mask = emask;
+	}
+
+	/* N is only set if we're encoding a 64bit value */
+	n = esz == 64;
+
+	/* Trim imm to the element size */
+	imm &= mask;
+
+	/* That's how many ones we need to encode */
+	ones = hweight64(imm);
+
+	/*
+	 * imms is set to (ones - 1), prefixed with a string of ones
+	 * and a zero if they fit. Cap it to 6 bits.
+	 */
+	imms  = ones - 1;
+	imms |= 0xf << ffs(esz);
+	imms &= BIT(6) - 1;
+
+	/* Compute the rotation */
+	if (range_of_ones(imm)) {
+		/*
+		 * Pattern: 0..01..10..0
+		 *
+		 * Compute how many rotate we need to align it right
+		 */
+		ror = __ffs64(imm);
+	} else {
+		/*
+		 * Pattern: 0..01..10..01..1
+		 *
+		 * Fill the unused top bits with ones, and check if
+		 * the result is a valid immediate (all ones with a
+		 * contiguous ranges of zeroes).
+		 */
+		imm |= ~mask;
+		if (!range_of_ones(~imm))
+			return AARCH64_BREAK_FAULT;
+
+		/*
+		 * Compute the rotation to get a continuous set of
+		 * ones, with the first bit set at position 0
+		 */
+		ror = fls64(~imm);
+	}
+
+	/*
+	 * immr is the number of bits we need to rotate back to the
+	 * original set of ones. Note that this is relative to the
+	 * element size...
+	 */
+	immr = (esz - ror) % esz;
+
+	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_N, insn, n);
+	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_R, insn, immr);
+	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_S, insn, imms);
+}
+
+static __always_inline u32 aarch64_insn_gen_logical_immediate(
+					 enum aarch64_insn_logic_type type,
+					 enum aarch64_insn_variant variant,
+					 enum aarch64_insn_register Rn,
+					 enum aarch64_insn_register Rd,
+					 u64 imm)
+{
+	compiletime_assert(type == AARCH64_INSN_LOGIC_AND ||
+		type == AARCH64_INSN_LOGIC_ORR ||
+		type == AARCH64_INSN_LOGIC_EOR ||
+		type == AARCH64_INSN_LOGIC_AND_SETFLAGS,
+		"unknown logical encoding");
+	u32 insn;
+
+	switch (type) {
+	case AARCH64_INSN_LOGIC_AND:
+		insn = aarch64_insn_get_and_imm_value();
+		break;
+	case AARCH64_INSN_LOGIC_ORR:
+		insn = aarch64_insn_get_orr_imm_value();
+		break;
+	case AARCH64_INSN_LOGIC_EOR:
+		insn = aarch64_insn_get_eor_imm_value();
+		break;
+	case AARCH64_INSN_LOGIC_AND_SETFLAGS:
+		insn = aarch64_insn_get_ands_imm_value();
+		break;
+	default:
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, Rd);
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
+	return aarch64_encode_immediate(imm, variant, insn);
+}
+
+
 u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
 			  enum aarch64_insn_register Rm,
 			  enum aarch64_insn_register Rn,
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 7530d51f9b2a..15634094de05 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -1106,142 +1106,6 @@ u32 aarch32_insn_mcr_extract_crm(u32 insn)
 	return insn & CRM_MASK;
 }
 
-static bool range_of_ones(u64 val)
-{
-	/* Doesn't handle full ones or full zeroes */
-	u64 sval = val >> __ffs64(val);
-
-	/* One of Sean Eron Anderson's bithack tricks */
-	return ((sval + 1) & (sval)) == 0;
-}
-
-static u32 aarch64_encode_immediate(u64 imm,
-				    enum aarch64_insn_variant variant,
-				    u32 insn)
-{
-	unsigned int immr, imms, n, ones, ror, esz, tmp;
-	u64 mask;
-
-	switch (variant) {
-	case AARCH64_INSN_VARIANT_32BIT:
-		esz = 32;
-		break;
-	case AARCH64_INSN_VARIANT_64BIT:
-		insn |= AARCH64_INSN_SF_BIT;
-		esz = 64;
-		break;
-	default:
-		pr_err("%s: unknown variant encoding %d\n", __func__, variant);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	mask = GENMASK(esz - 1, 0);
-
-	/* Can't encode full zeroes, full ones, or value wider than the mask */
-	if (!imm || imm == mask || imm & ~mask)
-		return AARCH64_BREAK_FAULT;
-
-	/*
-	 * Inverse of Replicate(). Try to spot a repeating pattern
-	 * with a pow2 stride.
-	 */
-	for (tmp = esz / 2; tmp >= 2; tmp /= 2) {
-		u64 emask = BIT(tmp) - 1;
-
-		if ((imm & emask) != ((imm >> tmp) & emask))
-			break;
-
-		esz = tmp;
-		mask = emask;
-	}
-
-	/* N is only set if we're encoding a 64bit value */
-	n = esz == 64;
-
-	/* Trim imm to the element size */
-	imm &= mask;
-
-	/* That's how many ones we need to encode */
-	ones = hweight64(imm);
-
-	/*
-	 * imms is set to (ones - 1), prefixed with a string of ones
-	 * and a zero if they fit. Cap it to 6 bits.
-	 */
-	imms  = ones - 1;
-	imms |= 0xf << ffs(esz);
-	imms &= BIT(6) - 1;
-
-	/* Compute the rotation */
-	if (range_of_ones(imm)) {
-		/*
-		 * Pattern: 0..01..10..0
-		 *
-		 * Compute how many rotate we need to align it right
-		 */
-		ror = __ffs64(imm);
-	} else {
-		/*
-		 * Pattern: 0..01..10..01..1
-		 *
-		 * Fill the unused top bits with ones, and check if
-		 * the result is a valid immediate (all ones with a
-		 * contiguous ranges of zeroes).
-		 */
-		imm |= ~mask;
-		if (!range_of_ones(~imm))
-			return AARCH64_BREAK_FAULT;
-
-		/*
-		 * Compute the rotation to get a continuous set of
-		 * ones, with the first bit set at position 0
-		 */
-		ror = fls64(~imm);
-	}
-
-	/*
-	 * immr is the number of bits we need to rotate back to the
-	 * original set of ones. Note that this is relative to the
-	 * element size...
-	 */
-	immr = (esz - ror) % esz;
-
-	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_N, insn, n);
-	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_R, insn, immr);
-	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_S, insn, imms);
-}
-
-u32 aarch64_insn_gen_logical_immediate(enum aarch64_insn_logic_type type,
-				       enum aarch64_insn_variant variant,
-				       enum aarch64_insn_register Rn,
-				       enum aarch64_insn_register Rd,
-				       u64 imm)
-{
-	u32 insn;
-
-	switch (type) {
-	case AARCH64_INSN_LOGIC_AND:
-		insn = aarch64_insn_get_and_imm_value();
-		break;
-	case AARCH64_INSN_LOGIC_ORR:
-		insn = aarch64_insn_get_orr_imm_value();
-		break;
-	case AARCH64_INSN_LOGIC_EOR:
-		insn = aarch64_insn_get_eor_imm_value();
-		break;
-	case AARCH64_INSN_LOGIC_AND_SETFLAGS:
-		insn = aarch64_insn_get_ands_imm_value();
-		break;
-	default:
-		pr_err("%s: unknown logical encoding %d\n", __func__, type);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, Rd);
-	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
-	return aarch64_encode_immediate(imm, variant, insn);
-}
-
 u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
 			  enum aarch64_insn_register Rm,
 			  enum aarch64_insn_register Rn,
-- 
2.43.0

