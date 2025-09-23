Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B4F29C351
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649770; cv=none; b=NQYczrddGXu9S2hlsVjVU+bQ9aSY5aPpwbQN6GSNoSxKjogWUFOAZoi+CeHEnwPC+DoQ1ovfpZpVV/dzUOHhEi4JvhuojIywxblj5f6IyFpOBEQOcG3CY0j1SBtOGEoj2uaxEaJu28Y4JHCW1Fh8F/5sM8OIbXlNilURiR/NNzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649770; c=relaxed/simple;
	bh=xtIsC31tIAtKKB8qHnYm4xT7iB6zAT90RzN5yj2qix8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIgDa7BOsNhSCGjXOBVio5fUI96vaAgtnOCdJryGN33QGi/e0m1F39ApEd6i5R6sZN8npg95QmIosn0j1Jh4BZnNJ3FlQYkhzJyscWRerQsKbTom3NPDTypnZO2TA+YdASAYrfhjsWyYZrs8Q2wkHcgqKuY0+nMC8XnDi9QW/5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D92C0497;
	Tue, 23 Sep 2025 10:49:19 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F0BD3F5A1;
	Tue, 23 Sep 2025 10:49:24 -0700 (PDT)
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
Subject: [RFC PATCH 03/16] arm64/insn: always inline aarch64_insn_decode_register()
Date: Tue, 23 Sep 2025 18:48:50 +0100
Message-ID: <20250923174903.76283-4-ada.coupriediaz@arm.com>
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

As it is always called with an explicit register type, we can
check for its validity at compile time and remove the runtime error print.

This makes `aarch64_insn_decode_register()` self-contained and safe
for inlining and usage from patching callbacks.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 32 ++++++++++++++++++++++++++++++--
 arch/arm64/lib/insn.c         | 29 -----------------------------
 2 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 18c7811774d3..f6bce1a62dda 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -7,6 +7,7 @@
  */
 #ifndef	__ASM_INSN_H
 #define	__ASM_INSN_H
+#include <linux/bits.h>
 #include <linux/build_bug.h>
 #include <linux/types.h>
 
@@ -558,8 +559,35 @@ enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
-u32 aarch64_insn_decode_register(enum aarch64_insn_register_type type,
-					 u32 insn);
+static __always_inline u32 aarch64_insn_decode_register(
+				 enum aarch64_insn_register_type type, u32 insn)
+{
+	compiletime_assert(type >= AARCH64_INSN_REGTYPE_RT &&
+		type <= AARCH64_INSN_REGTYPE_RS, "unknown register type encoding");
+	int shift;
+
+	switch (type) {
+	case AARCH64_INSN_REGTYPE_RT:
+	case AARCH64_INSN_REGTYPE_RD:
+		shift = 0;
+		break;
+	case AARCH64_INSN_REGTYPE_RN:
+		shift = 5;
+		break;
+	case AARCH64_INSN_REGTYPE_RT2:
+	case AARCH64_INSN_REGTYPE_RA:
+		shift = 10;
+		break;
+	case AARCH64_INSN_REGTYPE_RM:
+	case AARCH64_INSN_REGTYPE_RS:
+		shift = 16;
+		break;
+	default:
+		return 0;
+	}
+
+	return (insn >> shift) & GENMASK(4, 0);
+}
 u32 aarch64_insn_gen_branch_imm(unsigned long pc, unsigned long addr,
 				enum aarch64_insn_branch_type type);
 u32 aarch64_insn_gen_comp_branch_imm(unsigned long pc, unsigned long addr,
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 4e298baddc2e..0fac78e542cf 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -144,35 +144,6 @@ u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 	return insn;
 }
 
-u32 aarch64_insn_decode_register(enum aarch64_insn_register_type type,
-					u32 insn)
-{
-	int shift;
-
-	switch (type) {
-	case AARCH64_INSN_REGTYPE_RT:
-	case AARCH64_INSN_REGTYPE_RD:
-		shift = 0;
-		break;
-	case AARCH64_INSN_REGTYPE_RN:
-		shift = 5;
-		break;
-	case AARCH64_INSN_REGTYPE_RT2:
-	case AARCH64_INSN_REGTYPE_RA:
-		shift = 10;
-		break;
-	case AARCH64_INSN_REGTYPE_RM:
-		shift = 16;
-		break;
-	default:
-		pr_err("%s: unknown register type encoding %d\n", __func__,
-		       type);
-		return 0;
-	}
-
-	return (insn >> shift) & GENMASK(4, 0);
-}
-
 static u32 aarch64_insn_encode_register(enum aarch64_insn_register_type type,
 					u32 insn,
 					enum aarch64_insn_register reg)
-- 
2.43.0

