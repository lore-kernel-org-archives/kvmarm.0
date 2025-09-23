Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132992BE7A0
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649777; cv=none; b=o1/Neertmp/th/QypFszYXAnHNzJLvu+V0l1dGOziQXEIMow+EywYZvYuKgtbDbwdEsn2jt1K9bZTh3oU7iIFuwXPWLKzVIAST4eorK/GH73Ycz16Ey36SQubBFa9zcM0czTJCofK4f6zjioMSAKSYWYKwgtxbrjOAFImJKu6IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649777; c=relaxed/simple;
	bh=utee+C1D9MBTxnYgylcBivUsPRX2koBM0Ut2XMYDZkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWaB+2i23Jo77C3Tq++vXAwijwxN0lMqgHH/IZ0rcLybovMxL/70DeWGz2vm5SaArd3fdabbnsUHaEuKP7LEI24K0IiN+PnrHwI3+1P552EeymUNrqyH2FHMA8/8QXgJDhFKrWChxu0dMpNEm/oV7q7PJFnjJxssz6r90PIokFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5738B25E0;
	Tue, 23 Sep 2025 10:49:27 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB98A3F5A1;
	Tue, 23 Sep 2025 10:49:31 -0700 (PDT)
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
Subject: [RFC PATCH 05/16] arm64/insn: always inline aarch64_insn_encode_immediate()
Date: Tue, 23 Sep 2025 18:48:52 +0100
Message-ID: <20250923174903.76283-6-ada.coupriediaz@arm.com>
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

As type is passed dynamically at runtime we cannot check at compile time
that is valid.
However, in practice this should not happen and will still result in a
fault BRK, so remove the error print.

Pull `aarch64_get_imm_shift_mask()` in the header as well and make it
`__always_inline` as it is needed for `aarch64_insn_encode_immediate()`
and is already safe to inline.
This is a change of visibility, so make sure to check the input pointers
in case it is used in other places.
Current callers do not care about -EINVAL, they just check for an error,
so change the return to a boolean.

This makes `aarch64_insn_encode_immediate()` safe for inlining and
usage from patching callbacks.

As both functions are now `__always_inline`, they do not need
their `__kprobes` annotation anymore.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 103 +++++++++++++++++++++++++++++++++-
 arch/arm64/lib/insn.c         | 102 +--------------------------------
 2 files changed, 102 insertions(+), 103 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 90f271483e5b..5f5f6a125b4e 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -9,6 +9,7 @@
 #define	__ASM_INSN_H
 #include <linux/bits.h>
 #include <linux/build_bug.h>
+#include <linux/sizes.h>
 #include <linux/types.h>
 
 #include <asm/insn-def.h>
@@ -555,10 +556,108 @@ static __always_inline bool aarch64_insn_uses_literal(u32 insn)
 	       aarch64_insn_is_prfm_lit(insn);
 }
 
+static __always_inline bool aarch64_get_imm_shift_mask(
+				 enum aarch64_insn_imm_type type, u32 *maskp, int *shiftp)
+{
+	u32 mask;
+	int shift;
+
+	if (maskp == NULL || shiftp == NULL)
+		return false;
+
+	switch (type) {
+	case AARCH64_INSN_IMM_26:
+		mask = BIT(26) - 1;
+		shift = 0;
+		break;
+	case AARCH64_INSN_IMM_19:
+		mask = BIT(19) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_16:
+		mask = BIT(16) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_14:
+		mask = BIT(14) - 1;
+		shift = 5;
+		break;
+	case AARCH64_INSN_IMM_12:
+		mask = BIT(12) - 1;
+		shift = 10;
+		break;
+	case AARCH64_INSN_IMM_9:
+		mask = BIT(9) - 1;
+		shift = 12;
+		break;
+	case AARCH64_INSN_IMM_7:
+		mask = BIT(7) - 1;
+		shift = 15;
+		break;
+	case AARCH64_INSN_IMM_6:
+	case AARCH64_INSN_IMM_S:
+		mask = BIT(6) - 1;
+		shift = 10;
+		break;
+	case AARCH64_INSN_IMM_R:
+		mask = BIT(6) - 1;
+		shift = 16;
+		break;
+	case AARCH64_INSN_IMM_N:
+		mask = 1;
+		shift = 22;
+		break;
+	default:
+		return false;
+	}
+
+	*maskp = mask;
+	*shiftp = shift;
+
+	return true;
+}
+
+#define ADR_IMM_HILOSPLIT	2
+#define ADR_IMM_SIZE		SZ_2M
+#define ADR_IMM_LOMASK		((1 << ADR_IMM_HILOSPLIT) - 1)
+#define ADR_IMM_HIMASK		((ADR_IMM_SIZE >> ADR_IMM_HILOSPLIT) - 1)
+#define ADR_IMM_LOSHIFT		29
+#define ADR_IMM_HISHIFT		5
+
 enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn);
-u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
-				  u32 insn, u64 imm);
+
+static __always_inline u32 aarch64_insn_encode_immediate(
+				 enum aarch64_insn_imm_type type, u32 insn, u64 imm)
+{
+	u32 immlo, immhi, mask;
+	int shift;
+
+	if (insn == AARCH64_BREAK_FAULT)
+		return AARCH64_BREAK_FAULT;
+
+	switch (type) {
+	case AARCH64_INSN_IMM_ADR:
+		shift = 0;
+		immlo = (imm & ADR_IMM_LOMASK) << ADR_IMM_LOSHIFT;
+		imm >>= ADR_IMM_HILOSPLIT;
+		immhi = (imm & ADR_IMM_HIMASK) << ADR_IMM_HISHIFT;
+		imm = immlo | immhi;
+		mask = ((ADR_IMM_LOMASK << ADR_IMM_LOSHIFT) |
+			(ADR_IMM_HIMASK << ADR_IMM_HISHIFT));
+		break;
+	default:
+		if (aarch64_get_imm_shift_mask(type, &mask, &shift) == false) {
+			return AARCH64_BREAK_FAULT;
+		}
+	}
+
+	/* Update the immediate field. */
+	insn &= ~(mask << shift);
+	insn |= (imm & mask) << shift;
+
+	return insn;
+}
 static __always_inline u32 aarch64_insn_encode_register(
 				 enum aarch64_insn_register_type type,
 				 u32 insn,
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 1810e1ea64a7..d77aef7f84f1 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -13,7 +13,6 @@
 #include <linux/types.h>
 
 #include <asm/debug-monitors.h>
-#include <asm/errno.h>
 #include <asm/insn.h>
 #include <asm/kprobes.h>
 
@@ -21,71 +20,6 @@
 #define AARCH64_INSN_N_BIT	BIT(22)
 #define AARCH64_INSN_LSL_12	BIT(22)
 
-static int __kprobes aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
-						u32 *maskp, int *shiftp)
-{
-	u32 mask;
-	int shift;
-
-	switch (type) {
-	case AARCH64_INSN_IMM_26:
-		mask = BIT(26) - 1;
-		shift = 0;
-		break;
-	case AARCH64_INSN_IMM_19:
-		mask = BIT(19) - 1;
-		shift = 5;
-		break;
-	case AARCH64_INSN_IMM_16:
-		mask = BIT(16) - 1;
-		shift = 5;
-		break;
-	case AARCH64_INSN_IMM_14:
-		mask = BIT(14) - 1;
-		shift = 5;
-		break;
-	case AARCH64_INSN_IMM_12:
-		mask = BIT(12) - 1;
-		shift = 10;
-		break;
-	case AARCH64_INSN_IMM_9:
-		mask = BIT(9) - 1;
-		shift = 12;
-		break;
-	case AARCH64_INSN_IMM_7:
-		mask = BIT(7) - 1;
-		shift = 15;
-		break;
-	case AARCH64_INSN_IMM_6:
-	case AARCH64_INSN_IMM_S:
-		mask = BIT(6) - 1;
-		shift = 10;
-		break;
-	case AARCH64_INSN_IMM_R:
-		mask = BIT(6) - 1;
-		shift = 16;
-		break;
-	case AARCH64_INSN_IMM_N:
-		mask = 1;
-		shift = 22;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	*maskp = mask;
-	*shiftp = shift;
-
-	return 0;
-}
-
-#define ADR_IMM_HILOSPLIT	2
-#define ADR_IMM_SIZE		SZ_2M
-#define ADR_IMM_LOMASK		((1 << ADR_IMM_HILOSPLIT) - 1)
-#define ADR_IMM_HIMASK		((ADR_IMM_SIZE >> ADR_IMM_HILOSPLIT) - 1)
-#define ADR_IMM_LOSHIFT		29
-#define ADR_IMM_HISHIFT		5
-
 u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 {
 	u32 immlo, immhi, mask;
@@ -100,7 +34,7 @@ u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 		mask = ADR_IMM_SIZE - 1;
 		break;
 	default:
-		if (aarch64_get_imm_shift_mask(type, &mask, &shift) < 0) {
+		if (aarch64_get_imm_shift_mask(type, &mask, &shift) == false) {
 			pr_err("%s: unknown immediate encoding %d\n", __func__,
 			       type);
 			return 0;
@@ -110,40 +44,6 @@ u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 	return (insn >> shift) & mask;
 }
 
-u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
-				  u32 insn, u64 imm)
-{
-	u32 immlo, immhi, mask;
-	int shift;
-
-	if (insn == AARCH64_BREAK_FAULT)
-		return AARCH64_BREAK_FAULT;
-
-	switch (type) {
-	case AARCH64_INSN_IMM_ADR:
-		shift = 0;
-		immlo = (imm & ADR_IMM_LOMASK) << ADR_IMM_LOSHIFT;
-		imm >>= ADR_IMM_HILOSPLIT;
-		immhi = (imm & ADR_IMM_HIMASK) << ADR_IMM_HISHIFT;
-		imm = immlo | immhi;
-		mask = ((ADR_IMM_LOMASK << ADR_IMM_LOSHIFT) |
-			(ADR_IMM_HIMASK << ADR_IMM_HISHIFT));
-		break;
-	default:
-		if (aarch64_get_imm_shift_mask(type, &mask, &shift) < 0) {
-			pr_err("%s: unknown immediate encoding %d\n", __func__,
-			       type);
-			return AARCH64_BREAK_FAULT;
-		}
-	}
-
-	/* Update the immediate field. */
-	insn &= ~(mask << shift);
-	insn |= (imm & mask) << shift;
-
-	return insn;
-}
-
 static const u32 aarch64_insn_ldst_size[] = {
 	[AARCH64_INSN_SIZE_8] = 0,
 	[AARCH64_INSN_SIZE_16] = 1,
-- 
2.43.0

