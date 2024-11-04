Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846AB1C2DB4
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727172; cv=none; b=EXdl1MkcePvg/TlU5DFgj7xD+qBqVclQ3gvz42VVqSvXx3BAiedM14kSR3PR3CuHB+1n6qoMfzJC5o6B2BGQsDBsfnAQRk516hwEcZOqLPfB2ezCE1sSGpW7XvdTE8ZcQZTPcwYSxTodr1pFaslgB7A/sYTbOWLpnfEWBojIMr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727172; c=relaxed/simple;
	bh=dSET2om031O47ic/vQaT/kszjb9PKKevw2/1LUEtxGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HEHa0Tv70vHYQ5ACWMcpgR5fSuX21E8QCwXvA3vedMk6AInj0gPAArPnDqt//xXcz7cOiixg9Bq0+sxQaw4TUmfDeEIdx9KPjJCrk1F0ogCccfVcnf6fnYMjc0PwEaOBkqDVJJurI9u+ntCqjf6kGGXVswbV1TO04XS3YWJY2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kLLy1FgX; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kLLy1FgX"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a99fa9f0c25so316527166b.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727169; x=1731331969; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S9P+6CghAZlP90zl0lmxcimUJWiddvnPxJsTkSWCUgY=;
        b=kLLy1FgXQAzpnevMILtP4LxgFlSoLJp+YS5sZMZiKs8VB1mDWzsBS5B6seaedGTGTd
         Jm6nxSak9B9EtCDTW2fRFtustG8DTD45S0cCuL6BnIILZFr/AxYWQS+f7WFDCNd8cpkl
         04NHLairB749A8ngZnDrJJAQcpbJoxIDEyw4hxpPF46IwB9oD7P/APKRZo6iIFarwXoy
         5ZtPIMw+wtZLJze9wHPRWLXJUMzKk7OzM32Y64mjJ6fyB3sEVHldExDdkwgZcj4e/Do8
         K+dS7R2CeweAMrWOHd8cmCcBQTm2C2EZWVZfH7Xbju5qdFIxQaHezOJI9u0FnPc9sGSI
         FPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727169; x=1731331969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S9P+6CghAZlP90zl0lmxcimUJWiddvnPxJsTkSWCUgY=;
        b=dBEAgtxT4fAvyGhN6fxeuYP/7p7x+NT2DimJoPO3oY9B735oJYKnw+dPgUEmiCHQUy
         BDxOR6iHfyrwrWlz00o+05QLhWEzKiEKSo77avchAnCMGXFpJZWi+3JkBkqMXmk97cdq
         kYNwjDS3zIp61pRmrYPFUYaat2ytuaS+0b8geO7y6oCBOXs6wd4/BgqitNxcxhgwIdOK
         zYORK6US8XTx+1us4YWNsxOL/14tBgs9V46/8vJDMarPYb7OYGAQtTYPxe39wIUH7aTd
         bqDU9ESw6JPDa4xQ+c8P9byiUCwU1hB4G0/6PnQD7obDBA+Ei+d7tRQln79un86v1ATj
         xyGA==
X-Forwarded-Encrypted: i=1; AJvYcCUf/pbTrqlAkg9JevLUrqNcVaF7fbzICr4uuGNmCQXQQoIQhehIemHdck1YoMu088XanFCXt/g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpFsnP++uMJwmiHJnrNA4gptdEkiJYgzRKbMLDVu5CXat3PN+b
	5Q4e8hqIwsgC18cOMYwj0fV/oOBAn7nfbsWP5ll8Ml9916ZwW9JBs/3je0d9OwkdWFQoItzSxNf
	r1hpOYQ==
X-Google-Smtp-Source: AGHT+IHUzeHYOCyrvkdBeV51c0cW/76sAnrie0GiITF3JTcKQ/wOV0BVt/eR+Wlt38fknSvzPr+8LNYUrM6G
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:f24d:b0:a99:4c49:d4af with SMTP id
 a640c23a62f3a-a9de5cbcb54mr798466b.4.1730727168889; Mon, 04 Nov 2024 05:32:48
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:32:03 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-18-qperret@google.com>
Subject: [PATCH 17/18] KVM: arm64: Introduce the EL1 pKVM MMU
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a set of helper functions allowing to manipulate the pKVM
guest stage-2 page-tables from EL1 using pKVM's HVC interface.

Each helper has an exact one-to-one correspondance with the traditional
kvm_pgtable_stage2_*() functions from pgtable.c, with a strictly
matching prototype. This will ease plumbing later on in mmu.c.

These callbacks track the gfn->pfn mappings in a simple rb_tree indexed
by IPA in lieu of a page-table. This rb-tree is kept in sync with pKVM's
state and is protected by a new rwlock -- the existing mmu_lock
protection does not suffice in the map() path where the tree must be
modified while user_mem_abort() only acquires a read_lock.

Signed-off-by: Quentin Perret <qperret@google.com>
---

The embedded union inside struct kvm_pgtable is arguably a bit horrible
currently... I considered making the pgt argument to all kvm_pgtable_*()
functions an opaque void * ptr, and moving the definition of
struct kvm_pgtable to pgtable.c and the pkvm version into pkvm.c. Given
that the allocation of that data-structure is done by the caller, that
means we'd need to expose kvm_pgtable_get_pgd_size() or something that
each MMU (pgtable.c and pkvm.c) would have to implement and things like
that. But that felt like a bigger surgery, so I went with the simpler
option. Thoughts welcome :-)

Similarly, happy to drop the mappings_lock if we want to teach
user_mem_abort() about taking a write lock on the mmu_lock in the pKVM
case, but again this implementation is the least invasive into normal
KVM so that felt like a reasonable starting point.
---
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/include/asm/kvm_pgtable.h |  27 ++--
 arch/arm64/include/asm/kvm_pkvm.h    |  28 ++++
 arch/arm64/kvm/pkvm.c                | 194 +++++++++++++++++++++++++++
 4 files changed, 241 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4b02904ec7c0..2bfb5983f6f1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -87,6 +87,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
+	struct pkvm_mapping *mapping; /* only used from EL1 */
 };
 
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 047e1c06ae4c..9447193ee630 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -412,15 +412,24 @@ static inline bool kvm_pgtable_walk_lock_held(void)
  *			be used instead of block mappings.
  */
 struct kvm_pgtable {
-	u32					ia_bits;
-	s8					start_level;
-	kvm_pteref_t				pgd;
-	struct kvm_pgtable_mm_ops		*mm_ops;
-
-	/* Stage-2 only */
-	struct kvm_s2_mmu			*mmu;
-	enum kvm_pgtable_stage2_flags		flags;
-	kvm_pgtable_force_pte_cb_t		force_pte_cb;
+	union {
+		struct {
+			u32					ia_bits;
+			s8					start_level;
+			kvm_pteref_t				pgd;
+			struct kvm_pgtable_mm_ops		*mm_ops;
+
+			/* Stage-2 only */
+			struct kvm_s2_mmu			*mmu;
+			enum kvm_pgtable_stage2_flags		flags;
+			kvm_pgtable_force_pte_cb_t		force_pte_cb;
+		};
+		struct {
+			struct kvm				*kvm;
+			struct rb_root				mappings;
+			rwlock_t				mappings_lock;
+		} pkvm;
+	};
 };
 
 /**
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56acd9a842..f3eed6a5fa57 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -11,6 +11,12 @@
 #include <linux/scatterlist.h>
 #include <asm/kvm_pgtable.h>
 
+struct pkvm_mapping {
+	u64 gfn;
+	u64 pfn;
+	struct rb_node node;
+};
+
 /* Maximum number of VMs that can co-exist under pKVM. */
 #define KVM_MAX_PVMS 255
 
@@ -137,4 +143,26 @@ static inline size_t pkvm_host_sve_state_size(void)
 			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
 }
 
+static inline pkvm_handle_t pkvm_pgt_to_handle(struct kvm_pgtable *pgt)
+{
+	return pgt->pkvm.kvm->arch.pkvm.handle;
+}
+
+int pkvm_pgtable_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu, struct kvm_pgtable_mm_ops *mm_ops);
+void pkvm_pgtable_destroy(struct kvm_pgtable *pgt);
+int pkvm_pgtable_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			   u64 phys, enum kvm_pgtable_prot prot,
+			   void *mc, enum kvm_pgtable_walk_flags flags);
+int pkvm_pgtable_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
+int pkvm_pgtable_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
+int pkvm_pgtable_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
+bool pkvm_pgtable_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold);
+int pkvm_pgtable_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
+			     enum kvm_pgtable_walk_flags flags);
+kvm_pte_t pkvm_pgtable_mkyoung(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_walk_flags flags);
+int pkvm_pgtable_split(struct kvm_pgtable *pgt, u64 addr, u64 size, struct kvm_mmu_memory_cache *mc);
+void pkvm_pgtable_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level);
+kvm_pte_t *pkvm_pgtable_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
+					enum kvm_pgtable_prot prot, void *mc, bool force_pte);
+
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 85117ea8f351..6d04a1a0fc6b 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/kmemleak.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
 #include <linux/sort.h>
@@ -268,3 +269,196 @@ static int __init finalize_pkvm(void)
 	return ret;
 }
 device_initcall_sync(finalize_pkvm);
+
+static int cmp_mappings(struct rb_node *node, const struct rb_node *parent)
+{
+	struct pkvm_mapping *a = rb_entry(node, struct pkvm_mapping, node);
+	struct pkvm_mapping *b = rb_entry(parent, struct pkvm_mapping, node);
+
+	if (a->gfn < b->gfn)
+		return -1;
+	if (a->gfn > b->gfn)
+		return 1;
+	return 0;
+}
+
+static struct rb_node *find_first_mapping_node(struct rb_root *root, u64 gfn)
+{
+	struct rb_node *node = root->rb_node, *prev = NULL;
+	struct pkvm_mapping *mapping;
+
+	while (node) {
+		mapping = rb_entry(node, struct pkvm_mapping, node);
+		if (mapping->gfn == gfn)
+			return node;
+		prev = node;
+		node = (gfn < mapping->gfn) ? node->rb_left : node->rb_right;
+	}
+
+	return prev;
+}
+
+#define for_each_mapping_in_range(pgt, start_ipa, end_ipa, mapping, tmp)				\
+	for (tmp = find_first_mapping_node(&pgt->pkvm.mappings, ((start_ipa) >> PAGE_SHIFT));		\
+	     tmp && ({ mapping = rb_entry(tmp, struct pkvm_mapping, node); tmp = rb_next(tmp); 1; });)	\
+		if (mapping->gfn < ((start_ipa) >> PAGE_SHIFT))						\
+			continue;									\
+		else if (mapping->gfn >= ((end_ipa) >> PAGE_SHIFT))					\
+			break;										\
+		else
+
+int pkvm_pgtable_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu, struct kvm_pgtable_mm_ops *mm_ops)
+{
+	pgt->pkvm.kvm		= kvm_s2_mmu_to_kvm(mmu);
+	pgt->pkvm.mappings	= RB_ROOT;
+	rwlock_init(&pgt->pkvm.mappings_lock);
+
+	return 0;
+}
+
+void pkvm_pgtable_destroy(struct kvm_pgtable *pgt)
+{
+	pkvm_handle_t handle = pkvm_pgt_to_handle(pgt);
+	struct pkvm_mapping *mapping;
+	struct rb_node *node;
+
+	if (!handle)
+		return;
+
+	node = rb_first(&pgt->pkvm.mappings);
+	while (node) {
+		mapping = rb_entry(node, struct pkvm_mapping, node);
+		kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		node = rb_next(node);
+		rb_erase(&mapping->node, &pgt->pkvm.mappings);
+		kfree(mapping);
+	}
+}
+
+int pkvm_pgtable_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			   u64 phys, enum kvm_pgtable_prot prot,
+			   void *mc, enum kvm_pgtable_walk_flags flags)
+{
+	struct pkvm_mapping *mapping = NULL;
+	struct kvm_hyp_memcache *cache = mc;
+	u64 gfn = addr >> PAGE_SHIFT;
+	u64 pfn = phys >> PAGE_SHIFT;
+	int ret;
+
+	if (size != PAGE_SIZE)
+		return -EINVAL;
+
+	write_lock(&pgt->pkvm.mappings_lock);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
+	if (ret) {
+		/* Is the gfn already mapped due to a racing vCPU? */
+		if (ret == -EPERM)
+			ret = -EAGAIN;
+		goto unlock;
+	}
+
+	swap(mapping, cache->mapping);
+	mapping->gfn = gfn;
+	mapping->pfn = pfn;
+	WARN_ON(rb_find_add(&mapping->node, &pgt->pkvm.mappings, cmp_mappings));
+unlock:
+	write_unlock(&pgt->pkvm.mappings_lock);
+
+	return ret;
+}
+
+int pkvm_pgtable_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	pkvm_handle_t handle = pkvm_pgt_to_handle(pgt);
+	struct pkvm_mapping *mapping;
+	struct rb_node *tmp;
+	int ret = 0;
+
+	write_lock(&pgt->pkvm.mappings_lock);
+	for_each_mapping_in_range(pgt, addr, addr + size, mapping, tmp) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		if (WARN_ON(ret))
+			break;
+
+		rb_erase(&mapping->node, &pgt->pkvm.mappings);
+		kfree(mapping);
+	}
+	write_unlock(&pgt->pkvm.mappings_lock);
+
+	return ret;
+}
+
+int pkvm_pgtable_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	pkvm_handle_t handle = pkvm_pgt_to_handle(pgt);
+	struct pkvm_mapping *mapping;
+	struct rb_node *tmp;
+	int ret = 0;
+
+	read_lock(&pgt->pkvm.mappings_lock);
+	for_each_mapping_in_range(pgt, addr, addr + size, mapping, tmp) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn);
+		if (WARN_ON(ret))
+			break;
+	}
+	read_unlock(&pgt->pkvm.mappings_lock);
+
+	return ret;
+}
+
+int pkvm_pgtable_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct pkvm_mapping *mapping;
+	struct rb_node *tmp;
+
+	read_lock(&pgt->pkvm.mappings_lock);
+	for_each_mapping_in_range(pgt, addr, addr + size, mapping, tmp)
+		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
+	read_unlock(&pgt->pkvm.mappings_lock);
+
+	return 0;
+}
+
+bool pkvm_pgtable_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold)
+{
+	pkvm_handle_t handle = pkvm_pgt_to_handle(pgt);
+	struct pkvm_mapping *mapping;
+	struct rb_node *tmp;
+	bool young = false;
+
+	read_lock(&pgt->pkvm.mappings_lock);
+	for_each_mapping_in_range(pgt, addr, addr + size, mapping, tmp)
+		young |= kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, mkold);
+	read_unlock(&pgt->pkvm.mappings_lock);
+
+	return young;
+}
+
+int pkvm_pgtable_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
+			     enum kvm_pgtable_walk_flags flags)
+{
+	return kvm_call_hyp_nvhe(__pkvm_host_relax_guest_perms, addr >> PAGE_SHIFT, prot);
+}
+
+kvm_pte_t pkvm_pgtable_mkyoung(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_walk_flags flags)
+{
+	return kvm_call_hyp_nvhe(__pkvm_host_mkyoung_guest, addr >> PAGE_SHIFT);
+}
+
+void pkvm_pgtable_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
+{
+	WARN_ON(1);
+}
+
+kvm_pte_t *pkvm_pgtable_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
+					enum kvm_pgtable_prot prot, void *mc, bool force_pte)
+{
+	WARN_ON(1);
+	return NULL;
+}
+
+int pkvm_pgtable_split(struct kvm_pgtable *pgt, u64 addr, u64 size, struct kvm_mmu_memory_cache *mc)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
-- 
2.47.0.163.g1226f6d8fa-goog

