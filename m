Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3352DCF50
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649809; cv=none; b=NoTlzfvhsUrk/CFY1E5ecX8DZ/HfJW/C1uJiJHu61Nhbe2gvEX8U30kwmGmm455nJixVIHP5BuWytv4mUNydhiXT2B80wxEQG2OkgHtFEflo4m4qpiPGdYGDNqT9vO7arkTfEJJFb6yOtdb3hO4VECQXzLMkyrSvHYcgU9pu6MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649809; c=relaxed/simple;
	bh=oUgQCxSQ8ScXU1gOufuTnRrF675d4ncv/V4PX7owEbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLr5momYz99lj6zzc4dm4JRyg1+pkvH6TBwcjXR8k2lyANLccHFjnFqYmH5SoP0dnQILLqz3G7kBUx9Z0KokJO0qcvQZRoS+6SB4lZPre7kiy0C6jjichTgXoW+o1XDEHIu6uXiiVn9bRQ8sZBlNceIX+ag/5+c6LXawFU7g4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65F85FEC;
	Tue, 23 Sep 2025 10:49:59 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D6C233F5A1;
	Tue, 23 Sep 2025 10:50:03 -0700 (PDT)
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
Subject: [RFC PATCH 13/16] arm64/insn: introduce missing is_store/is_load helpers
Date: Tue, 23 Sep 2025 18:49:00 +0100
Message-ID: <20250923174903.76283-14-ada.coupriediaz@arm.com>
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

The current helpers only cover single and pair load/stores.
Introduce new helpers to cover exclusive, load acquire, store release
and the LSE atomics, as they both load and store.

To gather all of them in one call : introduce `aarch64_insn_is_load()`,
`aarch64_insn_is_store()`, and `aarch64_insn_is_ldst()` helpers which
check if the instruction is a load, store or either.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
Note: I made the LSE atomics part of the is_{load,store} helpers
as they are used as such by `aarch64_insn_encode_ldst_size()`,
but it could make sense to not have them in the helpers and just
call them together where neeeded.
---
 arch/arm64/include/asm/insn.h | 53 +++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 4ba4d5c50137..44435eede1f3 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -520,6 +520,23 @@ static __always_inline bool aarch64_insn_is_barrier(u32 insn)
 	       aarch64_insn_is_pssbb(insn);
 }
 
+#ifdef CONFIG_ARM64_LSE_ATOMICS
+static __always_inline bool aarch64_insn_is_lse_atomic(u32 insn)
+{
+	return aarch64_insn_is_ldadd(insn) ||
+	       aarch64_insn_is_ldclr(insn) ||
+	       aarch64_insn_is_ldeor(insn) ||
+		   aarch64_insn_is_ldset(insn) ||
+		   aarch64_insn_is_swp(insn) ||
+		   aarch64_insn_is_cas(insn);
+}
+#else /* CONFIG_ARM64_LSE_ATOMICS */
+static __always_inline bool aarch64_insn_is_lse_atomic(u32 insn)
+{
+	return false;
+}
+#endif /* CONFIG_ARM64_LSE_ATOMICS */
+
 static __always_inline bool aarch64_insn_is_store_single(u32 insn)
 {
 	return aarch64_insn_is_store_imm(insn) ||
@@ -534,6 +551,21 @@ static __always_inline bool aarch64_insn_is_store_pair(u32 insn)
 	       aarch64_insn_is_stp_post(insn);
 }
 
+static __always_inline bool aarch64_insn_is_store_ex_or_rel(u32 insn)
+{
+	return aarch64_insn_is_store_ex(insn) ||
+	       aarch64_insn_is_store_ex(insn & (~BIT(15))) ||
+		   aarch64_insn_is_store_rel(insn);
+}
+
+static __always_inline bool aarch64_insn_is_store(u32 insn)
+{
+	return aarch64_insn_is_store_single(insn) ||
+	       aarch64_insn_is_store_pair(insn) ||
+		   aarch64_insn_is_store_ex_or_rel(insn) ||
+		   aarch64_insn_is_lse_atomic(insn);
+}
+
 static __always_inline bool aarch64_insn_is_load_single(u32 insn)
 {
 	return aarch64_insn_is_load_imm(insn) ||
@@ -548,6 +580,27 @@ static __always_inline bool aarch64_insn_is_load_pair(u32 insn)
 	       aarch64_insn_is_ldp_post(insn);
 }
 
+static __always_inline bool aarch64_insn_is_load_ex_or_acq(u32 insn)
+{
+	return aarch64_insn_is_load_ex(insn) ||
+	       aarch64_insn_is_load_ex(insn & (~BIT(15))) ||
+		   aarch64_insn_is_load_acq(insn);
+}
+
+static __always_inline bool aarch64_insn_is_load(u32 insn)
+{
+	return aarch64_insn_is_load_single(insn) ||
+	       aarch64_insn_is_load_pair(insn) ||
+		   aarch64_insn_is_load_ex_or_acq(insn) ||
+		   aarch64_insn_is_lse_atomic(insn);
+}
+
+static __always_inline bool aarch64_insn_is_ldst(u32 insn)
+{
+	return aarch64_insn_is_load(insn) ||
+		   aarch64_insn_is_store(insn);
+}
+
 static __always_inline bool aarch64_insn_uses_literal(u32 insn)
 {
 	/* ldr/ldrsw (literal), prfm */
-- 
2.43.0

