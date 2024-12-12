Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C1622652B
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026751; cv=none; b=DEUnzQ6pK57iC7kjGsn29QQzg0sJwkizIbVzfTSvEmbCYdkPSQtp16aWwsOB2dwouCBViA8l0crm0x1rafAg060FHnudQSsiFTcLaKfVyO/Y5ewjccB8ptDTKkkbg2yGnfUOj+gygfyX6mMFtFtdLVScSqbcWqBi/XNmc+mPG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026751; c=relaxed/simple;
	bh=vx+jCTtR7P3OGsZuyIcw2+7atnaHKZPpkcPBracoBQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MK50S7VkVf+CPxXwmcKvNVR/kKZUJiRbIsjiV8esrSdHTHgGT97kVRmxyQrgYGbiCjriMz7sQQeR87jGnuivrvrQUsGMxE8EjuoP2dBIIdWPDstw4m4W5Dk44abxlcwUWuRNTGQX7y8PmsNAnQAsxza/dtHKcFAfu5YUn9Gq+VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fgpd9zJa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fgpd9zJa"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436228ebc5eso5626985e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026748; x=1734631548; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfVS3osJ9q22MREQZzZV+YBtg9RTu0l7wPS76L6zkGo=;
        b=fgpd9zJa0EXo8RYelk/tBTPnq1W5rbUwSnGSqj0otFTxywV/lcr0smUy6k616WfEgn
         HRVf7H8/k8YT2t+56pdabCoMydnjadAM2FYVg3o/casfCe9EknVFbKQ623S5eSmwek3J
         9jkQw5/LGAr/xztF11a9BdIq82+uyRfeaPSkj1PVmahZ9BjC3U6B+blt+9HafZPCEzXa
         wDvYVqeTqSqsCGBaqui6OuQb9sty+oTgwGcNNmVFZlmOufUGJa5DHfG8r9YdsoNXDFyY
         FYNh9gyAk/vfNwopI1HRDDf7MymR7ZePhIH9QdwpJh8XVbHA0c/JmViD7phoAI/DbPSu
         YnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026748; x=1734631548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfVS3osJ9q22MREQZzZV+YBtg9RTu0l7wPS76L6zkGo=;
        b=n6kxwlO42r/K7Cv8MhVNp4QWz8+6g51a0wlqqsgQBIcL0oa3y1mIIQllb698MQ5Up1
         u0vYmJSDXT0UBlPbvTivW10X/ZSxB9l6n8v+d3EYosycXo2+yQubq7L+uFTJ16lahIhd
         mfWBpgW7vPgyHjXvKUgIyXM4bYY5zBe12P++uhEW4mKvgDwdw0OwmhNbJyr5PWlIx6Rk
         IRmP9+nPX5gLLf2hm6Eg0rN7pp1u2dgUl4eFvSXbfmGHj1Am1NJIH1tMxNiSGUYNXVvt
         wklJsCvtknBvSksSe8pdCN3duylq4Pnu7ASu1H+D7bDps0r/ug3xKY4Q3hbnnXkrjiAW
         QiDw==
X-Forwarded-Encrypted: i=1; AJvYcCVt65I5Nmd0Q4v5Xocl5pb8WflvkEpfkQsZWbkaz6W6i8VgqkInL+8xn7EywljTvwnuysEBsDs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw56/G4rPFMBSLjyDa/V07ELYw8AUpZwPcwr0AA27beiUvkH+zH
	5tiU2MhGd00VFKiJwnrqPJQaEQ0IM5HamVCGRcHFYghUlmxEFdNWZlKsnV+lGrro/10BePtSjhW
	CiWNry4wDpQ==
X-Google-Smtp-Source: AGHT+IGxFKclHRVEq5ycO+SmEmjwkOwSKayY3zd4xYSx9lryA9h551F87hCr0p5MkmL1i0ozD721MEZuLPSrCg==
X-Received: from wmgg28.prod.google.com ([2002:a05:600d:1c:b0:434:f847:ba1b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:468b:b0:431:54d9:da57 with SMTP id 5b1f17b1804b1-4361c41811cmr73715735e9.30.1734026748472;
 Thu, 12 Dec 2024 10:05:48 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:55 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-32-smostafa@google.com>
Subject: [RFC PATCH v2 31/58] KVM: arm64: smmu-v3: Support io-pgtable
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Implement the hypervisor version of io-pgtable allocation functions,
mirroring drivers/iommu/io-pgtable-arm.c. Page allocation uses the
IOMMU pool filled by the host.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +
 .../arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c | 153 ++++++++++++++++++
 include/linux/io-pgtable-arm.h                |  11 ++
 3 files changed, 166 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index edfd8a11ac90..e4f662b1447f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -17,6 +17,8 @@ hyp-obj-$(CONFIG_MODULES) += modules.o
 hyp-obj-y += $(lib-objs)
 
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/arm-smmu-v3.o
+hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/io-pgtable-arm.o \
+	../../../../../drivers/iommu/io-pgtable-arm-common.o
 
 $(obj)/hyp.lds: $(src)/hyp.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c b/arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c
new file mode 100644
index 000000000000..aa5bf7c0ed03
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Arm Ltd.
+ */
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <kvm/arm_smmu_v3.h>
+#include <linux/types.h>
+#include <linux/gfp_types.h>
+#include <linux/io-pgtable-arm.h>
+
+#include <nvhe/alloc.h>
+#include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+
+int arm_lpae_map_exists(void)
+{
+	return -EEXIST;
+}
+
+int arm_lpae_unmap_empty(void)
+{
+	return -EEXIST;
+}
+
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
+			     struct io_pgtable_cfg *cfg, void *cookie)
+{
+	void *addr;
+
+	if (!PAGE_ALIGNED(size))
+		return NULL;
+
+	addr = kvm_iommu_donate_pages(get_order(size), 0);
+
+	if (addr && !cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(addr, size);
+
+	return addr;
+}
+
+void __arm_lpae_free_pages(void *addr, size_t size, struct io_pgtable_cfg *cfg,
+			   void *cookie)
+{
+	u8 order;
+
+	/*
+	 * It's guaranteed all allocations are aligned, but core code
+	 * might free PGD with it's actual size.
+	 */
+	order = get_order(PAGE_ALIGN(size));
+
+	if (!cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(addr, size);
+
+	kvm_iommu_reclaim_pages(addr, order);
+}
+
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg)
+{
+	if (!cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(ptep, sizeof(*ptep) * num_entries);
+}
+
+static int kvm_arm_io_pgtable_init(struct io_pgtable_cfg *cfg,
+				   struct arm_lpae_io_pgtable *data)
+{
+	int ret = -EINVAL;
+
+	if (cfg->fmt == ARM_64_LPAE_S2)
+		ret = arm_lpae_init_pgtable_s2(cfg, data);
+	else if (cfg->fmt == ARM_64_LPAE_S1)
+		ret = arm_lpae_init_pgtable_s1(cfg, data);
+
+	if (ret)
+		return ret;
+
+	data->iop.cfg = *cfg;
+	data->iop.fmt	= cfg->fmt;
+
+	return 0;
+}
+
+struct io_pgtable *kvm_arm_io_pgtable_alloc(struct io_pgtable_cfg *cfg,
+					    void *cookie,
+					    int *out_ret)
+{
+	size_t pgd_size, alignment;
+	struct arm_lpae_io_pgtable *data;
+	int ret;
+
+	data = hyp_alloc(sizeof(*data));
+	if (!data) {
+		*out_ret = hyp_alloc_errno();
+		return NULL;
+	}
+
+	ret = kvm_arm_io_pgtable_init(cfg, data);
+	if (ret)
+		goto out_free;
+
+	pgd_size = PAGE_ALIGN(ARM_LPAE_PGD_SIZE(data));
+	data->pgd = __arm_lpae_alloc_pages(pgd_size, 0, &data->iop.cfg, cookie);
+	if (!data->pgd) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	/*
+	 * If it has eight or more entries, the table must be aligned on
+	 * its size. Otherwise 64 bytes.
+	 */
+	alignment = max(pgd_size, 8 * sizeof(arm_lpae_iopte));
+	if (!IS_ALIGNED(hyp_virt_to_phys(data->pgd), alignment)) {
+		__arm_lpae_free_pages(data->pgd, pgd_size,
+				      &data->iop.cfg, cookie);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	data->iop.cookie = cookie;
+	if (cfg->fmt == ARM_64_LPAE_S2)
+		data->iop.cfg.arm_lpae_s2_cfg.vttbr = __arm_lpae_virt_to_phys(data->pgd);
+	else if (cfg->fmt == ARM_64_LPAE_S1)
+		data->iop.cfg.arm_lpae_s1_cfg.ttbr = __arm_lpae_virt_to_phys(data->pgd);
+
+	if (!data->iop.cfg.coherent_walk)
+		kvm_flush_dcache_to_poc(data->pgd, pgd_size);
+
+	/* Ensure the empty pgd is visible before any actual TTBR write */
+	wmb();
+
+	*out_ret = 0;
+	return &data->iop;
+out_free:
+	hyp_free(data);
+	*out_ret = ret;
+	return NULL;
+}
+
+int kvm_arm_io_pgtable_free(struct io_pgtable *iopt)
+{
+	struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iopt);
+	size_t pgd_size = ARM_LPAE_PGD_SIZE(data);
+
+	if (!data->iop.cfg.coherent_walk)
+		kvm_flush_dcache_to_poc(data->pgd, pgd_size);
+
+	io_pgtable_tlb_flush_all(iopt);
+	__arm_lpae_free_pgtable(data, data->start_level, data->pgd);
+	hyp_free(data);
+	return 0;
+}
diff --git a/include/linux/io-pgtable-arm.h b/include/linux/io-pgtable-arm.h
index 337e9254fdbd..88922314157d 100644
--- a/include/linux/io-pgtable-arm.h
+++ b/include/linux/io-pgtable-arm.h
@@ -191,8 +191,19 @@ static inline bool iopte_table(arm_lpae_iopte pte, int lvl)
 	return iopte_type(pte) == ARM_LPAE_PTE_TYPE_TABLE;
 }
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/memory.h>
+#define __arm_lpae_virt_to_phys	hyp_virt_to_phys
+#define __arm_lpae_phys_to_virt	hyp_phys_to_virt
+
+struct io_pgtable *kvm_arm_io_pgtable_alloc(struct io_pgtable_cfg *cfg,
+					    void *cookie,
+					    int *out_ret);
+int kvm_arm_io_pgtable_free(struct io_pgtable *iop);
+#else
 #define __arm_lpae_virt_to_phys	__pa
 #define __arm_lpae_phys_to_virt	__va
+#endif
 
 /* Generic functions */
 void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
-- 
2.47.0.338.g60cca15819-goog

