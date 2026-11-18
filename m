Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015156;
	b=23rmtAq0/+YBlUPg8OZODiMq2hxSCSYdIOnW/v3A4QdytFAsSxPT+d5QIf3ENPjEGpiu
	 JBl1oE01LR6eVmRGw3boX9Re2H3NXVH5sEWls9tQIsUDTBI7wO7SYZrnDXDctw2TanOc8
	 CEKaYU4VctQoIiy0cYJds0yVrBcwv27QhuqdKJQCLNIctPLHf5JoXCePDpOiSaJU8Tq+h
	 l/PbpULUJAacKH4dSJ9x3qK7QWG8aCd1r5kQFPPlyQNMOKZCiCToaED1SmQZfxrueGl12
	 YvZXLfcA3ZsJWFrGwqHn5qthASEF/aqN52mfZoQEb3mjc5D+8o63qXw/1p+wdH9prtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015156;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XxS1Hr5iSvOl6fOwkjhZi3LzWbITchcX649E4+3LqoA=;
	b=DcmnK8nqwJpDK6nV7cVEroQMFi1mpHwzvQsHXOU6JdlW2o8/tCvlLPiPluTllfBfNWMq
	 3KMb/nnAXd3AE7In/cPAsykyLqn3dJ1rEwJlSJ7gWhL+O9bleCuV7HGn3vH3dtG6d3LDd
	 1joCF2dmyHsMaOM+zeNt0uafYo9ds+ZzOCS2Ycapa4GQziV44RqjveNj04pvURQwKQLVh
	 UrM4Aq/6KC3+d7c6Ri7tXNzRIGxGoIkoy8Q/hytpJDdJk+tA6E/5L4B5kMNpc2X1hB/JP
	 7O78AJjn8ffSm20KIrk1JXmVxpUnvUCyqEm7+LFSE2EZuiG3/ZIa2r57+ojeYudGpww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pT4iXIZi;
	arc=none smtp.remote-ip=91.218.175.9
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2627E606A336
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2627E606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pT4iXIZi
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=12FyQSDWC04tw1AfNqnvah2Vp7QoZOeWEZh8bpTz72o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015154; v=1; x=1795619954;
 b=pT4iXIZi5+9GTPpooN17TmVPWTOcyrMLbCC96719y1LunQR+qo3uJ0FDUVUTotKS41z9qQbG
 nPwphHerLiYdU0Svt5gZxMT94I2VXYk33m7eTl+ZDCyXwnE57adRnZpfzz7NxA4OrcaCRe/abpr
 25GoHKNlWSmxlYBaZUI9NvEA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d5f1326243dc5c6c;
	Wed, 18 Nov 2026 15:19:14 +0000
X-Mizu-Trace-ID: d5f1326243dc5c6c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/13] KVM: arm64: Donate MMIO to the hypervisor
Date: Wed, 18 Nov 2026 15:18:52 +0000
Message-ID: <20261118151904.4099560-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mostafa Saleh <smostafa@google.com>

Add __pkvm_host_donate_hyp_mmio() so IOMMU drivers in the hypervisor can
take ownership of the IOMMU MMIO. The range is mapped in the hypervisor
private range and annotated as owned by the hypervisor in the host
stage-2, so host accesses fault and further donations of the same range
are refused. MMIO has no struct hyp_page, so the annotation is the only
state, and a dedicated function is simpler than teaching the memory
donation path about MMIO. Donation is only allowed before the host is
de-privileged, which is when the hypervisor IOMMU drivers initialise.

Make kvm_pgtable_stage2_unmap() leave invalid counted PTEs (annotations)
in place. host_stage2_unmap_dev_all() unmaps all non-memory ranges to
recycle page-table pages under memory pressure, and would otherwise drop
the annotation and let the host fault the MMIO back in. No caller depends
on the old behaviour: host_stage2_unmap_dev_all() only covers non-memory
ranges, where no annotation existed until now, and the guest unmap paths
check that the PTE is valid first. Returning an error for counted PTEs
instead is not an option, as a non-zero visitor return stops the walk,
which would abort recycling at the first hypervisor-owned MMIO page and
inject an abort into the host for an unrelated address.

Link: https://lore.kernel.org/r/20261015200903.2735565-2-smostafa@google.com
Signed-off-by: Mostafa Saleh <smostafa@google.com>
[fuad: pass kvm_pgtable_get_leaf() the walk flags ee26443f3dd70 added;
 drop __pkvm_hyp_donate_host_mmio(), which this series doesn't call]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h          |  2 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  5 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 62 ++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c                  |  8 +--
 4 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6ae40..1a3f6e851c94f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -721,6 +721,8 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * freed. Unmapping a cacheable page will ensure that it is clean to the PoC if
  * FWB is not supported by the CPU.
  *
+ * Invalid counted PTEs (annotations) are left in place.
+ *
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ec85a95471207..16e5864ab7f08 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,11 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+/*
+ * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
+ * private range and unmapped from the host stage-2.
+ */
+int __pkvm_host_donate_hyp_mmio(u64 pfn, u64 nr_pages, unsigned long *haddr);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d4c332a918035..a6dacaca77610 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -385,7 +385,11 @@ static int host_stage2_unmap_dev_all(void)
 	u64 addr = 0;
 	int i, ret;
 
-	/* Unmap all non-memory regions to recycle the pages */
+	/*
+	 * Unmap all non-memory regions to recycle the pages.
+	 * That relies on kvm_pgtable_stage2_unmap() not clearing
+	 * counted PTEs which include hypervisor MMIO.
+	 */
 	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
 		reg = &hyp_memory[i];
 		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
@@ -1146,6 +1150,62 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
+int __pkvm_host_donate_hyp_mmio(u64 pfn, u64 nr_pages, unsigned long *haddr)
+{
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
+	unsigned long addr;
+	kvm_pte_t pte;
+	u64 offset;
+	int ret;
+
+	/* Only before de-privilege. */
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
+	host_lock_component();
+	for (offset = 0; offset < size; offset += PAGE_SIZE) {
+		if (addr_is_memory(phys + offset)) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys + offset, &pte, NULL, 0);
+		if (ret)
+			goto unlock;
+		if (pte && !kvm_pte_valid(pte)) {
+			ret = -EPERM;
+			goto unlock;
+		}
+	}
+
+	ret = __pkvm_create_private_mapping(phys, size, PAGE_HYP_DEVICE, &addr);
+	if (ret)
+		goto unlock;
+
+	/*
+	 * Mark the range as owned by the hypervisor in the host stage-2.
+	 * The annotation makes host accesses fault, and is retained by
+	 * host_stage2_unmap_dev_all()
+	 */
+	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+			      phys, size, &host_s2_pool,
+			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
+			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
+	if (ret) {
+		hyp_lock_component();
+		WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size) != size);
+		hyp_unlock_component();
+	} else {
+		*haddr = addr;
+	}
+unlock:
+	host_unlock_component();
+	return ret;
+}
+
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b184d3..041bd0d522f2c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1163,13 +1163,9 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	kvm_pte_t *childp = NULL;
 	bool need_flush = false;
 
-	if (!kvm_pte_valid(ctx->old)) {
-		if (stage2_pte_is_counted(ctx->old)) {
-			kvm_clear_pte(ctx->ptep);
-			mm_ops->put_page(ctx->ptep);
-		}
+	/* Invalid PTEs are left in place, including annotations. */
+	if (!kvm_pte_valid(ctx->old))
 		return 0;
-	}
 
 	if (kvm_pte_table(ctx->old, ctx->level)) {
 		childp = kvm_pte_follow(ctx->old, mm_ops);
-- 
2.47.3

