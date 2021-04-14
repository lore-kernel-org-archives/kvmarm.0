Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E424C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1148613C4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1148613C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93ED24B583;
	Wed, 14 Apr 2021 07:24:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FvgG1v6hPqPo; Wed, 14 Apr 2021 07:24:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 597C14B619;
	Wed, 14 Apr 2021 07:24:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7613A4B56E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v2o0Il5ghuFz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:24:41 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDD4E4B49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:40 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FL0SF5yLyz18Hbh;
 Wed, 14 Apr 2021 19:22:21 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:24:31 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 02/16] arm64/mm: Move active_asids and reserved_asids to
 asid_info
Date: Wed, 14 Apr 2021 12:22:58 +0100
Message-ID: <20210414112312.13704-3-shameerali.kolothum.thodi@huawei.com>
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

The variables active_asids and reserved_asids hold information for a
given ASID allocator. So move them to the structure asid_info.

At the same time, introduce wrappers to access the active and reserved
ASIDs to make the code clearer.


Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v3-->v4
  keep the this_cpu_ptr in fastpath. See c4885bbb3afe("arm64/mm: save
memory access in check_and_switch_context() fast switch path")

---
 arch/arm64/mm/context.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 783f8bdb91ee..42e011094571 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -25,8 +25,13 @@ static struct asid_info
 	atomic64_t	generation;
 	unsigned long	*map;
 	unsigned int	map_idx;
+	atomic64_t __percpu	*active;
+	u64 __percpu		*reserved;
 } asid_info;
 
+#define active_asid(info, cpu)	 (*per_cpu_ptr((info)->active, cpu))
+#define reserved_asid(info, cpu) (*per_cpu_ptr((info)->reserved, cpu))
+
 static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
 static cpumask_t tlb_flush_pending;
@@ -114,7 +119,7 @@ static void flush_context(struct asid_info *info)
 	set_reserved_asid_bits(info);
 
 	for_each_possible_cpu(i) {
-		asid = atomic64_xchg_relaxed(&per_cpu(active_asids, i), 0);
+		asid = atomic64_xchg_relaxed(&active_asid(info, i), 0);
 		/*
 		 * If this CPU has already been through a
 		 * rollover, but hasn't run another task in
@@ -123,9 +128,9 @@ static void flush_context(struct asid_info *info)
 		 * the process it is still running.
 		 */
 		if (asid == 0)
-			asid = per_cpu(reserved_asids, i);
+			asid = reserved_asid(info, i);
 		__set_bit(asid2idx(asid), info->map);
-		per_cpu(reserved_asids, i) = asid;
+		reserved_asid(info, i) = asid;
 	}
 
 	/*
@@ -135,7 +140,8 @@ static void flush_context(struct asid_info *info)
 	cpumask_setall(&tlb_flush_pending);
 }
 
-static bool check_update_reserved_asid(u64 asid, u64 newasid)
+static bool check_update_reserved_asid(struct asid_info *info, u64 asid,
+				       u64 newasid)
 {
 	int cpu;
 	bool hit = false;
@@ -150,9 +156,9 @@ static bool check_update_reserved_asid(u64 asid, u64 newasid)
 	 * generation.
 	 */
 	for_each_possible_cpu(cpu) {
-		if (per_cpu(reserved_asids, cpu) == asid) {
+		if (reserved_asid(info, cpu) == asid) {
 			hit = true;
-			per_cpu(reserved_asids, cpu) = newasid;
+			reserved_asid(info, cpu) = newasid;
 		}
 	}
 
@@ -171,7 +177,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 		 * If our current ASID was active during a rollover, we
 		 * can continue to use it and this was just a false alarm.
 		 */
-		if (check_update_reserved_asid(asid, newasid))
+		if (check_update_reserved_asid(info, asid, newasid))
 			return newasid;
 
 		/*
@@ -229,8 +235,8 @@ void check_and_switch_context(struct mm_struct *mm)
 
 	/*
 	 * The memory ordering here is subtle.
-	 * If our active_asids is non-zero and the ASID matches the current
-	 * generation, then we update the active_asids entry with a relaxed
+	 * If our active_asid is non-zero and the ASID matches the current
+	 * generation, then we update the active_asid entry with a relaxed
 	 * cmpxchg. Racing with a concurrent rollover means that either:
 	 *
 	 * - We get a zero back from the cmpxchg and end up waiting on the
@@ -241,9 +247,9 @@ void check_and_switch_context(struct mm_struct *mm)
 	 *   relaxed xchg in flush_context will treat us as reserved
 	 *   because atomic RmWs are totally ordered for a given location.
 	 */
-	old_active_asid = atomic64_read(this_cpu_ptr(&active_asids));
+	old_active_asid = atomic64_read(this_cpu_ptr(info->active));
 	if (old_active_asid && asid_gen_match(asid, info) &&
-	    atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_asids),
+	    atomic64_cmpxchg_relaxed(this_cpu_ptr(info->active),
 				     old_active_asid, asid))
 		goto switch_mm_fastpath;
 
@@ -259,7 +265,7 @@ void check_and_switch_context(struct mm_struct *mm)
 	if (cpumask_test_and_clear_cpu(cpu, &tlb_flush_pending))
 		local_flush_tlb_all();
 
-	atomic64_set(this_cpu_ptr(&active_asids), asid);
+	atomic64_set(&active_asid(info, cpu), asid);
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
 switch_mm_fastpath:
@@ -416,6 +422,8 @@ static int asids_init(void)
 		      NUM_USER_ASIDS);
 
 	info->map_idx = 1;
+	info->active = &active_asids;
+	info->reserved = &reserved_asids;
 
 	pinned_asid_map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS),
 				  sizeof(*pinned_asid_map), GFP_KERNEL);
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
