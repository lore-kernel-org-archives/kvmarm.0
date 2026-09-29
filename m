Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D03514746
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678243; cv=none; b=NV0r/BsA2gnB1GaqespTN3dzB/mZg+tDFWs3H0gKDX+RI5Fs09qXrvMovhjQY+dC87sbjNY5SxCyfS2fb9yJ6r5kVCCkzFxoAIKshJuKcUsljsXULLq/z9hJgyu0NxKtpGKwut/mM/41AFXwzESpswHl5ykXHXEuHNQDttag3/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678243; c=relaxed/simple;
	bh=7dAGAZt61NcYflfhAv0nDLW17VM0ti4kgeJDgL6NmkU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=biwR09WgJJl1RNXfXDEM1ZVRIAevKajPYMGBwyOSc8tqJaUHMBmYd3fMvlouiu0zwd0lMorPc8LiEuWBI2g3Jsj6MVauDaj8w7TT+TvJBs0rLJaYRElFr+hQcsT83eDpsN7LQaWFimBivSsPPZc78iu05qSbww9evE1z05bY2XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ljGVRr9d; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ljGVRr9d"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FG2fSrBLzTEi5cgZPg/wmj6p28Uf1X+o6OUro3L7LTw=;
	b=ljGVRr9djyRE4Nc9scgYujgOAYfl8s9i1kh2EthogOwA4BFrUs6cZ6GZawsCn9OyBxbDJe1P+
	Z0znAg+Rz4XKlsJ5d8Drw0f1+0hAkNZRjsplR4Ne6mu7GHDsLwEUC6zBhWPDo3iiHeXUD+LKDWQ
	FxANwd2uTN7saIN91CWsX9w=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnZ4yH4zmV8f;
	Tue, 29 Sep 2026 18:24:50 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id F20DA4055B;
	Tue, 29 Sep 2026 18:36:58 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:36:57 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<zhengtian10@huawei.com>, <leo.bras@arm.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <tangchengchang@huawei.com>,
	<yezhenyu2@huawei.com>, <yubihong@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>,
	<mark.rutland@arm.com>, <seanjc@google.com>, <rdunlap@infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<skhan@linuxfoundation.org>
Subject: [PATCH v5 03/15] KVM: arm64: Introduce a dedicated walker for stage2 write-protect
Date: Tue, 29 Sep 2026 18:36:43 +0800
Message-ID: <20260929103655.85107-4-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260929103655.85107-1-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: Leonardo Bras <leo.bras@arm.com>

The new walker cleans the dirty bit on leaf entries, as well as clean
the DBM bit in blocks so it still faults for lazy hugepage splitting when
we enable FEAT_HDBSS in future patches.

With disabled HDBSS, there should be no change in faulting behavior.

Link: https://lore.kernel.org/all/20260901171558.2674031-4-leo.bras@arm.com/
Signed-off-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 357b06648418..aa0448d3a6a4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1293,12 +1293,34 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 	return 0;
 }

+static int stage2_wrprotect_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				   enum kvm_pgtable_walk_flags visit)
+{
+	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+
+	/* We remove DBM on blocks so they can fault and get split */
+	if (ctx->level < KVM_PGTABLE_LAST_LEVEL)
+		new &= ~KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
+	/*
+	 * We may race with the CPU trying to set the access flag here,
+	 * but worst-case the access flag update gets lost and will be
+	 * set on the next access instead.
+	 */
+	if (kvm_pte_valid(ctx->old) && ctx->old != new)
+		WRITE_ONCE(*ctx->ptep, new);
+
+	return 0;
+}
+
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	return stage2_update_leaf_attrs(pgt, addr, size, 0,
-					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL,
-					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_wrprotect_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }

 void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
--
2.43.0

