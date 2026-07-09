Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55687407590
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 10:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593636; cv=none; b=jSBdTWPVZnSu3APS9un6YM738rBat1lk6wMnnnZoqEFge2j3FKGdsu0l/CvHWOCTwhJ/LroM2bYX5aONzzGFu6BazNWSEsiFGfJxRJUhElQNioLYZb6qVua95updSKJZraJc6qV4RhTsfjVNN3Ymlwxvo3YipYIssOFKHaSgEto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593636; c=relaxed/simple;
	bh=HiUAuijxG943HWMaSUbGa6+RnFLqMHI118VSDcC0tp4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+CPNPdN5tiOiLl5irVoDaQ5oPZEITFNH1JQpFOL//IiM5C9uqDBtZUYbq7JlhwjgZEOLDJOGALnPfq49gSxGIhin7+sGggc+0gRaRkdG+cOadLPwQEgPpy2cUC45HBb4tW6+vmnvJedZPRQlmUHIMZsDG8LC9O84p1VBC6fi7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hekE5s7/; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hekE5s7/"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jijx0ahIqC44fYp2NoWKu1QyFuyycAV3i8HM+hvqKxw=;
	b=hekE5s7/JixoudAh6w1oWWluEXM2AkY87QjnrtSve1WJVveQejQqAtr1uZpbW+EeG3DiIsLpZ
	RV3VgjS9Bkl23R338jnPsf58fP5YlptfIlnkpxuIJCGALINBbums44J9c6rQuTWHqJzvfQSOYlF
	IPBuQ6moWkjbHPDvTvUlLiY=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gwrpp6x5Jz1cyPZ;
	Thu,  9 Jul 2026 18:31:14 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 378DE40586;
	Thu,  9 Jul 2026 18:40:28 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 9 Jul
 2026 18:40:27 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v4 1/6] KVM: arm64: Enable eager hugepage splitting if HDBSS is available
Date: Thu, 9 Jul 2026 18:40:21 +0800
Message-ID: <20260709104026.2612599-2-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260709104026.2612599-1-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
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

FEAT_HDBSS speeds up guest memory dirty tracking by avoiding a page fault
and saving the entry in a tracking structure.

That may be a problem when we have guest memory backed by hugepages or
transparent huge pages, as it's not possible to do on-demand hugepage
splitting, relying only on eager hugepage splitting.

So, at stage2 initialization, enable eager hugepage splitting with
chunk = 256K * PAGE_SIZE if the system supports HDBSS.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..e086c01a9325 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;

-	 /* The eager page splitting is disabled by default */
-	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+	 /* The eager page splitting is disabled by default if system has no HDBSS */
+	if (system_supports_hdbss())
+		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
+	else
+		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->split_page_cache.gfp_zero = __GFP_ZERO;

 	mmu->pgd_phys = __pa(pgt->pgd);
--
2.33.0

