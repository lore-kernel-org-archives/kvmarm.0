Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7524C43381
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 13:42:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B8222223D
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 13:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B8222223D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 021A44B166;
	Tue, 26 Jan 2021 08:42:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ihNFQAulUz2T; Tue, 26 Jan 2021 08:42:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4644B2AE;
	Tue, 26 Jan 2021 08:42:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 672F44B17D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 08:42:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eaF9z4Lp7QLH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 08:42:20 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54D6E4B15A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 08:42:20 -0500 (EST)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DK21PRz7bHL;
 Tue, 26 Jan 2021 21:41:05 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:08 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH v1 3/5] KVM: arm64: Support usage of TTRem in guest
 stage-2 translation
Date: Tue, 26 Jan 2021 21:42:00 +0800
Message-ID: <20210126134202.381996-4-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
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

As TTrem can be used when coalesce existing table mappings into a block
in guest stage-2 translation, so just support usage of it.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d536..c8b959e3951b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -437,6 +437,7 @@ struct stage2_map_data {
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
+	u32				ttrem_level;
 };
 
 static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
@@ -633,6 +634,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
+		.ttrem_level	= system_support_level_of_ttrem(),
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
