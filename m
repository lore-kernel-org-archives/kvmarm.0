Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F2C2857C6
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649775; cv=none; b=sVeDS/iu1ts6Bm7l/ioujAo0YNw4OCOcpKXwUiTqLMv+mpCY8wclWow10CyARU+74UM1NJF5u7z1HPegV345hxIKHhsXSA6Q0xBUhLaEzqPbgzhA2ii+I7cWkT/IslV78MhvvKhabbcjvhLX35AWnUTpIv7KmH0uOToCb8qqYDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649775; c=relaxed/simple;
	bh=cZst8SaMQq9Nj4wU3NBzuqgsLJ5jKgBxDr0f5Dvt9Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM9QUhHQrlmbozLZiW9CX0vN/2w1GuwDX6jsuupFOyDthNubT5uvLgBxyxGudxbINOkaEH7xAbYfMZ9xlHmy8PYclfMAwZeE5+r3K2xyGNjBn1CzDOIYCiMEcp/oAbqCZtJ8k+A72T+aic7kRW1fbsXDKF8lqUfXLb78eUUBwuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72CBAFEC;
	Tue, 23 Sep 2025 10:49:23 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4AA563F5A1;
	Tue, 23 Sep 2025 10:49:28 -0700 (PDT)
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
Subject: [RFC PATCH 04/16] arm64/insn: always inline aarch64_insn_encode_register()
Date: Tue, 23 Sep 2025 18:48:51 +0100
Message-ID: <20250923174903.76283-5-ada.coupriediaz@arm.com>
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
The register and instruction checks cannot be made at compile time,
as they are dynamically created. However, we can remove the error print
as it should never appear in normal operation and will still lead to
a fault BRK.

This makes `aarch64_insn_encode_register()` self-contained and safe
for inlining and usage from patching callbacks.

This is a change of visiblity, as previously the function was private to
lib/insn.c.
However, in order to inline more `aarch64_insn_...` functions and make
patching callbacks safe, it needs to be accessible by those functions.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 42 +++++++++++++++++++++++++++++++++++
 arch/arm64/lib/insn.c         | 42 -----------------------------------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index f6bce1a62dda..90f271483e5b 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -559,6 +559,48 @@ enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
 u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn);
 u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 				  u32 insn, u64 imm);
+static __always_inline u32 aarch64_insn_encode_register(
+				 enum aarch64_insn_register_type type,
+				 u32 insn,
+				 enum aarch64_insn_register reg)
+{
+	compiletime_assert(type >= AARCH64_INSN_REGTYPE_RT &&
+		type <= AARCH64_INSN_REGTYPE_RS, "unknown register type encoding");
+	int shift;
+
+	if (insn == AARCH64_BREAK_FAULT)
+		return AARCH64_BREAK_FAULT;
+
+	if (reg < AARCH64_INSN_REG_0 || reg > AARCH64_INSN_REG_SP) {
+		return AARCH64_BREAK_FAULT;
+	}
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
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn &= ~(GENMASK(4, 0) << shift);
+	insn |= reg << shift;
+
+	return insn;
+}
+
 static __always_inline u32 aarch64_insn_decode_register(
 				 enum aarch64_insn_register_type type, u32 insn)
 {
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 0fac78e542cf..1810e1ea64a7 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -144,48 +144,6 @@ u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 	return insn;
 }
 
-static u32 aarch64_insn_encode_register(enum aarch64_insn_register_type type,
-					u32 insn,
-					enum aarch64_insn_register reg)
-{
-	int shift;
-
-	if (insn == AARCH64_BREAK_FAULT)
-		return AARCH64_BREAK_FAULT;
-
-	if (reg < AARCH64_INSN_REG_0 || reg > AARCH64_INSN_REG_SP) {
-		pr_err("%s: unknown register encoding %d\n", __func__, reg);
-		return AARCH64_BREAK_FAULT;
-	}
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
-	case AARCH64_INSN_REGTYPE_RS:
-		shift = 16;
-		break;
-	default:
-		pr_err("%s: unknown register type encoding %d\n", __func__,
-		       type);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	insn &= ~(GENMASK(4, 0) << shift);
-	insn |= reg << shift;
-
-	return insn;
-}
-
 static const u32 aarch64_insn_ldst_size[] = {
 	[AARCH64_INSN_SIZE_8] = 0,
 	[AARCH64_INSN_SIZE_16] = 1,
-- 
2.43.0

