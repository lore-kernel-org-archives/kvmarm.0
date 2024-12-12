Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C94622A813
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026712; cv=none; b=TBQ0X1RgOgkCQp1p0R1iZfZ4nU5gwEtJnpOzACVb2ta/+UrDLoCD0t+ikAlr+adTQkaCjveMz0bRfLCwV/MleVcpLogBPqCIPkpuV1r2ZLkEF7u1ta+3jYRXtu0tsChIvMMFYRGww0XmNvRdpu9v5wp9VXnITvvThLK1B7c2oEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026712; c=relaxed/simple;
	bh=l4FsE44zdt2XfWMQvkqayVSDSJzVGOEltPA16a4uDmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FaVww11mezpi/a30oj6rZLJFV9BG3Mg/Rew5pmDLideWwsB65Yt82aTZSz/dq7PeHZSDSDiB8cXZCrRy47uJnXl9unlilMO2Mr9llXSz1Gk9IMvElacevK/HeFg9OJIce0pgY4QePAM10nXDfv75I4tiz7HlYe+GVXxBHxmFixQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dlx7oYsZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dlx7oYsZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so7196415e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026709; x=1734631509; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iXIRvpZuiwLtOV93NpSTxaaQKTg5ZvL9FYLJBzJb620=;
        b=dlx7oYsZJGwQyKQscCujIDUlmCz9rvZvucUnfW8l8Zl4U3/rV4TcrWXH8+duiL5ve4
         IFl44uZv5O35JlsNWfdw2EJYaCljK/UENyNg2JkbqJ3WObZxixAYEvvnvXCd86QsHo5I
         WFKAezya5mBdvjdQXfwI+Hi7slb9SOgqKBlKYnaFrg8ITM2/DiSpOou0h2yUAJ2GeQQ/
         IN7UCuYvnAofdWcJ2192EzDB5QScxpOQwqmtB0dDZonX4awy3gVQU/S2z1ZiBlo1r3Iq
         OgZncE+jCTdczt0MwrVJPp/U3qfiFoBAmAcugfk2F3aVEDFImpbB+fe0YZayo/SQn15D
         uMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026709; x=1734631509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXIRvpZuiwLtOV93NpSTxaaQKTg5ZvL9FYLJBzJb620=;
        b=p3IgZzkiO0yjqDPerj3iZ0tTSO0R0eMMd3IGr/kf1j4iILI1xeITjUdEZiP4cOrJ4B
         3SLeBBweygox2WRQbzYd8Z7jGXAf2+1aB8S+L5VZJEqDnRuL+66KmDoQvzKnpqZeINjF
         peMGXP95ZRFXm5GJ5uzaCg8m3g5vpB777dMmr9tSXEaLS3FugFp8ClacjFxjvyZhgBgQ
         HWArAi7dxVJ+nWLKa7hIZh8EZfDjaVTRQ4PD7M+fOzhz2Gk7K0dlJIN6XcpRJSTXdCtQ
         Lp0Hqr9ZGzxY2XISOclure8W/fzmUYfiojIxfQdDg0w2BAd0PK9zF8rbc5lzJsWMfuTU
         KouA==
X-Forwarded-Encrypted: i=1; AJvYcCXf1fXPcJGmT32Qp5Anx67V/Lpa7uopCjdAXw0467XqugrHrgA76hOht2oaIlvF7qEVzCcPbsQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YytkL0jBtLOc40BIfIrH36jpn4mczw3l1IgN2vKO9Fx/+e34zka
	I1IHWFEOicKkvILH5jS8FcQnGWjegS8LFDyQZAwxaoxor+leVtufFace0MTBiqHcrbwp2WO2oUX
	GsW9O+vL4vQ==
X-Google-Smtp-Source: AGHT+IHgnk/pCZh1WlJnWXuUNSz2FFTV3sydknebPh6K+YIgIP/qVa3msTdRnMT5NLGcQQqFklKUxKoqwGRQMg==
X-Received: from wmdp19.prod.google.com ([2002:a05:600c:5d3:b0:434:f271:522e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c6:b0:434:a746:9c82 with SMTP id 5b1f17b1804b1-43622823ab1mr38109965e9.5.1734026709204;
 Thu, 12 Dec 2024 10:05:09 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:36 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-13-smostafa@google.com>
Subject: [RFC PATCH v2 12/58] KVM: arm64: Add __pkvm_{use, unuse}_dma()
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

When a page is mapped in an IOMMU page table for DMA, it must
not be donated to a guest or the hypervisor we ensure this with:
- Host can only map pages that are OWNED
- Any page that is mapped is refcounted
- Donation/Sharing is prevented from refcount check in
  host_request_owned_transition()
- No MMIO transtion is allowed beyond IOMMU MMIO which
  happens during de-privilege.
In case in the future shared pages are allowed to be mapped,
similar checks are needed in host_request_unshare() and
host_ack_unshare()

Add 2 functions that would be called before each IOMMU map
and after each successful IOMMU unmap.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 97 +++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 67466b4941b4..d75e64e59596 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -92,6 +92,8 @@ int __pkvm_remove_ioguard_page(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
 bool __pkvm_check_ioguard_page(struct pkvm_hyp_vcpu *hyp_vcpu);
 int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 				    u64 ipa, u64 *ppa);
+int __pkvm_host_use_dma(u64 phys_addr, size_t size);
+int __pkvm_host_unuse_dma(u64 phys_addr, size_t size);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d14f4d63eb8b..0840af20c366 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -513,6 +513,20 @@ bool addr_is_memory(phys_addr_t phys)
 	return !!find_mem_range(phys, &range);
 }
 
+static bool is_range_refcounted(phys_addr_t addr, u64 nr_pages)
+{
+	struct hyp_page *p;
+	int i;
+
+	for (i = 0 ; i < nr_pages ; ++i) {
+		p = hyp_phys_to_page(addr + i * PAGE_SIZE);
+		if (hyp_refcount_get(p->refcount))
+			return true;
+	}
+
+	return false;
+}
+
 static bool addr_is_allowed_memory(phys_addr_t phys)
 {
 	struct memblock_region *reg;
@@ -927,6 +941,9 @@ static int host_request_owned_transition(u64 *completer_addr,
 	u64 size = tx->nr_pages * PAGE_SIZE;
 	u64 addr = tx->initiator.addr;
 
+	if (range_is_memory(addr, addr + size) && is_range_refcounted(addr, tx->nr_pages))
+		return -EINVAL;
+
 	*completer_addr = tx->initiator.host.completer_addr;
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
@@ -938,6 +955,7 @@ static int host_request_unshare(u64 *completer_addr,
 	u64 addr = tx->initiator.addr;
 
 	*completer_addr = tx->initiator.host.completer_addr;
+
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
 }
 
@@ -2047,6 +2065,85 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
+static void __pkvm_host_use_dma_page(phys_addr_t phys_addr)
+{
+	struct hyp_page *p = hyp_phys_to_page(phys_addr);
+
+	hyp_page_ref_inc(p);
+}
+
+static void __pkvm_host_unuse_dma_page(phys_addr_t phys_addr)
+{
+	struct hyp_page *p = hyp_phys_to_page(phys_addr);
+
+	hyp_page_ref_dec(p);
+}
+
+/*
+ * __pkvm_host_use_dma - Mark host memory as used for DMA
+ * @phys_addr:	physical address of the DMA region
+ * @size:	size of the DMA region
+ * When a page is mapped in an IOMMU page table for DMA, it must
+ * not be donated to a guest or the hypervisor we ensure this with:
+ * - Host can only map pages that are OWNED
+ * - Any page that is mapped is refcounted
+ * - Donation/Sharing is prevented from refcount check in
+ *   host_request_owned_transition()
+ * - No MMIO transtion is allowed beyond IOMMU MMIO which
+ *   happens during de-privilege.
+ * In case in the future shared pages are allowed to be mapped,
+ * similar checks are needed in host_request_unshare() and
+ * host_ack_unshare()
+ */
+int __pkvm_host_use_dma(phys_addr_t phys_addr, size_t size)
+{
+	int i;
+	int ret = 0;
+	size_t nr_pages = size >> PAGE_SHIFT;
+
+	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
+		return -EINVAL;
+
+	host_lock_component();
+	ret = __host_check_page_state_range(phys_addr, size, PKVM_PAGE_OWNED);
+	if (ret)
+		goto out_ret;
+
+	if (!range_is_memory(phys_addr, phys_addr + size))
+		goto out_ret;
+
+	for (i = 0; i < nr_pages; i++)
+		__pkvm_host_use_dma_page(phys_addr + i * PAGE_SIZE);
+
+out_ret:
+	host_unlock_component();
+	return ret;
+}
+
+int __pkvm_host_unuse_dma(phys_addr_t phys_addr, size_t size)
+{
+	int i;
+	size_t nr_pages = size >> PAGE_SHIFT;
+
+	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
+		return -EINVAL;
+
+	host_lock_component();
+	if (!range_is_memory(phys_addr, phys_addr + size))
+		goto out_ret;
+	/*
+	 * We end up here after the caller successfully unmapped the page from
+	 * the IOMMU table. Which means that a ref is held, the page is shared
+	 * in the host s2, there can be no failure.
+	 */
+	for (i = 0; i < nr_pages; i++)
+		__pkvm_host_unuse_dma_page(phys_addr + i * PAGE_SIZE);
+
+out_ret:
+	host_unlock_component();
+	return 0;
+}
+
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot)
 {
-- 
2.47.0.338.g60cca15819-goog

