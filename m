From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 08/14] arm64/mm: Split asid_inits in 2 parts
Date: Thu, 21 Mar 2019 16:36:17 +0000
Message-ID: <20190321163623.20219-9-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACDFF4A449
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:36:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7O0+hs+kMuY1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Mar 2019 12:36:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0FE4A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:36:58 -0400 (EDT)
In-Reply-To: <20190321163623.20219-1-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Move out the common initialization of the ASID allocator in a separate
function.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/mm/context.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index fb13bc249951..b071a1b3469e 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -271,31 +271,50 @@ asmlinkage void post_ttbr_update_workaround(void)
 			CONFIG_CAVIUM_ERRATUM_27456));
 }
 
-static int asids_init(void)
+/*
+ * Initialize the ASID allocator
+ *
+ * @info: Pointer to the asid allocator structure
+ * @bits: Number of ASIDs available
+ * @asid_per_ctxt: Number of ASIDs to allocate per-context. ASIDs are
+ * allocated contiguously for a given context. This value should be a power of
+ * 2.
+ */
+static int asid_allocator_init(struct asid_info *info,
+			       u32 bits, unsigned int asid_per_ctxt)
 {
-	struct asid_info *info = &asid_info;
-
-	info->bits = get_cpu_asid_bits();
-	info->ctxt_shift = ilog2(ASID_PER_CONTEXT);
+	info->bits = bits;
+	info->ctxt_shift = ilog2(asid_per_ctxt);
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
-	 * one more ASID than CPUs. ASID #0 is reserved for init_mm.
+	 * one more ASID than CPUs. ASID #0 is always reserved.
 	 */
 	WARN_ON(NUM_CTXT_ASIDS(info) - 1 <= num_possible_cpus());
 	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
 	info->map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
 			    sizeof(*info->map), GFP_KERNEL);
 	if (!info->map)
-		panic("Failed to allocate bitmap for %lu ASIDs\n",
-		      NUM_CTXT_ASIDS(info));
-
-	info->active = &active_asids;
-	info->reserved = &reserved_asids;
+		return -ENOMEM;
 
 	raw_spin_lock_init(&info->lock);
 
+	return 0;
+}
+
+static int asids_init(void)
+{
+	u32 bits = get_cpu_asid_bits();
+
+	if (!asid_allocator_init(&asid_info, bits, ASID_PER_CONTEXT))
+		panic("Unable to initialize ASID allocator for %lu ASIDs\n",
+		      1UL << bits);
+
+	asid_info.active = &active_asids;
+	asid_info.reserved = &reserved_asids;
+
 	pr_info("ASID allocator initialised with %lu entries\n",
-		NUM_CTXT_ASIDS(info));
+		NUM_CTXT_ASIDS(&asid_info));
+
 	return 0;
 }
 early_initcall(asids_init);
-- 
2.11.0
