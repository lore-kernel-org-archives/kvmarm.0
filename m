Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4B7C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 885EA613CD
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 885EA613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33BF64B583;
	Wed, 14 Apr 2021 07:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m4SWR5zOHSQX; Wed, 14 Apr 2021 07:24:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDF584B6C2;
	Wed, 14 Apr 2021 07:24:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C826C4B6AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 60zdIFuOQs2H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:24:55 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2E8D4B63E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:55 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FL0SY0Cxlz18Hlm;
 Wed, 14 Apr 2021 19:22:37 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:24:43 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 05/16] arm64/mm: Remove dependency on MM in new_context
Date: Wed, 14 Apr 2021 12:23:01 +0100
Message-ID: <20210414112312.13704-6-shameerali.kolothum.thodi@huawei.com>
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

The function new_context will be part of a generic ASID allocator. At
the moment, the MM structure is currently used to fetch the ASID and
pinned refcount.

To remove the dependency on MM, it is possible to just pass a pointer to
the current ASID and pinned refcount. Also please note that 'pinned' may
be NULL if the user doesn't require the pinned asid support.


Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v3-->v4:
  Changes related to Pinned ASID refcount.

---
 arch/arm64/mm/context.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 139ebc161acb..628304e0d3b1 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -165,9 +165,10 @@ static bool check_update_reserved_asid(struct asid_info *info, u64 asid,
 	return hit;
 }
 
-static u64 new_context(struct asid_info *info, struct mm_struct *mm)
+static u64 new_context(struct asid_info *info, atomic64_t *pasid,
+		       refcount_t *pinned)
 {
-	u64 asid = atomic64_read(&mm->context.id);
+	u64 asid = atomic64_read(pasid);
 	u64 generation = atomic64_read(&info->generation);
 
 	if (asid != 0) {
@@ -185,7 +186,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 		 * takes priority, because even if it is also pinned, we need to
 		 * update the generation into the reserved_asids.
 		 */
-		if (refcount_read(&mm->context.pinned))
+		if (pinned && refcount_read(pinned))
 			return newasid;
 
 		/*
@@ -257,7 +258,7 @@ void check_and_switch_context(struct mm_struct *mm)
 	/* Check that our ASID belongs to the current generation. */
 	asid = atomic64_read(&mm->context.id);
 	if (!asid_gen_match(asid, info)) {
-		asid = new_context(info, mm);
+		asid = new_context(info, &mm->context.id, &mm->context.pinned);
 		atomic64_set(&mm->context.id, asid);
 	}
 
@@ -306,7 +307,7 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 		 * We went through one or more rollover since that ASID was
 		 * used. Ensure that it is still valid, or generate a new one.
 		 */
-		asid = new_context(info, mm);
+		asid = new_context(info, &mm->context.id, &mm->context.pinned);
 		atomic64_set(&mm->context.id, asid);
 	}
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
