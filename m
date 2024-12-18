Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875DC1FF60D
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550903; cv=none; b=aqCLbNh7O4xadkgHMvgJjQnC70XElESMXz65ifb1Z7ZS3sbghACyS4zU0BZsMpbifWZvs3E5IcOteUCgY7hmXbktiCm1vIOFEwYkrP/NdnSGTpEHVsMwoap9zQABprqg9PvxwCV1ZgS9eY7gswVzk2eH/q9MfVfquFbQoaYZE5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550903; c=relaxed/simple;
	bh=ZQPelPNWhkJ1At26Nrdp5WffmSNYb8CHelUw1gYrKzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZ2Z4RIpHmF41coB7cPVbmUzYGxdV4b+fGYWpm0SOCpUxa/mMzX2ho7X8UQTNy12dFbvebepoAW6PH0XDrlXivPI2g4J7qnipLX7wtiQ9Dzx4dGrY6tkR/AlGe9O0wtWwTsdHLaqvxX8wAplNtbJSjtxqoL6UzurZ1nANFizkTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f+ek/ZwZ; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f+ek/ZwZ"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa68203d288so505618966b.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550900; x=1735155700; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6DkakClF8BqI5Hrkmle3MNhfJWXR/14r9X27edMbAg=;
        b=f+ek/ZwZ871vImajP5+iJjSlRRSPc9+0vhQ2tSIrmBqqNiL8ilrPPy5DNzAa8apSKz
         QyMzkICf3PpwLyI7+y0w5WHluT8pTQg6YLnaWm6Ppx8iJSVi64dNj3MUWRBkt8NZQcx7
         YpSwESN6wURB1Ji5GIqDARPtvM4ZA6Iz7jgFJae+qfJXm8lUWx/VttEbPYs4cqGbY5RC
         NtR7XpMnCbbcoGm/YZHC08UTPh/MEcXJuzPZ6vO9npUfK2lPXzwXl8uXFc39NlD0ZFY0
         NaE0N7cdVLDDZv1EAHDdVnNcfoIX+7ZIu+j8Sa1aHZhYjxdOj+yZPlY+t/w+X8GaiqPa
         VdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550900; x=1735155700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y6DkakClF8BqI5Hrkmle3MNhfJWXR/14r9X27edMbAg=;
        b=s3x3LgMtSyYQA+nev5AclP+ej49YJM6VbySLV0WXr8iivR/rE6COxGKmp36d8gzTtn
         r6IE4dhCXjfn/V6qVjeTeCzxe29+8Y6ma6NdjoQ4xA5WruSd3pszsxkQxBDY4BMttZGP
         7A+oypGO5nsO3+D6D/P5P96adcpT1L/vawiRH89zqgGHjykufUWtVkQ8dQkN68hyyJv0
         eaadGXGBurUcmxrG0JfnQMdfoH3181xwBkMRMfQhqmCaKXynWhFe5mR0hQDHKlfMKX8t
         qdkOALuzeWYXjuhCZ/PU9vhVW03uMUTYfAx3z9L/4YN/W4IzXD33Ugg9fmAUYWD3Mrb+
         heOw==
X-Forwarded-Encrypted: i=1; AJvYcCWPU/NCqUG29ZEb7hlwse+69quzDlZHHF1dpyIwh4xxQpaUDDo6j9OkkAf7Fj9HV70SDkkQ+WE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKs9WdZDg1QCAf2RH1AXkmApW3/1ktGS9EP9SlAV2itlLXVw6r
	ZlYrbZkWkCUpPZFhesKHMHXYwZ6Z/8ie7uK337IOhE+oF5C+ZhEmVOhxHDDa9rz8nsgsj2JJMWR
	WrKESIw==
X-Google-Smtp-Source: AGHT+IHNKpe3m3A1MgUUPpiS0U2tlUavLUx/VUDBj0i41dQCQEpXAX6s495FgbN3PfM0SoDtetWb6xxetzlN
X-Received: from ejctq12.prod.google.com ([2002:a17:907:c50c:b0:aa6:a222:16b6])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:72c7:b0:aab:d4f0:c598
 with SMTP id a640c23a62f3a-aabf478a5d0mr412739466b.27.1734550899889; Wed, 18
 Dec 2024 11:41:39 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:58 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-18-qperret@google.com>
Subject: [PATCH v4 17/18] KVM: arm64: Introduce the EL1 pKVM MMU
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
state and is protected by the mmu_lock like a traditional stage-2
page-table.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/include/asm/kvm_pgtable.h |  23 +--
 arch/arm64/include/asm/kvm_pkvm.h    |  26 ++++
 arch/arm64/kvm/pkvm.c                | 201 +++++++++++++++++++++++++++
 4 files changed, 242 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1246f1d01dbf..f23f4ea9ec8b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -85,6 +85,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
+	struct pkvm_mapping *mapping; /* only used from EL1 */
 };
 
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 04418b5e3004..6b9d274052c7 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -412,15 +412,20 @@ static inline bool kvm_pgtable_walk_lock_held(void)
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
+		struct rb_root					pkvm_mappings;
+		struct {
+			u32					ia_bits;
+			s8					start_level;
+			kvm_pteref_t				pgd;
+			struct kvm_pgtable_mm_ops		*mm_ops;
+
+			/* Stage-2 only */
+			enum kvm_pgtable_stage2_flags		flags;
+			kvm_pgtable_force_pte_cb_t		force_pte_cb;
+		};
+	};
+	struct kvm_s2_mmu					*mmu;
 };
 
 /**
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56acd9a842..65f988b6fe0d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -137,4 +137,30 @@ static inline size_t pkvm_host_sve_state_size(void)
 			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
 }
 
+struct pkvm_mapping {
+	struct rb_node node;
+	u64 gfn;
+	u64 pfn;
+};
+
+int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
+			     struct kvm_pgtable_mm_ops *mm_ops);
+void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
+int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
+			    enum kvm_pgtable_prot prot, void *mc,
+			    enum kvm_pgtable_walk_flags flags);
+int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
+int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
+int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
+bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold);
+int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
+				    enum kvm_pgtable_walk_flags flags);
+void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				 enum kvm_pgtable_walk_flags flags);
+int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			      struct kvm_mmu_memory_cache *mc);
+void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level);
+kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
+					       enum kvm_pgtable_prot prot, void *mc,
+					       bool force_pte);
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 85117ea8f351..930b677eb9b0 100644
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
@@ -268,3 +269,203 @@ static int __init finalize_pkvm(void)
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
+/*
+ * __tmp is updated to rb_next(__tmp) *before* entering the body of the loop to allow freeing
+ * of __map inline.
+ */
+#define for_each_mapping_in_range_safe(__pgt, __start, __end, __map)				\
+	for (struct rb_node *__tmp = find_first_mapping_node(&(__pgt)->pkvm_mappings,		\
+							     ((__start) >> PAGE_SHIFT));	\
+	     __tmp && ({									\
+				__map = rb_entry(__tmp, struct pkvm_mapping, node);		\
+				__tmp = rb_next(__tmp);						\
+				true;								\
+		       });									\
+	    )											\
+		if (__map->gfn < ((__start) >> PAGE_SHIFT))					\
+			continue;								\
+		else if (__map->gfn >= ((__end) >> PAGE_SHIFT))					\
+			break;									\
+		else
+
+int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
+			     struct kvm_pgtable_mm_ops *mm_ops)
+{
+	pgt->pkvm_mappings	= RB_ROOT;
+	pgt->mmu		= mmu;
+
+	return 0;
+}
+
+void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
+	struct rb_node *node;
+
+	if (!handle)
+		return;
+
+	node = rb_first(&pgt->pkvm_mappings);
+	while (node) {
+		mapping = rb_entry(node, struct pkvm_mapping, node);
+		kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		node = rb_next(node);
+		rb_erase(&mapping->node, &pgt->pkvm_mappings);
+		kfree(mapping);
+	}
+}
+
+int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			   u64 phys, enum kvm_pgtable_prot prot,
+			   void *mc, enum kvm_pgtable_walk_flags flags)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	struct pkvm_mapping *mapping = NULL;
+	struct kvm_hyp_memcache *cache = mc;
+	u64 gfn = addr >> PAGE_SHIFT;
+	u64 pfn = phys >> PAGE_SHIFT;
+	int ret;
+
+	if (size != PAGE_SIZE)
+		return -EINVAL;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
+	if (ret) {
+		/* Is the gfn already mapped due to a racing vCPU? */
+		if (ret == -EPERM)
+			return -EAGAIN;
+	}
+
+	swap(mapping, cache->mapping);
+	mapping->gfn = gfn;
+	mapping->pfn = pfn;
+	WARN_ON(rb_find_add(&mapping->node, &pgt->pkvm_mappings, cmp_mappings));
+
+	return ret;
+}
+
+int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
+	int ret = 0;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		if (WARN_ON(ret))
+			break;
+		rb_erase(&mapping->node, &pgt->pkvm_mappings);
+		kfree(mapping);
+	}
+
+	return ret;
+}
+
+int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
+	int ret = 0;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn);
+		if (WARN_ON(ret))
+			break;
+	}
+
+	return ret;
+}
+
+int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	struct pkvm_mapping *mapping;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
+		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
+
+	return 0;
+}
+
+bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
+	bool young = false;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
+		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
+					   mkold);
+
+	return young;
+}
+
+int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
+				    enum kvm_pgtable_walk_flags flags)
+{
+	return kvm_call_hyp_nvhe(__pkvm_host_relax_perms_guest, addr >> PAGE_SHIFT, prot);
+}
+
+void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				 enum kvm_pgtable_walk_flags flags)
+{
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_mkyoung_guest, addr >> PAGE_SHIFT));
+}
+
+void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
+{
+	WARN_ON_ONCE(1);
+}
+
+kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
+					enum kvm_pgtable_prot prot, void *mc, bool force_pte)
+{
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			      struct kvm_mmu_memory_cache *mc)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
-- 
2.47.1.613.gc27f4b7a9f-goog

