Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F110913D25D
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566371; cv=none; b=s/OeB2KsO1GvTICkExI1IYW9BsCZ8ZZ6T0nad7WvuEAOD+MZLIO3IfBCCFwzTcbYGawijq4d0UT2bxzngZtoR+I9c5WCyHWQIqadWB3vrsMwomVAM57kWJDrdy1mSRlgJWk65+r4d3G+TYFQD29h/EiJULDv0KP0Qbiwffpe1XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566371; c=relaxed/simple;
	bh=J8gQJ6259vigXlMgfQ4aT80tPHdJCf0NK/hA2svSJHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6XfhEfWxWhcgdboZj5RZe7DkjC96YwuqsVxH2+ZeFIgglmOV3dalzF0NOBsk82Dt48y7pSWNUqd2V15KBSFeKqBSiPC4NoqvfzSzfHzQ3s0FZuWU/8v+cwG4Y0kG6LHqbPhyOvlYOR+/iapZWfW+FcueJXdrG/pVmDN/zK7750=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dtAGDI4D; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dtAGDI4D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aH/N0MOe1K9rUp6qPHuSiP3tPqpQX+INrXJ+MjkpYjE=;
	b=dtAGDI4DSU847d3CEZoXQX619qmgJYZaGSXVjG9rokXW2sG6ZtbwRqw3ielgrO8lXchzVn
	o5WmibVPrIPKHBdspE17bYH+APAETLxm6CDW6Gjy7SoqFht4gZ4Y2sH9lPn+WBbBcF14pD
	0X7nXaNothczxmpo2PPYsHp2GuFtsBg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 11/19] KVM: arm64: vgic-its: Rip out the global translation cache
Date: Fri, 19 Apr 2024 22:38:34 +0000
Message-ID: <20240419223842.951452-12-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The MSI injection fast path has been transitioned away from the global
translation cache. Rip it out.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |   7 ---
 arch/arm64/kvm/vgic/vgic-its.c  | 100 +-------------------------------
 arch/arm64/kvm/vgic/vgic.h      |   2 -
 include/kvm/arm_vgic.h          |   3 -
 4 files changed, 1 insertion(+), 111 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f20941f83a07..6ee42f395253 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
 }
@@ -305,9 +304,6 @@ int vgic_init(struct kvm *kvm)
 		}
 	}
 
-	if (vgic_has_its(kvm))
-		vgic_lpi_translation_cache_init(kvm);
-
 	/*
 	 * If we have GICv4.1 enabled, unconditionally request enable the
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
@@ -361,9 +357,6 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_has_its(kvm))
-		vgic_lpi_translation_cache_destroy(kvm);
-
 	if (vgic_supports_direct_msis(kvm))
 		vgic_v4_teardown(kvm);
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7fb942f4f105..f0287414fa75 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -149,14 +149,6 @@ struct its_ite {
 	u32 event_id;
 };
 
-struct vgic_translation_cache_entry {
-	struct list_head	entry;
-	phys_addr_t		db;
-	u32			devid;
-	u32			eventid;
-	struct vgic_irq		*irq;
-};
-
 /**
  * struct vgic_its_abi - ITS abi ops and settings
  * @cte_esz: collection table entry size
@@ -574,7 +566,6 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 {
 	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
 	phys_addr_t db;
 
@@ -588,9 +579,6 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	rcu_read_lock();
 
-	if (unlikely(list_empty(&dist->lpi_translation_cache)))
-		goto out;
-
 	/*
 	 * We could have raced with another CPU caching the same
 	 * translation behind our back, so let's check it is not in
@@ -600,37 +588,12 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (__vgic_its_check_cache(kvm, db, devid, eventid))
 		goto out;
 
-	/* Always reuse the last entry (LRU policy) */
-	cte = list_last_entry(&dist->lpi_translation_cache,
-			      typeof(*cte), entry);
-
-	/*
-	 * Caching the translation implies having an extra reference
-	 * to the interrupt, so drop the potential reference on what
-	 * was in the cache, and increment it on the new interrupt.
-	 */
-	if (cte->irq)
-		vgic_put_irq(kvm, cte->irq);
-
 	/*
 	 * The irq refcount is guaranteed to be nonzero while holding the
 	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
 	 */
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
-	/*
-	 * Get a second ref for the ITS' translation cache. This will
-	 * disappear.
-	 */
-	vgic_get_irq_kref(irq);
-
-	cte->db		= db;
-	cte->devid	= devid;
-	cte->eventid	= eventid;
-	cte->irq	= irq;
-
-	/* Move the new translation to the head of the list */
-	list_move(&cte->entry, &dist->lpi_translation_cache);
 
 	xa_store(&its->translation_cache, cache_key, irq, 0);
 out:
@@ -640,27 +603,9 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 
 static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte;
-	unsigned long flags, idx;
+	unsigned long idx;
 	struct vgic_irq *irq;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
-		/*
-		 * If we hit a NULL entry, there is nothing after this
-		 * point.
-		 */
-		if (!cte->irq)
-			break;
-
-		vgic_put_irq(kvm, cte->irq);
-		cte->irq = NULL;
-	}
-
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-
 	xa_for_each(&its->translation_cache, idx, irq) {
 		xa_erase(&its->translation_cache, idx);
 		vgic_put_irq(its->dev->kvm, irq);
@@ -1882,47 +1827,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
 	return ret;
 }
 
-/* Default is 16 cached LPIs per vcpu */
-#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
-
-void vgic_lpi_translation_cache_init(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned int sz;
-	int i;
-
-	if (!list_empty(&dist->lpi_translation_cache))
-		return;
-
-	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
-
-	for (i = 0; i < sz; i++) {
-		struct vgic_translation_cache_entry *cte;
-
-		/* An allocation failure is not fatal */
-		cte = kzalloc(sizeof(*cte), GFP_KERNEL_ACCOUNT);
-		if (WARN_ON(!cte))
-			break;
-
-		INIT_LIST_HEAD(&cte->entry);
-		list_add(&cte->entry, &dist->lpi_translation_cache);
-	}
-}
-
-void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte, *tmp;
-
-	vgic_its_invalidate_all_caches(kvm);
-
-	list_for_each_entry_safe(cte, tmp,
-				 &dist->lpi_translation_cache, entry) {
-		list_del(&cte->entry);
-		kfree(cte);
-	}
-}
-
 #define INITIAL_BASER_VALUE						  \
 	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
 	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
@@ -1955,8 +1859,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 			kfree(its);
 			return ret;
 		}
-
-		vgic_lpi_translation_cache_init(dev->kvm);
 	}
 
 	mutex_init(&its->its_lock);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e5cda1eb4bcf..407640c24049 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -335,8 +335,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
-void vgic_lpi_translation_cache_init(struct kvm *kvm);
-void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
 void vgic_its_invalidate_all_caches(struct kvm *kvm);
 
 /* GICv4.1 MMIO interface */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 0b027ed71dac..276082db9ae6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -286,9 +286,6 @@ struct vgic_dist {
 #define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 
-	/* LPI translation cache */
-	struct list_head	lpi_translation_cache;
-
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
 
-- 
2.44.0.769.g3c40516874-goog

