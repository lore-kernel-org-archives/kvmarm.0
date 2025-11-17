Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB4B33DECA
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405328; cv=none; b=AyaEp+qV9uGaEE9ad3Fu/g7HefooqyQdLsqfE52k/FpJ/1kPiu3n07jK/vtJEA9U8oCeBhM3cUNlnRF3aPeF1wNOOzg5N6WTvBu8Agdsvs7fFEPEBVXOoFySARjWPftYbDnF8RX5Yc+mRJ4XlOmRoArZ5TqtfLpBCihW9eeUOWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405328; c=relaxed/simple;
	bh=WWfCCBvddxM5OBSZYoCRyfY75yEJKzutFES+Qny/bnk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CI5Ug7LrlPOnI/jLFQzKl5rncx61uRWIkyy8q68kqzxrACTyHV3J7o/KnqZhG6RBztI9C2uh/qiBi5L8eg1amsMcSDDaY7pzxkR/GrljCABPEYngvyeSbfgRn67i0YgPJI8KU+IIhPL/ssPJlQtMf9ObjfbqWagnYiraWpfuB7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P28TKWhN; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P28TKWhN"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b736dc23d6eso296227966b.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405323; x=1764010123; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDHGRVWxr8tiMMJHgFkthzaCbmxDX2W8q2KLEFUMQ0M=;
        b=P28TKWhNdgpz7tn3uTr1Ju5q4I1Ak5/0kRN7jkNYnd+YEVzvD9iHwOVs4EacN3/14P
         pOKay2v3YRaJt1rUsQhBAKx3GvDKO3fl3B5/MBGvZ9RHbzntT2nk+IHnChRNPg7TQ7m5
         emAjJsqnWDGqsBBvGG4L6dsytdLVr6ZlGAfzWu1bVp/VEqK4pQGyCMATZujbvSUW+BkT
         /c1nCeTHBBUhg8rBHKCddcP/WoJrzTMloJMHml9au8IPwq+lsEHEHzHcm4dz0RGs2AsJ
         /4qCxeGw38Lv9N7i4iBuCCeKdA/llxZaO7YMUOTsAVjAln+BdebPR/fXMIPVZBlTbUgo
         k3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405323; x=1764010123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDHGRVWxr8tiMMJHgFkthzaCbmxDX2W8q2KLEFUMQ0M=;
        b=RZiZsxJBRXUWK6GS2ON9ZsXBkVyD1vlx7AcHJ+D45WwZM3FKRV9QWGt4jMoFU4wzUt
         DaEq6t0ZbT2AnyITbDQiRiMELQOiqjVMGu3WhMwZ5MK3Fcc7roS/gwwQhu99RRJXgeyH
         vjwKwJ2qQ39THnozQ/1dmswVhibvUMXjlXUHAtejIUlV/2v+MU+PwBxhFoj4SWGe7m+l
         kb+5n4Pr0kk+I/fP3cucWPbwbTdASc8poUSw5tvr8eLYUbJz2CcI31v0XdNfUv/nuu6D
         5VS8WmEQBAg+hF3DubTAM3oAlv9J2uzEQTazDHZKtLEZsdV+YSaVHC1s8CZkNs0HlZwn
         /0vA==
X-Forwarded-Encrypted: i=1; AJvYcCVtRjBFBeCuLSYPQ0fTRARF9MS5oTshTcoz2E0vZEKysvHP5TtPTHDJ5AZZ0hiIT2jKqrvaI/U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIEun1+BpS2rMCzn9hhSOiW137dJyfVEXgUaJb9HNenfS96K8L
	sXnKQjJCHGG2iOU3nfwWuAomFBX/DXgkpjG6ZgLPZ3RNWpZA0+46czxcQLMOM2JfIvs3k6Zytc+
	tq+uQAr+/bwxYzA==
X-Google-Smtp-Source: AGHT+IG0TrsHTOFqlfcoz8fH0quPptO87OaYvkyHV4a6ntExQ0SYHVEwf58bnjdfGxOgO/BBPbDmIMTbefbdcw==
X-Received: from ejclk13.prod.google.com ([2002:a17:907:178d:b0:b73:69d2:27b7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:97cc:b0:b73:7b5d:e76a with SMTP id a640c23a62f3a-b737b5dea0bmr1018806066b.27.1763405322837;
 Mon, 17 Nov 2025 10:48:42 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:04 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-18-smostafa@google.com>
Subject: [PATCH v5 17/27] iommu/arm-smmu-v3-kvm: Probe SMMU HW
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Probe SMMU features from the IDR register space, most of
the logic is common with the kernel.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 57 ++++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  8 +++
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 309194ceebe7..1d552efdc4ae 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -49,6 +49,7 @@ struct arm_vsmmu;
 #define IDR0_S2P			(1 << 0)
 
 #define ARM_SMMU_IDR1			0x4
+#define IDR1_ECMDQ			(1 << 31)
 #define IDR1_TABLES_PRESET		(1 << 30)
 #define IDR1_QUEUES_PRESET		(1 << 29)
 #define IDR1_REL			(1 << 28)
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index b56feae81dda..e45b4e50b1e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -10,6 +10,7 @@
 #include <nvhe/mem_protect.h>
 
 #include "arm_smmu_v3.h"
+#include "../arm-smmu-v3.h"
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
@@ -45,9 +46,56 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 	}
 }
 
+/*
+ * Mini-probe and validation for the hypervisor.
+ */
+static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u32 reg;
+
+	/* IDR0 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
+	smmu->features = smmu_idr0_features(reg);
+
+	/*
+	 * Some MMU600 and MMU700 have errata that prevent them from using nesting,
+	 * not sure how can we identify those, so it's recommended not to enable this
+	 * drivers on such systems.
+	 * And preventing any of those will be too restrictive
+	 */
+	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
+	    !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
+		return -ENXIO;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL | IDR1_ECMDQ))
+		return -EINVAL;
+
+	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+	/* Follows the kernel logic */
+	if (smmu->sid_bits <= STRTAB_SPLIT)
+		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	smmu->features |= smmu_idr3_features(reg);
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
+	smmu->pgsize_bitmap = smmu_idr5_to_pgsize(reg);
+
+	smmu->oas = smmu_idr5_to_oas(reg);
+	if (smmu->oas == 52)
+		smmu->pgsize_bitmap |= 1ULL << 42;
+	else if (!smmu->oas)
+		smmu->oas = 48;
+
+	smmu->ias = 64;
+	smmu->ias = min(smmu->ias, smmu->oas);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
-	int i;
+	int i, ret;
 	size_t nr_pages;
 
 	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
@@ -64,8 +112,13 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 		WARN_ON(__pkvm_host_donate_hyp_mmio(pfn));
 	}
 	smmu->base = hyp_phys_to_virt(smmu->mmio_addr);
-
+	ret = smmu_probe(smmu);
+	if (ret)
+		goto out_ret;
 	return 0;
+out_ret:
+	smmu_deinit_device(smmu);
+	return ret;
 }
 
 static int smmu_init(void)
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 744ee2b7f0b4..3550fa695539 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -12,12 +12,20 @@
  *
  * Other members are filled and used at runtime by the SMMU driver.
  * @base		Virtual address of SMMU registers
+ * @ias			IPA size
+ * @oas			PA size
+ * @pgsize_bitmap	Supported page sizes
+ * @sid_bits		Max number of SID bits supported
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
 	size_t			mmio_size;
 	void __iomem		*base;
 	u32			features;
+	unsigned long		ias;
+	unsigned long		oas;
+	unsigned long		pgsize_bitmap;
+	unsigned int		sid_bits;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.52.0.rc1.455.g30608eb744-goog

