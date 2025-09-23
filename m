Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AEC2DE6F5
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649813; cv=none; b=eK7dJA+fEv9kMCnyyG9a6PoCTnW1FP6oaiGNVe9JkgjLCr/zOG5AzUcXGv5bLHoYBZpXEhrfwhjetmFHfIUVTuYC4SnOFkbDJNw5iVuzWTKFC3h7KuioV9E5Fl3AB5oK9SjwfEUUm5syJOwYiczJZZHs/smMMqkoe7yKG/K0X/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649813; c=relaxed/simple;
	bh=wiExZ4Fgng8BTYqoMIsC2nlF1tC8brtADbufO81BoN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6BBTHCVLOx5x29KRbO/klMIRpYW+/v0urrD9wnSPNh20gRovtBrpsvXuiX/FHgAwzlIVkKPNggt8cbDy1sHQTY4XFGwjo7/JOj2gx9GRzmI0XVxYyQdBh0wxWNZ+XM9KBFRMkQA4Qkkso0ZuhC4/o4uDSfxLjyghDNK9XNo7qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60DD1497;
	Tue, 23 Sep 2025 10:50:03 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D65E03F5A1;
	Tue, 23 Sep 2025 10:50:07 -0700 (PDT)
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
Subject: [RFC PATCH 14/16] arm64/insn: always inline aarch64_insn_encode_ldst_size()
Date: Tue, 23 Sep 2025 18:49:01 +0100
Message-ID: <20250923174903.76283-15-ada.coupriediaz@arm.com>
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

The type and instruction checks cannot be made at compile time,
as they are dynamically created. However, we can remove the error print
as it should never appear in normal operation and will still lead to
a fault BRK.

This makes `aarch64_insn_encode_ldst_size()` safe for inlining
and usage from patching callbacks.

This is a change of visiblity, as previously the function was private to
lib/insn.c.
However, in order to inline more `aarch64_insn_` functions and make
patching callbacks safe, it needs to be accessible by those functions.
As it is more accessible than before, add a check so that only loads
or stores can be affected by the size encoding.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 24 ++++++++++++++++++++++++
 arch/arm64/lib/insn.c         | 19 +------------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 44435eede1f3..46d4d452e2e2 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -717,6 +717,30 @@ static __always_inline u32 aarch64_insn_encode_immediate(
 
 	return insn;
 }
+
+extern const u32 aarch64_insn_ldst_size[];
+static __always_inline u32 aarch64_insn_encode_ldst_size(
+					 enum aarch64_insn_size_type type,
+					 u32 insn)
+{
+	u32 size;
+
+	if (type < AARCH64_INSN_SIZE_8 || type > AARCH64_INSN_SIZE_64) {
+		return AARCH64_BREAK_FAULT;
+	}
+
+	/* Don't corrput the top bits of other instructions which aren't a size. */
+	if (!aarch64_insn_is_ldst(insn)) {
+		return AARCH64_BREAK_FAULT;
+	}
+
+	size = aarch64_insn_ldst_size[type];
+	insn &= ~GENMASK(31, 30);
+	insn |= size << 30;
+
+	return insn;
+}
+
 static __always_inline u32 aarch64_insn_encode_register(
 				 enum aarch64_insn_register_type type,
 				 u32 insn,
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 71df4d72ac81..63564d236235 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -42,30 +42,13 @@ u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 	return (insn >> shift) & mask;
 }
 
-static const u32 aarch64_insn_ldst_size[] = {
+const u32 aarch64_insn_ldst_size[] = {
 	[AARCH64_INSN_SIZE_8] = 0,
 	[AARCH64_INSN_SIZE_16] = 1,
 	[AARCH64_INSN_SIZE_32] = 2,
 	[AARCH64_INSN_SIZE_64] = 3,
 };
 
-static u32 aarch64_insn_encode_ldst_size(enum aarch64_insn_size_type type,
-					 u32 insn)
-{
-	u32 size;
-
-	if (type < AARCH64_INSN_SIZE_8 || type > AARCH64_INSN_SIZE_64) {
-		pr_err("%s: unknown size encoding %d\n", __func__, type);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	size = aarch64_insn_ldst_size[type];
-	insn &= ~GENMASK(31, 30);
-	insn |= size << 30;
-
-	return insn;
-}
-
 static inline long label_imm_common(unsigned long pc, unsigned long addr,
 				     long range)
 {
-- 
2.43.0

