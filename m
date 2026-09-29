Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9763D519DE3
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678241; cv=none; b=HDQ0BHop9j2PWGvMtVLEPMtvKCBKfVEAa0zu7kVxDm9dH3KlzshVHqvg9/4xBDOg/O8WhnOe/T+Fe7gxs4+dCNU19sm8vQv8h3Asal7oGFsczRq0/FsbcgzgBeG4PyfYxjOIu1T1YIVIIe4fMYBL3ttva+1yFdUEf6dVF4ZqMW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678241; c=relaxed/simple;
	bh=ItLfTe4Xj7U+jCQ8lrtq6m2FRje8G3Lp4fDHc9S8vGc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQ//T1R8YsW/mtsvX9VmhDejH9yrXf1wk8wOQVKK230qMZexT/+qNqQf9BMZiXXbh6SdSz6dkW2zpWBy91NlxCsrfellb06ANa9wS54YmegOU30fqhPIa9b7lzVFTd5bXmbRrUoRzw01CyUpGY6T9X8t4oWVtFMJRm9lE159YE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PW5NPQWV; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PW5NPQWV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Andp5VDV+A4AW07a5bDFOCh8KWVJkL4Vd6SoEbvZutE=;
	b=PW5NPQWVzKrCPAeqQzi5/g4ahW18MU7ss3ZMC2zzYgBfLa+P+/sgySwMBkPZKwRkSG1FpiOAu
	miJqRgqLhWlsWdyHY0O8uAxdMZBTowN1PXuRKYnYsSsM9wAeqk4J60/eAW9HBG8It3tVsFMrlcn
	lkfBnWfpWvuEiR6NvEmg7Xo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnb64TSzpSy8;
	Tue, 29 Sep 2026 18:24:51 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 8514940575;
	Tue, 29 Sep 2026 18:37:00 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:36:59 +0800
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
Subject: [PATCH v5 05/15] KVM: arm64: Harvest stage-2 dirty state into the host folio account
Date: Tue, 29 Sep 2026 18:36:45 +0800
Message-ID: <20260929103655.85107-6-zhengtian10@huawei.com>
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

With VTCR_EL2.HD set, hardware promotes writable-clean descriptors to
writable-dirty without any VM exit, and the only record of the write
is the S2AP[1] bit in the stage-2 PTE. The write never passed through
the host stage-1, and no unmap path reads the bit, so the record dies
with the PTE and reclaim may discard written guest data (silent
corruption).

The fault paths already mark the folio speculatively at fault-in, but
the mapping lifecycle still needs exact harvesting, mirroring
zap_present_folio_ptes() in the generic mm:

  - stage2_unmap_walker(): harvest the output address of a valid leaf
    with S2AP[1] set before tearing it down.

  - stage2_wrprotect_walker(): a WD -> WC transition drops the dirty
    state, so harvest before the clear.

Both hooks go through a new kvm_pgtable_mm_ops::mark_page_dirty
callback, as the walkers are also compiled into the nVHE hypervisor,
where SetPageDirty() is unavailable. pKVM leaves the callback NULL.

The folio is dirtied at its head, so one harvest covers a whole block
mapping. MMIO/PFNMAP ranges and reserved pages are skipped, mirroring
kvm_is_ad_tracked_page().

Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 14 ++++++++++++--
 arch/arm64/kvm/mmu.c                 | 16 ++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 379031c74cbc..ea71c13615f7 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -246,6 +246,8 @@ struct kvm_pgtable_mm_ops {
 	phys_addr_t	(*virt_to_phys)(void *addr);
 	void		(*dcache_clean_inval_poc)(void *addr, size_t size);
 	void		(*icache_inval_pou)(void *addr, size_t size);
+	/* NULL where folios are not tracked. */
+	void		(*mark_page_dirty)(u64 pa);
 };

 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index aa0448d3a6a4..9dde7e779699 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1182,8 +1182,13 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,

 		if (mm_ops->page_count(childp) != 1)
 			return 0;
-	} else if (stage2_pte_cacheable(pgt, ctx->old)) {
-		need_flush = !cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
+	} else {
+		if (stage2_pte_cacheable(pgt, ctx->old))
+			need_flush = !cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
+
+		if ((ctx->old & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W) &&
+		    mm_ops->mark_page_dirty)
+			mm_ops->mark_page_dirty(kvm_pte_to_phys(ctx->old));
 	}

 	/*
@@ -1302,6 +1307,11 @@ static int stage2_wrprotect_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (ctx->level < KVM_PGTABLE_LAST_LEVEL)
 		new &= ~KVM_PTE_LEAF_ATTR_HI_S2_DBM;

+	if (kvm_pte_valid(ctx->old) && ctx->old != new &&
+	    (ctx->old & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W) &&
+	    ctx->mm_ops->mark_page_dirty)
+		ctx->mm_ops->mark_page_dirty(kvm_pte_to_phys(ctx->old));
+
 	/*
 	 * We may race with the CPU trying to set the access flag here,
 	 * but worst-case the access flag update gets lost and will be
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 698a87e85a6d..85a98d2c23a9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -897,6 +897,21 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }

+static void kvm_s2_mark_page_dirty(u64 pa)
+{
+	unsigned long pfn = pa >> PAGE_SHIFT;
+	struct page *page;
+
+	if (!pfn_valid(pfn))
+		return;
+
+	page = pfn_to_page(pfn);
+	if (PageReserved(page))
+		return;
+
+	SetPageDirty(page);
+}
+
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
@@ -909,6 +924,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.virt_to_phys		= kvm_host_pa,
 	.dcache_clean_inval_poc	= clean_dcache_guest_page,
 	.icache_inval_pou	= invalidate_icache_guest_page,
+	.mark_page_dirty	= kvm_s2_mark_page_dirty,
 };

 static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
--
2.43.0

