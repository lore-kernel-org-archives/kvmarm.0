Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3F283FF2
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725238; cv=none; b=WDcaWEEOf2sfErYj/5wnnRTZ0FuYniI9BfZJtKdKf7J6jDwC+lh0MzGuS03PPCpFTAq6OO1CFEdxS1Ec0/kcn78txHoIJzPh4Q0VqFAsPAJ8LecOVEhdSNzmxB3anlD96CTLBCfc/XNdnqsTUEeiSh/UEolbK2flMrGImfiJO3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725238; c=relaxed/simple;
	bh=68XysYzVRkp7yPxFX0twn9GRICXaS3WOTofD7U03o1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E/s+6seckUiG8FcrmukGitnWuUbeVPbYK0FL2G0BIJN58ptSMPxNoGjC8tq3sDfOQHNx3VCa/DRYg0wMix/raKwkvC7qvvHk1/+ghv9tKNWCx6ngUGoatTWZZfmj1YSnPl1mQHr55j5uMuLLDj7u2x42Ns8Oii/4WnPAnjQxFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PaO+HCrL; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PaO+HCrL"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4538f375e86so36591185e9.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725234; x=1754330034; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VqHi92spgQQq7xJIa7m1bm1iGpbSgFZkVBRcVzoY6CI=;
        b=PaO+HCrLBtmI3tqGBjCC7/QxyUY0TEB1/n++RtQQja/6gszifIIWGXTXzb26LRaI/x
         Uw7iWKFJOdCen1DK6YRjLsiLA2gbP6mECkHAs18AOiJMjJkg5Ii2YgR9dS88M6P1XqoK
         XtF+A8VUiUO4hC6R06ejfMI/5+mF3okmVfJbTWkubpG+8Tc2kWDYo4YXQmxUWeE8g6Hc
         o1VSMpDnDFtOG60XVL7J6N2jSBkeGlSsdJVkmRSrsRSCdOIT4MZPq//DS3GopKgaRKDI
         zoBIWmd7Us9jry9+uWun45mpFwZH3I7OGXj2yGbcaDNAMIlQuHcHF7EFSvw6GnIBw9tN
         hdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725234; x=1754330034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VqHi92spgQQq7xJIa7m1bm1iGpbSgFZkVBRcVzoY6CI=;
        b=B4rMtKjS4hEg7akSk3WSkEULp2a6ktGBEH3FE9P+LuJLcaCxdapPTfKl68YxliKwsi
         VOPdFqJaPHO4gPVz7pU6s3ljVitGDXDUOHck508o4Bigmbs5a4RIU/ooQZp6WmGmz/A0
         KTTujGUWbeQsjYVigUx1/KBBZgq5BQ9Sgf5PMX2q61WnBMX2teA1D3zEzhIs9PA7N6s0
         oUm8y2aP283XQamOr/gqWMjAR/WUN6EwZYUWH+TwXIdBwSgzQMdSCjIHSj+C4uUrG6oO
         QsWqKkhDzitx3wlfjfdXqQsSKmWnroMVmQyEw1c/XhGWfy0m/0QLosCbVFQnI5fktghn
         Ke5w==
X-Forwarded-Encrypted: i=1; AJvYcCU10+T1zvHwBX7kHp21lDisoQWs9ScMa3yDuNkkCY420V8VhyoiEdNhWYOQG6aRDpFfvrm/EK0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMMbkMIXNUT8PONVAY9WeO67Znn02AjECta3lkVEQk2N86RLAl
	IWsElMBqXhdYlTiWNUY1h0InNHrtu1RZPwz+TyWfw3fb1/XMtfKM5GniMPcoPFt/4rVgSbIYF0U
	35BwurY2nKX316w==
X-Google-Smtp-Source: AGHT+IHT79YZti6f2oD/dU8174eWV4cxRx+bo5QS0U+d88lWGOSu4bRkgBXGcKpAbcfb4esmAkOl21DA22Bq6g==
X-Received: from wmrn36.prod.google.com ([2002:a05:600c:5024:b0:456:26d1:4451])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fd3:b0:455:ed0f:e8d4 with SMTP id 5b1f17b1804b1-4588cd731admr9962885e9.10.1753725233793;
 Mon, 28 Jul 2025 10:53:53 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:12 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-26-smostafa@google.com>
Subject: [PATCH v3 25/29] iommu/arm-smmu-v3-kvm: Add enable/disable device HVCs
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add implementation of enable/disable HVCs, for enable, the STE of
the device would be configured to use the idmap page table, while
for disable it would zero the STE.

As now STEs can be configured from kernel, add a lock to protect
against concurrent access.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 109 +++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  11 ++
 2 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 38d81cd6d24a..85131962094f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -143,10 +143,15 @@ static int smmu_tlb_inv_range_smmu(struct hyp_arm_smmu_v3_device *smmu,
 				   struct arm_smmu_cmdq_ent *cmd,
 				   unsigned long iova, size_t size, size_t granule)
 {
+	int ret;
+
+	hyp_spin_lock(&smmu->lock);
 	arm_smmu_tlb_inv_build(cmd, iova, size, granule,
 			       idmap_pgtable->cfg.pgsize_bitmap, smmu,
 			       __smmu_add_cmd, NULL);
-	return smmu_sync_cmd(smmu);
+	ret = smmu_sync_cmd(smmu);
+	hyp_spin_unlock(&smmu->lock);
+	return ret;
 }
 
 static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t granule,
@@ -183,7 +188,6 @@ static const struct iommu_flush_ops smmu_tlb_ops = {
 	.tlb_add_page	= smmu_tlb_add_page,
 };
 
-__maybe_unused
 static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, unsigned long ste)
 {
 	struct arm_smmu_cmdq_ent cmd = {
@@ -409,6 +413,9 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	}
 	smmu->base = hyp_phys_to_virt(smmu->mmio_addr);
 
+	hyp_spin_lock_init(&smmu->lock);
+	BUILD_BUG_ON(sizeof(smmu->lock) != sizeof(hyp_spinlock_t));
+
 	ret = smmu_init_registers(smmu);
 	if (ret)
 		goto out_err;
@@ -430,6 +437,102 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	return ret;
 }
 
+static struct hyp_arm_smmu_v3_device *smmu_id_to_ptr(pkvm_handle_t smmu_id)
+{
+	if (smmu_id >= kvm_hyp_arm_smmu_v3_count)
+		return NULL;
+	smmu_id = array_index_nospec(smmu_id, kvm_hyp_arm_smmu_v3_count);
+
+	return &kvm_hyp_arm_smmu_v3_smmus[smmu_id];
+}
+
+static void smmu_init_s2_ste(struct arm_smmu_ste *ste)
+{
+	struct io_pgtable_cfg *cfg;
+	u64 ts, sl, ic, oc, sh, tg, ps;
+
+	cfg = &idmap_pgtable->cfg;
+	ps = cfg->arm_lpae_s2_cfg.vtcr.ps;
+	tg = cfg->arm_lpae_s2_cfg.vtcr.tg;
+	sh = cfg->arm_lpae_s2_cfg.vtcr.sh;
+	oc = cfg->arm_lpae_s2_cfg.vtcr.orgn;
+	ic = cfg->arm_lpae_s2_cfg.vtcr.irgn;
+	sl = cfg->arm_lpae_s2_cfg.vtcr.sl;
+	ts = cfg->arm_lpae_s2_cfg.vtcr.tsz;
+
+	ste->data[0] = STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
+	ste->data[1] = FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING);
+	ste->data[2] = FIELD_PREP(STRTAB_STE_2_VTCR,
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, ps) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, tg) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, sh) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, oc) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, ic) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, sl) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, ts)) |
+		 FIELD_PREP(STRTAB_STE_2_S2VMID, 0) |
+		 STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2R;
+	ste->data[3] = cfg->arm_lpae_s2_cfg.vttbr & STRTAB_STE_3_S2TTB_MASK;
+}
+
+static int smmu_enable_dev(pkvm_handle_t iommu, pkvm_handle_t dev)
+{
+	static struct arm_smmu_ste *ste, target;
+	struct hyp_arm_smmu_v3_device *smmu = smmu_id_to_ptr(iommu);
+	int ret;
+
+	if (!smmu)
+		return -ENODEV;
+
+	hyp_spin_lock(&smmu->lock);
+	ste = smmu_get_alloc_ste_ptr(smmu, dev);
+	if (!ste) {
+		ret = - EINVAL;
+		goto out_ret;
+	}
+
+	smmu_init_s2_ste(&target);
+	WRITE_ONCE(ste->data[1], target.data[1]);
+	WRITE_ONCE(ste->data[2], target.data[2]);
+	WRITE_ONCE(ste->data[3], target.data[3]);
+	smmu_sync_ste(smmu, dev, (unsigned long)ste);
+	WRITE_ONCE(ste->data[0], target.data[0]);
+	ret = smmu_sync_ste(smmu, dev, (unsigned long)ste);
+
+out_ret:
+	hyp_spin_unlock(&smmu->lock);
+	return ret;
+}
+
+static int smmu_disable_dev(pkvm_handle_t iommu, pkvm_handle_t dev)
+{
+	static struct arm_smmu_ste *ste;
+	struct hyp_arm_smmu_v3_device *smmu = smmu_id_to_ptr(iommu);
+	int ret;
+
+	if (!smmu)
+		return -ENODEV;
+
+	hyp_spin_lock(&smmu->lock);
+	ste = smmu_get_alloc_ste_ptr(smmu, dev);
+	if (!ste) {
+		ret = -EINVAL;
+		goto out_ret;
+	}
+
+	WRITE_ONCE(ste->data[0], 0);
+	smmu_sync_ste(smmu, dev, (unsigned long)ste);
+	WRITE_ONCE(ste->data[1], 0);
+	WRITE_ONCE(ste->data[2], 0);
+	WRITE_ONCE(ste->data[3], 0);
+	ret = smmu_sync_ste(smmu, dev, (unsigned long)ste);
+
+out_ret:
+	hyp_spin_unlock(&smmu->lock);
+	return ret;
+}
+
 static int smmu_init_pgt(void)
 {
 	/* Default values overridden based on SMMUs common features. */
@@ -568,4 +671,6 @@ static void smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
 	.host_stage2_idmap		= smmu_host_stage2_idmap,
+	.enable_dev			= smmu_enable_dev,
+	.disable_dev			= smmu_disable_dev,
 };
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 5c2f121837ad..89faa622af24 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -4,6 +4,10 @@
 
 #include <asm/kvm_asm.h>
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/spinlock.h>
+#endif
+
 #include "../arm-smmu-v3-common.h"
 
 /*
@@ -18,6 +22,7 @@
  * @oas			OAS of the SMMUv3
  * @pgsize_bitmap	Pages sizes supported by the SMMUv3
  * Other members are filled and used at runtime by the SMMU driver.
+ * @lock		Lock to protect the SMMU resources (STE/CMDQ)
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -29,6 +34,12 @@ struct hyp_arm_smmu_v3_device {
 	unsigned int            ias;
 	unsigned int            oas;
 	size_t                  pgsize_bitmap;
+	/* nvhe/spinlock.h not exposed to EL1. */
+#ifdef __KVM_NVHE_HYPERVISOR__
+	hyp_spinlock_t		lock;
+#else
+	u32			lock;
+#endif
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.50.1.552.g942d659e1b-goog

