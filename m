Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81889C7618B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 09:04:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 434772189F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 09:04:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 434772189F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F114A59D;
	Wed, 24 Jul 2019 05:04:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xoty3tOJ2LRW; Wed, 24 Jul 2019 05:04:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02C2B4A58C;
	Wed, 24 Jul 2019 05:04:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15EE74A59F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 05:04:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sxc8eQ3OhpnE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 05:04:49 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BE4C4A594
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 05:04:49 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 297D7688EB64753DD9F2;
 Wed, 24 Jul 2019 17:04:43 +0800 (CST)
Received: from localhost (10.177.19.122) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 17:04:39 +0800
From: Xiangyou Xie <xiexiangyou@huawei.com>
To: <marc.zyngier@arm.com>
Subject: [PATCH 1/3] KVM: arm/arm64: vgic-its: Introduce multiple LPI
 translation caches
Date: Wed, 24 Jul 2019 17:04:35 +0800
Message-ID: <20190724090437.49952-2-xiexiangyou@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
In-Reply-To: <20190724090437.49952-1-xiexiangyou@huawei.com>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Because dist->lpi_list_lock is a perVM lock, when a virtual machine
is configured with multiple virtual NIC devices and receives
network packets at the same time, dist->lpi_list_lock will become
a performance bottleneck.

This patch increases the number of lpi_translation_cache to eight,
hashes the cpuid that executes irqfd_wakeup, and chooses which
lpi_translation_cache to use.

Signed-off-by: Xiangyou Xie <xiexiangyou@huawei.com>
---
 include/kvm/arm_vgic.h        |  13 ++-
 virt/kvm/arm/vgic/vgic-init.c |   6 +-
 virt/kvm/arm/vgic/vgic-its.c  | 199 +++++++++++++++++++++++++-----------------
 3 files changed, 133 insertions(+), 85 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index eef69b5..ce372a0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -33,6 +33,9 @@
 #define irq_is_spi(irq) ((irq) >= VGIC_NR_PRIVATE_IRQS && \
 			 (irq) <= VGIC_MAX_SPI)
 
+/*The number of lpi translation cache lists*/
+#define LPI_TRANS_CACHES_NUM 8
+
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
 	VGIC_V3,		/* New fancy GICv3 */
@@ -162,6 +165,12 @@ struct vgic_io_device {
 	struct kvm_io_device dev;
 };
 
+struct its_translation_cache {
+	/* LPI translation cache */
+	struct list_head        lpi_cache;
+	raw_spinlock_t          lpi_cache_lock;
+};
+
 struct vgic_its {
 	/* The base address of the ITS control register frame */
 	gpa_t			vgic_its_base;
@@ -249,8 +258,8 @@ struct vgic_dist {
 	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
-	/* LPI translation cache */
-	struct list_head	lpi_translation_cache;
+	/* LPI translation cache array*/
+	struct its_translation_cache lpi_translation_cache[LPI_TRANS_CACHES_NUM];
 	u32			lpi_pcpu_cache_size;
 
 	/* used by vgic-debug */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 80127ca..6060dbe 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -51,9 +51,13 @@
 void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	int i;
 
 	INIT_LIST_HEAD(&dist->lpi_list_head);
-	INIT_LIST_HEAD(&dist->lpi_translation_cache);
+	for (i = 0; i < LPI_TRANS_CACHES_NUM; i++) {
+		INIT_LIST_HEAD(&dist->lpi_translation_cache[i].lpi_cache);
+		raw_spin_lock_init(&dist->lpi_translation_cache[i].lpi_cache_lock);
+	}
 	raw_spin_lock_init(&dist->lpi_list_lock);
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 5f2ad74..792d90b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -535,13 +535,21 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+/* Default is 16 cached LPIs per vcpu */
+#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
+
 static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 					       phys_addr_t db,
-					       u32 devid, u32 eventid)
+					       u32 devid, u32 eventid,
+					       int cacheid)
 {
 	struct vgic_translation_cache_entry *cte;
+	struct vgic_irq *irq = NULL;
+	int pos = 0;
 
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+	list_for_each_entry(cte,
+			    &dist->lpi_translation_cache[cacheid].lpi_cache,
+			    entry) {
 		/*
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
@@ -549,21 +557,26 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 		if (!cte->irq)
 			break;
 
-		if (cte->db != db || cte->devid != devid ||
-		    cte->eventid != eventid)
-			continue;
-
-		/*
-		 * Move this entry to the head, as it is the most
-		 * recently used.
-		 */
-		if (!list_is_first(&cte->entry, &dist->lpi_translation_cache))
-			list_move(&cte->entry, &dist->lpi_translation_cache);
-
-		return cte->irq;
+		pos++;
+
+		if (cte->devid == devid &&
+		    cte->eventid == eventid &&
+		    cte->db == db) {
+			/*
+			 * Move this entry to the head if the entry at the
+			 * position behind the LPI_DEFAULT_PCPU_CACHE_SIZE * 2
+			 * of the LRU list, as it is the most recently used.
+			 */
+			if (pos > LPI_DEFAULT_PCPU_CACHE_SIZE * 2)
+				list_move(&cte->entry,
+				    &dist->lpi_translation_cache[cacheid].lpi_cache);
+
+			irq = cte->irq;
+			break;
+		}
 	}
 
-	return NULL;
+	return irq;
 }
 
 static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
@@ -571,11 +584,15 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq;
-	unsigned long flags;
+	int cpu;
+	int cacheid;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	irq = __vgic_its_check_cache(dist, db, devid, eventid);
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	cpu = smp_processor_id();
+	cacheid = cpu % LPI_TRANS_CACHES_NUM;
+
+	raw_spin_lock(&dist->lpi_translation_cache[cacheid].lpi_cache_lock);
+	irq = __vgic_its_check_cache(dist, db, devid, eventid, cacheid);
+	raw_spin_unlock(&dist->lpi_translation_cache[cacheid].lpi_cache_lock);
 
 	return irq;
 }
@@ -588,49 +605,55 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
 	phys_addr_t db;
+	int cacheid;
 
 	/* Do not cache a directly injected interrupt */
 	if (irq->hw)
 		return;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-
-	if (unlikely(list_empty(&dist->lpi_translation_cache)))
-		goto out;
-
-	/*
-	 * We could have raced with another CPU caching the same
-	 * translation behind our back, so let's check it is not in
-	 * already
-	 */
-	db = its->vgic_its_base + GITS_TRANSLATER;
-	if (__vgic_its_check_cache(dist, db, devid, eventid))
-		goto out;
-
-	/* Always reuse the last entry (LRU policy) */
-	cte = list_last_entry(&dist->lpi_translation_cache,
-			      typeof(*cte), entry);
+	for (cacheid = 0; cacheid < LPI_TRANS_CACHES_NUM; cacheid++) {
+		raw_spin_lock_irqsave(&dist->lpi_translation_cache[cacheid].lpi_cache_lock, flags);
+		if (unlikely(list_empty(&dist->lpi_translation_cache[cacheid].lpi_cache))) {
+			raw_spin_unlock_irqrestore(&dist->lpi_translation_cache[cacheid].lpi_cache_lock, flags);
+			break;
+		}
 
-	/*
-	 * Caching the translation implies having an extra reference
-	 * to the interrupt, so drop the potential reference on what
-	 * was in the cache, and increment it on the new interrupt.
-	 */
-	if (cte->irq)
-		__vgic_put_lpi_locked(kvm, cte->irq);
+		/*
+		 * We could have raced with another CPU caching the same
+		 * translation behind our back, so let's check it is not in
+		 * already
+		 */
+		db = its->vgic_its_base + GITS_TRANSLATER;
+		if (__vgic_its_check_cache(dist, db, devid, eventid, cacheid)) {
+			raw_spin_unlock_irqrestore(&dist->lpi_translation_cache[cacheid].lpi_cache_lock, flags);
+			continue;
+		}
 
-	vgic_get_irq_kref(irq);
+		/* Always reuse the last entry (LRU policy) */
+		cte = list_last_entry(&dist->lpi_translation_cache[cacheid].lpi_cache,
+				      typeof(*cte), entry);
 
-	cte->db		= db;
-	cte->devid	= devid;
-	cte->eventid	= eventid;
-	cte->irq	= irq;
+		/*
+		 * Caching the translation implies having an extra reference
+		 * to the interrupt, so drop the potential reference on what
+		 * was in the cache, and increment it on the new interrupt.
+		 */
+		if (cte->irq) {
+			raw_spin_lock(&dist->lpi_list_lock);
+			__vgic_put_lpi_locked(kvm, cte->irq);
+			raw_spin_unlock(&dist->lpi_list_lock);
+		}
+		vgic_get_irq_kref(irq);
 
-	/* Move the new translation to the head of the list */
-	list_move(&cte->entry, &dist->lpi_translation_cache);
+		cte->db		= db;
+		cte->devid	= devid;
+		cte->eventid	= eventid;
+		cte->irq	= irq;
 
-out:
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+		/* Move the new translation to the head of the list */
+		list_move(&cte->entry, &dist->lpi_translation_cache[cacheid].lpi_cache);
+		raw_spin_unlock_irqrestore(&dist->lpi_translation_cache[cacheid].lpi_cache_lock, flags);
+	}
 }
 
 void vgic_its_invalidate_cache(struct kvm *kvm)
@@ -638,22 +661,25 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
+	int i;
 
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
-		__vgic_put_lpi_locked(kvm, cte->irq);
-		cte->irq = NULL;
+	for (i = 0; i < LPI_TRANS_CACHES_NUM; i++) {
+		raw_spin_lock_irqsave(&dist->lpi_translation_cache[i].lpi_cache_lock, flags);
+		list_for_each_entry(cte, &dist->lpi_translation_cache[i].lpi_cache, entry) {
+			/*
+			 * If we hit a NULL entry, there is nothing after this
+			 * point.
+			 */
+			if (!cte->irq)
+				break;
+
+			raw_spin_lock(&dist->lpi_list_lock);
+			__vgic_put_lpi_locked(kvm, cte->irq);
+			raw_spin_unlock(&dist->lpi_list_lock);
+			cte->irq = NULL;
+		}
+		raw_spin_unlock_irqrestore(&dist->lpi_translation_cache[i].lpi_cache_lock, flags);
 	}
-
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
@@ -1821,16 +1847,18 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
 	return ret;
 }
 
-/* Default is 16 cached LPIs per vcpu */
-#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
-
 void vgic_lpi_translation_cache_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	unsigned int sz = dist->lpi_pcpu_cache_size;
 	int i;
+	int cacheid;
 
-	if (!list_empty(&dist->lpi_translation_cache))
+	/*
+	 * If the first cache entry has been initialized, all cache groups
+	 * have been initialized.
+	 */
+	if (!list_empty(&dist->lpi_translation_cache[0].lpi_cache))
 		return;
 
 	if (!sz)
@@ -1838,16 +1866,17 @@ void vgic_lpi_translation_cache_init(struct kvm *kvm)
 
 	sz *= atomic_read(&kvm->online_vcpus);
 
-	for (i = 0; i < sz; i++) {
-		struct vgic_translation_cache_entry *cte;
+	for (cacheid = 0; cacheid < LPI_TRANS_CACHES_NUM; cacheid++) {
+		for (i = 0; i < sz; i++) {
+			struct vgic_translation_cache_entry *cte;
 
-		/* An allocation failure is not fatal */
-		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
-		if (WARN_ON(!cte))
-			break;
+			cte = kzalloc(sizeof(*cte), GFP_KERNEL);
+			if (WARN_ON(!cte))
+				break;
 
-		INIT_LIST_HEAD(&cte->entry);
-		list_add(&cte->entry, &dist->lpi_translation_cache);
+			INIT_LIST_HEAD(&cte->entry);
+			list_add(&cte->entry, &dist->lpi_translation_cache[cacheid].lpi_cache);
+		}
 	}
 }
 
@@ -1855,13 +1884,19 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte, *tmp;
+	unsigned long flags;
+	int cacheid;
 
 	vgic_its_invalidate_cache(kvm);
 
-	list_for_each_entry_safe(cte, tmp,
-				 &dist->lpi_translation_cache, entry) {
-		list_del(&cte->entry);
-		kfree(cte);
+	for (cacheid = 0; cacheid < LPI_TRANS_CACHES_NUM; cacheid++) {
+		raw_spin_lock_irqsave(&dist->lpi_translation_cache[cacheid].lpi_cache_lock, flags);
+		list_for_each_entry_safe(cte, tmp,
+					 &dist->lpi_translation_cache[cacheid].lpi_cache, entry) {
+			list_del(&cte->entry);
+			kfree(cte);
+		}
+		raw_spin_unlock_irqrestore(&dist->lpi_translation_cache[cacheid].lpi_cache_lock, flags);
 	}
 }
 
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
