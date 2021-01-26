Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43038C433E6
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D60172311D
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D60172311D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B9AF4B28A;
	Tue, 26 Jan 2021 07:45:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Q4KTJt3g60m; Tue, 26 Jan 2021 07:45:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4416C4B284;
	Tue, 26 Jan 2021 07:45:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0A644B27B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fOzb7XXE05yI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 07:45:16 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5EB44B21A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:15 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR1JhfzjDdq;
 Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:03 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH 2/7] kvm: arm64: Use atomic operation when update PTE
Date: Tue, 26 Jan 2021 20:44:39 +0800
Message-ID: <20210126124444.27136-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: yubihong@huawei.com, Cornelia Huck <cohuck@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, zhengchuan@huawei.com,
 Alex Williamson <alex.williamson@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>
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

We are about to add HW_DBM support for stage2 dirty log, so software
updating PTE may race with the MMU trying to set the access flag or
dirty state.

Use atomic oparations to avoid reverting these bits set by MMU.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 41 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..4915ba35f93b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -153,10 +153,34 @@ static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte)
 	return __va(kvm_pte_to_phys(pte));
 }
 
+/*
+ * We may race with the MMU trying to set the access flag or dirty state,
+ * use atomic oparations to avoid reverting these bits.
+ *
+ * Return original PTE.
+ */
+static kvm_pte_t kvm_update_pte(kvm_pte_t *ptep, kvm_pte_t bit_set,
+				kvm_pte_t bit_clr)
+{
+	kvm_pte_t old_pte, pte = *ptep;
+
+	do {
+		old_pte = pte;
+		pte &= ~bit_clr;
+		pte |= bit_set;
+
+		if (old_pte == pte)
+			break;
+
+		pte = cmpxchg_relaxed(ptep, old_pte, pte);
+	} while (pte != old_pte);
+
+	return old_pte;
+}
+
 static void kvm_set_invalid_pte(kvm_pte_t *ptep)
 {
-	kvm_pte_t pte = *ptep;
-	WRITE_ONCE(*ptep, pte & ~KVM_PTE_VALID);
+	kvm_update_pte(ptep, 0, KVM_PTE_VALID);
 }
 
 static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
@@ -723,18 +747,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 
 	data->level = level;
-	data->pte = pte;
-	pte &= ~data->attr_clr;
-	pte |= data->attr_set;
-
-	/*
-	 * We may race with the CPU trying to set the access flag here,
-	 * but worst-case the access flag update gets lost and will be
-	 * set on the next access instead.
-	 */
-	if (data->pte != pte)
-		WRITE_ONCE(*ptep, pte);
-
+	data->pte = kvm_update_pte(ptep, data->attr_set, data->attr_clr);
 	return 0;
 }
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
