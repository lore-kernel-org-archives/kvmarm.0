Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B573229
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:31 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id d14so17221755wrr.9
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lU6O9CZcUVv8hYcDQ334N0zwZYT/omiCvAafRyvmTzE=;
        b=m/voFpeGQsUt+6NrWmVb5fj87WGpfE8oDM/HYbxPMBaboItMuRhjxJpWOC0UMmot2U
         HKiagg3IyUbb7RAY8EOvyDQ7kQrzP5VHWttvLSk3E6AM1J5Mbjt+FfakdBoywoJrkuev
         whu4Zb/6+vc3sD6va7O/OM5TjGtMaKYW8uiJxQQHP+I89qPsMHvnujrHvYUkmc7Km9Cp
         jw58YT7nvqAtjn66VOgsCgsENZyeq1kzuA17D18ZlCVWR6+hoVL1jC1uOJomzKkdLi5d
         TaBeleGJimSEybsh7xkzdNXyAeURNnapi11HfA5nZfDPdACQAqJu3gyVjm+f0KNh4XaA
         e1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lU6O9CZcUVv8hYcDQ334N0zwZYT/omiCvAafRyvmTzE=;
        b=UlK9P9SZdJxvkj52TPx69lum7f3+YxBD7KhAoO849OEjfFgC53aSRfCkUzZ16JgRCV
         ynBGRZ7OKUKp9QdBXe4towfno/pOnEDR1XWEzE6V8CQDrkxF2CQ15kIrHTBeA74CDHgJ
         wT0hu/ViDUkAQEm+PGYH3jPjR3VigbgeWMQ8c3M+VtPp2EZg3OAI9RzRYBoOAidb6Q8A
         crMsjSQXOCLnmWe++Csdf3zfcPnuuWZOWvIbpMgTRHcuVvOJZhp2YUV8KL01wDKf2Uky
         BNn41WuegSnXvt+Ja8kxIAVxZcuLK8uNo5uGjltIJk/1yPGEGpuBQq2TB35rEOOfErsM
         2q5g==
X-Gm-Message-State: AO0yUKXoU5Sj/iLK80mZPCEKRwZ4DBK8hP9anolbVLCVzXrBCrh626Dn
	eW1gdLvBu3QmXDCwg52+oaGCcg==
X-Google-Smtp-Source: AK7set8mqrMZj30mZqLkmp/Suy++GhfmsN1hQm9nbWbdJ8dYAZEUk6nRMACSn+IwYHRF/R++5hECXw==
X-Received: by 2002:a05:6000:1285:b0:2bf:c58b:9cba with SMTP id f5-20020a056000128500b002bfc58b9cbamr2384179wrx.60.1675256371211;
        Wed, 01 Feb 2023 04:59:31 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:30 -0800 (PST)
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
Subject: [RFC PATCH 15/45] KVM: arm64: pkvm: Add __pkvm_host_share/unshare_dma()
Date: Wed,  1 Feb 2023 12:52:59 +0000
Message-Id: <20230201125328.2186498-16-jean-philippe@linaro.org>
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

Host pages mapped in the SMMU must not be donated to the guest or
hypervisor, since the host could then use DMA to break confidentiality.
Mark them shared in the host stage-2 page tables, and keep a refcount in
the hyp vmemmap.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 185 ++++++++++++++++++
 2 files changed, 188 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 021825aee854..a363d58a998b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -58,6 +58,7 @@ enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
 	PKVM_ID_GUEST,
+	PKVM_ID_IOMMU,
 };
 
 extern unsigned long hyp_nr_cpus;
@@ -72,6 +73,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
+int __pkvm_host_share_dma(u64 phys_addr, size_t size, bool is_ram);
+int __pkvm_host_unshare_dma(u64 phys_addr, size_t size);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 856673291d70..dcf08ce03790 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1148,6 +1148,9 @@ static int check_share(struct pkvm_mem_share *share)
 	case PKVM_ID_GUEST:
 		ret = guest_ack_share(completer_addr, tx, share->completer_prot);
 		break;
+	case PKVM_ID_IOMMU:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1185,6 +1188,9 @@ static int __do_share(struct pkvm_mem_share *share)
 	case PKVM_ID_GUEST:
 		ret = guest_complete_share(completer_addr, tx, share->completer_prot);
 		break;
+	case PKVM_ID_IOMMU:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1239,6 +1245,9 @@ static int check_unshare(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_ack_unshare(completer_addr, tx);
 		break;
+	case PKVM_ID_IOMMU:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1273,6 +1282,9 @@ static int __do_unshare(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_complete_unshare(completer_addr, tx);
 		break;
+	case PKVM_ID_IOMMU:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1633,6 +1645,179 @@ void hyp_unpin_shared_mem(void *from, void *to)
 	host_unlock_component();
 }
 
+static int __host_check_page_dma_shared(phys_addr_t phys_addr)
+{
+	int ret;
+	u64 hyp_addr;
+
+	/*
+	 * The page is already refcounted. Make sure it's owned by the host, and
+	 * not part of the hyp pool.
+	 */
+	ret = __host_check_page_state_range(phys_addr, PAGE_SIZE,
+					    PKVM_PAGE_SHARED_OWNED);
+	if (ret)
+		return ret;
+
+	/*
+	 * Refcounted and owned by host, means it's either mapped in the
+	 * SMMU, or it's some VM/VCPU state shared with the hypervisor.
+	 * The host has no reason to use a page for both.
+	 */
+	hyp_addr = (u64)hyp_phys_to_virt(phys_addr);
+	return __hyp_check_page_state_range(hyp_addr, PAGE_SIZE, PKVM_NOPAGE);
+}
+
+static int __pkvm_host_share_dma_page(phys_addr_t phys_addr, bool is_ram)
+{
+	int ret;
+	struct hyp_page *p = hyp_phys_to_page(phys_addr);
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= phys_addr,
+			},
+			.completer	= {
+				.id	= PKVM_ID_IOMMU,
+			},
+		},
+	};
+
+	hyp_assert_lock_held(&host_mmu.lock);
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
+	/*
+	 * Some differences between handling of RAM and device memory:
+	 * - The hyp vmemmap area for device memory is not backed by physical
+	 *   pages in the hyp page tables.
+	 * - Device memory is unmapped automatically under memory pressure
+	 *   (host_stage2_try()) and the ownership information would be
+	 *   discarded.
+	 * We don't need to deal with that at the moment, because the host
+	 * cannot share or donate device memory, only RAM.
+	 *
+	 * Since 'is_ram' is only a hint provided by the host, we do need to
+	 * make sure of it.
+	 */
+	if (!is_ram)
+		return addr_is_memory(phys_addr) ? -EINVAL : 0;
+
+	ret = hyp_page_ref_inc_return(p);
+	BUG_ON(ret == 0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		ret = do_share(&share);
+	else
+		ret = __host_check_page_dma_shared(phys_addr);
+
+	if (ret)
+		hyp_page_ref_dec(p);
+
+	return ret;
+}
+
+static int __pkvm_host_unshare_dma_page(phys_addr_t phys_addr)
+{
+	struct hyp_page *p = hyp_phys_to_page(phys_addr);
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= phys_addr,
+			},
+			.completer	= {
+				.id	= PKVM_ID_IOMMU,
+			},
+		},
+	};
+
+	hyp_assert_lock_held(&host_mmu.lock);
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
+	if (!addr_is_memory(phys_addr))
+		return 0;
+
+	if (!hyp_page_ref_dec_and_test(p))
+		return 0;
+
+	return do_unshare(&share);
+}
+
+/*
+ * __pkvm_host_share_dma - Mark host memory as used for DMA
+ * @phys_addr:	physical address of the DMA region
+ * @size:	size of the DMA region
+ * @is_ram:	whether it is RAM or device memory
+ *
+ * We must not allow the host to donate pages that are mapped in the IOMMU for
+ * DMA. So:
+ * 1. Mark the host S2 entry as being owned by IOMMU
+ * 2. Refcount it, since a page may be mapped in multiple device address spaces.
+ *
+ * At some point we may end up needing more than the current 16 bits for
+ * refcounting, for example if all devices and sub-devices map the same MSI
+ * doorbell page. It will do for now.
+ */
+int __pkvm_host_share_dma(phys_addr_t phys_addr, size_t size, bool is_ram)
+{
+	int i;
+	int ret;
+	size_t nr_pages = size >> PAGE_SHIFT;
+
+	if (WARN_ON(!PAGE_ALIGNED(phys_addr | size)))
+		return -EINVAL;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	for (i = 0; i < nr_pages; i++) {
+		ret = __pkvm_host_share_dma_page(phys_addr + i * PAGE_SIZE,
+						 is_ram);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		for (--i; i >= 0; --i)
+			__pkvm_host_unshare_dma_page(phys_addr + i * PAGE_SIZE);
+	}
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
+int __pkvm_host_unshare_dma(phys_addr_t phys_addr, size_t size)
+{
+	int i;
+	int ret;
+	size_t nr_pages = size >> PAGE_SHIFT;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	/*
+	 * We end up here after the caller successfully unmapped the page from
+	 * the IOMMU table. Which means that a ref is held, the page is shared
+	 * in the host s2, there can be no failure.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		ret = __pkvm_host_unshare_dma_page(phys_addr + i * PAGE_SIZE);
+		if (ret)
+			break;
+	}
+
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 {
 	int ret;
-- 
2.39.0

