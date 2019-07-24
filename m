Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2408DC7618F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 16:26:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4CFC22387
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 16:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4CFC22387
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3D64A5C6;
	Wed, 24 Jul 2019 12:26:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QGCYpu+phZjh; Wed, 24 Jul 2019 12:25:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E779E4A5EE;
	Wed, 24 Jul 2019 12:25:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F31CD4A5B1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 12:25:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D2IHMVt0n72I for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 12:25:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 453954A5C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 12:25:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F103E337;
 Wed, 24 Jul 2019 09:25:54 -0700 (PDT)
Received: from e108454-lin.cambridge.arm.com (e108454-lin.cambridge.arm.com
 [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DB073F71F;
 Wed, 24 Jul 2019 09:25:53 -0700 (PDT)
From: Julien Grall <julien.grall@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 05/15] arm64/mm: Remove dependency on MM in new_context
Date: Wed, 24 Jul 2019 17:25:24 +0100
Message-Id: <20190724162534.7390-6-julien.grall@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190724162534.7390-1-julien.grall@arm.com>
References: <20190724162534.7390-1-julien.grall@arm.com>
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

The function new_context will be part of a generic ASID allocator. At
the moment, the MM structure is only used to fetch the ASID.

To remove the dependency on MM, it is possible to just pass a pointer to
the current ASID.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/mm/context.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index b50f52a09baf..dfb0da35a541 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -140,10 +140,10 @@ static bool check_update_reserved_asid(struct asid_info *info, u64 asid,
 	return hit;
 }
 
-static u64 new_context(struct asid_info *info, struct mm_struct *mm)
+static u64 new_context(struct asid_info *info, atomic64_t *pasid)
 {
 	static u32 cur_idx = 1;
-	u64 asid = atomic64_read(&mm->context.id);
+	u64 asid = atomic64_read(pasid);
 	u64 generation = atomic64_read(&info->generation);
 
 	if (asid != 0) {
@@ -225,7 +225,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	/* Check that our ASID belongs to the current generation. */
 	asid = atomic64_read(&mm->context.id);
 	if ((asid ^ atomic64_read(&info->generation)) >> info->bits) {
-		asid = new_context(info, mm);
+		asid = new_context(info, &mm->context.id);
 		atomic64_set(&mm->context.id, asid);
 	}
 
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
