Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070551B166
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678242; cv=none; b=QH7FlpOCq32/HwjiwOUS2BTu9uPLwqG9M0NUVPPyIetUrKYLmbffIsHS74g9z+XKb4i8fRgo8SLcjWqF5FF4or8Ums6EoUUY4kouJoHffjGdaJJr/L+OEJkfAILOkp0VH5j4khpjV4bo5aU8+diXxcNHtnEDujaGon4+PIKgBEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678242; c=relaxed/simple;
	bh=wWJglgb/iAHgJX8EmX9HwVtLlJ3TvgDZEromL5/4lLo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uefLOEsCGqOb+31Hzx8TkatRxlYbaczSITZvGlXxk5hpsl/nxf3oXId4d2I6CaZdD4q8/SUY01wYfH/gCW3Dr0tbX2YuVtVLVPqfD4r9geWrSDsRZBGM2Btm26i8Qjqib2e+rpVcXLWhiRfz/DiV8OELJ3wZIq0EZSMTjMYJ68o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hgUnkkio; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hgUnkkio"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CEDPGYC1RPsp34/2huo9oDvdsWGlpazljPcYpxq/p2I=;
	b=hgUnkkiogWWkH7pZKOinYR2DNSU52mvRAVR3j5GBOkMDrN1DJWXryE1cs8DYdMeia8UT3Mlcb
	wjddmZZtAjxjvHIo5Z9Ig+uPXpOh9UsIWklvh4BRmahW52P1uOllLrraCEKesBNfyi7j6SqNB3v
	z/H1Cn3Y7DBA4tLgh+eHxqA=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hvDpB0ZV4zcb44;
	Tue, 29 Sep 2026 18:25:22 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 626594057D;
	Tue, 29 Sep 2026 18:36:57 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:36:56 +0800
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
Subject: [PATCH v5 01/15] KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
Date: Tue, 29 Sep 2026 18:36:41 +0800
Message-ID: <20260929103655.85107-2-zhengtian10@huawei.com>
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

As a first step of changing the encoding for the Stage2 PTE descriptor,
introduce the DBM bit, and adapt every usage of writable to use the DBM
bit (51) instead of S2AP[1]/Dirty bit (7).

With DBM as the write permission bit and S2AP[1] as the dirty state,
the encoding follows the FEAT_S2PIE principle of managing permissions
and dirty state independently.

For this step, we convert usages of RW(Dirty) -> WD(DBM|Dirty): every
writable mapping sets both bits, read-only mappings clear both, and no
behaviour changes.

Link: https://lore.kernel.org/all/20260901171558.2674031-2-leo.bras@arm.com/
Signed-off-by: Leonardo Bras <leo.bras@arm.com>
[zhengtian: keep the nested walker reading writability from S2AP[1]
alone, document why, and reword the commit message]
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 7 ++++---
 arch/arm64/kvm/nested.c              | 5 +++++
 arch/arm64/kvm/ptdump.c              | 4 ++--
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..37baa86d6fd8 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -93,10 +93,13 @@ typedef u64 kvm_pte_t;

 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)

+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)

 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_DBM | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)

 /* pKVM invalid pte encodings */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..50f4d3a74f77 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -732,7 +732,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;

 	if (prot & KVM_PGTABLE_PROT_W)
-		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
@@ -753,7 +753,7 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)

 	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
 		prot |= KVM_PGTABLE_PROT_R;
-	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
+	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
 		prot |= KVM_PGTABLE_PROT_W;

 	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
@@ -1288,6 +1288,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
+					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
 					NULL, NULL,
 					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
@@ -1368,7 +1369,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;

 	if (prot & KVM_PGTABLE_PROT_W)
-		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

 	if (prot & KVM_PGTABLE_PROT_X) {
 		ret = stage2_set_xn_attr(prot, &xn);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b191365d97cc..4d7f52f4bc09 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -388,6 +388,11 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
 	out->output = paddr;
 	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
+	/*
+	 * L1 descriptors keep the legacy encoding: S2AP[1] is the write
+	 * permission, and DBM is RES0 (the L1-visible HAFDBS is limited
+	 * to AF-only).
+	 */
 	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 	out->level = level;
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 69899797dbad..b0cb8d84a9e9 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -40,8 +40,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 		.clear	= " ",
 	},
 	{
-		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_DBM,
+		.val	= KVM_PTE_LEAF_ATTR_HI_S2_DBM,
 		.set	= "W",
 		.clear	= " ",
 	},
--
2.43.0

