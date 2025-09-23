Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DDE2C0F60
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649781; cv=none; b=A8S0A8VcnpYBX4G7+eI9R3Qj5IYqMgG8fjvqlzy65aR7qA9+ch30e4Wc7Wi251LJTwe0BsLKP85lX0k8NTZMgeBnYQYvUgVwllPZQrFK8AqdlWzKDEuwd7+LZV7QBEZobRypZQzHOUNOZCZqP30J7SNZ06TwdZ69U5EMV1tTlbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649781; c=relaxed/simple;
	bh=CjDMdhk0G6tcrHt3kbkGU5RYLrcfJPwi8y6dzNI2K/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmX0KO7WwZdHDohcwPOWhKnVAKmhCVXl1I93AiFIJP4bc+Ouvp1jrOuBnL1jp/LeAa3W2m+Xhr3NoKWwA//kdtuzpDxkrJbZ2g92sURnGGWjceQkooFSGpWEm8QJadrL1imBYep9l1BUgQc+qUF9G9VHvEEqTGwv2DfCowklYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55F86497;
	Tue, 23 Sep 2025 10:49:31 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C991B3F5A1;
	Tue, 23 Sep 2025 10:49:35 -0700 (PDT)
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
Subject: [RFC PATCH 06/16] arm64/insn: always inline aarch64_insn_gen_movewide()
Date: Tue, 23 Sep 2025 18:48:53 +0100
Message-ID: <20250923174903.76283-7-ada.coupriediaz@arm.com>
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

As it is always called with an explicit movewide type, we can
check for its validity at compile time and remove the runtime error print.

The other error prints cannot be verified at compile time, but should not
occur in practice and will still lead to a fault BRK, so remove them.

This makes `aarch64_insn_gen_movewide()` safe for inlining
and usage from patching callbacks, as both
`aarch64_insn_encode_register()` and `aarch64_insn_encode_immediate()`
have been made safe in previous commits.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 58 ++++++++++++++++++++++++++++++++---
 arch/arm64/lib/insn.c         | 56 ---------------------------------
 2 files changed, 54 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 5f5f6a125b4e..5a25e311717f 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -624,6 +624,8 @@ static __always_inline bool aarch64_get_imm_shift_mask(
 #define ADR_IMM_LOSHIFT		29
 #define ADR_IMM_HISHIFT		5
 
+#define AARCH64_INSN_SF_BIT	BIT(31)
+
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn);
 
@@ -796,10 +798,58 @@ u32 aarch64_insn_gen_bitfield(enum aarch64_insn_register dst,
 			      int immr, int imms,
 			      enum aarch64_insn_variant variant,
 			      enum aarch64_insn_bitfield_type type);
-u32 aarch64_insn_gen_movewide(enum aarch64_insn_register dst,
-			      int imm, int shift,
-			      enum aarch64_insn_variant variant,
-			      enum aarch64_insn_movewide_type type);
+
+static __always_inline u32 aarch64_insn_gen_movewide(
+				 enum aarch64_insn_register dst,
+				 int imm, int shift,
+				 enum aarch64_insn_variant variant,
+				 enum aarch64_insn_movewide_type type)
+{
+	compiletime_assert(type >=  AARCH64_INSN_MOVEWIDE_ZERO &&
+		type <= AARCH64_INSN_MOVEWIDE_INVERSE, "unknown movewide encoding");
+	u32 insn;
+
+	switch (type) {
+	case AARCH64_INSN_MOVEWIDE_ZERO:
+		insn = aarch64_insn_get_movz_value();
+		break;
+	case AARCH64_INSN_MOVEWIDE_KEEP:
+		insn = aarch64_insn_get_movk_value();
+		break;
+	case AARCH64_INSN_MOVEWIDE_INVERSE:
+		insn = aarch64_insn_get_movn_value();
+		break;
+	default:
+		return AARCH64_BREAK_FAULT;
+	}
+
+	if (imm & ~(SZ_64K - 1)) {
+		return AARCH64_BREAK_FAULT;
+	}
+
+	switch (variant) {
+	case AARCH64_INSN_VARIANT_32BIT:
+		if (shift != 0 && shift != 16) {
+			return AARCH64_BREAK_FAULT;
+		}
+		break;
+	case AARCH64_INSN_VARIANT_64BIT:
+		insn |= AARCH64_INSN_SF_BIT;
+		if (shift != 0 && shift != 16 && shift != 32 && shift != 48) {
+			return AARCH64_BREAK_FAULT;
+		}
+		break;
+	default:
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn |= (shift >> 4) << 21;
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, dst);
+
+	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_16, insn, imm);
+}
+
 u32 aarch64_insn_gen_add_sub_shifted_reg(enum aarch64_insn_register dst,
 					 enum aarch64_insn_register src,
 					 enum aarch64_insn_register reg,
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index d77aef7f84f1..7530d51f9b2a 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -16,7 +16,6 @@
 #include <asm/insn.h>
 #include <asm/kprobes.h>
 
-#define AARCH64_INSN_SF_BIT	BIT(31)
 #define AARCH64_INSN_N_BIT	BIT(22)
 #define AARCH64_INSN_LSL_12	BIT(22)
 
@@ -702,61 +701,6 @@ u32 aarch64_insn_gen_bitfield(enum aarch64_insn_register dst,
 	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_S, insn, imms);
 }
 
-u32 aarch64_insn_gen_movewide(enum aarch64_insn_register dst,
-			      int imm, int shift,
-			      enum aarch64_insn_variant variant,
-			      enum aarch64_insn_movewide_type type)
-{
-	u32 insn;
-
-	switch (type) {
-	case AARCH64_INSN_MOVEWIDE_ZERO:
-		insn = aarch64_insn_get_movz_value();
-		break;
-	case AARCH64_INSN_MOVEWIDE_KEEP:
-		insn = aarch64_insn_get_movk_value();
-		break;
-	case AARCH64_INSN_MOVEWIDE_INVERSE:
-		insn = aarch64_insn_get_movn_value();
-		break;
-	default:
-		pr_err("%s: unknown movewide encoding %d\n", __func__, type);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	if (imm & ~(SZ_64K - 1)) {
-		pr_err("%s: invalid immediate encoding %d\n", __func__, imm);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	switch (variant) {
-	case AARCH64_INSN_VARIANT_32BIT:
-		if (shift != 0 && shift != 16) {
-			pr_err("%s: invalid shift encoding %d\n", __func__,
-			       shift);
-			return AARCH64_BREAK_FAULT;
-		}
-		break;
-	case AARCH64_INSN_VARIANT_64BIT:
-		insn |= AARCH64_INSN_SF_BIT;
-		if (shift != 0 && shift != 16 && shift != 32 && shift != 48) {
-			pr_err("%s: invalid shift encoding %d\n", __func__,
-			       shift);
-			return AARCH64_BREAK_FAULT;
-		}
-		break;
-	default:
-		pr_err("%s: unknown variant encoding %d\n", __func__, variant);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	insn |= (shift >> 4) << 21;
-
-	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RD, insn, dst);
-
-	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_16, insn, imm);
-}
-
 u32 aarch64_insn_gen_add_sub_shifted_reg(enum aarch64_insn_register dst,
 					 enum aarch64_insn_register src,
 					 enum aarch64_insn_register reg,
-- 
2.43.0

