Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287B82ED860
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 19:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861565; cv=none; b=qgqRYwk3mT3ExiYYKuUl4lgvDo9L99SlWou5hQkQ1/6vUNX5Ypk0iM60K7QMuP0EmbJ3bz/2/Eaz4dzrH1OixMNo70G1XWDF6F6XqR/xZyjCzfbdeRukLqH4B7hdqGFYMu6LnENWSC6M6RO/xD/kQnSs/e16h0wKo5yi5Hv5xgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861565; c=relaxed/simple;
	bh=n44nzEdcs5q6hxO9Ccw3xSYgtVRfO72Xn+L+Fy0yLRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFMUi5L9QwlUiIs5YuFl9EyfxQVXu1T0HHSiQiGtDJqaBOxFgYUupIr66ua5LqzZw4701ZUgQEfkiCdA40quabI+e8+4Fq0l+pWlu4MM941/oWz6z8d59Do2HrW+VQq5+bz/QfQSmaMB9yyzw7fp6jxOc0DwLbInmtGSbkIUixU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EE981C2B;
	Wed, 18 Mar 2026 12:19:17 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBBD73F73B;
	Wed, 18 Mar 2026 12:19:21 -0700 (PDT)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 1/4] arm64: tlb: Introduce __tlbi_sync_s1ish_{kernel,batch}() for TLB maintenance
Date: Wed, 18 Mar 2026 19:19:13 +0000
Message-ID: <20260318191918.2653160-2-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318191918.2653160-1-catalin.marinas@arm.com>
References: <20260318191918.2653160-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add __tlbi_sync_s1ish_kernel() similar to __tlbi_sync_s1ish() and use it
for kernel TLB maintenance. Also use this function in flush_tlb_all()
which is only used in relation to kernel mappings. Subsequent patches
can differentiate between workarounds that apply to user only or both
user and kernel.

A subsequent patch will add mm_struct to __tlbi_sync_s1ish(). Since
arch_tlbbatch_flush() is not specific to an mm, add a corresponding
__tlbi_sync_s1ish_batch() helper.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 1416e652612b..f41eebf00990 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -191,6 +191,18 @@ static inline void __tlbi_sync_s1ish(void)
 	__repeat_tlbi_sync(vale1is, 0);
 }
 
+static inline void __tlbi_sync_s1ish_batch(void)
+{
+	dsb(ish);
+	__repeat_tlbi_sync(vale1is, 0);
+}
+
+static inline void __tlbi_sync_s1ish_kernel(void)
+{
+	dsb(ish);
+	__repeat_tlbi_sync(vale1is, 0);
+}
+
 /*
  * Complete broadcast TLB maintenance issued by hyp code which invalidates
  * stage 1 translation information in any translation regime.
@@ -299,7 +311,7 @@ static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
 	__tlbi(vmalle1is);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish_kernel();
 	isb();
 }
 
@@ -385,7 +397,7 @@ static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
  */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish_batch();
 }
 
 /*
@@ -568,7 +580,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	dsb(ishst);
 	__flush_tlb_range_op(vaale1is, start, pages, stride, 0,
 			     TLBI_TTL_UNKNOWN, false, lpa2_is_enabled());
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish_kernel();
 	isb();
 }
 
@@ -582,7 +594,7 @@ static inline void __flush_tlb_kernel_pgtable(unsigned long kaddr)
 
 	dsb(ishst);
 	__tlbi(vaae1is, addr);
-	__tlbi_sync_s1ish();
+	__tlbi_sync_s1ish_kernel();
 	isb();
 }
 
