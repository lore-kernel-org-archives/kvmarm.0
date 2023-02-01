Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3A763AD
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:35 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id t7so8870027wrp.5
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddRi2xjm5qKwZuQWROegNJjMJDcBpGuXL4kHQQYyIJY=;
        b=m6g42YGzLMao8QwbIQapNNIlNo6UVD6eQjNNe+hs/Xc015lEu7ZxVowlHKux4AoHxI
         sb9JQwdCA13OYEGycnWSAcU7p7H//jALkcCbT4USxtFmDjlowAnA8NeI0Ae+BRycKfs0
         tQwK5M8h7OT2IhiMMik5L++Xi+7p02Q+XVQ26bTQYVt53Ypb0Xqjrh5+RSQAht8Oh+KS
         zxBh41JeLuauraexikMDvsV0teAjmi10RikhEUyIIg6Stx2hV+aCk65TMTqzzDFVtD4Z
         4eUV2VHSLfFs6iOEN39tRaYqK20zVBuJ2KBBoBZUolvZPGxIMk8ASXMZqu9fzBuWfgMr
         1+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddRi2xjm5qKwZuQWROegNJjMJDcBpGuXL4kHQQYyIJY=;
        b=3W4ZTYSsiJlHHbVL/CJ+Yl03O8Wy1K7mN2VAHUtCqKr+qS2nNhgl9cbpktr5uQ9w/9
         3xmOhC1xt/36myrH/pNy5nzhIWp9r8FYaN0VOY4wcqA+bJ18BGt9t7RcU7URzHEul3u8
         1/Tf6vc+7tlvzD6BpsUp4XexxR2czS0Gcs7PEm8AWCmqtdoIR+iuiRUk7H3szRnasV0I
         tnW4nUfaUnHL2YWu8trI7ZpobuFTmJTTgg+0hVaL78UIN6/ZiUXVgf0v7Ob4jg26ke9f
         zqaxN70vpubRzBsvALQJZPqiq3rEPskVJQ+PpYD/87RcVcwg/fq/R8DVfdb469UmonJn
         iyJw==
X-Gm-Message-State: AO0yUKVROvY45fGFWYdZTgUV+C6jn8NyV9KYl3wiRT2xzVv23G4jPbRh
	mNVCJbXh9Z5UsEuiqbYqpANWRA==
X-Google-Smtp-Source: AK7set8DmcRt2pyERXxrrjdUCl0ThMt1k62he86OoSE1GzaSXLyMzj+He+IP0QvIHgL8Ls+mmdHtOw==
X-Received: by 2002:a5d:6f03:0:b0:2bf:b140:ae11 with SMTP id ay3-20020a5d6f03000000b002bfb140ae11mr6293750wrb.63.1675256375261;
        Wed, 01 Feb 2023 04:59:35 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:34 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 20/45] KVM: arm64: iommu: Add map() and unmap() operations
Date: Wed,  1 Feb 2023 12:53:04 +0000
Message-Id: <20230201125328.2186498-21-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle map() and unmap() hypercalls by calling the io-pgtable library.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c | 144 ++++++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 7404ea77ed9f..0550e7bdf179 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -183,6 +183,150 @@ int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	return ret;
 }
 
+static int __kvm_iommu_unmap_pages(struct io_pgtable *iopt, unsigned long iova,
+				   size_t pgsize, size_t pgcount)
+{
+	int ret;
+	size_t unmapped;
+	phys_addr_t paddr;
+	size_t total_unmapped = 0;
+	size_t size = pgsize * pgcount;
+
+	while (total_unmapped < size) {
+		paddr = iopt_iova_to_phys(iopt, iova);
+		if (paddr == 0)
+			return -EINVAL;
+
+		/*
+		 * One page/block at a time, because the range provided may not
+		 * be physically contiguous, and we need to unshare all physical
+		 * pages.
+		 */
+		unmapped = iopt_unmap_pages(iopt, iova, pgsize, 1, NULL);
+		if (!unmapped)
+			return -EINVAL;
+
+		ret = __pkvm_host_unshare_dma(paddr, pgsize);
+		if (ret)
+			return ret;
+
+		iova += unmapped;
+		pgcount -= unmapped / pgsize;
+		total_unmapped += unmapped;
+	}
+
+	return 0;
+}
+
+#define IOMMU_PROT_MASK (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |\
+			 IOMMU_NOEXEC | IOMMU_MMIO)
+
+int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			unsigned long iova, phys_addr_t paddr, size_t pgsize,
+			size_t pgcount, int prot)
+{
+	size_t size;
+	size_t granule;
+	int ret = -EINVAL;
+	size_t mapped = 0;
+	struct io_pgtable iopt;
+	struct kvm_hyp_iommu *iommu;
+	size_t pgcount_orig = pgcount;
+	unsigned long iova_orig = iova;
+	struct kvm_hyp_iommu_domain *domain;
+
+	if (prot & ~IOMMU_PROT_MASK)
+		return -EINVAL;
+
+	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
+	    iova + size < iova || paddr + size < paddr)
+		return -EOVERFLOW;
+
+	hyp_spin_lock(&iommu_lock);
+
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (!domain)
+		goto err_unlock;
+
+	granule = 1 << __ffs(iommu->pgtable->cfg.pgsize_bitmap);
+	if (!IS_ALIGNED(iova | paddr | pgsize, granule))
+		goto err_unlock;
+
+	ret = __pkvm_host_share_dma(paddr, size, !(prot & IOMMU_MMIO));
+	if (ret)
+		goto err_unlock;
+
+	iopt = domain_to_iopt(iommu, domain, domain_id);
+	while (pgcount) {
+		ret = iopt_map_pages(&iopt, iova, paddr, pgsize, pgcount, prot,
+				     0, &mapped);
+		WARN_ON(!IS_ALIGNED(mapped, pgsize));
+		pgcount -= mapped / pgsize;
+		if (ret)
+			goto err_unmap;
+		iova += mapped;
+		paddr += mapped;
+	}
+
+	hyp_spin_unlock(&iommu_lock);
+	return 0;
+
+err_unmap:
+	__kvm_iommu_unmap_pages(&iopt, iova_orig, pgsize, pgcount_orig - pgcount);
+err_unlock:
+	hyp_spin_unlock(&iommu_lock);
+	return ret;
+}
+
+int kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			  unsigned long iova, size_t pgsize, size_t pgcount)
+{
+	size_t size;
+	size_t granule;
+	int ret = -EINVAL;
+	struct io_pgtable iopt;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domain;
+
+	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
+	    iova + size < iova)
+		return -EOVERFLOW;
+
+	hyp_spin_lock(&iommu_lock);
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (!domain)
+		goto out_unlock;
+
+	granule = 1 << __ffs(iommu->pgtable->cfg.pgsize_bitmap);
+	if (!IS_ALIGNED(iova | pgsize, granule))
+		goto out_unlock;
+
+	iopt = domain_to_iopt(iommu, domain, domain_id);
+	ret = __kvm_iommu_unmap_pages(&iopt, iova, pgsize, pgcount);
+out_unlock:
+	hyp_spin_unlock(&iommu_lock);
+	return ret;
+}
+
+phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
+				   pkvm_handle_t domain_id, unsigned long iova)
+{
+	phys_addr_t phys = 0;
+	struct io_pgtable iopt;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domain;
+
+	hyp_spin_lock(&iommu_lock);
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (domain) {
+		iopt = domain_to_iopt(iommu, domain, domain_id);
+
+		phys = iopt_iova_to_phys(&iopt, iova);
+	}
+	hyp_spin_unlock(&iommu_lock);
+	return phys;
+}
+
 int kvm_iommu_init_device(struct kvm_hyp_iommu *iommu)
 {
 	void *domains;
-- 
2.39.0

