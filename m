Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A9730FB0
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C7261650;
	Thu, 16 Nov 2023 06:30:32 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A55BA3F73F;
	Thu, 16 Nov 2023 06:29:44 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v5 01/12] arm64/mm: Modify range-based tlbi to decrement scale
Date: Thu, 16 Nov 2023 14:29:20 +0000
Message-Id: <20231116142931.1675485-2-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231116142931.1675485-1-ryan.roberts@arm.com>
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding support for LPA2 to the tlb invalidation
routines, modify the algorithm used by range-based tlbi to start at the
highest 'scale' and decrement instead of starting at the lowest 'scale'
and incrementing. This new approach makes it possible to maintain 64K
alignment as we work through the range, until the last op (at scale=0).
This is required when LPA2 is enabled. (This part will be added in a
subsequent commit).

This change is separated into its own patch because it will also impact
non-LPA2 systems, and I want to make it easy to bisect in case it leads
to performance regression (see below for benchmarks that suggest this
should not be a problem).

The original commit (d1d3aa98 "arm64: tlb: Use the TLBI RANGE feature in
arm64") stated this as the reason for _incrementing_ scale:

  However, in most scenarios, the pages = 1 when flush_tlb_range() is
  called. Start from scale = 3 or other proper value (such as scale
  =ilog2(pages)), will incur extra overhead. So increase 'scale' from 0
  to maximum.

But pages=1 is already special cased by the non-range invalidation path,
which will take care of it the first time through the loop (both in the
original commit and in my change), so I don't think switching to
decrement scale should have any extra performance impact after all.

Indeed benchmarking kernel compilation, a TLBI-heavy workload, suggests
that this new approach actually _improves_ performance slightly (using a
virtual machine on Apple M2):

Table shows time to execute kernel compilation workload with 8 jobs,
relative to baseline without this patch (more negative number is
bigger speedup). Repeated 9 times across 3 system reboots:

| counter   |       mean |     stdev |
|:----------|-----------:|----------:|
| real-time |      -0.6% |      0.0% |
| kern-time |      -1.6% |      0.5% |
| user-time |      -0.4% |      0.1% |

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index bb2c2833a987..36acdb3d16a5 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -350,14 +350,14 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  * entries one by one at the granularity of 'stride'. If the TLB
  * range ops are supported, then:
  *
- * 1. If 'pages' is odd, flush the first page through non-range
- *    operations;
+ * 1. The minimum range granularity is decided by 'scale', so multiple range
+ *    TLBI operations may be required. Start from scale = 3, flush the largest
+ *    possible number of pages ((num+1)*2^(5*scale+1)) that fit into the
+ *    requested range, then decrement scale and continue until one or zero pages
+ *    are left.
  *
- * 2. For remaining pages: the minimum range granularity is decided
- *    by 'scale', so multiple range TLBI operations may be required.
- *    Start from scale = 0, flush the corresponding number of pages
- *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
- *    until no pages left.
+ * 2. If there is 1 page remaining, flush it through non-range operations. Range
+ *    operations can only span an even number of pages.
  *
  * Note that certain ranges can be represented by either num = 31 and
  * scale or num = 0 and scale + 1. The loop below favours the latter
@@ -367,12 +367,12 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 				asid, tlb_level, tlbi_user)		\
 do {									\
 	int num = 0;							\
-	int scale = 0;							\
+	int scale = 3;							\
 	unsigned long addr;						\
 									\
 	while (pages > 0) {						\
 		if (!system_supports_tlb_range() ||			\
-		    pages % 2 == 1) {					\
+		    pages == 1) {					\
 			addr = __TLBI_VADDR(start, asid);		\
 			__tlbi_level(op, addr, tlb_level);		\
 			if (tlbi_user)					\
@@ -392,7 +392,7 @@ do {									\
 			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
 			pages -= __TLBI_RANGE_PAGES(num, scale);	\
 		}							\
-		scale++;						\
+		scale--;						\
 	}								\
 } while (0)
 
-- 
2.25.1

