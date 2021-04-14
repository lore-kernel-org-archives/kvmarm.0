Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC14C43461
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF85E613CD
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF85E613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E274B5AC;
	Wed, 14 Apr 2021 07:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VGvBItH4yBio; Wed, 14 Apr 2021 07:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D7D84B6AB;
	Wed, 14 Apr 2021 07:25:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2704B508
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XfC+Atf0Alae for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:25:01 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB1524B630
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:00 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FL0Sf33jKztW1h;
 Wed, 14 Apr 2021 19:22:42 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:24:47 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 06/16] arm64/mm: Introduce NUM_CTXT_ASIDS
Date: Wed, 14 Apr 2021 12:23:02 +0100
Message-ID: <20210414112312.13704-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
References: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.82.32]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, julien@xen.org, maz@kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, will@kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Julien Grall <julien.grall@arm.com>

At the moment ASID_FIRST_VERSION is used to know the number of ASIDs
supported. As we are going to move the ASID allocator to a separate file,
it would be better to use a different name for external users.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v3-->v4
 -Dropped patch #6, but retained the name NUM_CTXT_ASIDS.

---
 arch/arm64/mm/context.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 628304e0d3b1..0f11d7c7f6a3 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -41,9 +41,9 @@ static unsigned long nr_pinned_asids;
 static unsigned long *pinned_asid_map;
 
 #define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
-#define ASID_FIRST_VERSION(info)	(1UL << (info)->bits)
+#define NUM_CTXT_ASIDS(info)		(1UL << ((info)->bits))
+#define ASID_FIRST_VERSION(info)        NUM_CTXT_ASIDS(info)
 
-#define NUM_USER_ASIDS(info)		ASID_FIRST_VERSION(info)
 #define asid2idx(info, asid)		((asid) & ~ASID_MASK(info))
 #define idx2asid(info, idx)		asid2idx(info, idx)
 
@@ -87,7 +87,7 @@ void verify_cpu_asid_bits(void)
 
 static void set_kpti_asid_bits(struct asid_info *info, unsigned long *map)
 {
-	unsigned int len = BITS_TO_LONGS(NUM_USER_ASIDS(info)) * sizeof(unsigned long);
+	unsigned int len = BITS_TO_LONGS(NUM_CTXT_ASIDS(info)) * sizeof(unsigned long);
 	/*
 	 * In case of KPTI kernel/user ASIDs are allocated in
 	 * pairs, the bottom bit distinguishes the two: if it
@@ -100,11 +100,11 @@ static void set_kpti_asid_bits(struct asid_info *info, unsigned long *map)
 static void set_reserved_asid_bits(struct asid_info *info)
 {
 	if (pinned_asid_map)
-		bitmap_copy(info->map, pinned_asid_map, NUM_USER_ASIDS(info));
+		bitmap_copy(info->map, pinned_asid_map, NUM_CTXT_ASIDS(info));
 	else if (arm64_kernel_unmapped_at_el0())
 		set_kpti_asid_bits(info, info->map);
 	else
-		bitmap_clear(info->map, 0, NUM_USER_ASIDS(info));
+		bitmap_clear(info->map, 0, NUM_CTXT_ASIDS(info));
 }
 
 #define asid_gen_match(asid, info) \
@@ -204,8 +204,8 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid,
 	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
 	 * pairs.
 	 */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), info->map_idx);
-	if (asid != NUM_USER_ASIDS(info))
+	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), info->map_idx);
+	if (asid != NUM_CTXT_ASIDS(info))
 		goto set_asid;
 
 	/* We're out of ASIDs, so increment the global generation count */
@@ -214,7 +214,7 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid,
 	flush_context(info);
 
 	/* We have more ASIDs than CPUs, so this will always succeed */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), 1);
+	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), 1);
 
 set_asid:
 	__set_bit(asid, info->map);
@@ -387,7 +387,7 @@ void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm)
 static int asids_update_limit(void)
 {
 	struct asid_info *info = &asid_info;
-	unsigned long num_available_asids = NUM_USER_ASIDS(info);
+	unsigned long num_available_asids = NUM_CTXT_ASIDS(info);
 
 	if (arm64_kernel_unmapped_at_el0()) {
 		num_available_asids /= 2;
@@ -418,18 +418,18 @@ static int asids_init(void)
 
 	info->bits = get_cpu_asid_bits();
 	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
-	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS(info)),
+	info->map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
 			    sizeof(*info->map), GFP_KERNEL);
 	if (!info->map)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
-		      NUM_USER_ASIDS(info));
+		      NUM_CTXT_ASIDS(info));
 
 	info->map_idx = 1;
 	info->active = &active_asids;
 	info->reserved = &reserved_asids;
 	raw_spin_lock_init(&info->lock);
 
-	pinned_asid_map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS(info)),
+	pinned_asid_map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
 				  sizeof(*pinned_asid_map), GFP_KERNEL);
 	nr_pinned_asids = 0;
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
