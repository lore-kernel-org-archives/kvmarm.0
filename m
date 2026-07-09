Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4540F8ED
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 10:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593640; cv=none; b=m4DnfSUEXSlM4k8oKImbGTe26NIlgrK9FFnL4o9Ad51/0FwbfJ1gAZ/bDg95vmEdpSHnokiip2QkrxB5uJsDXd0y+PUtTPhHt9p99zmEDx66O3CcqubTl+ZYYbwy38lpDx1o6MZeg3mJwu00HF1eJOWiD2lpaMe1bM+SYsEO0Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593640; c=relaxed/simple;
	bh=rg8b0PL5O9xAe9uKALesdbeYuZuRIaC5vu59T0PMLIA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aU89clA5mw/u5uuZo5X9+l8Th5615fEAoBsBPyUpOb78wk0PLFCdvlt059YClNMKv9BJLXnIf1GhBUMJf5kaeiqHrDR+7NDc1fbecFoFwEufZe8CcbSpuZwfRZL0/CI6im+pSMVt1G5LEhr1Yg5wKmXmbQU5Y0m0R2UXFSN6XM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=36OzWK3j; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="36OzWK3j"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eWPREcJym9bdOle0sxzYXf4RDxMshoqHFiSjTUXHuk4=;
	b=36OzWK3jq6Yhk86VJ7Lzky66AjXZPRuts2Mk4B0y2oxxSlyV1viwRPK6CQMFaRw38X4u+7w0P
	HVJaF96y3oWS2AbEIeP1v5Gw0LqRF3ZxibUfhp5BDEAu2QcmnNt+UTt8SJhYfwiGuwwy0apjXNT
	q3BRn5wQkDhHdJCeeHrpfGo=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gwrpm1vJ1zKm60;
	Thu,  9 Jul 2026 18:31:12 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CD4E40586;
	Thu,  9 Jul 2026 18:40:29 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 9 Jul
 2026 18:40:28 +0800
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
Subject: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Thu, 9 Jul 2026 18:40:23 +0800
Message-ID: <20260709104026.2612599-4-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260709104026.2612599-1-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

The DBM (Dirty Bit Modifier) attribute, introduced in ARMv8.1, enables
hardware to automatically promote write-clean pages to write-dirty. This
prevents the guest from being trapped in EL2 due to missing write
permissions.

In this design, DBM is controlled by the page-table level flag
KVM_PGTABLE_S2_DBM rather than per-PTE software flags. DBM is
automatically set for writable non-device pages when the page-table has
KVM_PGTABLE_S2_DBM flag, which is determined at MMU init time based on
hardware capability.

The DBM bit is set in stage2_set_prot_attr() for initial mappings and
hugepage splitting, and directly manipulated in
kvm_pgtable_stage2_relax_perms() when removing write-protection. On
W->RO downgrade, DBM is cleared to prevent hardware from silently
upgrading RO+DBM back to W+dirty, which would bypass KVM's write
tracking.

kvm_pgtable_stage2_pte_prot() does not extract the DBM bit back into
enum kvm_pgtable_prot because DBM is a page-table policy determined by
pgt->flags, not a per-PTE property. Callers should check
pgt->flags & KVM_PGTABLE_S2_DBM instead.

This ensures DBM is consistently applied across all PTEs, including
during hugepage splitting where child PTEs inherit DBM from the parent
block entry via the pgt->flags mechanism.

Safety: DBM bit is only interpreted by hardware when VTCR_EL2.HD=1.
When HDBSS is not enabled (HD=0), ARM architecture guarantees hardware
completely ignores DBM bit in PTEs.

Co-developed-by: Eillon <yezhenyu2@huawei.com>
Signed-off-by: Eillon <yezhenyu2@huawei.com>
Co-developed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  4 ++++
 arch/arm64/kvm/hyp/pgtable.c         | 35 ++++++++++++++++++++++++++--
 arch/arm64/kvm/mmu.c                 |  3 +++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..5e0fac4bfa53 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -93,6 +93,8 @@ typedef u64 kvm_pte_t;

 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)

+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)

 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
@@ -249,10 +251,12 @@ struct kvm_pgtable_mm_ops {
  * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
  * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
  * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
+ * @KVM_PGTABLE_S2_DBM:	Hardware-managed DBM for writable pages.
  */
 enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_IDMAP			= BIT(0),
 	KVM_PGTABLE_S2_AS_S1			= BIT(1),
+	KVM_PGTABLE_S2_DBM			= BIT(2),
 };

 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 91a7dfad6686..21ec456ecc41 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -731,9 +731,23 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;

-	if (prot & KVM_PGTABLE_PROT_W)
+	if (prot & KVM_PGTABLE_PROT_W) {
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

+		/*
+		 * Set DBM bit for writable non-device pages if the page-table
+		 * has KVM_PGTABLE_S2_DBM flag (system supports HDBSS).
+		 *
+		 * For stage 2 translations using Indirect permissions, if the
+		 * Effective value of VTCR_EL2.HD is 0, then dirty state is
+		 * managed by software. Hardware only updates the dirty state
+		 * when VTCR_EL2.HD=1 (HDBSS enabled).
+		 */
+		if ((pgt->flags & KVM_PGTABLE_S2_DBM) &&
+		    !(prot & KVM_PGTABLE_PROT_DEVICE))
+			attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	}
+
 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);

@@ -1367,9 +1381,26 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;

-	if (prot & KVM_PGTABLE_PROT_W)
+	if (prot & KVM_PGTABLE_PROT_W) {
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

+		/*
+		 * No DEVICE filter needed here: relax_perms is only called
+		 * on FSC_PERM faults. Device pages always get full RW from
+		 * initial mapping and are never write-protected during
+		 * migration, so they never trigger a permission fault.
+		 */
+		if (pgt->flags & KVM_PGTABLE_S2_DBM)
+			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	} else {
+		/*
+		 * Clear DBM on W→RO downgrade to prevent hardware from
+		 * silently upgrading RO+DBM back to W+dirty, which would
+		 * bypass KVM's write tracking and cause data corruption.
+		 */
+		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	}
+
 	ret = stage2_set_xn_attr(prot, &xn);
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e086c01a9325..346efed6e605 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1014,6 +1014,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	if (err)
 		goto out_free_pgtable;

+	if (system_supports_hdbss())
+		pgt->flags |= KVM_PGTABLE_S2_DBM;
+
 	mmu->pgt = pgt;
 	if (is_protected_kvm_enabled())
 		return 0;
--
2.33.0

