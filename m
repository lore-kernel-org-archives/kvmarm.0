Return-Path: <SRS0=IDfC=UT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19191C43613
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jun 2019 13:06:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D32EC2082C
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jun 2019 13:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D32EC2082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88DD14A500;
	Thu, 20 Jun 2019 09:06:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dwHp-NGMty5J; Thu, 20 Jun 2019 09:06:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EE34A51A;
	Thu, 20 Jun 2019 09:06:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E75314A50E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jun 2019 09:06:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WADHAkLr4bry for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jun 2019 09:06:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3454A524
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jun 2019 09:06:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EAE411B3;
 Thu, 20 Jun 2019 06:06:32 -0700 (PDT)
Received: from e108454-lin.cambridge.arm.com (e108454-lin.cambridge.arm.com
 [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE3AC3F718;
 Thu, 20 Jun 2019 06:06:30 -0700 (PDT)
From: Julien Grall <julien.grall@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [RFC v2 06/14] arm64/mm: Store the number of asid allocated per
 context
Date: Thu, 20 Jun 2019 14:06:00 +0100
Message-Id: <20190620130608.17230-7-julien.grall@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620130608.17230-1-julien.grall@arm.com>
References: <20190620130608.17230-1-julien.grall@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 Julien Grall <julien.grall@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Currently the number of ASID allocated per context is determined at
compilation time. As the algorithm is becoming generic, the user may
want to instantiate the ASID allocator multiple time with different
number of ASID allocated.

Add a field in asid_info to track the number ASID allocated per context.
This is stored in term of shift amount to avoid division in the code.

This means the number of ASID allocated per context should be a power of
two.

At the same time rename NUM_USERS_ASIDS to NUM_CTXT_ASIDS to make the
name more generic.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/mm/context.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index a9cc59288b08..d128f02644b0 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -37,6 +37,8 @@ static struct asid_info
 	raw_spinlock_t		lock;
 	/* Which CPU requires context flush on next call */
 	cpumask_t		flush_pending;
+	/* Number of ASID allocated by context (shift value) */
+	unsigned int		ctxt_shift;
 } asid_info;
 
 #define active_asid(info, cpu)	*per_cpu_ptr((info)->active, cpu)
@@ -49,15 +51,15 @@ static DEFINE_PER_CPU(u64, reserved_asids);
 #define ASID_FIRST_VERSION(info)	(1UL << ((info)->bits))
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-#define NUM_USER_ASIDS(info)		(ASID_FIRST_VERSION(info) >> 1)
-#define asid2idx(info, asid)		(((asid) & ~ASID_MASK(info)) >> 1)
-#define idx2asid(info, idx)		(((idx) << 1) & ~ASID_MASK(info))
+#define ASID_PER_CONTEXT		2
 #else
-#define NUM_USER_ASIDS(info)		(ASID_FIRST_VERSION(info))
-#define asid2idx(info, asid)		((asid) & ~ASID_MASK(info))
-#define idx2asid(info, idx)		asid2idx(info, idx)
+#define ASID_PER_CONTEXT		1
 #endif
 
+#define NUM_CTXT_ASIDS(info)		(ASID_FIRST_VERSION(info) >> (info)->ctxt_shift)
+#define asid2idx(info, asid)		(((asid) & ~ASID_MASK(info)) >> (info)->ctxt_shift)
+#define idx2asid(info, idx)		(((idx) << (info)->ctxt_shift) & ~ASID_MASK(info))
+
 /* Get the ASIDBits supported by the current CPU */
 static u32 get_cpu_asid_bits(void)
 {
@@ -102,7 +104,7 @@ static void flush_context(struct asid_info *info)
 	u64 asid;
 
 	/* Update the list of reserved ASIDs and the ASID bitmap. */
-	bitmap_clear(info->map, 0, NUM_USER_ASIDS(info));
+	bitmap_clear(info->map, 0, NUM_CTXT_ASIDS(info));
 
 	for_each_possible_cpu(i) {
 		asid = atomic64_xchg_relaxed(&active_asid(info, i), 0);
@@ -182,8 +184,8 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid)
 	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
 	 * pairs.
 	 */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), cur_idx);
-	if (asid != NUM_USER_ASIDS(info))
+	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), cur_idx);
+	if (asid != NUM_CTXT_ASIDS(info))
 		goto set_asid;
 
 	/* We're out of ASIDs, so increment the global generation count */
@@ -192,7 +194,7 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid)
 	flush_context(info);
 
 	/* We have more ASIDs than CPUs, so this will always succeed */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), 1);
+	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), 1);
 
 set_asid:
 	__set_bit(asid, info->map);
@@ -272,17 +274,18 @@ static int asids_init(void)
 	struct asid_info *info = &asid_info;
 
 	info->bits = get_cpu_asid_bits();
+	info->ctxt_shift = ilog2(ASID_PER_CONTEXT);
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
 	 * one more ASID than CPUs. ASID #0 is reserved for init_mm.
 	 */
-	WARN_ON(NUM_USER_ASIDS(info) - 1 <= num_possible_cpus());
+	WARN_ON(NUM_CTXT_ASIDS(info) - 1 <= num_possible_cpus());
 	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
-	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS(info)),
+	info->map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
 			    sizeof(*info->map), GFP_KERNEL);
 	if (!info->map)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
-		      NUM_USER_ASIDS(info));
+		      NUM_CTXT_ASIDS(info));
 
 	info->active = &active_asids;
 	info->reserved = &reserved_asids;
@@ -290,7 +293,7 @@ static int asids_init(void)
 	raw_spin_lock_init(&info->lock);
 
 	pr_info("ASID allocator initialised with %lu entries\n",
-		NUM_USER_ASIDS(info));
+		NUM_CTXT_ASIDS(info));
 	return 0;
 }
 early_initcall(asids_init);
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
