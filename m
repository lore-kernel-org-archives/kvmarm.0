Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B572D948E
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649798; cv=none; b=BXgCFo9cxjY1l0gDkZGdew5fEvjAx3XK6uQHWFq4UXGC9t8OEgQqJO26LFWAbgntjFSzZjgLcmNOZdySjBqy0ZkIkuiyPOuuOB5kgZRs988/tPDl5TusSvNuNIwoZ8OUTn1/99W2uYHSFbtGWVLnc7lCJ5BWT7TXT7JdVrqFtv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649798; c=relaxed/simple;
	bh=LCKq7fLf7Qu3vSMK4wYqBuUbaQGUmC2XSGreBuSbVJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnb77I4w7BInR/AEuuulkxiN6EuJ9ro+e50MnNZ8FHj0m1iGSAPCbPf+HerN1lY5cg49zRocW1/qEbvcP1HU4VQsQxHJ0jdVxwmpWdlSrm6JTSIkUc1oF8ijDZXJi/6YDzWBN1bRgBQJxDjfeMLGU1hIwBwdcLIKntFwMle6MrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDDE8497;
	Tue, 23 Sep 2025 10:49:47 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 333583F5A1;
	Tue, 23 Sep 2025 10:49:51 -0700 (PDT)
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
Subject: [RFC PATCH 10/16] arm64/insn: always inline aarch64_insn_gen_branch_reg()
Date: Tue, 23 Sep 2025 18:48:57 +0100
Message-ID: <20250923174903.76283-11-ada.coupriediaz@arm.com>
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

As it is always called with an explicit instruction branch type, we can
check for its validity at compile time and remove the runtime error print.

This makes `aarch64_insn_gen_branch_reg()` safe for inlining
and usage from patching callbacks, as `aarch64_insn_encode_register()`
has been made safe in a previous commit.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/include/asm/insn.h | 28 ++++++++++++++++++++++++++--
 arch/arm64/lib/insn.c         | 23 -----------------------
 2 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index a7caafd6f02b..6e6a53d4d750 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -760,8 +760,32 @@ static __always_inline bool aarch64_insn_is_nop(u32 insn)
 	return insn == aarch64_insn_gen_nop();
 }
 
-u32 aarch64_insn_gen_branch_reg(enum aarch64_insn_register reg,
-				enum aarch64_insn_branch_type type);
+static __always_inline u32 aarch64_insn_gen_branch_reg(
+			 enum aarch64_insn_register reg,
+			 enum aarch64_insn_branch_type type)
+{
+	compiletime_assert(type >= AARCH64_INSN_BRANCH_NOLINK &&
+		type <= AARCH64_INSN_BRANCH_RETURN,
+		"unknown branch encoding");
+	u32 insn;
+
+	switch (type) {
+	case AARCH64_INSN_BRANCH_NOLINK:
+		insn = aarch64_insn_get_br_value();
+		break;
+	case AARCH64_INSN_BRANCH_LINK:
+		insn = aarch64_insn_get_blr_value();
+		break;
+	case AARCH64_INSN_BRANCH_RETURN:
+		insn = aarch64_insn_get_ret_value();
+		break;
+	default:
+		return AARCH64_BREAK_FAULT;
+	}
+
+	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, reg);
+}
+
 u32 aarch64_insn_gen_load_store_reg(enum aarch64_insn_register reg,
 				    enum aarch64_insn_register base,
 				    enum aarch64_insn_register offset,
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 34b6f1c692b4..8d38bf4bf203 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -178,29 +178,6 @@ u32 aarch64_insn_gen_cond_branch_imm(unsigned long pc, unsigned long addr,
 					     offset >> 2);
 }
 
-u32 aarch64_insn_gen_branch_reg(enum aarch64_insn_register reg,
-				enum aarch64_insn_branch_type type)
-{
-	u32 insn;
-
-	switch (type) {
-	case AARCH64_INSN_BRANCH_NOLINK:
-		insn = aarch64_insn_get_br_value();
-		break;
-	case AARCH64_INSN_BRANCH_LINK:
-		insn = aarch64_insn_get_blr_value();
-		break;
-	case AARCH64_INSN_BRANCH_RETURN:
-		insn = aarch64_insn_get_ret_value();
-		break;
-	default:
-		pr_err("%s: unknown branch encoding %d\n", __func__, type);
-		return AARCH64_BREAK_FAULT;
-	}
-
-	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, reg);
-}
-
 u32 aarch64_insn_gen_load_store_reg(enum aarch64_insn_register reg,
 				    enum aarch64_insn_register base,
 				    enum aarch64_insn_register offset,
-- 
2.43.0

